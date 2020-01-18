---
title: Android中的MVP模式
date: 2017-09-29 15:18:32
category: notes
tags:
    - android
    - java
keywords:
    - android
    - java
    - MVP
    - 架构
---

Model View Presenter (MVP) 模式是安卓开发中非常热门的一种架构模式。MVP模式将数据模型从传统的View层分离出来，通过presenter实现两者的间接通信。

![img](/img/2017-09-29-MVP-in-Android.png)
(图片出处：[vogella](http://www.vogella.com/tutorials/AndroidArchitecture/article.html))

* View层 该层专注于UI的实现，实现UI操作的接口，如`showProgressBar`, `updateData`等。通常会持有对Presenter层的引用，或通过依赖注入获取到Presenter实例。
* Presenter层 该层实现业务逻辑，负责View层和Model层的控制和交互。该层通常应尽量避变对sdk产生依赖。
* Model层 该层实现对数据操作的封装，暴露接口给Presenter层。
