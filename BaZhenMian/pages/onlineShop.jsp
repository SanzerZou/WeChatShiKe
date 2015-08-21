<%@ page contentType="text/html; charset=utf8"%>
<!DOCTYPE HTML>  
<html>
<head>
<title>折扣券列表</title>
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no"> 
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black">
<meta name="format-detection" content="telephone=no">

<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/3rd/bootstrap/css/bootstrap.min.css" />
<script src="<%=request.getContextPath()%>/3rd/jquery/jquery.min.js"></script>
<script type="text/javascript" src="js/jquery-barcode.min.js"></script>

<style type="text/css">
body {
    font: normal 100%;
    font-family: "Microsoft YaHei" !important;  
    background-color: #EEEEEE;  
    /*text-indent: 5px;*/
}

.row {
	background-color: #fafafa;
	border-radius: 5px;
	margin: 8px 1px;
	box-shadow: 0px 1px 2px #9E9E9E;
}
.row .info {
	border-bottom: 3px dashed #FFF;
	color: #FFF;
	background-color: #00695C;
	border-radius: 5px 5px 0 0;
}

.row .info h2 {
	font-weight: bold;
}

.row .bar {
	padding-top: 5px;
	padding-bottom: 8px;
}

.row .bar p {
	font-weight: bold;
}

.row .barcode {
	margin: 0 auto;
}

.row .used {
	position: absolute;
	display: none;
	height: 100%;
	top: 0;
	left: 0;
	z-index: 2;
	border-radius: 5px;
}
.used p{
	position: absolute;
	top: 50%;
	left: 50%;
	margin-left: -7rem;
	margin-top: -7rem;
	font-size: 14rem;
	color: #B71C1C;
}

#error h1 {
	margin-top: 40%;
	font-size: 2em;
	text-align: center;
	color: #757575;
}
#error span {
	font-size: 1.5em;
}
</style>
</head>
<body>
<div class="container-fluid" id="coupons" style="display: none">
<!-- template -->
	<div class="row" style="position:relative">
		<div class="col-xs-12 info">
			<h2 class="text-center"><span class="glyphicon glyphicon-yen"></span>&nbsp;{{val}}</h2>
			<p  class="text-center"><small>{{period}}</small></p>
		</div>
		<div class="col-xs-12 bar">
			<p class="text-center" style="font-weight: bold"><span class="glyphicon glyphicon-barcode"></span>&nbsp;{{code}}</p>
			<div id="barcode-{{index}}" class="barcode"></div>
		</div>
		<div class="col-xs-12 used" style="display:{{status}}">
			<p><span class="glyphicon glyphicon-ban-circle"></span></p>	
		</div>
	</div>
</div>
<div class="container-fluid" id="error" style="display: none">
	<h1><span class="glyphicon glyphicon-exclamation-sign"></span><br>没有优惠券</h1>
</div>

<script type="text/javascript">
var openId = '<%=request.getParameter("openId")%>';

$(function (){
	var arr = [
	{
		faceValue: 4,
		validPeriod: "2012-12-01",
		voucherCode: "7915155145",
		status: 0
	},
	{
		faceValue: 10,
		validPeriod: "2012-12-01",
		voucherCode: "7915155145",
		status: 1
	}]
    var coupons = $('#coupons');
    var template = 	coupons.html();
    coupons.html("");
    var _html;
    for(i in arr) {
        var row = arr[i];
        _html = template.replace(/{{val}}/g, row.faceValue)
        				.replace(/{{period}}/g, row.validPeriod)
        				.replace(/{{code}}/g, row.voucherCode)
        				.replace(/{{index}}/g, i)
        				.replace(/{{status}}/g, row.status == 0 ? "none" : "block");
        coupons.append(_html);
        $("#barcode-" + i).barcode( row.voucherCode, "codabar",{barWidth:2, barHeight:90, showHRI:false, bgColor:"#fafafa"});
    }
    coupons.show();  
});
</script>
</body>
</html>
