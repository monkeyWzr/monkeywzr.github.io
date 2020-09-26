---
layout: post
title: Kali下Metasploit学习笔记
date: 2015-12-07 09:00:00
categories: notes
tags:
  - kali
keywords:
  - Metasploit
  - kali
  - 渗透
  - 安全
description:
---

## 启动

使用框架前先开启其几个服务：

	# service postgresql start
	# msfdb init

注意kali2.0开始不再有metasploit服务，所以官方文档说要用`msfdb init`代替`service metasploit start`

<!-- more -->

然后启动msf控制台

	# msfconsole

## 一些命令

workspace -h 帮助
workspace [-a/d/r] 创建/删除/重命名工作平台
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTIwODk2MTE2MjYsLTUwNjE2NDA1Ml19
-->