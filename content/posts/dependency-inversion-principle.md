---
title: "依存性逆転の原則(Dependency Inversion Principle), the D in SOLID"
date: 2020-12-19T15:43:21+09:00
draft: true
tags:
    - Java
categories:
    - notes
keywords:
    - SOLID
    - Java
    - Dependency Inversion
    - Programming to an Interface
---

SOLIDの一つである、依存性逆転の原則(Dependency Inversion Principle, DIP)は一体どういうものか？色々調査してみた。今までもはっきりわかったと言えないがある程度納得したと思う。

## まず、依存性の注入(DI)は依存性逆転の原則(DIP)ではない

よく言われてる依存性の注入(Dependency Injection, DI)と依存性逆転の原則は、全く別のものである。

あるクラスBの中には、別のクラスAを使う場合、BはAを依存している

```java
class A {
    public A(int p) {
        // ...
    }
}
class B {
    public B() {
        A a = new A(1);
        // ...
    }

    public static void main(String[] args) {
        B b = new B();
    }
}
```

DIていうのは、その依存対象を直接扱う代わりに、外から注入することです。

```java
class B {
    public B(A a) {
        // ...
    }

    public static void main(String[] args) {
        A a = new A(1);
        B b = new B(a);　// Bの依存を注入する
    }
}
```

SpringとかのフレームワークはDIを利用して依存関係を管理して注入してくれる。

```java
class B {
    @Autowired
    public B(A a) {
        // ...
    }
}
```

## その次、Programming to an Interfaceを理解する必要ある

この原則は、下記の感じだと思う
```java
List<String> todos1 = new ArrayList<>(); // 良い
ArrayList<String> todos2 = new ArrayList<>(); // 良くない

Map<String, String> routes1 = new HashMap<>(); // 良い
HashMap<String, String> routes2 = new HashMap<>(); // 良くない
```
特定の実現を依存せず、Interfaceを依存する、でいうことです。
下記のようなソース、よく書いた、、
```java
class Something {
    private ArrayList<String> data;
    public Something(ArrayList<String> d) {
        this.data = d;
    }
}
```
Somethingクラスを使うクライアント側、ArrayListしか選択肢がないから、LinkedListを使いたい場合、ケンカになっちゃう。
Programming to an interfaceを従うと、
```java
class Something {
    private List<String> data;
    public Something(List<String> d) {
        this.data = d;
    }
}
```
クライアント側好きなList実現を自由に使える

## ようやく依存性逆転の原則を理解してみよう

明確な定義というと[^1]、

>* High-level modules should not depend on low-level modules. Both should depend on abstractions.
>* Abstractions should not depend on details. Details should depend on abstractions.

>* 上位レベルのモジュールは下位レベルのモジュールに依存すべきではない。両方とも抽象（abstractions)に依存すべきである。
>* 抽象は詳細に依存してはならない。詳細が抽象に依存すべきである。

以下の例を考えてみよう。
あるTextクラスを操作できるエディタークラスを実装する
```java
package foo.bar.file;

class Text {
    private String content;
    private int size;
    public Text(String filename) {
        // ...
    }

    public int size() {

    }

    public String getContent() {

    }

    public void setContent() {

    }
}
```

```java
package foo.bar.editor;

class Editor {
    private Text target;
    private Text temp;

    public open(Text text) {
        
    }
    public void new(Text text) {
        
    }

    public Text duplicate() {

    }

    public void save() {
        this.target.setContent(this.temp.getContent());
    }

    public void update(String newContent) {
        this.temp.setContent(newContent);
    }

    public static void main(Stirng[] args) {
        Text text = new Text("to/somewhere/bah.txt");
        Editor editor = new Editor(text);
    }
}
```

一つ種類のファイルしか編集できないエディターはあんまり価値がないだろう。他のファイルを編集したい場合、Editorの定義を修正するか新しいエディターを実装しないといけない状況になる。Textの定義が変わった場合、Editorが使えなくなる可能性も高いです。

ではEditorの定義を修正しようか

```java
package foo.bar.editor;

interface File {

    public void init(String filePath);

    public int size();

    public String getContent();

    public void setContent(String content);
}
```

```java
package foo.bar.editor;

class Editor {
    private Text target;
    private Text temp;

    public open(File file) {
        
    }

    public void new(File file) {
        
    }

    public File duplicate() {

    }

    public int size() {

    }

    public void save() {
        this.target.setContent(this.temp.getContent());
    }

    public void update(String newContent) {
        this.temp.setContent(newContent);
    }

    public static void main(Stirng[] args) {
        Text text = new Text("to/somewhere/bah.txt");
        Editor editor = new Editor(text);
    }
}
```

```java
// TODO:someFileの実現
```

次、interfaceとEditorのパッケージを分ける

現実の例
java.Util.Scanner

Scanner(Path source)
Scanner(Readable source)

https://docs.oracle.com/javase/jp/8/docs/api/java/util/Scanner.html




[^1]: [https://ja.wikipedia.org/wiki/%E4%BE%9D%E5%AD%98%E6%80%A7%E9%80%86%E8%BB%A2%E3%81%AE%E5%8E%9F%E5%89%87](https://ja.wikipedia.org/wiki/%E4%BE%9D%E5%AD%98%E6%80%A7%E9%80%86%E8%BB%A2%E3%81%AE%E5%8E%9F%E5%89%87)