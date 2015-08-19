<%@ page language="java" import="java.util.*" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!-- jQuery Mobile CDN start -->
<link rel="stylesheet" href="js/jquery.mobile-1.3.2.min.css">
<script type="text/javascript" src="js/jquery-1.8.3.min.js"></script>
<script type="text/javascript" src="js/jquery.mobile-1.3.2.min.js"></script>
<!-- jQuery Mobile end -->
<!-- barcode start-->
<script type="text/javascript" src="js/jquery-barcode.min.js"></script>
<!-- barcode end -->
<title>尚汤八珍面</title>	
<meta content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport">
<!-- Mobile Devices Support @begin -->
<meta content="telephone=no, address=no" name="format-detection">
<meta name="apple-mobile-web-app-capable" content="yes"> <!-- apple devices fullscreen -->
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
	<!-- Mobile Devices Support @end -->
<style type="text/css">
	label {
		margin-top: 0.3em;
		font-weight: bold;
	}
	i {
		color:red;
		font-size:1.2em;
		margin-right: 0.2em;
	}
	.content p {
		font-size: 0.8em;
	}
	#footer h1 {
		font-size: 0.7em;
	}
	#header p {
		text-indent: .5em;
	}
	.label + div{
		width: 70%;
	}
  /*barcode style*/
  #barcode-wrap {
    width: 100%;
    overflow: hidden;
    display: none;
  }

  #barcode-show {
    margin: 10px auto;
    overflow: hidden;
  }
</style>

<script type="text/javascript">
$(document).ready(function(){

});
</script>
</head>
  
<body>
<div data-role="page">
<!-- ListView -->
	<div id="header" data-role="header" data-theme="b">
		<p>完善信息即赠40积分，更有好礼相送</p>
	</div>
	<div class="content" data-role="content" data-theme="b">
    <!-- <form method="post" action="#" id="userInfoForm"> -->
    <!-- barcode -->
    <div id="barcode-wrap">
        <h3 id="barcode-title"></h3>
        <div id="barcode-show"></div>
    </div>
    <!-- end -->
    <form id="userInfoForm">
      <div data-role="fieldcontain">
        <label for="userName" class="label"><i style="color:red">*</i>姓名：</label>
        <input type="text" name="userName" id="userName">
        <br> 

        <fieldset data-role="controlgroup" data-type="horizontal">
        <legend>性别：</legend>
          <label for="male">男</label>
          <input type="radio" name="gender" id="male" value="m">
          <label for="female">女</label>
          <input type="radio" name="gender" id="female" value="f">	
        </fieldset>
        <br>

        <label for="userBirth" class="label"><i style="color:red">*</i>生日：</label>
        <input type="date" data-role="date" name="userBirth" id="userBirth">
				<p>日期设置后不能修改</p>
      </div>
                <div style="display:none;">
                    <label for="nameL" ><font color="red">*</font>身份证号</label>
                    <div >
                        <input type="text" id="idNum" placeholder="">
                    </div>
                    <label id="idMsg"></label>
                </div>   
      <input id="submit_btn" type="submit"  value="保存">
    </form>
    <p><i style="color:red">*</i>为必填项，输入后方可保存</p>
	</div>
</div>
<script type="text/javascript">

var openId = '<%=request.getParameter("openId")%>';

var re = /^[\d]+$/;

function verifyAll() {
	<%--
    var wechatNo = $("#wechatNo").val();
    --%>
    <%-- 校验微信号 --%>
    <%--
    if (!wechatNo) {
        //$('#submit_btn').attr("disabled", true);
        return;
    }
    --%>
    var userBirth = $("#userBirth").val();
    <%-- 校验用户年龄 --%>
	
    if (!userBirth) {
        //$('#submit_btn').attr("disabled", true);
        return;
    }
    <%--
    if (!re.test(userBirth)) {
        //$('#submit_btn').attr("disabled", true);
        return;
    }
     --%>
    <%-- 校验用户姓名 --%>
    var userName = $("#userName").val();
    if (!userName) {
        //$('#submit_btn').attr("disabled", true);
        return;
    }    
    
    //$('#submit_btn').removeAttr("disabled");
}

$(function (){
	//$('#submit_btn').attr("disabled", true);
	$('#userBirth').val('');
  $.ajax({
      url: '<%=request.getContextPath()%>/pageService',
      type: 'post',
      async: true,
      dataType: 'json',
      data: JSON.stringify({
      	service: "QueryUserInfoService",
          openId: openId
      }),
      success: function (data, status) {
      	
        if (status != 'success') {
            return;
        }
        
        if (!data) {
        	return;
        }
        //alert(JSON.stringify(data));
        if (data.birthday && !data.name) {
            delete data.birthday;
        }

        if (!data.birthday && !data.name && data.gender) {
            delete data.gender;
        }
        // show phone number and barcode
        if (data.phone) {
          $('#barcode-title').text( "手机号码：" + data.phone);
          $('#barcode-show').barcode( data.phone, "codabar",{barWidth:2, barHeight:90});
          $('#barcode-wrap').show();
        }

        if (data.birthday) {
            $('#userBirth').val(data.birthday);
            //$('#userBirth').prop('type','text');
            $("#userBirth").textinput( "disable" );
        }
        
        if (data.name) {
            $('#userName').val(data.name);
        }            
        
        if (data.gender) {
        	if (data.gender == "m") {
        		$('#male').attr("checked", "checked");
              $('#male').checkboxradio("refresh");
              //$("input[type='radio']").attr("checked",true).checkboxradio("refresh");
        	} 
        	else {
        		$('#female').attr("checked", "checked");
              $('#female').checkboxradio("refresh");
              //$("input[type='radio']").attr("checked",true).checkboxradio("refresh");
        	}
        	
        }

          // if($.trim(data.name)!='' && data.birthday && data.gender){
          //     $('#submit_btn').removeAttr("disabled");
          // }
      }
  });

  $("#userName").on('input', function(e) {
      verifyAll();
  });  
    
  $("#userBirth").on('input', function(e) {
      verifyAll();
  });
    
  $("#idNum").on('input', function(e) {
      var v = this.value;
      if(v.length > 14) {
          if(isChinaIDCard(v)){
              $('#idMsg').html('');
              var yyyy = '';
              var mm = '';
              var dd = '';
              if(v.length==15){
                  yyyy = '19' + v.substr(6,2);
                  mm = v.substr(8,2);
                  dd = v.substr(10,2);
              } else if(v.length==18){
                  yyyy = v.substr(6,4);
                  mm = v.substr(10,2);
                  dd = v.substr(12,2);
              }
              var s = yyyy + '-' + mm + '-' + dd;
              $('#userBirth').val(s);
              verifyAll();
          } else {
              $('#userBirth').val('');
              $('#idMsg').html('身份证号码有误！');
              verifyAll();
          }
      } else {
          $('#idMsg').html('');
          return;
      }
  });

  $('#submit_btn').bind('click', function (){
  	var userBirth = $('#userBirth').val();
  	var userName = $('#userName').val();
  	<%--var wechatNo = $('#wechatNo').val();--%>
  	var gender = $("#userInfoForm input:checked").val();
  	if($.trim(userName)!='' && $.trim(userBirth)!=''){
          $.ajax({
              url: '<%=request.getContextPath()%>/pageService',
              type: 'post',
              async: false,
              dataType: 'json',
              data: JSON.stringify({
                  service: "SaveUserInfoService",
                  openId: openId,
                  userBirth: userBirth,
                  userName: userName,
                  gender: gender
              }),
              success: function(){
                  alert('保存成功！');
              },
              complete: function () {
               try {
                   if (WeixinJSBridge) {
                       WeixinJSBridge.call('closeWindow');     
                   }	 
               }
               catch (e) {
              	 window.close();
               }
               
              }
          });
      } else {
          alert('请输入必填项');
      }
  });
});

/**
* 验证是不是数字
*/
function isNumber(oNum) {
    if(!oNum) return false;
    var strP=/^\d+(\.\d+)?$/;
    //var strP=/^\d+$/;
    if(!strP.test(oNum)) return false;
    
    try {
        if(parseFloat(oNum)!=oNum) return false;
    } catch(ex) {
        return false;
    }

    return true;
}
/**
*校验日期是否正确
*/
function isValidDate(iY, iM, iD) {
    if (iY>2200 || iY<1900 || !isNumber(iY)){
        //alert("输入身份证号,年度"+iY+"非法！");
        return false;
    }
    if (iM>12 || iM<=0 || !isNumber(iM)){
        //alert("输入身份证号,月份"+iM+"非法！");
        return false;
    }
    if (iD>31 || iD<=0 || !isNumber(iD)){
        //alert("输入身份证号,日期"+iD+"非法！");
        return false;
    }
    return true;
}  
/**
*判断身份证号码格式函数
*公民身份号码是特征组合码，
*排列顺序从左至右依次为：六位数字地址码，八位数字出生日期码，三位数字顺序码和一位数字校验码
*/
function isChinaIDCard(StrNo){
    StrNo = StrNo.toString();
    if(StrNo.length == 15){        
        if(!isValidDate("19"+StrNo.substr(6,2),StrNo.substr(8,2),StrNo.substr(10,2))){
            return false;
        }
    } else if(StrNo.length == 18){
        if (!isValidDate(StrNo.substr(6,4),StrNo.substr(10,2),StrNo.substr(12,2))){
            return false;
        }
    }else{
        //alert("输入的身份证号码必须为15位或者18位！");
        return false;
    }

    if (StrNo.length==18)  {  
        var a,b,c;
        if (!isNumber(StrNo.substr(0,17))){
            //alert("身份证号码错误,前17位不能含有英文字母！");
            return false;
        }
        a=parseInt(StrNo.substr(0,1))*7+parseInt(StrNo.substr(1,1))*9+parseInt(StrNo.substr(2,1))*10;  
        a=a+parseInt(StrNo.substr(3,1))*5+parseInt(StrNo.substr(4,1))*8+parseInt(StrNo.substr(5,1))*4;  
        a=a+parseInt(StrNo.substr(6,1))*2+parseInt(StrNo.substr(7,1))*1+parseInt(StrNo.substr(8,1))*6;    
        a=a+parseInt(StrNo.substr(9,1))*3+parseInt(StrNo.substr(10,1))*7+parseInt(StrNo.substr(11,1))*9;    
        a=a+parseInt(StrNo.substr(12,1))*10+parseInt(StrNo.substr(13,1))*5+parseInt(StrNo.substr(14,1))*8;    
        a=a+parseInt(StrNo.substr(15,1))*4+parseInt(StrNo.substr(16,1))*2;  
        b=a%11;  
        if (b==2) {   //最后一位为校验位
            c=StrNo.substr(17,1).toUpperCase();   //转为大写X  
        }else{
            c=parseInt(StrNo.substr(17,1));  
        }
        switch(b){  
            case 0: if ( c!=1 ) {/*alert("身份证好号码校验位错:最后一位应该为:1");*/return false;}break;  
            case 1: if ( c!=0 ) {/*alert("身份证好号码校验位错:最后一位应该为:0");*/return false;}break;  
            case 2: if ( c!="X") {/*alert("身份证好号码校验位错:最后一位应该为:X");*/return false;}break;  
            case 3: if ( c!=9 ) {/*alert("身份证好号码校验位错:最后一位应该为:9");*/return false;}break;  
            case 4: if ( c!=8 ) {/*alert("身份证好号码校验位错:最后一位应该为:8");*/return false;}break;  
            case 5: if ( c!=7 ) {/*alert("身份证好号码校验位错:最后一位应该为:7");*/return false;}break;  
            case 6: if ( c!=6 ) {/*alert("身份证好号码校验位错:最后一位应该为:6");*/return false;}break;  
            case 7: if ( c!=5 ) {/*alert("身份证好号码校验位错:最后一位应该为:5");*/return false;}break;  
            case 8: if ( c!=4 ) {/*alert("身份证好号码校验位错:最后一位应该为:4");*/return false;}break;  
            case 9: if ( c!=3 ) {/*alert("身份证好号码校验位错:最后一位应该为:3");*/return false;}break;  
            case 10: if ( c!=2 ){/*alert("身份证好号码校验位错:最后一位应该为:2");*/return false;}
        }
    } else {//15位身份证号
        if (!isNumber(StrNo)) {
            //alert("身份证号码错误,前15位不能含有英文字母！");
            return false;
        }
    }
    return true;
} 

</script>
</body>
</html>
