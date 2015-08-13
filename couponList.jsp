<%@ page contentType="text/html; charset=utf8"%>
<!DOCTYPE HTML>  
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no"> 
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black">
<meta name="format-detection" content="telephone=no">

<!-- <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/3rd/bootstrap/css/bootstrap.min.css" /> -->
<%-- 
<script src="<%=request.getContextPath()%>/3rd/jquery/jquery.min.js"></script>
<script type="text/javascript" src="js/jquery-barcode.min.js"></script>
--%>
<!-- 测试 -->
<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap.min.css">
<script type="text/javascript" src="js/jquery-1.8.3.min.js"></script>
<script type="text/javascript" src="js/jquery-barcode.min.js"></script>s

<style type="text/css">
body {
    font: normal 100%;
    font-family: 宋体;    
    text-indent: 5px;
}

.container-fluid {
    padding-left: 0;
    padding-right: 0;
    overflow: hidden;
}

.panel-body {
    padding-left: 1px;
    padding-right: 1px;
}

.barcode {
	margin: 10px 0 50px 0;
	overflow: hidden;
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
        <div class="container-fluid" style="overflow: hidden; min-width: 300px">
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
			    </table>
			</div>
	   </div>
	</div>
</div>

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
		        var couponTable = $('#couponTable'), tableRowLen = arr.length, i = 0;
	            for(i in arr) {
	                var tableRow = arr[i];
	                var table = $('<table class="table table-condensed"></table>');
	                var tb = $("<tbody></tbody>");
	                var tr=$("<tr></tr>");
	                table.appendTo(couponTable);
	                
	                var td=$("<td>"+ tableRow.faceValue +"</td>");
	                td.appendTo(tr);

	                var td=$("<td>"+ tableRow.vocherCode +"</td>");
	                td.appendTo(tr);
	                
	                var td=$("<td>"+ tableRow.validPeriod +"</td>");
	                td.appendTo(tr);

	                var s = tableRow.status==0?'未使用':'已使用';
	               	var td=$("<td>"+ s +"</td>");
	                td.appendTo(tr);
	                tr.appendTo(tb);
	                tb.appendTo(table);

	                var barcode = $('<div class="barcode" id="barcode-'+i+'"></div>');
	                barcode.appendTo(couponTable);
	                $("#barcode-"+i).barcode( tableRow.vocherCode, "codabar", {barWidth:2, barHeight:90, showHRI:false});
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
