---
title: "毎日考えずにgettersとsettersを実装しているのにその理由が分からない私、調査してみた"
date: 2021-01-11T18:05:32+09:00
draft: true
tags:
    - Java
categories:
    - notes
keywords:
    - Java
    - getters and setters
---


最近lombokを使って下記のようなやつを結構実装していた

```java
@Getter
@Setter
// @Dataもよく使ってる
public class Foo {
    private String name;
    private int id;
}
```
ある日考えずに動いてる俺は突然目覚めた：lombokでいうのはgettersとsettersを生成してくれる、ただのツールに過ぎないから、上記のような処理せずフィールドの値の参照と設定だけの場合、どうしてgettersとsettersが必要なのだろう？fieldのアクセス修飾子をpublicにして直接使ったらいいんじゃない？


TODO

関係あるキーワード:

JavaBeans, POJO, Persistence Ignorance, YAGNI, ORM


https://dzone.com/articles/why-should-i-write-getters-and-setters


すげぇ：
https://blog1.mammb.com/entry/2019/12/06/090000#



https://www.infoworld.com/article/2073723/why-getter-and-setter-methods-are-evil.html

https://qiita.com/CostlierRain464/items/07f46ba005c6c9bb42e2


https://stackoverflow.com/questions/1568091/why-use-getters-and-setters-accessors
https://softwareengineering.stackexchange.com/questions/416386/what-is-the-utility-and-advantage-of-getters-setters-especially-when-they-are
https://www.quora.com/What-is-the-use-of-getters-and-setters-in-java

http://blogs.williamsplayground.com/knowledge-base/server-side/design-patterns/design-pattern-persistence-ignorance/