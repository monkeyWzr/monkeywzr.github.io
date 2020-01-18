---
title: hexo博客突然丢失了所有的css js？？
date: 2016-11-05 14:31:16
category: tech
tags:
  - hexo
keywords:
  - hexo
  - jekyll
  - github
  - vendors
  - missing
  - 404
---

我这个博客使用`Github Pages` + `hexo` + `next`主题，昨天提交一篇博客之后就跪了，看不见文章列表，控制台里发现所有在vendor目录下的css和js全部404。纠结了一下午终于在github上找到了这个问题的issue

>We recently updated to Jekyll v3.3, which ignores the vendor folder by default. If you're not using Jekyll, you can add a .nojekyll file to the root of your repository to disable Jekyll from building your site. Once you do that, your site should build with your vendor folder.

原来是github最近升级了Jekyll，升级之后会默认忽略vendor/vendors文件夹。。这个会直接影响到next主题的显示。

<!-- more -->

目前找到了这么几种解决办法：
* 官方给出的解决办法就是在根目录下添加一个`.nojekyll`文件，对于hexo的话需要在`.deploy_git`和`public`目录下添加，然后`hexo d`即可。
* 更新next主题，作者已提交针对此问题的更新。
* 手动将 `source/vendors` 目录修改成 `source/lib` 或者其他的名称；同时，修改下主题配置文件`_config.yml`， 将 `_internal: vendors` 改成你所修改的名字

__相关链接:__

[What's new in GitHub Pages with Jekyll 3.3](https://github.com/blog/2277-what-s-new-in-github-pages-with-jekyll-3-3)

[issue #1214](https://github.com/iissnan/hexo-theme-next/issues/1214)

[有关博客传到github css js 404的问题 解决方案！！！](https://github.com/iissnan/hexo-theme-next/issues/1220)
