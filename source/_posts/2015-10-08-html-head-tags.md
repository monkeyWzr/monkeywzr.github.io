---
layout: post
title: HTML常用头标签
category: 技术
tags: html
keywords: html,头标签
description: 
---

## meta

`<meta>`标签提供了 HTML 文档的元数据(metadate)。元数据不会显示在客户端，而是被浏览器解析。
meta元素通常用于指定网页的描述，关键词，的文件的最后修改，作者，和其他元数据。
元数据可以被使用浏览器（如何显示内容或重新加载页面），搜索引擎（关键词），或其他 Web 服务调用。

`<meta>`标签通常位于`<head>`区域内,有如下几个属性；

>__charset__-定义文档字符编码，常用值为utf-8
>__http-equiv__-提供了名称/值对中的名称，并指示服务器把名称/值对添加到发送给浏览器的MIME文档头部
>__name__-提供了名称/值对中的名称，通常情况下可自定义对自己和源文档的读者来说富有意义的名称，常用值有`keywords``description`等
>__content__-定义与`http+equiv`或`name`属性相关的元信息，即名称/值对中的值
>__scheme__-定义用于翻译`content`属性值的格式，html5中已删除此属性

使用`http-equiv`属性，服务器将把名称/值对添加到发送给浏览器的内容头部，例如：

		<meta http-equiv="charset" content="iso-8859-1">
		<meta http-equiv="expires" content="31 Dec 2008">

浏览器头部就应包含：

		content-type: text/html
		charset:iso-8859-1
		expires:31 Dec 2008

所有服务器都至少要发送一个：`content-type:text/html`，这将告诉浏览器准备接受一个 HTML 文档。

 
其它实例：

		//定义文档关键词，用于搜索引擎
		<meta name="keywords" content="HTML, CSS, XML, XHTML, JavaScript">
		//每30秒刷新页面
		<meta http-equiv="refresh" content="30">
		//声明文档使用的字符编码
		<meta charset='utf-8'>

还有一种lang属性写法：

		//简体中文
		<html lang="zh-cmn-Hans">
		//繁体中文
		<html lang="zh-cmn-Hant">
		//英文
		<html lang="en">

lang属性的取值应该遵循 [BCP 47 - Tags for Identifying Languages](http://tools.ietf.org/html/bcp47)

>详见知乎回答[http://zhi.hu/XyIa](http://www.zhihu.com/question/20797118?utm_source=weibo&utm_medium=weibo_share&utm_content=share_question&utm_campaign=share_sidebar)

另外，meta的巧妙使用可以对网站SEO优化，相关的常用name值有`description``keywords``author``robots`等。

		//页面描述
		<meta name="description" content="不超过150个字符" />
		//页面关键字
		<meta name="keywords" content=""/>
		//网页作者
		<meta name="author" content="name, email@gmail.com" />

robots定义网页搜索引擎索引方式,对应content是一组使用英文逗号分割的值，通常有如下几种取值：`none``noindex``nofollow``all``cache``nocache``index``follow`等。

		<meta name="robots" content="index,follow" />

>__相关链接__
>[MSDN文档-搜索引擎优化](https://msdn.microsoft.com/zh-cn/library/ff723998(v=expression.40).aspx)
>p[MSDN文档-<meta name="robots">](https://msdn.microsoft.com/zh-cn/library/ff724037(v=expression.40).aspx)

mete还可以通过name属性的`msapplication-TileColor``msapplication-TileImage`两个值设置win8磁贴相关样式

		//磁贴颜色
		<meta name="msapplication-TileColor" content="#000"/>
		//磁贴图标
		<meta name="msapplication-TileImage" content="icon.png"/>

## link

link标签最常见的用途是链接样式表

		<link rel="stylesheet" type="text/css" href="style.css">

link比较常用的属性有`rel``href``type`：`rel`属性是必须的，规定当前文档与被链接文档/资源之间的关系，属性较多，详见底下相关链接；href 属性规定外部资源（通常是样式表文件）的位置（URL）；type 属性规定被链接文档/资源的 MIME 类型，只有设置了`href`属性时才能使用此属性。



>__相关链接：__
>[HTML <link> 标签的 rel 属性](http://www.w3school.com.cn/tags/att_link_rel.asp)
>[IANA MIME类型](http://www.iana.org/assignments/media-types/media-types.xhtml)

两个实例：

		//添加RSS订阅
		<link rel="alternate" type="application/rss+xml" title="RSS" href="/rss.xml" />
		//添加favicon icon
		<link rel="shortcut icon" type="image/ico" href="/favicon.ico" />


