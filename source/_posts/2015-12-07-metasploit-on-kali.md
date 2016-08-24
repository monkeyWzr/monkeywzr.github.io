---
layout: post
title: Kali下Metasploit学习笔记
category: 学习笔记
tags: [Metasploit,kali]
keywords: Metasploit,kali,渗透,安全
description: 
---

## 启动

使用框架前先开启其几个服务：

	# service postgresql start
	# msfdb init

注意kali2.0开始不再有metasploit服务，所以官方文档说要用`msfdb init`代替`service metasploit start`


然后启动msf控制台

	# msfconsole

## 一些命令

workspace -h 帮助
workspace [-a/d/r] 创建/删除/重命名工作平台