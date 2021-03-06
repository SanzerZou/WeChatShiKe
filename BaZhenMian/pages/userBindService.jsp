<%@ page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE HTML>  
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no"> 
 
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/3rd/bootstrap/css/bootstrap.min.css" />
<style type="text/css">
body {
    font-size: 14px;
    font-family: 宋体;
    text-indent: 5px;
}

label.col-xs-4 {
    text-align: right;
    margin-top: 6px;
    margin-bottom: 0;
    padding-right: 5px;
    padding-left: 5px
}

label.col-xs-3 {
    text-align: right;
    margin-top: 6px;
    margin-bottom: 0;
    padding-right: 5px;
    padding-left: 5px
}

.col-xs-3,
.col-xs-6,
.col-xs-8,
.col-xs-9 {
    padding-left: 5px;
}

.panel-primary {
    margin-top: 20px;
    margin-left: 2px;
    margin-right: 2px;
}
</style>
</head>
<body>

<div class="panel panel-primary">
    <div class="panel-heading">
		<h3 class="panel-title">首次绑定手机即赠4元抵扣券！
		</h3>
    </div>
    <div class="panel-body">
        <div class="container-fluid">
            <form class="form-horizontal" role="form">
                <div class="form-group">
                    <label for="phoneNoL" class="col-xs-3 col-sm-2 control-label">手机号码</label>
                    <div class="col-xs-9 col-sm-10">
                        <input type="tel" class="form-control" id="phoneNo" placeholder="请输入手机号码来获取验证码。">
                    </div>
                </div>
                <div class="form-group">
                    <label for="verifyCodeL" class="col-xs-3 col-sm-2 control-label">验证码</label>
                    <div class="col-xs-6 col-sm-8">
                        <input type="number" class="form-control" id="verifyCode" placeholder="请输入验证码。">
                    </div>
                    <div class="col-xs-3 col-sm-2">
                        <button id="get_verify_code_btn" class="btn btn-primary btn-default">获取</button>
                    </div>
                </div>

				<div class="form-group">
	                <div class="col-xs-offset-3 col-xs-9 col-sm-offset-2 col-sm-10" >
	                   <div id="confirmInfo">
	                   </div>
	                </div>

				</div>
			</form>  
			<div class="row">
	            <div class="col-xs-offset-3 col-xs-9 col-sm-offset-2 col-sm-10" style="padding-left: 0;">
	                <button id="submit_btn" type="submit" class="btn btn-primary btn-default">提交</button>
	            </div>
			</div>           

	   </div>
	</div>
</div>
<script src="<%=request.getContextPath()%>/3rd/jquery/jquery.min.js"></script>
<%--  <script src="<%=request.getContextPath()%>/3rd/bootstrap/js/bootstrap.min.js"></script>--%>
<script src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script type="text/javascript">

var openId = '<%=request.getParameter("openId")%>';
var COUNT_MAX = 60, counter = COUNT_MAX;
var timerId;
function resetVerifyCode () {
	$('#get_verify_code_btn').removeAttr("disabled");
    $('#confirmInfo').html('');
    clearInterval(timerId);
}

function resetVerifyCodeCounter () {
	$('#confirmInfo').html(counter+' 秒后重新获取验证码');
	--counter;
}
var re = /^[\d]+$/;
    
function initView(){
	$('#get_verify_code_btn').attr("disabled", true);
	$('#submit_btn').attr("disabled", true);
	
	$("#phoneNo").on('input', function(e) {
		var phoneNo = $("#phoneNo").val();
		if (!phoneNo) {
			$('#get_verify_code_btn').attr("disabled", true);
			return;
		}
		if (phoneNo.length < 8) {
			$('#get_verify_code_btn').attr("disabled", true);
			return;
		}
		
		if (!re.test(phoneNo)) {
			$('#get_verify_code_btn').attr("disabled", true);
			return;
		}
		$('#get_verify_code_btn').removeAttr("disabled");
	});  
	
    $("#verifyCode").on('input', function(e) {
        var verifyCode = $("#verifyCode").val();
        if (!verifyCode) {
        	$('#submit_btn').attr("disabled", true);
            return;
        }
        if (verifyCode.length < 6) {
        	$('#submit_btn').attr("disabled", true);
            return;
        }
        
        if (!re.test(verifyCode)) {
        	$('#submit_btn').attr("disabled", true);
            return;
        }
        $('#submit_btn').removeAttr("disabled");
    });  	

    $('#get_verify_code_btn').bind('click', function () {
        $('#get_verify_code_btn').attr("disabled", true);
        
        counter = COUNT_MAX;
        setTimeout('resetVerifyCode();', 60000);
        
        timerId = setInterval('resetVerifyCodeCounter();', 1000);
        var phoneNo = $('#phoneNo').val();
        $.ajax({
            url: '<%=request.getContextPath()%>/pageService',
            type: 'post',
            async: false,
            dataType: 'json',
            data: JSON.stringify({
                service: "GetVerifyCodeService",
                openId: openId,
                phoneNo: phoneNo
            })
        });        
    });
    
    $('#submit_btn').bind('click', function (){
        $('#confirmInfo').html('');
        clearInterval(timerId);
        
    	var verifyCode = $('#verifyCode').val();
    	var phoneNo = $('#phoneNo').val();
        $.ajax({
            url: '<%=request.getContextPath()%>/pageService',
            type: 'post',
            async: false,
            dataType: 'json',
            data: JSON.stringify({
                service: "DynamicService",
		scriptService:"userBindService",
                openId: openId,
                verifyCode: verifyCode,
                phoneNo: phoneNo
            }),
            success: function (d, s) {
                //{'resultCode':'','desc':'','voucherCode':'','validPeriod':'','faceValue':,'totalPoint':}
                if(d.error) {
                    alert('验证码错误或已失效');
                    return;
                }
                var o = jQuery.parseJSON(d.data);
                if(o.resultCode == 0){
                    var c = o.voucherCode;
                    var p = o.validPeriod;
                    var v = o.faceValue;
                    var msg = '';
                    if(c!=null){
                        msg = encodeURIComponent('您获得'+v+'元抵扣券<br/><br/>兑换码为:'+c+'<br/>有效期截至:'+p+'<br/>您可通过"抵扣券查询"菜单查询已领抵扣券');
                    }
                    location.href = '<%=request.getContextPath()%>/pages/userBindInfo.jsp?openId='+openId+'&msg='+msg;
                } else {
                    alert(o.desc);
                }
            }
        });
    });
}
$(function () {
    <%--
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
                jsApiList: ['hideOptionMenu', 'hideMenuItems', 'closeWindow']
            });

           wx.ready(function(){
               
               wx.hideMenuItems({
                   menuList: ["menuItem:editTag", "menuItem:delete","menuItem:copyUrl","menuItem:originPage","menuItem:readMode","menuItem:openWithQQBrowser","menuItem:openWithSafari", "menuItem:share:email"
                              ,"menuItem:share:appMessage","menuItem:share:timeline","menuItem:share:qq","menuItem:share:weiboApp","menuItem:favorite","menuItem:share:facebook", "menuItem:share:QZone"
                              ]
               });
               initView();
           });
           wx.error(function(res){
               showError('业务忙，请重新打开页面');
           });
        }
    });
    --%>    
    initView();
});
</script>
</body>
</html>
