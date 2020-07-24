---
title: Android Webview中的编码问题
date: 2017-09-24 20:11:30
categories: tech
tags:
    - android
    - Java
keywords:
    - android
    - java
    - webview
    - encoding
---

最近在处理一段html文本时，为了解析`ruby`标签，我用`Weview`代替了`Textview`，起初是这样写的：

```java
webview.loadData(article.getContent(), "text/html", "UTF-8");
```

结果显示出来全部是乱码。网上查阅资料后发现一个一简易的处理办法：

```java
contentText.loadData(article.getContent(), "text/html; charset=UTF-8", "UTF-8");
```

我处理的文本是含有日语的html文本，这个方法是有效的。

另外，也可以使用`WebView.loadDataWithBaseURL()`代替`WebView.loadData()`。
```java
webview.loadDataWithBaseURL(null, article.getContent(), "text/html", "UTF-8", null);
```

网上还有这样的方法：
```
if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.FROYO) {
    String base64 = Base64.encodeToString(htmlString.getBytes(), Base64.DEFAULT);
    myWebView.loadData(base64, "text/html; charset=utf-8", "base64");
}
```

如代码中所见，该方法适用于`Android 4+`的场景。不过我并没有进行实际测试这种方式。

>参考资料
>[stackoverflow - Android. WebView and loadData](https://stackoverflow.com/questions/3961589/android-webview-and-loaddata)
>[Android Developers](https://developer.android.com/reference/android/webkit/WebView.html)
<!--stackedit_data:
eyJoaXN0b3J5IjpbMjc3MjU5MTIwLC04MDgwMDYxMTFdfQ==
-->