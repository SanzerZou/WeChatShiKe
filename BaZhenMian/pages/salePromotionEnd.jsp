<%@ page contentType="text/html; charset=utf8"%>
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
        <h3 class="panel-title">促销活动结束
        </h3>
    </div>
    <div class="panel-body">
        <div class="container-fluid">
            <div class="row">
                <div class="col-xs-offset-3 col-xs-9 col-sm-offset-2 col-sm-10" style="padding-left: 0;">
                    您已参加过当前活动，感谢您的关注，请留意后续促销宣传。
                </div>
            </div>           

       </div>
    </div>
</div>
<script src="<%=request.getContextPath()%>/3rd/jquery/jquery.min.js"></script>
<%--  <script src="<%=request.getContextPath()%>/3rd/bootstrap/js/bootstrap.min.js"></script>--%>
<script src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script type="text/javascript">

function initView(){

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
