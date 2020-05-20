---
layout: post
title: ubuntu server 搭建apache/mysql/php7
category: tech技术
tags: [Linux,php]
keywords: lamp,linux,apache,mysql,php,php7
description: 
---

## 先安装php的情况

如果安装php的时候还没有安装apache，那么安装好apache后需要安装一个模块：

        $ sudo apt-get install libapache2-mod-php7.0
        //如果安装的是php5则安装下面的包
        $ sudo apt-get install libapache2-mod-php


<!--stackedit_data:
eyJoaXN0b3J5IjpbMTY2MzY0MTk0MV19
-->