<%@ page language="java" import="java.util.*" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!-- jQuery Mobile CDN start -->
<link rel="stylesheet" href="js/jquery.mobile-1.3.2.min.css">
<script src="js/jquery-1.8.3.min.js"></script>
<script src="js/jquery.mobile-1.3.2.min.js"></script>
<!-- jQuery Mobile end -->

<!-- font awesome icon-->
<link rel="stylesheet" href="css/font-awesome.min.css">

<title>我的订单</title>	
<meta content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport">
<!-- Mobile Devices Support @begin -->
<meta content="telephone=no, address=no" name="format-detection">
<meta name="apple-mobile-web-app-capable" content="yes"> <!-- apple devices fullscreen -->
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
	<!-- Mobile Devices Support @end -->
<style type="text/css">
.ui-dialog .ui-dialog-contain { margin-top: 40% }
.ui-navbar li .ui-btn .ui-btn-inner {
	padding-top: 1.2em;
	padding-bottom: 1.2em;
}
.ui-header .ui-btn-inner, .ui-footer .ui-btn-inner, .ui-mini .ui-btn-inner {
	font-size: 16px;
}

.tips {
	text-align: center;
	color: #ccc;
	margin-top: 40%;
	margin-bottom: 40%;
	overflow: hidden;
}
</style>

<script type="text/javascript">
var ORDER ={};
ORDER.openId = '<%=request.getParameter("openId")%>';
ORDER.brandUid = '<%=request.getParameter("brandUidStr")%>';
ORDER.branchUid = '<%=request.getParameter("branchUidStr")%>';

// {data:[{"transtime":"","prods":[{"orderid":"","orderby":0,"prodname":"","id":,"prodprice":,"prodcount":}],"totalfee":,"openid":"","ordernum":"","id":"","phoneno":""}],"resultCode":,"desc":"success"}"
/**
 * 文档加载完首先获得远程订单数据，然后已支付订单详情。
 */
$(document).ready(function(){
  	//  显示已支付订单
	var LoadRemote = function (data) {
		var wrap = $("#list-ispay");
		var templet = '<li data-icon="false">'+
				'<a href="#" index="{{index}}" onclick="romoteOrderDetail({{index}})">'+
					'<img src="{{imgurl}}">'+
					'<h2>￥{{totalfee}}</h3>'+
					'<p>{{name}}</p>'+
					'<p class="ui-li-aside">{{transtime}}</p>'+
				'</a>'+
			'</li>';
		var s = [];
		if ( data.length === 0 ) {
			$('<p class="tips"><i class="icon-exclamation-sign"></i>&nbsp;没有已支付订单</p>').appendTo(wrap);
			return;
		}
		for (var i = 0; i < data.length; i++) {
			var tp = data[i];
			var name = '';
			for (var j = 0; j < tp.prods.length; j++){
				name += tp.prods[j].prodname + '*' + tp.prods[j].prodcount + ' ';
			}
			var _str = templet.replace(/{{index}}/g, i)
												.replace(/{{imgurl}}/g, tp.prods[0].imgurl)
												.replace(/{{totalfee}}/g, tp.totalfee)
												.replace(/{{name}}/g, name)
												.replace(/{{transtime}}/g, tp.transtime.substr(0, 16));
			s.push(_str);
		};
		wrap.append(s.join(''));
		wrap.listview('refresh');
	}
	// 向服务器查询数据
	$.ajax({
        url: '<%=request.getContextPath()%>/pageService',
        type: 'post',
        contentType:'application/json;charset=UTF-8',
        async: true,
        dataType: 'json',
        data: JSON.stringify({
            service: "DynamicTransmitService",
            scriptService: "shop_query_order",
            openId: ORDER.openId,
            brandUid: ORDER.brandUid,
            branchUid: ORDER.branchUid,
            data: { 
            	openid: ORDER.openId, 
            	branduid: ORDER.brandUid 
            }
        }),
        success: function(d, s){
        	var o = jQuery.parseJSON(d.data);
        	if (o.resultCode == 0){
        		ORDER.data = o.data;
        		LoadRemote(o.data);
        	}
        },
        error: function(r, e, o){
            alert('订单加载失败');
        }
  	});
  	// 显示本地订单
  	LoadLocal();
});
/**
 * 弹出是否删除对话框
 */
function openPopUp(o){
	var dlg = $("#mdialog");
	dlg.attr('index', o.toString());
}
/**
 * 读本地存储数据
 */
var readLocal = function () {
	return JSON.parse(window.localStorage.getItem("Lailr"));
}
/**
 * 写本地存储数据
 */
var writeLocal = function (d) {
	window.localStorage.setItem("Lailr", JSON.stringify(d));
}
/**
 * 删除未支付订单
 */
function onDeleteOrder(){
	var index = parseInt( $("#mdialog").attr('index') );
	var local = readLocal();
	local[ORDER.brandUid].splice(index, 1);
	writeLocal(local);
	LoadLocal();
}
/**
 *	跳转未支付订单详情
 */
function localOrderDetail(index){
	var local = readLocal();
	var orders = local[ORDER.brandUid];
	var order = orders[index];
	var item = order.orderItem;
	var num = 0;
	for (var i = 0; i < item.prods.length; i++){
		var tp = item.prods[i];
		num += tp.prodcount;
	}
	window.location.href="Order_page.jsp?orderMap=" + JSON.stringify(order.orderMap)+'&openId='+ORDER.openId+'&brandUidStr='+ORDER.brandUid+'&branchUidStr='+ORDER.branchUid + '&totalPrice='+item.totalfee+'&totalNum=' + num + '&transId=' + item.ordernum;
}
/**
 * 跳转已支付订单详情
 */
function romoteOrderDetail(index) {
	var item = ORDER.data[index];
	var num = 0;
	for (var i = 0; i < item.prods.length; i++){
		var tp = item.prods[i];
		num += tp.prodcount;
	}
	window.location.href="Order_detail.jsp?detail=" + JSON.stringify(item)+'&openId='+ORDER.openId+'&brandUidStr='+ORDER.brandUid+'&branchUidStr='+ORDER.branchUid + '&totalPrice='+item.totalfee+'&totalNum=' + num + '&transId=' + item.ordernum;

}

/**
 * 加载本地订单
 */

function LoadLocal(){
	var wrap = $('#list-nopay');
	wrap.html("");
	// 获取本地数据
	var local = readLocal();
	var templet = '<li>'+
					'<a href="#" onclick="localOrderDetail({{index}})">'+
						'<img src="{{imgurl}}">'+
						'<h2>￥{{totalfee}}</h3>'+
						'<p>{{name}}</p>'+
						'<p class="ui-li-aside">{{transtime}}</p>'+
					'</a>'+
					'<a href = "#mdialog" data-rel="popup" onclick="openPopUp({{index}})" data-icon="false"><i class="icon-delete"></i></a>'+
				'</li>';
	var s = [];
	var orders = local[ORDER.brandUid];
	if ( orders.length === 0 ) {
		$('<p class="tips"><i class="icon-exclamation-sign"></i>&nbsp;没有未支付订单</p>').appendTo(wrap);
		return;
	}
	for (var id = orders.length - 1; id >= 0; id--) {
		var tp = orders[id].orderItem;
		var name = '';
		for (var j = 0; j < tp.prods.length; j++){
			name += tp.prods[j].prodname + '*' + tp.prods[j].prodcount + ' ';
		}
		var _str = templet.replace(/{{index}}/g, id)
						.replace(/{{imgurl}}/g, tp.prods[0].imgurl)
						.replace(/{{totalfee}}/g, tp.totalfee)
						.replace(/{{name}}/g, name)
						.replace(/{{transtime}}/g, tp.transtime.substr(0, 16));
		s.push(_str);
	};
	wrap.append(s.join(''));
	wrap.listview('refresh');
}

var showLocal = function (b) {
	if (b) {
		$("#list-ispay").hide();
		$("#list-nopay").show();
	}
	else {
		$("#list-nopay").hide();
		$("#list-ispay").show();
	}
}
</script>
</head>
  
<body>
<div data-role="page" id="nopay">
	<!-- 导航栏 -->
	<div data-role="header"  data-theme="c" class="header">
		<div data-role="navbar" data-iconpos="top">
			<ul>
				<li><a href="#" class="ui-btn-active" onclick="showLocal(true)"><i class="icon-shopping-cart"></i>&nbsp;未支付</a></li>
				<li><a href="#" onclick="showLocal(false)"><i class="icon-ok-sign"></i>&nbsp;已支付</a></li>
			</ul>
		</div>
	</div>
	<!-- 内容 -->
	<div data-role="content" data-theme="c">
		<ul id="list-nopay" class="j_list" data-role="listview">
		</ul>
		<ul id="list-ispay" class="j_list" data-role="listview" style="display:none">
		</ul>                                         
	</div>
	<!-- popup -->
	<div  data-role="popup" data-theme="a" id="mdialog">		
			<div data-role="header">
				<h1>删除订单</h1>
			</div>
			<div data-role="content">
				<p>是否要删除此订单？</p>
				<a href="#" data-role="button" data-rel="back" data-theme="c" onclick="onDeleteOrder()">确定</a>       
				<a href="#" data-role="button" data-rel="back" data-theme="b">取消</a>  
			</div>
	</div>
</div>
</body>
</html>
