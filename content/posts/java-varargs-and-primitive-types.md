---
title: "JavaのArrays.asListのシグネチャーを始めとしてVarargsとバイトコードを調査した件"
date: 2021-01-29T23:39:16+09:00
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

ちなみに、`Arrays#toString`で簡単に配列を出力してくれる[^1]
```java
System.out.println(Arrays.toString(array)); // [1, 2, 3, 4]
```

## 1. 基本知識の明確

### 1.1 ジェネリクス「T」にはプリミティブ型が含まれていない. T = T extends Object

後ほどバイトコードを詳細した上、確認できた。
### 1.2 Object.String()の出力内容の読み方　(基本知識なのか？)

Objectクラスのディフォルト`toString`メソッド：

```java
public String toString() {
    return getClass().getName() + "@" + Integer.toHexString(hashCode());
}
```

`[I@5ba23b66`のような構成は[^2]：
* `[` 1次元配列 2次元の場合`[[`, 3次元は`[[[`、など
* `I` プリミティブint型。floatの場合`F`, longの場合`J`, オブジェクトの場合`Ljava/lang/Object`など[^3]
* `@`以降の部分は対象オブジェクトのハッシュコード

### Varargs(可変長引数)でいうのは？糖衣構文だ。コンパイル時配列として扱う

同時に定義できない[^4]
```java
    // 'foo(String...)' is already defined in 'Nani'
    public static void foo(String... args) {

    }

    // 'foo(String...)' is already defined in 'Nani'
    public static void foo(String[] args) {

    }
```

### Autoboxing発生のタイミング

TODO
## 2. 調査経緯

`java.util.Arrays#asList`の定義:
```java
    public static <T> List<T> asList(T... a) {
        return new ArrayList<>(a);
    }
```
引数はジェネリックなvarargsですね。渡されたパラメータがオブジェクトの配列`(T[])`にコンパイラされる。
なので、`int[]`の場合、このプリミティブ型の配列自身はObjectであり、可変長引数の1つとして、(`int[][]`)にコンパイルされる。
`Integer[]`の場合だと、すでにObjectの配列だから、そのまま引数配列として処理される。

そして、Autoboxingのおかげで下記の例も正常に処理できる
```java
    Arrays.asList(1,2,3,4).forEach(i -> System.out.print(i + " ")); // 1 2 3 4
```

下記もOK：
```java
    Arrays.asList(true, 1, "1", new Object());
```
Tは`Object`に推論されるだろう

コンパイルの流れは下記の感じかな？

* オブジェクトの配列？　→
* プリミティブ型をwrapper型に変換(Autoboxing)
* 引数を配列にする、Tの型を推論する


バイトコードを無理やり確認してみた。
varargについて、`javap　-v`でクラスファイルを確認する

```java
public static <T> void asList(T... a) {
        System.out.println(a.length);
    }
```

下記のようにコンパイルされる：(`##`のコメントは追加しておいたやつ)

```java
public static <T extends java.lang.Object> void asList(T...); // ## T extends Object!
    descriptor: ([Ljava/lang/Object;)V // ## 配列
    flags: (0x0089) ACC_PUBLIC, ACC_STATIC, ACC_VARARGS
    Code:
      stack=2, locals=1, args_size=1
         0: getstatic     #2                  // Field java/lang/System.out:Ljava/io/PrintStream;
         3: aload_0
         4: arraylength
         5: invokevirtual #3                  // Method java/io/PrintStream.println:(I)V
         8: return
      LineNumberTable:
        line 8: 0
        line 9: 8
      LocalVariableTable:
        Start  Length  Slot  Name   Signature
            0       9     0     a   [Ljava/lang/Object;
      LocalVariableTypeTable:
        Start  Length  Slot  Name   Signature
            0       9     0     a   [TT;
    Signature: #27                          // <T:Ljava/lang/Object;>([TT;)V

```

そして、配列を一旦定義する

```java
    int[] nums = new int[]{1, 2, 3, 4};
    Integer[] nums2 = new Integer[]{1, 2, 3, 4};
```

```java
Arrays.asList(nums);
```

は
```java
    ICONST_1
    ANEWARRAY [I // なにか処理しているよう
    DUP
    ICONST_0
    ALOAD 1
    AASTORE
    INVOKESTATIC java/util/Arrays.asList ([Ljava/lang/Object;)Ljava/util/List;
    POP
```

そしてIntegerの方
```java
    Arrays.asList(nums2);
```

は下記になっている

```java
    LINENUMBER 16 L3
    ALOAD 2 // なにかをそのまま使っているよう
    INVOKESTATIC java/util/Arrays.asList ([Ljava/lang/Object;)Ljava/util/List;
    POP
```

もう一個
```java
    Arrays.asList(1,2,3,4);
```
は
```java
    ICONST_4
    ANEWARRAY java/lang/Integer
    DUP
    ICONST_0
    ICONST_1
    INVOKESTATIC java/lang/Integer.valueOf (I)Ljava/lang/Integer;
    AASTORE
    DUP
    ICONST_1
    ICONST_2
    INVOKESTATIC java/lang/Integer.valueOf (I)Ljava/lang/Integer;
    AASTORE
    DUP
    ICONST_2
    ICONST_3
    INVOKESTATIC java/lang/Integer.valueOf (I)Ljava/lang/Integer;
    AASTORE
    DUP
    ICONST_3
    ICONST_4
    INVOKESTATIC java/lang/Integer.valueOf (I)Ljava/lang/Integer;
    AASTORE
    INVOKESTATIC java/util/Arrays.asList ([Ljava/lang/Object;)Ljava/util/List;
    POP
```

最初にAutoboxingしているような処理がある。

更に
```java
    Arrays.asList(true, 1, "1", new Object());
```
は
```java
    ICONST_4
    ANEWARRAY java/lang/Object // ## 今回はオブジェクトを扱っているよう
    DUP
    ICONST_0
    ICONST_1
    INVOKESTATIC java/lang/Boolean.valueOf (Z)Ljava/lang/Boolean;
    AASTORE
    DUP
    ICONST_1
    ICONST_1
    INVOKESTATIC java/lang/Integer.valueOf (I)Ljava/lang/Integer;
    AASTORE
    DUP
    ICONST_2
    LDC "1"
    AASTORE
    DUP
    ICONST_3
    NEW java/lang/Object
    DUP
    INVOKESPECIAL java/lang/Object.<init> ()V
    AASTORE
    INVOKESTATIC java/util/Arrays.asList ([Ljava/lang/Object;)Ljava/util/List;
    POP
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


[^1]: https://stackoverflow.com/questions/29140402/how-do-i-print-my-java-object-without-getting-sometype2f92e0f4
[^2]: https://stackoverflow.com/a/3615757
[^3]: [知らなくても困らない Javaクラスのバイトコードの読み方]: https://blog1.mammb.com/entry/2017/11/02/231509
[^4]: http://www.ne.jp/asahi/hishidama/home/tech/java/varargs.html#h2_def_array