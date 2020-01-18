---
title: 用php://input代替php的$HTTP_RAW_POST_DATA全局变量
date: 2017-09-03 04:02:29
category: tech
tags:
    - php
keywords:
    - php
    - $GLOBAL
    - HTTP_RAW_POST_DATA
---

最近在开发一个小微信应用时，发现使用原来的工具代码总是获取不到微信服务器发来的数据。原来的代码中使用`$GLOBALS["HTTP_RAW_POST_DATA"]`的方式获取post提交的数据。查了查才发现，`HTTP_RAW_POST_DATA` 早在php 5.6.0时就已经废弃，到了7.0.0版本已经移除。我的服务器上php是7.0版本，难怪会发生这样的问题。文档中推荐使用`php://input`的方式代替`$HTTP_RAW_POST_DATA`获取post数据。

```php

$postdata = file_get_contents("php://input");

```

>php://input 是个可以访问请求的原始数据的只读流。 POST 请求的情况下，最好使用 php://input 来代替 $HTTP_RAW_POST_DATA，因为它不依赖于特定的 php.ini 指令。 而且，这样的情况下 $HTTP_RAW_POST_DATA 默认没有填充， 比激活 always_populate_raw_post_data 潜在需要更少的内存。 enctype="multipart/form-data" 的时候 php://input 是无效的。

这其实算是自己的问题了。。想偷懒不及时了解php的版本变动真是使不得><
