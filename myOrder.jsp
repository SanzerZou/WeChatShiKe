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
$(document).ready(function(){
	showMyOrders();
});

function openPopUp(o){
	var dlg = $("#mdialog");
	dlg.attr('orderid', $(o).attr('orderid'));
	dlg.trigger('create').trigger('refresh').popup();
	dlg.popup("open");
}
/**
 * 删除指定订单
 */
function onDeleteOrder(){
	var oid = $("#mdialog").attr('orderid');
	var orders = JSON.parse(window.localStorage.getItem("orders"));
	delete orders[oid];
	window.localStorage.setItem("orders", JSON.stringify(orders));
	showMyOrders();
}

function showMyOrders(){
	// orders 数据格式
	// orderItem = {
	// 		content : orderMap,
	// 		ifo : {
	// 			id : id,
	// 			imgUrl : imgUrl,
	// 			price: totalPrice,
	// 			name: name,
	// 			time: time.toLocaleString(),
	// 			payOrNot:false
	// 		}
	// 	}
	// 	初始化页面
	var orderWapper = $('#orderlist');
	orderWapper.html("");
	// 获取本地数据
	var orders = JSON.parse(window.localStorage.getItem("orders"));
	var s = '';

	var cnt = 0; // 订单的个数
	for (var idex in orders) {
		cnt++;
		var tp = orders[idex].ifo;
		var pay = tp.payOrNot === true ? "check" : "delete";
		s += '<li>'+
			'<a href="#">'+
				'<img src="'+tp.imgUrl+'">'+
				'<h2>￥'+tp.price+'</h3>'+
				'<p>'+ tp.name+'</p>'+
				'<p class="ui-li-aside">'+ tp.time+'</p>'+
			'</a>'+
			'<a orderid="'+idex+'" onclick="openPopUp(this);" data-icon="'+pay+'"></a>'+
		'</li>';
	};
	s =  '<li data-role="list-divider">订单列表<span class="ui-li-count">'+ cnt +'</span></li>' + s;
	orderWapper.append(s);
	orderWapper.listview('refresh');
}

</script>
</head>
  
<body>
<div data-role="page">
<!-- ListView -->
	<div data-role="content" data-theme="c">
		<ul id="orderlist" data-role="listview">
		</ul>
	</div>	
</div>
<div id="mdialog" data-role="popup" data-theme="a">		
		<div data-role="header">
			<h1>删除订单</h1>
		</div>
		<div data-role="content">
			<p>是否要删除此订单？</p>
			<a href="#" data-role="button" data-rel="back" data-theme="c" onclick="onDeleteOrder()">确定</a>       
			<a href="#" data-role="button" data-rel="back" data-theme="b">取消</a>  
		</div>
</div>
</body>
</html>
