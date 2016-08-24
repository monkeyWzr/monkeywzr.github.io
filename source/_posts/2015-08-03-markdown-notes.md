---
layout: post
title: markdown语法简记
category: 学习笔记
tags: [markdown,教程]
keywords: markdown,教程
description: 
---






## 0. 反斜杠

反斜杠可以将在markdown中有特殊意义的字符作为正常字符插入。


## 1. 标题

类Setext形式
`=`和`-`的数量随意，效果效果是相同的。

```
This is H1
==========

This is H2
----------
```
类atx形式
也可以写成前后对称的形式。

```
#  H1

##  H2

######  H6
```
注意在#与标题间必须存在至少一个空格或制表符


## 2. 引用

\>在段落前加`>`进行引用。
	在段落前加`>`进行引用。
	在段落前加`>`进行引用。

\>或者每行前加`>`进行引用。
\>或者每行前加`>`进行引用。
\>或者每行前加`>`进行引用。

效果相同。

>在段落或者每句前加`>`进行引用
>在段落或者每行前加`>`进行引用。
>在段落或者每行前加`>`进行引用。

加上不同数量的`>`实现嵌套引用。


## 3. 代码区块

代码区块只需一个制表符或者4个空格：

当你想插入代码区块

		只需4个空格或者1个制表符

标记一小段代码可以用反引号\`包起来，在本文随处可见`效果`。

也可用<code>```</code>的形式：
    
        ```
        代码区块
        ```
将产生相同效果。但是此种方法并非标准markdown语法，有时可能会解析不正确。
在代码区块中可以方便的插入HTML原始码，Markdown会自动将`<``&`等转换为HTML实体。


## 4. 列表

无序列表

```
* red
+ green
- yellow
```
三种形式等同。

* red
+ green
- yellow

有序列表

```
1. 吃
2. 粑粑
```
1. 吃
2. 粑粑

句点后要有空格。数字是多少都无所谓，产生的效果相同。

列表项下包含段落时，段落必须以1个制表符或4个缩进开头。
如果列表项下需要引用，`>`需要缩进。
列表项下包含代码区块时，需要双倍缩进（2个制表符或者8个空格）。

```
* 列表项下引用

	>空行并缩进
```
* 列表项下引用

	>空行并缩进


## 5. 分割线

以下形式均可产生相同分割线，只要是3个以上的`*``+``-`即可。

    * * *
    +++
    -----



## 6. 强调

\*red\*
\_red\_
都会产生 *red* 的效果。

\*\*green\*\*
\_\_green\_\_
都会产生 **green** 的效果。

强调可以直接插在句子中。


## 7. 链接

行内式
<pre>这是[Google](http://google.com)搜索.</pre>   
这是[Google](http://google.com)搜索.

参考式
<pre>
这是[Google][id1]搜索
这是[Baidu][id2]搜索
这是[Github][]。
这是[Twitter][]。

[id1]:https://google.com
[id2]:https://baidu.com
[Github]:https://github.com
[Twitter]:https://twitter.com

</pre>

这是[Google][id1]搜索
这是[Baidu][id2]搜索
这是[Github][]。
这是[Twitter][]。

[id1]:https://google.com
[id2]:https://baidu.com
[Github]:https://github.com
[Twitter]:https://twitter.com

Markdown支持以比较简短的自动链接形式来处理网址和电子邮件信箱，只需用<>括起来。
    <https://google.com>
会自动转换为
    <a href="https://google.com/">https://google.com/</a>


## 8. 图片

行内式格式为：
<pre>![图片替代文字](/path/to/img.jpg)</pre>

参考式像这样：
<pre>
![Alt text][id]
[id]: url/to/image "Optional title attribute"  title文字部分可缺省
</pre>


## 详细内容参见

点击进入
[Markdown语法简体中文版](https://gitcafe.com/riku/Markdown-Syntax-CN/blob/master/syntax.md)
[Markdoown官方文档](http://daringfireball.net/projects/markdown/syntax)

