---
title: "思考せずに毎日gettersとsettersを実装している私、その理由が分からない"
date: 2021-01-17T18:05:32+09:00
tags:
    - Java
categories:
    - notes
keywords:
    - Java
    - getters and setters
    - Java Bean
    - POJO
    - accessors
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

ある日、考えずに動いてる俺は突然目覚めた：上記のような処理せずフィールドの値の参照と設定だけの場合、fieldのアクセス修飾子をpublicにして直接使ったらいいんじゃない？lombokを使ってgettersとsettersを生成する目的は何だっけ？gettersとsettersは何だっけ？

いつからgetters/settersを使うことを習慣になるのか、どこから学んだのか全然覚えてないので、調査してみた。

## TL;DR

関係あるキーワード:

Encapsulation, Accessors, Immutable, JavaBeans, POJO, Persistence Ignorance, YAGNI, ORM

Java世界にgetters/setters手法の定番化は、Beanの概念の誕生、発展、およびJavaエコシステムの発展に関係があります。

POJOはライブラリに依存せずごく普通なオブジェクトである、JavaBeanは再利用可能なGUIコンポーネントの定義として登場、現在にいたってBeanの名前で再利用コンポーネントの概念として使われている

調査した後、先頭のような場合なら、publicデータフィルドで扱う方が良いかもしれないじゃないかと思っているが断言できません。
常に考えて、適切な処理を実装するのは大切だと思う。

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
* [○]アクセサー操作するようなデザインであるライブラリとの相互運用性が良い
* 値の代わり、アクセサーメソッドその自身をlambda対象として使う
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
当時GUIプログラミングの流行で、コンポーネント定義の規約としてJavaBeans誕生した。再利用可能なソフトウェアコンポーネントを作ることに目標した。[^3]

from [wikipedia](https://en.wikipedia.org/wiki/JavaBeans):
>* serializable
>* zero-argument public constructor
>* allow access to properties using getter and setter methods

その後、web開発用のJava ServletとStrutsフレームワークが流行になった。HTMLフォール、JSP、DBの間相互のデータ受け渡しもBeansの定義を従ってgetters/settersメソッドを使った。よく使われてるPOJOオブジェクトとか、DTOオブジェクトの概念もあの時代に繋がているようです。
Enterprise JavaBeans(EJB)もあの時代に生まれたものです。（あんまり知らない）

* POJO(Plain Old Java Object): ごく普通のJavaオブジェクトである。普通でいうは、特定なライブラリ、フレームワークなどに依存せず、純粋なオブジェクト。例えば`HttpServlet`を継承するオブジェクトはPOJOでない、EJBのエンティティBeanを継承するオブジェクトもPOPでない。 
* DTO(Data Transfer Object): getters/settersを備えたデータ格納用の構造。特にMVCフレームワーク中には、httpリクエストのハンドリング、ロジック、DBアクセスとか、違う処理階層の間、DTOを使ってコミュニケーションする。


これらのプロジェクトの影響で、Beanの概念が広がって、getters/settersの手法がだんだん定番になってきたようだ。現時代のJavaエコシステムでも、getters/settersを前提として作らえたライブラリがいっぱいあると気がしている。あの時代に生まれ、今まだ生きて使われているやつも結構あるね。xml/jsonの解析、ORMライブラリなどデータマッピングライブラリも、Strutsも、色々なフレームワークを使う時、getters/settersを用意しないと動けない場面が多い。

## 個人の考え(若干間違ってるかも)

個人的にgetters/settersを使いたくないメインの理由は、面倒くさいなのだ。実装も面倒くさいし、使用も面倒くさい。`x.setXXXX(foo)` `x,getXXXXX()` `x.getFoo().getBar().setBah(bah)`のような長い構文になり、疲れやすい。

他のPL言語にアクセサーの仕組みもあるが、糖衣構文(syntactic sugar)の裏に隠されてる場合が多い。

JavaScriptだと、`accessor descriptor`と呼ばれる。オブジェクトプロパティを定義する時、暗黙的に`[[Get]]`と`[[Put]]`ビルトインメソッドも提供してもらう。`myObj.a`のような構文でプロパティをアクセスする時実は`[[Get]]`を通じて値を取得している。[^4]

```javascript
let myObj = {
    a: 2
}
console.log(myObj.a) // 2
console.log(myObj.b) // undefined

let myObj2 = {
    a: 1
    _b: true
    get a() {
        return this.a + 1
    }
    set a(v) {
        this.a = v
    }
    // 別名として提供する
    get b() {
        return this._b
    }
    set b(v) {
        this._b = v
    }

    // 動的にプロパティを定義する
    get c() {
        return this._c
    }
    set c(v) {
        this._c = v
    }
}
```

存在しないプロパティを参照するとundefinedが返されるのはディフォルトの`[[Get]]`のおかげです。

参照：
[You Don't Know JS: this & Object Prototypes - Chapter 3: Objects](https://github.com/getify/You-Dont-Know-JS/blob/1st-ed/this%20%26%20object%20prototypes/ch3.md)
の[#get](https://github.com/getify/You-Dont-Know-JS/blob/1st-ed/this%20%26%20object%20prototypes/ch3.md#get)
と[#Getters & Setters](https://github.com/getify/You-Dont-Know-JS/blob/1st-ed/this%20%26%20object%20prototypes/ch3.md#getters--setters)

Rubyだと`attr_accessor`のようなアクセスメソッドの糖衣構文があり、アクセサーを生成してくれる
[https://ruby-doc.org/docs/ruby-doc-bundle/UsersGuide/rg/accessors.html](https://ruby-doc.org/docs/ruby-doc-bundle/UsersGuide/rg/accessors.html)

C#も糖衣構文になっていると思う
[プロパティ (C# プログラミング ガイド)](https://docs.microsoft.com/ja-jp/dotnet/csharp/programming-guide/classes-and-structs/properties)

c++のコニュニティにgetters/settersもよく使われるようですが、どんなストーリーだろう。また、通常の定義以外、`=`演算子のオーバーロードも可能なので、面白くて変な実装ができそう。

## 次に調査したいもの(ORM, lombok)

ORMフレームワークの仕組みと実装方法にすごく興味を持っているので、調査してみたいと思ってる。doma2,Hibernate,etc.

lombokの仕組みもとても興味深いね。キーワードはAST変換みたいです。今の自分は足りない知識が多い気がする。

## 参考資料

https://www.infoworld.com/article/2073723/why-getter-and-setter-methods-are-evil.html

https://qiita.com/CostlierRain464/items/07f46ba005c6c9bb42e2


https://stackoverflow.com/questions/1568091/why-use-getters-and-setters-accessors

https://softwareengineering.stackexchange.com/questions/416386/what-is-the-utility-and-advantage-of-getters-setters-especially-when-they-are

https://www.quora.com/What-is-the-use-of-getters-and-setters-in-java

http://blogs.williamsplayground.com/knowledge-base/server-side/design-patterns/design-pattern-persistence-ignorance/

https://github.com/getify/You-Dont-Know-JS

[^1]: https://dzone.com/articles/why-should-i-write-getters-and-setters
[^2]: https://www.amazon.co.jp/Effective-Java-%E7%AC%AC3%E7%89%88-Joshua-Bloch/dp/4621303252
[^3]: https://en.wikipedia.org/wiki/JavaBeans
[^4]: (https://github.com/getify/You-Dont-Know-JS/blob/1st-ed/this%20%26%20object%20prototypes/ch3.md#get)
