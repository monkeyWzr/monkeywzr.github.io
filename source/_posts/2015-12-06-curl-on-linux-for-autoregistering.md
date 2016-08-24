---
layout: post
title: Linux下curl实现某资源站自动签到脚本
category: 技术
tags: [linux,curl，模拟登录]
keywords: linux,curl,模拟登录
description: 
---

## 前言

经常去某资源站下载美剧，我很喜欢的的团(ren)队(ren)在运营这个网站，资源很及时也很好。网站要求登录才能看到下载链接。连续登录达到多少天就可以升级并且可以查看更多下载资源。然而我这种人是不可能记着每天都去网站上签到的(-<-)。。。正好最近买了vps，于是决定自己写一个自动登录的脚本。

## 分析

Fiddler抓包发现此网站登陆时url为/User/Login/ajaxLogin，post提交用户名和密码。

![img](/assets/img/images/2015-12-04-zimuzu-auto-login_1.png)

登录成功之后返回JSON字符串

![img](/assets/img/images/2015-12-04-zimuzu-auto-login_3.png)

用户等级等相关信息是通过之后的两个请求`hotkeyword``getCurUserTopInfo`获取的，用于网站顶部的信息和搜索栏。

![img](/assets/img/images/2015-12-04-zimuzu-auto-login_4.png)

![img](/assets/img/images/2015-12-04-zimuzu-auto-login_5.png)

![img](/assets/img/images/2015-12-04-zimuzu-auto-login_6.png)

通过我的测试发现这两个请求并不会影响cookie的变化，不模拟也完全没问题。

签到页面url为/user/sign,签到按钮通过js控制15s后才可以点击，点击后fiddler抓到了/user/sign/dosign的请求，request包里面看起并没有什么新内容，response返回了一个json

![img](/assets/img/images/2015-12-04-zimuzu-auto-login_7.png)

![img](/assets/img/images/2015-12-04-zimuzu-auto-login_8.png)

json里面的info表示签到结果，1为成功。data为连续签到天数。




## 开搞

OK！开始祭出杀气__curl__，一开始是用的php，但是向dosign发送请求总是返回错误状态，可能是那里的curl参数配置错了，找个时间再回过头去看一下。。就不说这个了。

后来决定干脆直接上linux写脚本。我水平比较low。。就是简单的3个请求，存一下cookie，也没搞啥复杂东西。

![img](/assets/img/images/2015-12-04-zimuzu-auto-login_9.png)

先简单在本地测试了一下

![img](/assets/img/images/2015-12-04-zimuzu-auto-login_10.png)

![img](/assets/img/images/2015-12-04-zimuzu-auto-login_11.png)

哈哈，大功告成！！

最后把脚本丢到了vps上跑，crontab添加一条定时任务，每天凌晨啪啪啪~~ 麻麻再也不用担心我的签到~~
