<%@ page language="java" import="java.util.*" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!-- jQuery Mobile CDN start -->
<link rel="stylesheet" href="http://code.jquery.com/mobile/1.3.2/jquery.mobile-1.3.2.min.css">
<script src="http://code.jquery.com/jquery-1.8.3.min.js"></script>
<script src="http://code.jquery.com/mobile/1.3.2/jquery.mobile-1.3.2.min.js"></script>
<!-- jQuery Mobile end -->

<title>食客来了</title>	
<meta content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport">
<meta content="width=device-width" name="viewport">
<!-- Mobile Devices Support @begin -->
<meta content="telephone=no, address=no" name="format-detection">
<meta name="apple-mobile-web-app-capable" content="yes"> <!-- apple devices fullscreen -->
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
	<!-- Mobile Devices Support @end -->
<style type="text/css">
.ui-dialog .ui-dialog-contain { margin-top: 40% }
</style>

<script type="text/javascript">
var ORDER ={};
ORDER.openId = '<%=request.getParameter("openId")%>';
ORDER.brandUidStr = '<%=request.getParameter("brandUidStr")%>';
ORDER.branchUidStr = '<%=request.getParameter("branchUidStr")%>';

// {data:[{"transtime":"","prods":[{"orderid":"","orderby":0,"prodname":"","id":,"prodprice":,"prodcount":}],"totalfee":,"openid":"","ordernum":"","id":"","phoneno":""}],"resultCode":,"desc":"success"}"
$(document).ready(function(){
  	//  显示已支付订单
	var showRemote = function (data) {
		var wrap = $("#list-ispay");
		var templet = '<li>'+
				'<a href="#" index="{{index}}" onclick="romoteOrderDetail({{index}})">'+
					'<img src="{{imgurl}}">'+
					'<h2>￥{{totalfee}}</h3>'+
					'<p>{{name}}</p>'+
					'<p class="ui-li-aside">{{transtime}}</p>'+
				'</a>'+
				'<a index="{{index}}" href = "#mdialog" data-rel="popup" data-icon="check"></a>'+
			'</li>';
		var s = [];
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
            brandUid: ORDER.brandUidStr,
            branchUid: ORDER.branchUidStr,
            data: { openid: ORDER.openId }
        }),
        success: function(d, s){
        	var o = jQuery.parseJSON(d.data);
        	if (o.resultCode == 0){
        		ORDER.data = o.data;
        		showRemote(o.data);
        	}
        },
        error: function(r, e, o){
            alert('订单加载失败');
        }
  	});
  	// 显示本地订单
  	showLocal();
});

function openPopUp(o){
	var dlg = $("#mdialog");
	dlg.attr('orderid', $(o).attr('orderid'));
}
/**
 * 删除指定订单
 */
function onDeleteOrder(){
	var oid = $("#mdialog").attr('orderid');
	var orders = JSON.parse(window.localStorage.getItem("orders"));
	delete orders[oid];
	window.localStorage.setItem("orders", JSON.stringify(orders));
	showLocal();
}
/**
 *	跳转订单详情页面 
 */
function localOrderDetail(o){
	var orderId = $(o).attr("orderid");
	var orders = JSON.parse(window.localStorage.getItem("orders"));
	var order = orders[orderId];
	var item = order.orderItem;
	var num = 0;
	for (var i = 0; i < item.prods.length; i++){
		var tp = item.prods[i];
		num += tp.prodcount;
	}
	window.location.href="Order_page.jsp?orderMap=" + JSON.stringify(order.orderMap)+'&openId='+ORDER.openId+'&brandUidStr='+ORDER.brandUidStr+'&branchUidStr='+ORDER.branchUidStr + '&totalPrice='+item.totalfee+'&totalNum=' + num + '&transId=' + item.ordernum;
}
// 已支付订单详情页面，支持退款操作 
function romoteOrderDetail(index) {
	var item = ORDER.data[index];
	var num = 0;
	for (var i = 0; i < item.prods.length; i++){
		var tp = item.prods[i];
		num += tp.prodcount;
	}
	window.location.href="Order_detail.jsp?detail=" + JSON.stringify(item)+'&openId='+ORDER.openId+'&brandUidStr='+ORDER.brandUidStr+'&branchUidStr='+ORDER.branchUidStr + '&totalPrice='+item.totalfee+'&totalNum=' + num + '&transId=' + item.ordernum;

}

function showLocal(){
	var wrap = $('#list-nopay');
	wrap.html("");
	// 获取本地数据
	var orders = JSON.parse(window.localStorage.getItem("orders"));
	var templet = '<li>'+
					'<a href="#" orderid="{{orderid}}" onclick="localOrderDetail(this)">'+
						'<img src="{{imgurl}}">'+
						'<h2>￥{{totalfee}}</h3>'+
						'<p>{{name}}</p>'+
						'<p class="ui-li-aside">{{transtime}}</p>'+
					'</a>'+
					'<a orderid="{{orderid}}" href = "#mdialog" data-rel="popup" onclick="openPopUp(this)" data-icon="delete"></a>'+
				'</li>';
	var s = [];
	for (var id in orders) {
		var tp = orders[id].orderItem;
		var name = '';
		for (var j = 0; j < tp.prods.length; j++){
			name += tp.prods[j].prodname + '*' + tp.prods[j].prodcount + ' ';
		}
		var _str = templet.replace(/{{orderid}}/g, id)
						.replace(/{{imgurl}}/g, tp.prods[0].imgurl)
						.replace(/{{totalfee}}/g, tp.totalfee)
						.replace(/{{name}}/g, name)
						.replace(/{{transtime}}/g, tp.transtime.substr(0, 16));
		s.push(_str);
	};
	wrap.append(s.join(''));
	wrap.listview('refresh');
}
</script>
</head>
  
<body>
<div data-role="page" id="nopay">
	<!-- 导航栏 -->
	<div data-role="header"  data-theme="c">
		<div data-role="navbar" data-iconpos="top">
			<ul>
				<li><a href="#" data-icon="home"  class="ui-btn-active">未支付</a></li>
				<li><a href="#ispay" data-icon="info" data-transition="none">已支付</a></li>
			</ul>
		</div>
	</div>
	<!-- 内容 -->
	<div data-role="content" data-theme="c">
		<ul id="list-nopay" data-role="listview">
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
<div data-role="page" id="ispay">
<!-- 导航栏 -->
	<div data-role="header"  data-theme="c">
		<div data-role="navbar" data-iconpos="top">
			<ul>
				<li><a href="#nopay" data-icon="home" data-transition="none">未支付</a></li>
				<li><a href="#" data-icon="info" class="ui-btn-active">已支付</a></li>
			</ul>
		</div>
	</div>
	<!-- 内容 -->
	<div data-role="content" data-theme="c">
		<ul id="list-ispay" data-role="listview">
		</ul>
	</div>	
</div>
</body>
</html>
