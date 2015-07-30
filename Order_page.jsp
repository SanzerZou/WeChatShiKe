<%@ page language="java" import="java.util.*" contentType="text/html; charset=UTF-8"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="css/common.css" media="all">
<link rel="stylesheet" type="text/css" href="css/color.css" media="all">
<script type="text/javascript" src="js/jquery.js"></script>
<script type="text/javascript" src="js/dmain.js"></script>
<script type="text/javascript" src="js/dialog.js"></script>
<script type="text/javascript" src="js/showdialog.js"></script>
<script type="text/javascript" src="js/scroller.js"></script>

<script src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>

<title>订单</title>
<meta content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport">
<meta name="Keywords" content="">
<meta name="Description" content="">
<!-- Mobile Devices Support @begin -->
<meta content="telephone=no, address=no" name="format-detection">
<meta name="apple-mobile-web-app-capable" content="yes"> <!-- apple devices fullscreen -->
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
<!-- Mobile Devices Support @end -->

<script type="text/javascript">	
var discount=0;
var islock=false;
// JavaScript code

var openId = '<%=request.getParameter("openId")%>';
// var orderMap = <%=request.getParameter("orderMap")%>;
var transId = <%=request.getParameter("transId")%>;
// 提出对应transId中的数据内容
var orderItem = JSON.parse(window.localStorage.getItem("orders"))[transId];
var orderMap = orderItem.content;
var isPay = orderItem.info.isPay;
var brandUidStr = '<%=request.getParameter("brandUidStr")%>';
var branchUidStr = '<%=request.getParameter("branchUidStr")%>';
var sum = 0.0;

$(document).ready(function(){
	for(var p in orderMap) {
		var o = orderMap[p];
		var prod = o.obj;
		var s = '<li data-dishuid="'+o.dishUid+'" >'+
					'<div class="licontent">'+
						'<div class="span">'+
							'<img src="'+prod.dishImageUrl+'" alt="" url="">'+
						'</div>'+
						'<div class="menudesc">'+
							'<h3>'+prod.dishName+'</h3>'+
							'<p style="line-height: 30px;">库存：999</p>'+
							'<p class="addmark j_isPay" onclick="addmark($(this))">添加备注</p>'+
						'</div>'+
						'<div class="price_wrap">'+
							'<strong>￥<span class="unit_price" data-price="'+prod.dishPrice+'">'+prod.dishPrice+'</span></strong>'+
							'<div class="fr" max="999">'+
								'<a href="javascript:void(0);" class="btn minus j_isPay"></a><span class="num"><input type="text" readonly="true" value="'+o.count+
					'"></span><a href="javascript:void(0);" class="btn plus j_isPay" data-num="'+o.count+'"></a>'+
							'</div>'+
						'</div>'+
					'</div>'+
					'<input type="text" class="markinput" placeholder="备注(30个汉字以内)" name="dish[9][omark]" value="">'+
				'</li>';
		$("#menuList ul").append(s);
	}
	var ta = <%=request.getParameter("totalPrice")%>;
	var tc = <%=request.getParameter("totalNum")%>;
	var	_total = $('#allmoney')
	, _cartNum = $('#menucount');
	_total.text(ta);
	_cartNum.text(tc);
	/**
	 * 为列表加号键添加绑定监听
	 */
	$('#menuList li').each(function(){
		var _dishUid = $(this).data("dishuid");
		var _prod = orderMap[_dishUid].obj;
		var plus = $(this).find(".plus");
		plus.amount(_prod, $.amountCb());
	});
	// 如果已经付款则隐藏一部分元素
	if(isPay === true){
		$(".j_isPay").hide();
	}
});

function onEncodeSuccess(data, status) {
    if (status != 'success') {
        $('#branchError').css('display', 'block');
        $('#branchError').html('主人，业务忙，正在稍后重试。。。');
        return;
    }
    
    //alert(JSON.stringify(data));
    wx.chooseWXPay({
        timestamp: data.timestamp, // 支付签名时间戳，注意微信jssdk中的所有使用timestamp字段均为小写。但最新版的支付后台生成签名使用的timeStamp字段名需大写其中的S字符
        nonceStr: data.nonceStr, // 支付签名随机串，不长于 32 位
        package: data.package, // 统一支付接口返回的prepay_id参数值，提交格式如：prepay_id=***）
        signType: data.signType, // 签名方式，默认为'SHA1'，使用新版支付需传入'MD5'
        paySign: data.paySign, // 支付签名
        success: function (res) {
            //alert('支付成功');
			var arr = [];
			for(var p in orderMap) {
				var o = orderMap[p];
				delete o.obj;
				arr.push(o);
			}
			//alert('支付成功。');
			var desk = $('#deskId').val();
			desk = desk==null?'':desk;
			//alert(desk);
			$.ajax({
				url: '<%=request.getContextPath()%>/pageService',
				type: 'post',
				contentType:'application/json;charset=UTF-8',
				async: true,
				dataType: 'json',
				data: JSON.stringify({
					service: "DynamicTransmitService",
					scriptService: "shop_order.action",
					openId: openId,
					brandUid: brandUidStr,
					branchUid: branchUidStr,
					deskID: desk,
					transInfo: {'transID':transId,'transTime':'2015-07-16 12:00:00','transAmount':sum,'transDetails':arr}
				}),
				success: function(d, s){
					//{'resultCode':,'desc':'','menu':[{'categoryName':'','dishes':[{'dishUid':'','dishName':'','dishPrice':,'dishImageUrl':''}]}]}
					//alert('支付成功');
					//window.location.href='onlineShop.jsp?openId='+openId;
					var o = jQuery.parseJSON(d.data);
					//alert(o.resultCode);
					if(o.resultCode == 0){
						window.location.href = 'menu.jsp?openId='+openId+'&brandUid='+brandUidStr+'&branchUid='+branchUidStr;
						//window.location.href='onlineShop.jsp?openId='+openId;
					} else {
						alert(o.desc);
					}
				},
				error: function(r, e, o){
					alert('发生内部错误，请联系公众号管理员')
				}
			});	
        }
    });
}

function guid() {
	function s4() {
		return Math.floor((1 + Math.random()) * 0x10000)
		.toString(16)
		.substring(1);
	}
	return s4() + s4()  + s4()  + s4() + s4() + s4() + s4() + s4();
}

function enableCheckoutBtn(){
	$('#checkoutBtn').addClass('orange');
	$('#checkoutBtn').removeClass('disabled');
	$('#checkoutBtn').removeClass('gray');	
}

function disableCheckoutBtn(){
	$('#checkoutBtn').removeClass('orange');
	$('#checkoutBtn').addClass('disabled');
	$('#checkoutBtn').addClass('gray');	
}
	
function checkout(){
	disableCheckoutBtn();
	setTimeout(enableCheckoutBtn, 300);

	sum = 0
	for(var p in orderMap) {
		var o = orderMap[p];
		var prod = o.obj;
		sum += parseFloat(prod.dishPrice) * parseFloat(o.count);
	}
	
 	var tradeNo = guid();
	var prodName = '仅供体验测试，不销售任何产品'
	$.ajax({
		url: '<%=request.getContextPath()%>/pageService',
		type: 'post',
		contentType:'application/json;charset=UTF-8',
		async: true,
		dataType: 'json',
		data: JSON.stringify({
			service: "DynamicService",
			scriptService: "userOrder",
			openId: openId,
			prodDesc: prodName,
			tradeNo: tradeNo,
			totalFee: sum,
			clientAddress:'<%=request.getRemoteAddr() %>'
		}),
		success: onEncodeSuccess,
		error: function(r, e, o){
			alert('发生内部错误，请联系公众号管理员');
		}
	});
}

function discard(){
	cancel();
	window.location.href = 'menu.jsp?openId='+openId+'&brandUid='+brandUidStr+'&branchUid='+branchUidStr;
}

function addmark(obj){
	obj.parent().parent().siblings(".markinput").toggle();
}

$(function () {
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

            var debugEnabled = false || data.debug;
            wx.config({
                debug: debugEnabled,
                appId: data.appId, 
                timestamp: data.timestamp, 
                nonceStr: data.nonceStr,
                signature: data.signature,
                jsApiList: ['hideOptionMenu', 'hideMenuItems', 'closeWindow', 'chooseWXPay']
            });

           wx.ready(function(){
               
               wx.hideMenuItems({
                   menuList: ["menuItem:editTag", "menuItem:delete","menuItem:copyUrl","menuItem:originPage","menuItem:readMode","menuItem:openWithQQBrowser","menuItem:openWithSafari", "menuItem:share:email"
                              ,"menuItem:share:appMessage","menuItem:share:timeline","menuItem:share:qq","menuItem:share:weiboApp","menuItem:favorite","menuItem:share:facebook", "menuItem:share:QZone"
                              ]
               });
               <%--
               wx.hideOptionMenu();
               --%>
               initView();
           });
           wx.error(function(res){
               showError('业务忙，请重新打开页面');
           });
        }
    });    
});
		</script>
  </head>
  
  <body>
		<div data-role="container" class="container myMenu">
			<section data-role="body">
			<div class="main">
				<div class="top">
					<span>
						<div >我的菜单</div>						
						
						<div class="j_isPay">桌号：
							<input type="number" id="deskId" style="width:50px; height:30px; font-size:150%"/>
						</div>
						<!-- <a href="#" class="add">加菜</a> -->
						<a href="javascript:popup();" class="clear j_isPay">清空</a>
					</span>
				</div>
			<form name="myorderform" method="POST" action="">
			<div class="all" id="menuList">
				<ul id="usermenu"></ul>
				</div>
				<div class="mark j_isPay">
					<textarea placeholder=" 备注" name="allmark"></textarea>
					<input autocomplete="off" type="hidden" name="totalmoney" id="totalmoney" value="">
					<input autocomplete="off" type="hidden" name="totalnum" id="totalnum" value="">
					<input autocomplete="off" type="hidden" name="mycid" value="3">
				</div>
				<!-- Order's unique hash code -->
			</form>
			</div>
			</section>
			<footer data-role="footer">			
				<nav class="g_nav">
					<div>
						<span class="cart"></span>
						<span> <span class="money">￥<label id="allmoney"></label></span>/<label id="menucount"></label>个菜</span>
						<a id="checkoutBtn" href="javascript:checkout();" class="btn orange show j_isPay" id="nextstep">结账</a>
					</div>
				</nav>
			</footer>
			<!-- 弹出框信息 -->
			<div class="layer transparent"> </div>
			<div class="layer popup">
				<div class="dialogX">
					<div class="content">
						<div class="title">清空菜单</div>
						<div class="message">您是否要清空该菜单？</div>
					</div>
					<div class="button">
						<a class="cancel" href="javascript:cancel();">取消</a>
						<a href="javascript:discard();">确定</a>
					</div>
				</div>			
			</div>
		</div>    
  </body>
</html>
