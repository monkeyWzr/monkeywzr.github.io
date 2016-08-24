---
layout: post
title: 解决jekyll server无法启动问题
category: 技术
tags: 
keywords: 
description: 
---

前几天想要post新博客，照旧在本地测试效果，结果忽然发现jekyll server启动不了了
![img](/assets/img/images/2015-10-15-jekyll-server-failed_1.png)

目测是端口被占用，但是啥玩意会占用4000端口呢。。。netstat了下
![img](/assets/img/images/2015-10-15-jekyll-server-failed_2.png)

3608号进程在占用，继续查这个3608进程。。
![img](/assets/img/images/2015-10-15-jekyll-server-failed_3.png)
我勒个草，竟然是个福昕的保护程序。。没啥话可说了，现在就是在抉择是杀掉这个进程还是换个jekyll serve端口(>=<)先把这篇提交了再说
		
		$ jekyll serve --port 4001