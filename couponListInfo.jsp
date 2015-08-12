<%@ page contentType="text/html; charset=utf8"%>
<!DOCTYPE HTML>  
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no"> 
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black">
<meta name="format-detection" content="telephone=no">

<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap.min.css">
<script type="text/javascript" src="js/jquery.js"></script>
<script type="text/javascript" src="js/jquery-barcode.min.js"></script>
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
			<div id="couponError" style="display: none;">暂无折扣券信息</div>
			<div id="couponTable" style="display: block;" class="table-responsive">
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
	                    <tr>
	                    	<td>4</td>
	                    	<td>7915155145</td>
	                    	<td>2016-01-19</td>
	                    	<td>未使用</td>
	                    </tr>
                   	</tbody>			    
			    </table>
			    <div id="barcode" style="margin: 10px 0 50px 0">
			    </div>
			    <table class="table table-condensed">
                    <tbody>
	                    <tr>
	                    	<td>4</td>
	                    	<td>7915155145</td>
	                    	<td>2016-01-19</td>
	                    	<td>未使用</td>
	                    </tr>
                   	</tbody>			    
			    </table>
			    <div id="barcode2">
			    </div>
			</div>
	   </div>
	</div>
</div>
<script>
$(function() {
	$("#barcode").barcode("7915155145", "codabar",{barWidth:2, barHeight:90, showHRI:false});
	$("#barcode2").barcode("7915155145", "codabar",{barWidth:2, barHeight:90, showHRI:false});
})
</script>
</body>
</html>
