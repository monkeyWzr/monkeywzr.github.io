---
layout: post
title: jquery实现表单上传图片预览
category: 技术
tags: [jquery,php,html]
keywords: jquery,php,html,图片预览
description: 
---

最近有个小页面需要实现图片上传预览，自己还不擅长javascript，迷茫的看了好久文档之后算是利用File API实现了这个事情。
js代码：

        <script>
            function preview(files){
              for (var i = 0; i < files.length; i++) {
                var file = files[i];
                var reader = new FileReader();
                reader.onload = (function(aImg) { 
                  return function(e) { 
                    //假设页面上的img元素id为showimg
                    $('#showimg') . attr('src', e.target.result);
                  }; 
                })();
                reader.readAsDataURL(file);
              }
            }
        </script>

调用只要在input元素上加上`onchange="preview(this.files)"`。

>相关链接
>[在web应用中使用文件 -- Mozilla 文档](https://developer.mozilla.org/zh-CN/docs/Using_files_from_web_applications#%E4%BE%8B%E5%AD%90%EF%BC%9A%E6%98%BE%E7%A4%BA%E7%94%A8%E6%88%B7%E6%89%80%E9%80%89%E5%9B%BE%E7%89%87%E7%9A%84%E7%BC%A9%E7%95%A5%E5%9B%BE)
>来自百度的一个上传组件[http://fex.baidu.com/webuploader/](http://fex.baidu.com/webuploader/)
