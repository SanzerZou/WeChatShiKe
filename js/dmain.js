

$.fn.amount = function(num, callback){
	// 边界条件的判断
	var num = typeof num === 'undefined' ? 0 : num,
		callback = callback || $.noop,
		isShow = num > 0 ? '' : ' style="display:none;"',
		activeClass = 'active';

	function add(){
		var obj = $(this).prev(),
			_num = obj.find('input');
		// 获得当前的值
		var menu = $("#typeList .on"),
			li = $(this).parents("li");
		
		var prod = g_data[menu.data("menu")]['dishes'][li.data("index")];
		var dishUid = prod["dishUid"];
		var _curNum = parseInt(prod["dishNum"]) + 1;
		prod["dishNum"] = _curNum;
		
		orderMap[dishUid] = {'dishUid':dishUid,'count':_curNum, 'obj':prod};
		
		var data_obj = obj.parent();
		var max = data_obj.attr("max");
		if(null != max && max != "" && max != "-1" && _curNum >= max)
		{
			return false;
		}
		_num.val(_curNum);
		if(_curNum > 0){
			obj.show();
			$(this).addClass(activeClass);
		}
		return callback.call(this, '+');
	}

	function del(){
		var obj = $(this).parent(),
			_num = obj.find('input'),
			_add = obj.next();
		
		var menu = $("#typeList .on"),
		li = $(this).parents("li");
		var prod = g_data[menu.data("menu")]['dishes'][li.data("index")];
		var dishUid = prod["dishUid"];
		var _curNum = parseInt(prod["dishNum"]);
		if(_curNum > 0){
			_curNum--;
			prod["dishNum"] = _curNum;
			_num.val(_curNum);
			orderMap[dishUid] = {'dishUid':dishUid,'count':_curNum, 'obj':prod };
			if(_curNum <= 0) {
				delete orderMap[dishUid];
			}
			return callback.call(this, '-');			
		}else{
			//
		}

	}
	
	return this.each(function(){
		$(this).bind('click', add);
		
		$(this).prevAll(".minus").bind('click', del);

		if(num > 0){
			$(this).addClass(activeClass);
		}
	});
};
$.amountCb = function(){
	//var _condition = $('#sendCondition');
	var	_total = $('#allmoney'),
		_cartNum = $('#menucount'),
		_nextstep = $('#nextstep');
		//sendCondition = parseFloat(_condition.text()).toFixed(3);
	return function(sign){
		discount=parseFloat(discount); 
		var totalPrice = parseFloat(_total.text()) || 0,
			//disPrice = parseFloat(sign + 1) * parseFloat($(this).parents('li').find('.tureunit_price').val()),
			disPrice = parseFloat(sign + 1) * parseFloat($(this).parents('li').find('.unit_price').data('price')),
			price = totalPrice + disPrice,
			number = _cartNum.text() == '' ? 0 : parseInt(_cartNum.text()),
			disNumber = number + parseInt(sign + 1);
			price = parseFloat((price).toFixed(3));
		_total.text(price);
		_cartNum.text(disNumber);
		if((disNumber > 0) && (price>0)){
			_nextstep.removeClass('gray disabled');
			_nextstep.addClass('orange show');
		}else{ 
			_nextstep.removeClass('orange show');
			_nextstep.addClass('gray disabled');
		}
		return false;
	};
};

$(function(){
	if($('#swipeNum').length){
		new Swipe($('#imgSwipe')[0], {
			speed: 500, 
			auto: 5000, 
			callback: function(index){
				$('#swipeNum li').eq(index).addClass("on").siblings().removeClass("on");
			}
		});
	}
	$('#storeList li').click(function(e){
		if(e.target.tagName != 'A'){
			location.href = $(this).attr('href');
		}
	});
});
