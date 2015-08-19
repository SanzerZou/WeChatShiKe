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
#userInfo,
#confirmInfo {
    display: none;
}
</style>
</head>
<body>

<div class="panel panel-primary">
    <div class="panel-heading">
        <h3 class="panel-title">用户信息
        </h3>
    </div>
    <div class="panel-body">
        <div class="container-fluid">
            <form class="form-horizontal" role="form"  id="userInfo">
                <div class="form-group">
                    <label for="phoneNoL" class="col-xs-12 col-sm-12 control-label">本微信号已与如下手机号绑定</label>
                    <div class="col-xs-12 col-sm-12">
                        <div id="phoneNo"></div>
                        <br/>
                        <div id="msg"></div>
                    </div>
                </div>
                <%-- 
                <div class="form-group">
                    <div class="col-xs-offset-3 col-xs-9 col-sm-offset-2 col-sm-10" style="padding-left: 0;">
                       <button id="submit_btn" type="submit" class="btn btn-primary btn-default">解除绑定</button>
                    </div>
                </div>
                --%>
            </form>    
            <form class="form-horizontal" role="form"  id="confirmInfo">
                <div class="form-group">
                    <label for="phoneNoLL" class="col-xs-12 col-sm-12 control-label">
                                    亲，没有您的绑定信息。。。一定是哪里搞错了。
                    </label>
                </div>
            </form>             
       </div>
    </div>
</div>
  
<script src="<%=request.getContextPath()%>/3rd/jquery/jquery.min.js"></script>
<%-- <script src="<%=request.getContextPath()%>/3rd/bootstrap/js/bootstrap.min.js"></script>--%>
<script src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script type="text/javascript">
var openId = '<%=request.getParameter("openId")%>';
var msg = '<%=request.getParameter("msg")%>';
function initView(){
	// $('#userInfo').css('display', 'none');
	// $('#confirmInfo').css('display', 'none');
    $.ajax({
        url: '<%=request.getContextPath()%>/pageService',
        type: 'post',
        async: false,
        dataType: 'json',
        data: JSON.stringify({
            service: "UserBindInfoService",
            openId: openId
        }),
        success: function (data, status) {
        	if (status != 'success') {
        		$('#confirmInfo').css('display', 'block');
        		return;
        	}
            if (data && data.phoneNo) {
            	$('#userInfo').css('display', 'block');
                $('#phoneNo').html(data.phoneNo);            	
            }
            else {
            	$('#confirmInfo').css('display', 'block');
            }
        }
    });
    if(msg != null && msg != 'null'){
        msg = decodeURIComponent(msg);
        $('#msg').html(msg);
    }
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
