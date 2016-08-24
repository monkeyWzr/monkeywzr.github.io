---
layout: post
title: SQL字符串转换成时间
category: 技术
tags: 
keywords: 
description: 
---

最近改一个网站，网站的文章顺序总是很奇怪，看代码明明是`order by time desc`。看了数据库之后发现time列是字符串格式，导致比较的时候2015/11/2会被认为比2015/11/15大。查了一下后将sql语句改为`.......order by cast([time] as date) desc` 就解决了问题。

SQL Server支持的两个转换函数：

		CAST ( expression AS data_type [ ( length ) ] )

		CONVERT ( data_type [ ( length ) ] , expression [ , style ] )

还有几个其他的转换函数，详细内容请见相关链接。

>__相关链接__
>[date (Transact-SQL) - MSDN - Microsoft](https://msdn.microsoft.com/zh-cn/library/bb630352(v=sql.120).aspx)
>[CAST 和 CONVERT (Transact-SQL)](https://msdn.microsoft.com/zh-cn/library/ms187928(v=sql.120).aspx)