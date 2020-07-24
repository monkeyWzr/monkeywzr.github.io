---
layout: post
title: jQury基础笔记
date: 2015-10-01 09:00:00
categories: notes
tags: [jqury,教程]
keywords: jquey,教程
description:
---

## 安装

1.从[jqury.com](http://jqury.com)下载

2.CDN

    Baidu CDN:http://libs.baidu.com/jquery/1.10.2/jquery.min.js
    又拍云 CDN:http://upcdn.b0.upaiyun.com/libs/jquery/jquery-2.0.2.min.js
    新浪 CDN:http://lib.sinaapp.com/js/jquery/2.0.2/jquery-2.0.2.min.js
    Google CDN:http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js
    Microsoft CDN:http://ajax.htmlnetcdn.com/ajax/jQuery/jquery-1.10.2.min.js


## 语法

__基础语法： `$(selector).action()`__

<!-- more -->

### 选择器

jquery选择器基于已存在的css选择器

`$(this)` - 当前元素
`$("p")` - 所有 \<p\> 元素
`$("p:first")` - 选取第一个\<p\>元素
`$("p .test")` - 所有 class="test" 的 \<p\> 元素
`$(".test")` - 所有class="test"的元素
`$("#test")` - 所有 id="test" 的元素
`$("[href]")` - 带有href属性的元素
`$("ui li:first")` - 选取第一个\<ul\>的第一个\<li\>元素
`$("ui li:first-child")` - 选取每个\<ul\>的第一个\<li\>元素
`$("a[target!='_blank']")` - 选取所有target属性值不等于"_blank"的\<a\>元素
`$(":button")` - 选取所有type="button"的\<input\>元素和\<button\>元素

还有一些自定义的选择器

`$("tr:even")` - 选取奇数位置的\<tr\>，偶数为`:odd`
`$("tr:nth-child(odd)")` - 相对于元素的父元素而非当前所选择的元素来选取偶数位置
`$("td:contains(monkey)")` - 选择含有'monkey'的表格单元

注意`:nth-child`是jquery中唯一从1开始计数的选择符

## 事件

### 文档就绪事件

为防止jquery代码在文档未加载完成时就执行，最好将函数封装在document ready函数中：

		$(document).ready(function(){

    		// jQuery code...

		});

简写为：

		$(function(){

    		// jQuery code...

			});

或者：

		$().ready(function(){

			 	//jQuery code...

			})

### 常见DOM事件

鼠标事件：`click` `dbclick` `mouseenter` `mouseleave` `mouseup` `hover` `mousedown`
键盘事件：`keypress` `keydown` `keyup`
表单事件：`submit` `change` `focus` `blur`
文档/窗口事件：`load` `resize` `scroll` `unload`

    $("p").click(function(){
    	$(this).hide();
    	});

    $("input").focus(function(){
  		$(this).css("background-color","#cccccc");
			});


## 效果

1. 显示/隐藏

		//可选参数speed规定变化速度，可取"slow" "fast"或毫秒数
		//可选参数callback为变化完成之后执行的函数
		$(selector).hide(speed,callback);
		$(selector).show(speed,callback);
		//toggle()方法可切换hide()和show()
		$(selector).toggle(speed,callback);

2. 淡入淡出

		//淡入隐藏的元素
		$(selector).fadeIn(speed,callback);
		//淡出可见元素
		$(selector).fadeOut(speed,callback);
		//在fadeIn()和fadeOut()间进行切换
		$(selector).fadeToggle(speed,callback);
		//渐变为给定的不透明度(opacity)，值介于 0 与 1 之间，speed与opacity为必选参数
		$(selector).fadeTo(speed,opacity,callback);

3. 滑动

		$(selector).slideDown(speed,callback);
		$(selector).slideUp(speed,callback);
		$(selector).slideToggle(speed,callback);

4. 动画

		//必需的params定义形成动画的css属性，可同时操作多个属性
		//要使用驼峰式书写属性名，如`paddingLeft`而不是`padding-left`
		$(selector).animate({params},speed,callback);

		//停止动画或效果
		//stopAll参数规定是否应该清除动画队列，默认为false，仅停止活动的动画
		//goToEnd参数规定是否立即完成当前动画
		$(selector).stop(stopAll=false,goToEnd=false);

实例：

		$("button").click(function(){
  		$("div").animate({
    		left:'250px',
    		opacity:'0.5',
    		height:'150px',
    		width:'150px'
 	 		});
		});

__注意：对元素位置进行操作，要将元素的css position属性设为`absolute``fixed`或者`relative`__

jQuery中有一种chanining技术，允许在相同元素上依次执行多条命令

		//可进行换行和缩进以美观
		$("#p1").css("color","red").slideUp(2000).slideDown(2000);


## DOM操作

### 基本操作

		//设置或获取文本内容
		$(selector).text();
		//设置或获取转义后的内容
		$(selector).html();
		//设置或获取输入框内容
		$(selector).val();
		//设置或获取属性
		$(selector).attr();

`text()``html()``val()``attr()`拥有回调函数`callback(i,origText)`,i为当前元素下标，origText为原始值

		//在被选元素的结尾插入一个或多个内容
		$(selector).append();
		//在被选元素的开头插入一个或多个内容
		$(selector).prepend();
		//在被选元素之后插入一个或多个内容
		$(selector).after();
		//在被选元素之前插入一个或多个内容
		$(selector).before();

`after()/before()`与`append()/prepend()`的区别在于，前者是将内容插入到对象中来，作为元素的子节点，后者是将内容插入到对象的前后，作为元素的兄弟节点。

jQuery通常使用两种方法删除元素：

		//删除被选元素及其子元素，可选参数selector可对删除元素进行过滤
		$(selector).remove(selector);
		//删除被选元素的子元素
		$(selector)..empty();

### CSS操作

		//添加class属性
		$(selector).addClass(className);
		//删除class属性
		$(selector).removeClass(className);
		//add/remove切换操作
		$(selector).toggleClass(classname);

实例：

		.important{font-weight:bold;font-size:xx-large;}
		.blue{color:blue;}

		$("button").click(function(){
  	$("h1,h2,p").addClass("blue");
  	$("div").addClass("important blue");
		});

还有一个更实用的`css()`方法，设置或返回被选元素的一个或多个样式属性

		//返回首个匹配的值
		$("p").css("background-color");
		//设置属性值
		$("p").css("background-color","yellow");
		//设置多个属性值
		$("p").css({"background-color":"yellow","font-size":"200%"});

jQuery提供了多个处理尺寸的方法。
![css-size](/img/css-size.png)

		//设置或返回元素的宽度（不包括内边距、边框或外边距）
		$(selector).width();
		//设置或返回元素的高度（不包括内边距、边框或外边距）
		$(selector).height();
		//返回元素的宽度（包括内边距）
		$(selector).innerWidth();
		//返回元素的高度（包括内边距）
		$(selector).innerHeight();
		//返回元素的宽度（包括内边距和边框）
		$(selector).outerWidth();
		//方法返回元素的高度（包括内边距和边框）
		$(selector).outerHeight();

### 遍历

1. 向上遍历

		//返回每个被选元素的直接父元素
		$(selector).parent();
		//返回被选元素的所有祖先，直到文档的根元素<html>,可传入参数制定返回的祖先
		$(selector).parents();
		//返回制定元素之间的祖先元素
		$(selector).parentsUntil(selector)

2. 向下遍历

		//返回被选元素所有直接子元素，客串如参数指定返回的子元素
		$(selector).children();
		//返回被选元素的所有后代，直到最后一代,注意参数的传递
		$(selector).find("*");

__注意：find()需要传入参数"*"以返回所有后代__，也可以指定子元素。

实例：

		//返回class="1"的所有<p>
		$(document).ready(function(){
  		$("div").children("p.1");
		});

3. 水平遍历

		//返回被选元素所有同胞元素，可传入参数指定同胞元素
		$(selector).siblings();
		//返回被选元素下一个/上一个同胞元素
		$(selector).next();
		$(selector).prev();
		//返回被选元素所有跟随/前面同胞元素
		$(selector).nextAll();
		$(selector).prevAll();
		//返回指定元素之间所有同胞元素
		$(selector).nextUntil(selector);
		$(selector).prevUntil(selector);

4. 过滤

		//返回被选元素的首个元素
		$(selector).first();
		//返回被选元素的最后一个元素
		$(selector).last();
		//返回被选元素中指定索引的元素
		$(selector).eq(index);
		//返回匹配的元素
		$(selector).filter(selector);
		//返回不匹配的所有元素
		$(selector).not(selector);

首个元素的索引号是0。

## jQuery AJAX

jQuery将javascript的AJAX相关函数进一步封装，使用起来非常方便

>总是记不住这个单词怎么写
>AJAX = Asynchronous JavaScript and XML

load()函数从服务器加载数据并把返回的数据放入被选元素中

		//必需的 URL 参数规定您希望加载的 URL。
		//可选的 data 参数规定与请求一同发送的查询字符串键/值对集合。
		$(selector).load(URL,data,callback);

`callback`函数可设置如下参数:

>`responseTxt` - 包含调用成功时的结果内容
>`statusTXT` - 包含调用的状态
>`xhr` - 包含 XMLHttpRequest 对象

实例：

		//demo_test.txt内容为
		//<h2>jQuery and AJAX is FUN!!!</h2>
    //<p id="p1">This is some text in a paragraph.</p>

		//获取txt中id为p1的元素内容
		//执行错误返回错误码及错误信息
		$("button").click(function(){
  		$("#div1").load("demo_test.txt #p1",function(responseTxt,statusTxt,xhr){
    		if(statusTxt=="success")
      		alert("External content loaded successfully!");
    		if(statusTxt=="error")
      		alert("Error: "+xhr.status+": "+xhr.statusText);
  		});
		});

`get()`和`post()`方法用于通过 HTTP GET 或 POST 请求从服务器请求数据。

>GET 基本上用于从服务器获得（取回）数据。可能返回缓存数据。
>POST 向指定的资源提交要处理的数据,也可用于从服务器获取数据。不过，POST 方法不会缓存数据，并且常用于连同请求一起发送数据。

		//回调函数callback(data,status),第一个参数为请求页面内容，第二个参数为请求状态
		$.get(URL,callback);

		//可选的 data 参数规定连同请求发送的数据
		//可选参数callback(data,status)
		$.post(URL,data,callback);

实例：

		$("button").click(function(){
		  $.post("demo_test_post.html",
		  {
		   	name:"Donald Duck",
		   	city:"Duckburg"
		  },
		  function(data,status){
		    alert("Data: " + data + "nStatus: " + status);
		  });
		});

## jQuery JSONP

__JSONP(JSON with Padding)__ 是 json 的一种"使用模式"，可以让网页跨域读取数据。由于同源策略的存在，AJAX无权限进行跨域请求，为了解决这个头疼的问题，开发人员逐渐完善了JSONP这种非正式传输协议。该协议的要点就是允许用户传递一个callback参数给服务端，服务端返回数据时会将这个callback参数作为函数来封装JSON数据。

>同源策略(Same-Origin Policy)：相同domain/ip/端口/协议是为同一个域或源(origin),非同源的脚本不能访问对方的资源，除非得到授权。
>__相关链接：__
>[同源策略——浏览器的安全卫士](http://www.jianshu.com/p/4e17445d66e2)
>[JavaScript的同源策略](https://developer.mozilla.org/zh-CN/docs/Web/Security/Same-origin_policy)
>[浏览器的同源策略](http://blog.csdn.net/broadview2006/article/details/8595191)

jQuery可以很方便的实现JSONP调用，下面贴出一个简单实例。
服务端test.php代码：

		<?php
			header('Content-type: application/json');
			//获取回调函数名
			$jsoncallback = htmlspecialchars($_REQUEST ['jsoncallback']);
			//json数据
			$json_data = '["customername1","customername2"]';
			//输出jsonp格式的数据
			echo $jsoncallback . "(" . $json_data . ")";
		?>

客户端实现：

		<!DOCTYPE html>
		<html>
		<head>
			<title>JSONP 实例</title>
			<script src="http://apps.bdimg.com/libs/jquery/1.8.3/jquery.js"></script>
		</head>
		<body>
		<div id="divCustomers"></div>
		<script>
		$.getJSON("test.php?jsoncallback=?", function(data) {

			var html = '<ul>';
			for(var i = 0; i < data.length; i++)
			{
				html += '<li>' + data[i] + '</li>';
			}
			html += '</ul>';

			$('#divCustomers').html(html);
		});
		</script>
		</body>
		</html>

url中的`?`表示让jQuery自动处理返回的callback数据，也可自定义回调函数名称，默认为jQuery自动生成的随机函数名。

附上一个说的比较详细的博客：
[说说JSON和JSONP，也许你会豁然开朗，含jQuery用例](http://www.cnblogs.com/dowinning/archive/2012/04/19/json-jsonp-jquery.html)
