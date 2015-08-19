<%@ page contentType="text/html; charset=utf8"%>
<!DOCTYPE HTML>  
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no"> 
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black">
<meta name="format-detection" content="telephone=no">

<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/3rd/bootstrap/css/bootstrap.min.css" />
<%--
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/3rd/jquery/jquery-ui.min.css" />
--%>

<style type="text/css">
body {
    font: normal 100%;
    font-family: 宋体;    
    text-indent: 5px;
}

.container-fluid {
    padding-left: 0;
    padding-right: 0;
}

.panel-body {
    padding-left: 1px;
    padding-right: 1px;
}
</style>
</head>
<body>

<div class="panel panel-primary">
    <div class="panel-heading">
		<h3 class="panel-title">折扣券列表
		</h3>
    </div>
    <div class="panel-body">
        <div class="container-fluid">
			<div id="couponError" style="display:none">暂无折扣券信息</div>
			<div id="couponTable" style="display:none" class="table-responsive">
			    <table class="table table-condensed">
			        <thead>
			            <tr>
                            <th>面值</th>
                            <th>兑换码</th>
                            <th>有效期</th>
                            <th>状态</th>
                        </tr>
                    </thead>
                    <tbody id="tableBody">
                    </tbody>			    
			    </table>
			</div>
	   </div>
	</div>
</div>
<script src="<%=request.getContextPath()%>/3rd/jquery/jquery.min.js"></script>
<%--  
<script src="<%=request.getContextPath()%>/3rd/jquery/jquery-ui.min.js"></script>
--%>
<%--
<script src="<%=request.getContextPath()%>/3rd/bootstrap/js/bootstrap.min.js"></script>
--%>
<script type="text/javascript">
var openId = '<%=request.getParameter("openId")%>';

$('#couponTable').css('display', 'none');

$(function (){
	$.ajax({
	    url: '<%=request.getContextPath()%>/pageService',
	    type: 'post',
	    async: true,
	    dataType: 'json',
	    data: JSON.stringify({
            service: "DynamicService",
            scriptService:"couponList",
	        openId: openId
	    }),
	    success: function (data, status) {
	        if (status != 'success') {
	        	$('#couponError').css('display', 'block');
	            return;
	        }
            var o = jQuery.parseJSON(data.data);
            //{'resultCode':,'errDesc':'','vouchers':[{'faceValue':,'validPeriod':'','status':,'voucherCode':''}]}
            if(o.resultCode == 0){
            	var arr = o.vouchers;
            	if(arr.length == 0){
            		$('#couponError').css('display', 'block');
            		return;
            	}
            	$('#couponError').css('display', 'none');
		        var tableBody = $('#tableBody'), tableRowLen = arr.length, i = 0;
	            for(i in arr) {
	                var tableRow = arr[i];
	                var tr=$("<tr></tr>");
	                tr.appendTo(tableBody);
	                
	                var td=$("<td>"+ tableRow.faceValue +"</td>");
	                td.appendTo(tr);

	                var td=$("<td>"+ tableRow.vocherCode +"</td>");
	                td.appendTo(tr);
	                
	                var td=$("<td>"+ tableRow.validPeriod +"</td>");
	                td.appendTo(tr);

	                var s = tableRow.status==0?'未使用':'已使用';
	               	var td=$("<td>"+ s +"</td>");
	                td.appendTo(tr);

	            }
	            $('#couponTable').css('display', 'block');            	
            } else {
               	alert(o.desc);
            }

	        
            	        

	    }
	});     
	
});
</script>
</body>
</html>
