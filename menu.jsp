<%@ page language="java" import="java.util.*" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="css/common.css" media="all">
<link rel="stylesheet" type="text/css" href="css/color.css" media="all">
<script type="text/javascript" src="js/jquery.js"></script>
<script type="text/javascript" src="js/dmain.js" charset="UTF-8"></script>
<script type="text/javascript" src="js/dialog.js" charset="UTF-8"></script>
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
<script type="text/javascript">
var g_baseurl = '<%=request.getContextPath()%>';
var g_openId = '<%=request.getParameter("openId")%>';
var g_brandUidStr = '<%=request.getParameter("brandUid")%>';
var g_branchUidStr = '<%=request.getParameter("branchUid")%>';;

var discount=0; 
var totalPrice=totalNum=0;
var g_data; // 存放变量
var orderMap ={};
function guid() {
	function s4() {
		return Math.floor((1 + Math.random()) * 0x10000)
			.toString(16)
			.substring(1);
	}
	return s4() + s4() + '-' + s4() + '-' + s4() + '-' + 
		s4() + '-' + s4() + s4() + s4();
}

/**
 * 文档加载完成则执行，熟练使用jQuery的选择器
 */
$(document).ready(function(){
    //菜单加载
    $.ajax({
        url: g_baseurl+'/pageService',
        type: 'post',
        contentType:'application/json;charset=UTF-8',
        async: true,
        dataType: 'json',
        data: JSON.stringify({
            service: "DynamicTransmitService",
            scriptService: "shop_menuLoad.action",
            openId: g_openId,
            brandUid: g_brandUidStr,
            branchUid: g_branchUidStr
        }),
        success: function(d, s){
        	//{'resultCode':,'desc':'','menu':[{'categoryName':'','dishes':[{'dishUid':'','dishName':'','dishPrice':,'dishImageUrl':''}]}]}
        	var o = jQuery.parseJSON(d.data);
        	if(o.resultCode == 0){
        		//TODO
        		g_data = o["menu"];
        		initData();
        		$.showMenu(g_data); // menu是一个数组	
        		//$("#typeList li")[0].click();
        	} else {
        		alert(o.desc);
        	}
        },
        error: function(r, e, o){
            alert('发生内部错误，请联系公众号管理员')
        }
    });
});

/**
 * Check list{'id':id,'count':count}
 * @returns {Array}
 */
function initData(){
	for(var i = 0, len1 = g_data.length; i < len1; i++){
		for(var j = 0, len2 = g_data[i]['dishes'].length; j < len2; j++){
			g_data[i]['dishes'][j]['dishNum'] = 0;
		};
	};	
}

$.showDishs = function(menu_num){
	var dish_list = g_data[menu_num]['dishes'];
	for(var i = 0, len = dish_list.length; i < len; i++){
		var s = ' <li data-dishUid="'+dish_list[i]["dishUid"]+'" data-index='+i+'> <div class="licontent"> <div class="span showPop"> ' + 
			'<img src="'+dish_list[i]["dishImageUrl"]+'"> </div> <div class="menudesc"> <h3> ' +
			dish_list[i]["dishName"] + '</h3><p class="salenum"> 月售：<span class="sale_num"> 0</span> <br>' +
					'库存：<span class="sale_num"> 1000</span></p><!-- <p class="mylovedish">'+
					'<span class="icon hart"></span></p> --> <div class="info"></div> </div>'+
				'<div class="price_wrap">'+
					'<strong>￥<span class="unit_price" data-price="'+dish_list[i]["dishPrice"]+'">'+ dish_list[i]["dishPrice"]+'</span></strong>'+
					'<div class="fr" max="1110"><a href="javascript:void(0);" class="btn minus"></a><span class="num"><input type="text" readonly="true" value="'+dish_list[i]["dishNum"]+
					'"></span><a href="javascript:void(0);" class="btn plus" data-num="'+dish_list[i]["dishNum"]+ '"></a>'+				
		   	 		'</div></div></div></li>';
		$("#menuList ul").append(s);
	}
	$("#menuList ul").append('<li>&nbsp;</li>');
	$('#menuList .showPop').click(clickPop); // 为详情添加点击事件	 
};

$.showMenu = function(data){
	for(var i = 0, len = data.length; i < len; i++){
		var s = '<li data-menu="' + i +'">'+ data[i]['categoryName'] + '</li>';
		$("#typeList").append(s);
	};
	/**
	 * 为列表绑定监听事件
	 * 默认点击第一项
	 */
 $("#typeList li").click(function(){
	 	var menu = $(this).data("menu");
		$("#menuList li").hide();
		$.showDishs($(this).data("menu"));
		$("#menuList ul").data("menu", menu);
		// 为".plus"绑定监听事件
		$('#menuList .plus').each(function(){
			var li = $(this).parents("li");
			var prod=g_data[menu]['dishes'][li.data("index")];
			$(this).amount(prod, $.amountCb());
		});
		
		$("#typeList li").removeClass("on");  
		$(this).addClass("on"); 
});
 $("#typeList li")[0].click();
};

function checkout(){
	// get allmoney value
	totalPrice=$.trim($('#allmoney').text());
	totalPrice=parseFloat(totalPrice);
	// get count number;
	totalNum=$.trim($('#menucount').text());
	totalNum=parseInt(totalNum);
	if((totalNum>0) && (totalPrice>0)){
		// relocation "jsp"
		var paramStr = JSON.stringify(orderMap);
		window.location.href="Order_page.jsp?orderMap="+paramStr+'&openId='+g_openId+'&brandUidStr='+g_brandUidStr+'&branchUidStr='+g_branchUidStr+'&totalPrice='+totalPrice+'&totalNum='+totalNum;
	}
}

/**
 * [clickPop description]
 * @return {[type]}   [description]
 */
function clickPop(){
	var li = $(this).parents("li");
	var _wraper = $('#menuDetail');
  var dialogTarget;
	var F = function(str){return li.find(str);},
		title = F('h3').text(),
		imgUrl = F('img').attr('src'),
		price = F('.unit_price').text(),
		sales = F('.sales strong').attr('class'),
		saleDesc = F('.salenum').html(),
		info = F('.info').text(),
		unit=F('.theunit').text(),
		_detailImg = _wraper.find('img');

	if(info){ $('#menuDetail .desc').show();}else{$('#menuDetail .desc').hide();}
	_wraper.find('.price').text(price).end()
		.find('.sales strong').attr('class', sales).end()
		.find('.sale_desc').html(saleDesc).end()
		.find('.info').text(info);

	_detailImg.attr('src', imgUrl).show().next().hide();
	_wraper.dialog({title: title, closeBtn: true});
};


</script>
</head>
  
  <body>
    <div data-role="container" class="container menu">
		<!-- 左边栏列表 -->
		<div class="left">
			<div class="content">
			<ul id="typeList"><!--class="on"-->
			<!-- 动态添加列表名 -->
				</ul>
			</div>			
		</div>
		<!-- 右边栏列表 -->
		<div class="right" id="usermenu">
			<div class="all" id="menuList">
				<ul data-menu="menu1">
				</ul>
			</div>
		</div>
		<!-- Footer -->
		<footer data-role="footer">			
			<nav class="g_nav">
				<div>
					<span class="cart"></span>
					<span> <span class="money">￥<label id="allmoney">0</label> </span>/<label id="menucount">0</label>个菜</span>
					<a href="javascript:checkout();" class="btn gray disabled" id="nextstep">选好了</a>
				</div>
			</nav>
		</footer>

		<div class="menu_detail" id="menuDetail">
			<img style="display: none;">
			<div class="nopic"></div>
<!-- 			<a href="javascript:void(0);" class="comm_btn" id="detailBtn">来一份</a> -->
			<dl>
				<dt>价格：</dt>
				<dd class="highlight">￥<span class="price"></span></dd>
			</dl>
			<p class="sale_desc"></p>
			<dl class="desc">
				<dt>介绍：</dt>
				<dd class="info"></dd>
			</dl>
		</div>
		
	</div>
  </body>
</html>
