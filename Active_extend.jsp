<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>续费</title>
<link rel="stylesheet" href="js/jquery.mobile-1.3.2.min.css">
<script src="js/jquery-1.8.3.min.js"></script>
<script src="js/jquery.mobile-1.3.2.min.js"></script>

<meta content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport">
<!-- Mobile Devices Support @begin -->
<meta content="telephone=no, address=no" name="format-detection">
<meta name="apple-mobile-web-app-capable" content="yes"> <!-- apple devices fullscreen -->
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
	<!-- Mobile Devices Support @end -->
<style type="text/css">
</style>

<script src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
</head>
<body>
<div data-role="page">
<!-- ListView -->
	<div class="content" data-role="content" data-theme="d">
	    <form id="infoForm">
	      <div data-role="fieldcontain">
	        <label for="activation-code" class="label">激活码：</label>
	        <input type="text" name="activation-code" id="activation-code">
	        <br> 

			<fieldset data-role="controlgroup" id="radio-wrap">
				<legend>套餐选择：</legend>
				<!-- template -->
			</fieldset>
	        <br>

	        <label for="phone-num" class="label">推荐人手机号：</label>
	        <input type="text" name="phone-num" id="phone-num">
	      </div>  
	      <input id="submit_btn" type="submit"  value="结账" data-theme="b">
	    </form>
	</div>
</div>
<script type="text/javascript">
var openId = '<%=request.getParameter("openId")%>';

function guid() {
	function s4() {
		return Math.floor((1 + Math.random()) * 0x10000)
		.toString(16)
		.substring(1);
	}
	return s4() + s4()  + s4()  + s4() + s4() + s4() + s4() + s4();
}

function getRadioVal(){
	var fee_and_period = $("input[name='choice-v']:checked").val();
}
// 初始化界面
function showForm () {
	// show code
	var code = '9361070904382189';
	$('#activation-code').val(code).textinput( "disable" );
	// show Form
	var data = [
		{
			val : 10,
			str : "6个月——100元/月"
		},
		{
			val : 20,
			str : "12个月——80元/月"
		},
		{
			val : 40,
			str : "24个月——50元/月"
		},
		{
			val : 50,
			str : "36个月——40元/月"
		}
	];
	var input = '<input type="radio" name="choice-v" id="radio-{{index}}" value="{{val}}">';
	var label = '<label for="radio-{{index}}">{{str}}</label>';
				
	var wrap = $("#radio-wrap");
	for (var i in data) {
		$(input.replace( /{{index}}/g, i ).replace(/{{val}}/g, data[i].val) )
				.appendTo(wrap);
		$(label.replace( /{{index}}/g, i ).replace(/{{str}}/g, data[i].str) )
				.appendTo(wrap);
	}
	wrap.closest(":jqmData(role='page')").trigger('pagecreate');
	$("input[name='choice-v']").bind('click',function() {  
		$("input[name='choice-v']").attr("checked", false).checkboxradio("refresh");
	    $(this).attr("checked", true ).checkboxradio("refresh");   // 绑定事件及时更新checkbox的checked值  
	});
	$("#radio-0").attr("checked", true ).checkboxradio( 'refresh' );
}

function checkout(){
 	var tradeNo = guid();
	var prodName = '续费';
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
			totalFee: totalfee,
			clientAddress:'<%=request.getRemoteAddr()%>'
		}),
		success: onEncodeSuccess,
		error: function(r, e, o){
			alert('请选择一种续费套餐');
		}
	});
}

function onEncodeSuccess(data, status) {
    if (status != 'success') {
        $('#branchError').css('display', 'block');
        $('#branchError').html('主人，业务忙，正在稍后重试。。。');
        return;
    }
    wx.chooseWXPay({
        timestamp: data.timestamp, // 支付签名时间戳，注意微信jssdk中的所有使用timestamp字段均为小写。但最新版的支付后台生成签名使用的timeStamp字段名需大写其中的S字符
        nonceStr: data.nonceStr, // 支付签名随机串，不长于 32 位
        package: data.package, // 统一支付接口返回的prepay_id参数值，提交格式如：prepay_id=***）
        signType: data.signType, // 签名方式，默认为'SHA1'，使用新版支付需传入'MD5'
        paySign: data.paySign, // 支付签名
        success: function (res) {
       		var phoneno = $('#phoneId').val();
        	phoneno = phoneno==null?'':phoneno;
        	$.ajax({
        		url: '<%=request.getContextPath()%>/pageService',
        		type: 'post',
        		contentType:'application/json;charset=UTF-8',
        		async: true,
        		dataType: 'json',
        		data: JSON.stringify({
        			service: "DynamicTransmitService",
        			scriptService: "activeExtend",
        			openId: openId,
        			code: code,
        			extendPeriod: extendPeriod,
        			phoneno:phoneno,
        			clientAddress:'<%=request.getRemoteAddr()%>'
					}),
					success : function(d){
						//{"data":"{\"desc\":\"\",\"expireDate\":\"2042-06-19\",\"resultCode\":0}"}
						var m = jQuery.parseJSON(d.data);
				//		alert(m);
						if(m.resultCode == 0){
							window.location.href = 'Active_extend_msg.jsp?expireDate='+m.expireDate;
						} else {
							alert(m.desc);
						}	
					},
					error : function(r, e, o) {
						alert('发生内部错误，请联系公众号管理员');
					}
				});
			}
		});
}

$(function() {
	showForm();
	// var code = '9361070904382189';
	// $('#activation-code').val(code).textinput( "disable" );
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

	          //  var debugEnabled = false || data.debug;
	              var debugEnabled = false;
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
</body>
</html>