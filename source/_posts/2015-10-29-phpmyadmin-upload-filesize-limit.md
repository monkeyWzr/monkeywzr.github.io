---
layout: post
title: 快速临时解决phpmyadmin上传sql文件大小限制问题
category: 技术
tags: [phpmyadmin,mysql]
keywords: phpmyadmin上传sql文件大小限制
description: 
---

刚刚需要往服务器上导入数据库，服务器上的phpmyadmin有上传限制，最大是8192kb，我要导入的数据库压缩完了还有8300多。。不想对服务器配置做啥改动，不能远程登录mysql,脚本也不太好跑。查了一下原来phpmyadmin的上传限制是受php.ini和自己的config控制的，mysql控制台并不受影响。干脆直接从命令行导入好了。

		mysql>use test;
		mysql>set names utf8;
		mysql>source D:/fuck.sql;
		