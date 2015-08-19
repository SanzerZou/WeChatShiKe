<%@ page language="java" import="java.util.*" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="css/myCss.css" media="all">
<!-- font awesome icon-->
<link rel="stylesheet" href="css/font-awesome.min.css">

<!-- jQuery Mobile CDN start -->
<link rel="stylesheet" href="js/jquery.mobile-1.3.2.min.css">
<script src="js/jquery-1.8.3.min.js"></script>
<script src="js/jquery.mobile-1.3.2.min.js"></script>
<!-- jQuery Mobile end -->

<!-- Baidu Map Api -->
<script type="text/javascript" src="http://api.map.baidu.com/api?v=1.5&ak=biZdDTipTS4pMbFWk2oiDG3X"></script>
<!-- end -->

<!-- weChat -->
<script src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<!-- end -->

<title>食客来了</title>	
<meta content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport">
<!-- Mobile Devices Support @begin -->
<meta content="telephone=no, address=no" name="format-detection">
<meta name="apple-mobile-web-app-capable" content="yes"> <!-- apple devices fullscreen -->
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
	<!-- Mobile Devices Support @end -->
<style type="text/css">
.item{
	position:relative;
	padding:5px 2%;
	margin:0 4%;
	border-bottom:1px solid;
	border-color: rgb(192, 192, 192);
}
.ui-navbar li .ui-btn .ui-btn-inner {
	padding-top: 1.2em;
	padding-bottom: 1.2em;
}
.ui-header .ui-btn-inner, .ui-footer .ui-btn-inner, .ui-mini .ui-btn-inner {
	font-size: 16px;
}

.wrap {
	width: 100%;
	height: 100%;
	overflow: hidden;
}

#map-wrap {
	width: 100%;
	height: 100%;
	overflow: hidden;
	display: none;
	position: absolute;
	left:0;
	bottom: 0;
}
</style>

<script type="text/javascript">
var g_baseurl = '<%=request.getContextPath()%>';
var g_openId = '<%=request.getParameter("openId")%>';
var g_brandUidStr = 'bf754d76-26ac-11e5-8c51-55a12bf13948';

$(document).ready(function(){
	//店铺信息加载
	baiduMap.creat();
	$.ajax({
	    url: g_baseurl+'/pageService',
	    type: 'post',
	    contentType:'application/json;charset=UTF-8',
	    async: true,
	    dataType: 'json',
	    data: JSON.stringify({
	        service: "DynamicTransmitService",
	        scriptService: "shop_branchLoad.action",
	        openId: g_openId
	    }),
	    success: function(d, s){
	    	//{'resultCode':,'desc':,'branches':[{'brandUid':'',uid':'','name':'','address':'','tel':''}]}
	    	var o = jQuery.parseJSON(d.data);
	    	if(o.resultCode == 0){
	    		// get and set the list data
	    		shopList.setList ( o.branches );
	    		// generate list view
	    		shopList.generateList ();
	    	} else {
	    		alert(o.desc);
	    	}
	    },
	    error: function(r, e, o){
	        alert('发生内部错误，请联系公众号管理员');
	    }
	});
	$.ajax({
	        url: '<%=request.getContextPath()%>/pageService',
	        type: 'post',
	        async: true,
	        dataType: 'json',
	        data: JSON.stringify({
	            service: "CreateJsApiTicketService",
	            url: '<%=request.getRequestURL().append("?").append(request.getQueryString()).toString()%>'
	        }),
	        success: function (data, status) {
	            if (status != 'success') {
	                showError('主人，业务忙，正在稍后重试。。。');
	                return;
	            } 
	            var debugEnabled = false;
	            wx.config({
	                debug: debugEnabled,
	                appId: data.appId, 
	                timestamp: data.timestamp, 
	                nonceStr: data.nonceStr,
	                signature: data.signature,
	                jsApiList: ['checkJsApi', 'openLocation', 'getLocation']
	            });
	           	wx.ready(function(){    
		           	wx.getLocation({
		           	    success: function (o) {
		           	        var coord = {lng : o.longitude, lat : o.latitude}
		           	        baiduMap.setCoords(coord);
		           	        baiduMap.setCenterAndZoom();
		           	    },
		           	    cancel: function (res) {
		           	        alert('用户拒绝授权获取地理位置');
		           	    }
		           	});
	           });
	           wx.error(function(res){
	               showError('业务忙，请重新打开页面');
	           });
	        }
	    });
});
var shopList = ( function (){
	//	private data
	var list = [];
	var generateList = function () {
		// TODO: generateList
		var s = '';
		var i, length;
		for(var i = 0, length= list.length; i < length; i++){
			var dist = Math.round( Math.random()*1000 );
			var br = list[i];
			// onclick事件绑定； 设置brand Uid和uid这两个参数用于查找商家
			s += '<li onclick="showMenu(this)" data-icon="false" uid="'+br.uid+'" buid="'+br.brandUid+'">'+
					'<a href="#">'+
						'<h2>'+br.name+'</h2>'+
						'<p>'+br.address+'</p>'+
						'<p class="ui-li-count"><span>'+dist+'</span>米</p>'+
					'</a>'+
				'</li>';
		}
		$('#storeList').append(s);
		$('#storeList').listview('refresh')
	};
	var setList = function ( o ) {
		// TODO: initial the list
		list = o;
	};
	var addDistance = function () {
		// TODO: add infomation distance to list
		var start = baiduMap.getCoords();
		var end = 0;
		var distance = 0;
		// forEach element add the distance
		list.forEach ( function (item, index, array ) {
			end.lat = item.lat;
			end.lng = item.lng;
			distance = getDistance ( source, end );
			item.distance = distance;
		});
	};
	// TODO: resort the list
	var sortList = function () {
		// addDistance first
		addDistance();
		var sortFunc = function (a, b) {
			if (a.distance < b.distance) {
				return -1;
			}else if (a.distance > b.distance) {
				return 1;
			}else{
				return 0;
			};
		}
		// use distance to sort the list
		list.sort( sortFunc );
	};
	// caculate the distance of two coord;
    var getDistance = function ( coord1, coord2){
		var Rad = function (d){
	       return d * Math.PI / 180.0; //经纬度转换成三角函数中度分表形式。
	    }
        var radLat1 = Rad(coord1.lat);
        var radLat2 = Rad(coord2.lat);
        var a = radLat1 - radLat2;
        var  b = Rad(coord1.lng) - Rad(coord2.lng);
        var s = 2 * Math.asin(Math.sqrt(Math.pow(Math.sin(a/2),2) +
        Math.cos(radLat1)*Math.cos(radLat2)*Math.pow(Math.sin(b/2),2)));
        s = s * 6378.137 ;// EARTH_RADIUS;
        s = Math.round(s * 10000) / 10000; //return km
        //s=s.toFixed(4);
        return s;
    };
    // public interface
    return {
    	setList : setList,
    	generateList : generateList
    }
}() );

function showMenu(li){
	var o = $(li);
	// 使用jQuery的attr来保存属性，属性是直接在标签内添加，这种方法要比data-方便
	var uid = o.attr('uid');
	var buid = o.attr('buid');
	// 重定向，并且通过url传参
	window.location.href = 'menu.jsp?openId='+g_openId+'&brandUid='+buid+'&branchUid='+uid;
}

var showList = function () {
	$("#map-wrap").hide();
	$("#storeList-wrap").show();
}

var showMap = function () {
	$("#storeList-wrap").hide();
	$("#map-wrap").show();
}
// baiduMap 构造函数
var baiduMap = ( function () {
	// private var
	var map;
	var geolocation;
	var coords = { lng : 116.404, lat: 39.915};   // 创建点坐标
	var isReliable = false; // 坐标是否可靠
	var timer;
	// handle error
	var getCoords = function () {
		return coords;
	}
	var setCoords = function (coord) {
		coords = coord;
	}
	// reset Center when get the current coords
	var setCenterAndZoom = function () {
		var mk = new BMap.Marker( coords );
		var point = new BMap.Point( coords.lng, coords.lat );
		var scale = 13;
		map.centerAndZoom( point, scale);
		map.addOverlay(mk);
		mk.setAnimation(BMAP_ANIMATION_BOUNCE); 
	}
	// get Current Coords
	var errorFunction = function (error){
		alert("location false");
		map.centerAndZoom( "南京", 11);
		timer = setInterval( getCoordsFromUser, 5000 );
	  	switch(error) {
		    case BMAP_STATUS_UNKNOWN_LOCATION:
				// alert("User denied the request for Geolocation.");
				break;
		    case BMAP_STATUS_PERMISSION_DENIED:
				// alert("Location information is unavailable.");

		      break;
		    case BMAP_STATUS_SERVICE_UNAVAILABLE:
				// alert("The request to get user location timed out.");
		      break;
		    case BMAP_STATUS_TIMEOUT:
				// alert("An unknown error occurred.");
				break;
	    }
	}

	var successFunction = function (pos) {
		clearInterval( timer );
		var mk = new BMap.Marker(pos.point);
		map.addOverlay(mk);
		map.panTo(pos.point);
		coords = {
			lat : pos.point.lat,
			lng : pos.point.lng
		};
		setCenterAndZoom();
	}
	var getCoordsFromUser = function () {
		// navigator.geolocation.getCurrentPosition( successFunction, errorFunction );
		geolocation.getCurrentPosition( function( pos ){
			if( this.getStatus() == BMAP_STATUS_SUCCESS ){
				successFunction( pos );
			}
			else {
				errorFunction( this.getStatus() );
			}        
		},{enableHighAccuracy: true});
	}
	// initial
	var creat = function () {
		map = new BMap.Map("map-wrap"); // creatBaiduMap
		geolocation = new BMap.Geolocation(); // creatGeolocation
		// getCoordsFromUser();
		map.addControl( new BMap.MapTypeControl() );
		// map.setCurrentCity( "南京" );
	}
	return {
		creat : creat,
		getCoords : getCoords,
		setCoords : setCoords,
		setCenterAndZoom : setCenterAndZoom
	}
}() );

</script>
</head>
  
<body>
<div data-role="page" class="wrap">
	<div data-role="header"  data-theme="c" style="z-index:99;">
		<div data-role="navbar" data-iconpos="top">
			<ul>
				<li><a href="#" onclick="showList()" class="ui-btn-active" style="font-size:3em "><i class="icon-th-list"></i>&nbsp;列表</a></li>
				<li><a href="#" onclick="showMap()" style="font-size:3em"><i class="icon-map-marker"></i>&nbsp;地图</a></li>
			</ul>
		</div>
	</div>
<!-- ListView -->
	<div id="storeList-wrap" data-role="content" data-theme="c">
		<ul id="storeList" data-role="listview" data-inset="true">

		</ul>
	</div>	
	<div id="map-wrap" data-role="content">
	</div>
</div>


</body>
</html>
