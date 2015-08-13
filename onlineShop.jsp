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
<script type="text/javascript" src="http://api.map.baidu.com/api?type=quick&ak=biZdDTipTS4pMbFWk2oiDG3X&v=1.0"></script>
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
	var myMap = baiduMap();
	myMap.creat();
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
	    		var s = '';
	    		for(var i = 0, length= o.branches.length; i < length; i++){
	    			var dist = Math.round(Math.random()*1000);
	    			var br = o.branches[i];
	    			// onclick事件绑定； 设置brand Uid和uid这两个参数用于查找商家
	    			s += 	'<li onclick="showMenu(this)" data-icon="false" uid="'+br.uid+'" buid="'+br.brandUid+'">'+
												'<a href="#">'+
													'<h2>'+br.name+'</h2>'+
													'<p>'+br.address+'</p>'+
													'<p class="ui-li-count"><span>'+dist+'</span>米</p>'+
												'</a>'+
											'</li>';
	    		}
	    		$('#storeList').append(s);
	    		$('#storeList').listview('refresh')
	    	} else {
	    		alert(o.desc);
	    	}
	    },
	    error: function(r, e, o){
	        alert('发生内部错误，请联系公众号管理员');
	    }
	})
});

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
var baiduMap = function () {
	// private var
	var map;
	var point;   // 创建点坐标
	// public function
	// construct function
	var creat = function () {
		map = new BMap.Map("map-wrap");            // 创建Map实例
		point = new BMap.Point(116.404, 39.915);   // 创建点坐标
		map.centerAndZoom(point,15);               // 初始化地图,设置中心点坐标和地图级别。
	}
	return {
		creat : creat,
	}
}

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
