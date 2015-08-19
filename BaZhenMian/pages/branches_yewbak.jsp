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
		<h3 class="panel-title">亲爱的客户，欢迎造访！享受不一般的品味！
		</h3>
    </div>
    <div class="panel-body">
        <div class="container-fluid">
			<div id="branchError"></div>
			<div id="branchTable" class="table-responsive">
			    <table class="table table-condensed">
			        <thead>
			            <tr>
                            <th>门店</th>
                            <th>地址</th>
                            <th>联系电话</th>			            
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
$('#branchTable').css('display', 'none');

$(function (){
	$.ajax({
	    url: '<%=request.getContextPath()%>/pageService',
	    type: 'post',
	    async: true,
	    dataType: 'json',
	    data: JSON.stringify({
	        service: "QueryBranchesService"
	    }),
	    success: function (data, status) {
	        
	        if (status != 'success') {
	        	$('#branchError').css('display', 'block');
	            return;
	        }

            var tableData = data.rows;
	        if (!tableData || tableData.length == 0) {
	            $('#branchError').css('display', 'block');
	        	return;
	        }
	        
            $('#branchError').css('display', 'none');	        
	        var tableBody = $('#tableBody'), tableRowLen = tableData.length, i = 0;
            for(i in tableData) {
                var tableRow = tableData[i];
                var tr=$("<tr></tr>");
                tr.appendTo(tableBody);
                
                var td=$("<td>"+ tableRow.name +"</td>");
                td.appendTo(tr);

                var td=$("<td>"+ tableRow.address +"</td>");
                td.appendTo(tr);
                
                var td=$("<td>"+ tableRow.tel +"</td>");
                td.appendTo(tr);
            }
            $('#branchTable').css('display', 'block');
	    }
	});     
	
});
</script>
</body>
</html>
