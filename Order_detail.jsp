<%@ page language="java" import="java.util.*" contentType="text/html; charset=UTF-8"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="css/common.css" media="all">
<link rel="stylesheet" type="text/css" href="css/color.css" media="all">
<script type="text/javascript" src="js/jquery.js"></script>
<script type="text/javascript" src="js/scroller.js"></script>

<script src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>

<title>订单详情</title>
<meta content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport">
<meta name="Keywords" content="">
<meta name="Description" content="">
<!-- Mobile Devices Support @begin -->
<meta content="telephone=no, address=no" name="format-detection">
<meta name="apple-mobile-web-app-capable" content="yes"> <!-- apple devices fullscreen -->
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
<!-- Mobile Devices Support @end -->

<script type="text/javascript">
// JavaScript code

// 全局变量
var ORDER ={};
ORDER.openId = '<%=request.getParameter("openId")%>';
ORDER.transId = '<%=request.getParameter("transId")%>';
ORDER.brandUidStr = '<%=request.getParameter("brandUidStr")%>';
ORDER.branchUidStr = '<%=request.getParameter("branchUidStr")%>';
ORDER.detail = JSON.parse('<%=request.getParameter("detail")%>');
ORDER.totalFee = '<%=request.getParameter("totalPrice")%>';
ORDER.totalNum = '<%=request.getParameter("totalNum")%>';

$(document).ready(function(){
	var templet = '<li>'+
					'<div class="licontent">'+
						'<div class="span">'+
							'<img src="{{imageUrl}}">'+
						'</div>'+
						'<div class="menudesc">'+
							'<h3>{{name}}</h3>'+
						'</div>'+
						'<div class="price_wrap">'+
							'<strong>￥<span class="unit_price">{{price}} * {{count}}</span></strong>'+
						'</div>'+
					'</div>'+
				'</li>';
	var s = [];
	for(var p in ORDER.detail.prods) {
		var o = ORDER.detail.prods[p];
		var _str = templet.replace(/{{imageUrl}}/g, o.imgurl)
						.replace(/{{name}}/g, o.prodname)
						.replace(/{{price}}/g, o.prodprice)
						.replace(/{{count}}/g, o.prodcount);
		s.push(_str);
	}
	$("#menuList ul").append(s.join(''));
	$('#allmoney').text(ORDER.totalFee);
	$('#menucount').text(ORDER.totalNum);		
});

</script>
</head>  
  <body>
		<div data-role="container" class="container myMenu">
			<section data-role="body">
				<div class="main">
					<div class="top">
						<span>
							<div>订单详情</div>	
						</span>
					</div>
				<div class="all" id="menuList">
					<ul id="usermenu"></ul>
				</div>
			</div>
			</section>
			<footer data-role="footer">			
				<nav class="g_nav">
					<div>
						<span class="cart"></span>
						<span> <span class="money">￥<label id="allmoney"></label></span>/<label id="menucount"></label>个菜</span>
						<a id="checkoutBtn" href="javascript:checkout();" class="btn green show" id="nextstep">退款</a>
					</div>
				</nav>
			</footer>
		</div>    
  </body>
</html>
