<%@ page language="java" import="java.util.*" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="css/myCss.css" media="all">
<script type="text/javascript" src="js/jquery.js"></script>
<title>食客来了</title>	
<meta content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport">
<meta content="width=device-width" name="viewport">
<meta name="Keywords" content="">
<meta name="Description" content="">
<!-- Mobile Devices Support @begin -->
<meta content="telephone=no, address=no" name="format-detection">
<meta name="apple-mobile-web-app-capable" content="yes"> <!-- apple devices fullscreen -->
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
	<!-- Mobile Devices Support @end -->
<style type="text/css">
.item{
	position:relative;
	padding:5px 2%;
	margin:0 4%;
	border-bottom:1px solid;
	border-color: rgb(192, 192, 192);
}
</style>

<script type="text/javascript">
var g_baseurl = '<%=request.getContextPath()%>';
var g_openId = '<%=request.getParameter("openId")%>';
var g_brandUidStr = 'bf754d76-26ac-11e5-8c51-55a12bf13948';

$(document).ready(function(){
	//店铺信息加载
	$.ajax({
	    url: g_baseurl+'/pageService',
	    type: 'post',
	    contentType:'application/json;charset=UTF-8',
	    async: true,
	    dataType: 'json',
	    data: JSON.stringify({
	        service: "DynamicTransmitService",
	        scriptService: "shop_branchLoad.action",
	        openId: g_openId
	    }),
	    success: function(d, s){
	    	//{'resultCode':,'desc':,'branches':[{'brandUid':'',uid':'','name':'','address':'','tel':''}]}
	    	var o = jQuery.parseJSON(d.data);
	    	if(o.resultCode == 0){
	    		for(var i = 0, length= o.branches.length; i < length; i++){
	    			var dist = Math.round(Math.random()*1000);
	    			var br = o.branches[i];
	    			// onclick事件绑定； 设置brand Uid和uid这两个参数用于查找商家
	    			var s = ' <li class="item" onclick="showMenu(this)" uid="'+br.uid+'" buid="'+br.brandUid+'"> <div class="store_ifo"> <h3 class="store_name">' + br.name +  
	    			'</h3><p class="store_address"> ' + br.address + "&nbsp;" + br.tel +
	    			'</p></div><div class="distance">'+dist+'米</div></li>';

	    			$(".content ul").append(s);
	    		}
	    	} else {
	    		alert(o.desc);
	    	}
	    },
	    error: function(r, e, o){
	        alert('发生内部错误，请联系公众号管理员');
	    }
	})
});

function showMenu(li){
	var o = $(li);
	// 使用jQuery的attr来保存属性，属性是直接在标签内添加，这种方法要比data-方便
	var uid = o.attr('uid');
	var buid = o.attr('buid');
	// 重定向，并且通过url传参
	window.location.href = 'menu.jsp?openId='+g_openId+'&brandUid='+buid+'&branchUid='+uid;
}

</script>
</head>
  
<body>
	<header></header>
	<div class="button">
	    <button id="list" type="button">列表</button><button id="site" type="button">地图</button>
	</div>
	<div class="content">
		<ul class="store_list">
			
		</ul>
	</div>
</body>
</html>
