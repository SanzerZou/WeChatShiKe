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

function showMyOrders(){
	var data = [
	{
		orderId:"1",
		imgUrl:"image/order.jpg",
		price:62,
		name:"卡布奇诺*5",
		time:"2015-07-15 13:32",
		payOrNot:true
	},
	{
		orderId:"2",
		imgUrl:"image/order2.jpg",
		price:78,
		name:"摩卡*2，美式咖啡*3",
		time:"2015-07-15 13:32",
		payOrNot:true
	},
	{
		orderId:"3",
		imgUrl:"image/order3.jpg",
		price:25,
		name:"卡布奇诺*3，美式咖啡*2",
		time:"2015-07-11 16:32",
		payOrNot:false
	}
	];
	var s = '<li data-role="list-divider">订单列表<span class="ui-li-count">'+ data.length +'</span></li>'
	for (var i = data.length - 1; i >= 0; i--) {
		var pay = data[i].payOrNot === true ? "check" : "delete";
		s += '<li>'+
			'<a href="#">'+
				'<img src="'+data[i].imgUrl+'">'+
				'<h2>￥'+data[i].price+'</h3>'+
				'<p>'+data[i].name+'</p>'+
				'<p class="ui-li-aside">'+data[i].time+'</p>'+
			'</a>'+
			'<a href="#mdialog" data-rel="dialog" data-icon="'+pay+'"></a>'+
		'</li>';
	};
	$("#orderlist").append(s);
	$("#orderlist").listview('refresh');
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
<div id="mdialog" data-role="dialog">		
		<div data-role="header" data-theme="d">
			<h1>删除订单</h1>
		</div>
		<div data-role="content" data-theme="c">
			<p>是否要删除此订单？</p>
			<a href="#" data-role="button" data-rel="back" data-theme="c">确定</a>       
			<a href="#" data-role="button" data-rel="back" data-theme="b">取消</a>  
		</div>
</div>
</body>
</html>
