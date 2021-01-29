---
title: "Java Varargs and Primitive Types"
date: 2021-01-29T23:39:16+09:00
draft: true
tags:
    - Java
categories:
    - notes
keywords:
    - Java varargs
    - Java primitive types
    - Java Arrays.asList
---

## 0. 課題

数日前、配列を出力したいので下記のようなコードを書いた

```java
public class Nani {
    public static void main(String[] args) {

        int[] nums = new int[]{1, 2, 3, 4};
        Arrays.asList(nums).forEach(i -> System.out.println(i + " "));
    }
}
```

Ideaコード補完の提示に従って書いたし、エラーもないけど実行すると`1 2 3 4`ではなく、
`[I@5ba23b66`というようなやつが出力された。オブジェクトとして出力されてることが分かてるけどこれ以上理解できなかった。

友達からヒントをもらって、`Integer`にすると
```java
        Integer[] nums2 = new Integer[]{1, 2, 3, 4};
        Arrays.asList(nums2).forEach(i -> System.out.print(i + " "));
```

`1 2 3 4`になった。Listとかジェネリクスとかプリミティブとかに関係あるだろうと思って色々調べてみた。

結局、これらJavaの基本コンセプト:
* Varargs
* Autoboxing
* Generics

はいずれもよく把握してなかった。

ちなみに、`Arrays#toString`で簡単に配列を出力してくれる
```java
System.out.println(Arrays.toString(array)); // [1, 2, 3, 4]
```

## 1. 基本知識の明確

### 1.1 ジェネリクス「T」にはプリミティブ型が含まれていない. T = T extends Object

### 1.2 Object.String()の出力内容の読み方　(基本知識なのか？)

TODO
これはもっと早く勉強いていたらいいな[^2]

### Varargs(可変長引数)でいうのは？糖衣構文だ。コンパイル時配列になる

同時に定義できない[^3]
```java
    // 'foo(String...)' is already defined in 'Nani'
    public static void foo(String... args) {

    }

    // 'foo(String...)' is already defined in 'Nani'
    public static void foo(String[] args) {

    }
```

### Autoboxing発生のタイミング

## 2. 調査経緯

`java.util.Arrays#asList`の定義:
```java
    public static <T> List<T> asList(T... a) {
        return new ArrayList<>(a);
    }
```
引数はジェネリックなvarargsですね。`(T, T, T, ...)`あるいは`(T[])`のような引数を期待している。
なので、`int[]`の場合、このプリミティブ型の配列自身はObjectであり、可変長引数の1つとして、(`int[][]`)にコンパイルされる。
`Integer[]`の場合だと、すでにObjectの配列だから、そのまま引数配列として処理される。

それで、下記の例も正常に処理できるのは、どういうことでしょう
```java
    Arrays.asList(1,2,3,4).forEach(i -> System.out.print(i + " ")); // 1 2 3 4
```

これはAutoboxingの役だ。IntegerにボックスされてInteger[]になる。

バイトコードとか聞いたことあるけど、触ったこと全然ない。無理やり確認してみて、
```java
    Arrays.asList(nums).forEach(i -> System.out.println(i + " "));
```
は
```java
   L2
    LINENUMBER 9 L2
    ICONST_1
    ANEWARRAY [I
    DUP
    ICONST_0
    ALOAD 1
    AASTORE
    INVOKESTATIC java/util/Arrays.asList ([Ljava/lang/Object;)Ljava/util/List;
    INVOKEDYNAMIC accept()Ljava/util/function/Consumer; [
      // ...(省略)
      // arguments:
      (Ljava/lang/Object;)V, 
      // handle kind 0x6 : INVOKESTATIC
      Nani.lambda$main$0([I)V, 
      ([I)V // ここだろう？
    ]
    INVOKEINTERFACE java/util/List.forEach (Ljava/util/function/Consumer;)V (itf)
```

そしてIntegerの方
```java
    Arrays.asList(nums).forEach(i -> System.out.println(i + " "));
```

は下記になっている

```java
   L5
    LINENUMBER 13 L5
    ALOAD 2
    INVOKESTATIC java/util/Arrays.asList ([Ljava/lang/Object;)Ljava/util/List;
    INVOKEDYNAMIC accept()Ljava/util/function/Consumer; [
      // ...(省略)
      // arguments:
      (Ljava/lang/Object;)V, 
      // handle kind 0x6 : INVOKESTATIC
      Nani.lambda$main$1(Ljava/lang/Integer;)V, 
      (Ljava/lang/Integer;)V // ここだろう？
    ]
    INVOKEINTERFACE java/util/List.forEach (Ljava/util/function/Consumer;)V (itf)
```

あんまり読めないので一旦ここまでだ。次はバイトコードの読み方を勉強する:

[Javaバイトコードの読み方](https://nagise.hatenablog.jp/entry/20100207/1265522562)

[知らなくても困らない Javaクラスのバイトコードの読み方](https://blog1.mammb.com/entry/2017/11/02/231509)


## 参考

https://aoking.hatenablog.jp/entry/20110415/1302824606

https://qiita.com/nkojima/items/390282a0912aa560ad22

http://www.ne.jp/asahi/hishidama/home/tech/java/varargs.html#h2_def_array

https://stackoverflow.com/questions/29140402/how-do-i-print-my-java-object-without-getting-sometype2f92e0f4

https://www.ne.jp/asahi/hishidama/home/tech/java/generics.html


[^2]: https://stackoverflow.com/questions/29140402/how-do-i-print-my-java-object-without-getting-sometype2f92e0f4
[^3]: http://www.ne.jp/asahi/hishidama/home/tech/java/varargs.html#h2_def_array