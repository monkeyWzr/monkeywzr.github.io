---
title: ruby学习笔记
date: 2016-12-08 22:54:49
category: 学习笔记
tags:
    - ruby
keywords:
    - ruby
    - 教程
    - 笔记
---

## regular expressions

`=~`是用于正则表达式的匹配操作符。返回匹配到的字符串位置或nil。

```ruby
"abcdef" =~ /d/ # return 3
"aaaaaa" =~ /d/ # return nil
```

## !和?

The exclamation point (!, sometimes pronounced aloud as "bang!") indicates something potentially destructive, that is to say, something that can change the value of what it touches.
```
ruby> s1 = "forth"
  "forth"
ruby> s1.chop!       # This changes s1.
  "fort"
ruby> s2 = s1.chop   # This puts a changed copy in s2,
  "for"
ruby> s1             # ... without disturbing s1.
  "fort"
```

You'll also sometimes see chomp and chomp! used. These are more selective: the end of a string gets bit off only if it happens to be a newline.

The other method naming convention is the question mark (?, sometimes pronounced aloud as "huh?") indicates a "predicate" method, one that can return either true or false.
