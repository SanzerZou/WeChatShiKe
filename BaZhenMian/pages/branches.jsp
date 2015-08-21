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
	padding-bottom: 10px;
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
<div class="container-fluid" style="display: none" id="branchs">
	<div class="row">
		<div class="col-xs-4">
			<img class="img-responsive img-rounded" src="<%=request.getContextPath()%>/3rd/image/{{img}}.jpg" alt="店铺图">
		</div>
		<div class="col-xs-8 address">
			<address>
				<h4>{{name}}</h4>
				<p>{{address}}</p>
				<h4>
					<a href="tel:{{tel}}">
						<span class="glyphicon glyphicon-earphone" aria-hidden="true"></span>&nbsp;{{tel}}
					</a>
				</h4>
			</address>
		</div>
	</div>
</div>
<script src="<%=request.getContextPath()%>/3rd/jquery/jquery.min.js"></script>
<script type="text/javascript">
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
	        	// $('#branchError').css('display', 'block');
	            return;
	        }

            var branchData = data.rows;
	        if (!branchData || branchData.length == 0) {
	            // $('#branchError').css('display', 'block');
	        	return;
	        }

	        var branchs = $('#branchs');
	        var templete = branchs.html();
	        var _html;
	        var s = [];
            for(i in branchData) {
                var row = branchData[i];
                if(row.name.indexOf('测试')!=-1) continue;
                _html = templete.replace(/{{name}}/g, row.name)
                				.replace(/{{address}}/g, row.address)
                				.replace(/{{tel}}/g, row.tel)
                				.replace(/{{img}}/g, row.name);
                s.push(_html);
            }
           	branchs.html( s.join("") ).show();
	    }
	});     
	
});
</script>
</body>
</html>
