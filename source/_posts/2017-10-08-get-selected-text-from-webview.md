---
title: get-selected-text-from-webview
date: 2017-10-08 00:30:19
category: tech
tags:
    - android
    - java
keywords:
    - android
    - java
    - WebView
---

在试图自定义WebView选择文本之后的行为时，遇到了很多的麻烦。

首先便是获得选择文本这一步。WebView并没有相应的API，想获取选择的文本貌似只能通过js来解决。在最开始的尝试中，我的代码实现如下：
```java
contentText.loadDataWithBaseURL(null, article.getContent(), "text/html", "UTF-8", null);
contentText.evaluateJavascript("(function(){return window.getSelection().toString()})()", new ValueCallback<String>() {
    @Override
    public void onReceiveValue(String s) {
        Log.d("NewsContentActivity", s);
    }
});
```

然而不知为何，获取到的文本始终为空字符串`""`，百思不得其解的我偶然把`evaluateJavascript`方法放到了重写的`onActionModeStarted`中，竟然可以收到正确的文本了，不过依然有个严重的问题：在当前WebView中只能成功获取一次，再次选择文本就完全没有反应了。在调试时我发现，是因为我在选择文本时要先点击屏幕使得之前的选择消除掉，否则始终是同一次的`onActionModeStarted`调用。这样就无法解决我的问题了，因为我需要获取拖拽浮标选择的文本。

。。。

研究了一夜，实在没什么方案可以达到我想要的效果，只能通过点击菜单项获取选择的文本了。。

未完待续。
