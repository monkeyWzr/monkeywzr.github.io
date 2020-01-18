---
title: 使用Tools Attributes Reference
date: 2017-09-23 19:55:32
category: tech
tags:
    - android
    - java
keywords:
    - android
    - java
    - android studio
---

Android Studio 提供了一系列工具属性用于开发过程中，如预览布局效果等。构建应用时会自动删除掉所有此类属性。灵活应用这些属性可以给开发带来很大的快感。

为启用此类属性，加入`toolsNs`即可。
```xml
<RootTag xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools" >
```

## 使用tools:前缀代替android:

由于经常会在代码中对布局进行更改，无法通过IDE的预览功能直观的查看到效果。这时可使用`tools:`前缀代替`android:`来插入简单的数据，如`tools:text` `tools:src`等。

## 使用tools:listitem / tools:listheader / tools:listfooter

这些属性可以将item的布局加载出来，帮助我们预览ListView或RecyclerView，而不再是单纯的文本。

还有一些其他属性，待下次用到时再进行记载。

>参考资料
文档：[Tools Attributes Reference](https://developer.android.com/studio/write/tool-attributes.htm)
