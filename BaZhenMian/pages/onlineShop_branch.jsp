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
    font-family: 黑体;  
    background-color: #EEEEEE;  
    /*text-indent: 5px;*/
}
/*卡片样式*/
.row {
	padding-top: 10px;
	margin-top: 5px;
	box-shadow: 0px 1px 2px #9E9E9E;
	background-color: #fafafa;
}

.address h4,
.address a{
	font-weight: bold;
}
.address a {
	color: #616161;
}

</style>
</head>
<body>
	<div class="container-fluid" id="branchs">
		<div class="row">
			<div class="col-xs-12">
				<div class="row">
					<div class="col-xs-6"></div>
					<div class="col-xs-6"></div>
				</div>
			</div>
			<div class="col-xs-12 address">
				<h2 class="text-center"><span class="glyphicon glyphicon-barcode"></span>7915155145</h2>
				<div></div>
			</div>
		</div>
	</div>
</body>
</html>
