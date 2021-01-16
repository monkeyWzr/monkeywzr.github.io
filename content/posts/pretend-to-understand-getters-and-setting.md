---
title: "思考せずに毎日gettersとsettersを実装している私、その理由が分からない"
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

ある日、考えずに動いてる俺は突然目覚めた：lombokでいうのはgettersとsettersを生成してくれる、ただのツールに過ぎないから、上記のような処理せずフィールドの値の参照と設定だけの場合、どうしてgettersとsettersが必要なのだろう？fieldのアクセス修飾子をpublicにして直接使ったらいいんじゃない？

いつからgetters/settersを使うことを身に付いたのか、どこから学んだのか全然覚えてないので、調査してみた。

## TL;DR

関係あるキーワード:

Encapsulation, Accessors, Immutable, JavaBeans, POJO, Persistence Ignorance, YAGNI, ORM

調査した後、個人的にgetters/settersは（少なくともJava世界に）良くない習慣であり、避けたほうが良い、の方を賛成する傾向がある。しかし正直はまだわからない。
先頭のような実装で、publicデータフィルドで扱う方が良いかもしれないね

状況次第、最適な方法を選ばせてもらえれば良いかも。（今のプロジェクトの規約には、getters/settersを使うことが唯一の選択肢）

## まず、getters/settersをおすすめしている資料を探した

getters/settersはJavaオブジェクト指向プログラミングの入門教材の定番としてよく見られ、カプセルかとかの概念に紐付けられているような印象がある。
だがgoogleしてみるとgetters/settersの必要性を疑ているタイトルがいっぱい出てきた。

おすすめしている資料の一例：
[Why Should I Write Getters and Setters](https://dzone.com/articles/why-should-i-write-getters-and-setters)

後半から
>I understand, but generally, we do not write anything in getters/setters. We just return and set the field, which is same as exposing a field as public. So why are you saying all of this?

の疑問に対し、大体「未来にロジックを追加する可能性があるから」の観点で最後に「So please, go for it」で回答してくれたが、正直納得できなかった。

stackoverflowでgetters/settersを使う理由について、結構人気な記事がある
[why-use-getters-and-setters-accessors](https://stackoverflow.com/questions/1568091/why-use-getters-and-setters-accessors)

まとめで下記のメリット：（Javaを前提で納得できたやつに丸をつけた）

* [○]プロバティの制御をカプセル化、後日にバリデーションとか制御追加、変更が可能
* [○]プロパティ名とか内部情報を隠して、別名でアクセスを公開する
* publicインタフェースを変更から隔離する
* ライフタイムのコントロールとメモリマネジメント（Java以外の言語の話っぽい）
* [○]デバックに便利する（設定・取得にインタセプトできるから）
* アクセサー操作するようなデザインであるライブラリとの相互運用性が良い
* 値の代わり、アクセサーメソッドその自身をlambda対象として使う（Javaで可能？）
* [○]参照と変更を別々のアクセス権を制御できる、継承とかをする時、更にアクセサーのスコープを変更できる
* 遅延ロードできる、コピーオンライト（Copy on Write, COW）できる　→　具体的に何かが知らない


賛成する観点は結構あるが、なんか足りない気がする。一番先頭に書いてた実装のような、だたのデータを格納するための構造、バリデーションもBean ValidationとかSpring Validationとかの仕組みで別途実装してるから。

本の資料について、見つけた一番有名な資料は、多分「Effective Java」だと思う。（そう、一回本屋に行った）
項目16は明確的に
>In pulic class, use accessor methods, not public fields
（公開クラスにpublicフィルドの代わり、アクセサーを使う）

の観点である。だかパッケージプライベートあるいはプライベートネストクラスの場合データフィルドを公開しても良い、という例外も言及した。[^2]

## そもそもJavaのGetters/Settersは何者か

_Java世界のgetters/setters文化の形成は数十年前から始めたものである。Javaの誕生も私の誕生より５ヶ月ぐらい早いし、その発展に私はまったく実感が湧きてないので、このセクションの内容は、ほぼ以下２つのブログを拝見してからわかったものです。_

_[Java Beans の大罪 〜 getter/setter を捨てて美しきオブジェクトの世界で生きよ〜](https://blog1.mammb.com/entry/2019/12/06/090000#)_

_[getter/setterとはなんだったのか](https://nagise.hatenablog.jp/entry/20141010/1412930502)_

_すげぇなブログだと思ってる。_

----------------------------------------------------------

カプセル、アクセサーとかのコンセプトはソフトウェア方法論の一部であり、Java世界に限らず、Javascript, Ruby, C#等様々な言語仕様にも含まれている。

Java 1.0リリースされた時点（1996年1月23日）、定着的なgetters/setters仕様はJavaに含まれてなかったようです。




https://www.infoworld.com/article/2073723/why-getter-and-setter-methods-are-evil.html

https://qiita.com/CostlierRain464/items/07f46ba005c6c9bb42e2


https://stackoverflow.com/questions/1568091/why-use-getters-and-setters-accessors
https://softwareengineering.stackexchange.com/questions/416386/what-is-the-utility-and-advantage-of-getters-setters-especially-when-they-are
https://www.quora.com/What-is-the-use-of-getters-and-setters-in-java

http://blogs.williamsplayground.com/knowledge-base/server-side/design-patterns/design-pattern-persistence-ignorance/


[^1]:ttps://dzone.com/articles/why-should-i-write-getters-and-setters
[^2]:https://www.amazon.co.jp/Effective-Java-%E7%AC%AC3%E7%89%88-Joshua-Bloch/dp/4621303252