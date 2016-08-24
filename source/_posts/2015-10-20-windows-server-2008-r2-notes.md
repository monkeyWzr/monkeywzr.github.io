---
layout: post
title: Windows Server 2008 r2学习笔记
category: 学习笔记
tags: [服务器]
keywords: server,服务器
description: 
---

## AD

先扔到这里几个缩写

>AD DS - Active Dicretory Domain services
>DC - Domain Controllers
>OU -  Organizational Unit 
>GPO - Group Policy Object 组策略对象
>GC - global catalog 全局编录
>LDAP - Lightweight Directory Access Protocol 轻型目录访问协议
>DN - distinguished name 可分辨名称
>WSH - Windows Scripting Host Windows脚本宿主
>


计算机在加入域的时候，会自动创建一个计算机账户。默认情况下该账户在Computer容器中，可通过redircmp命令修改这一设置。

		redircmp DN

