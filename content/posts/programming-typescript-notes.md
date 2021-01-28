---
title: "プログラミングTypeScriptの読書メモ"
date: 2021-01-01T17:01:34+09:00
tags:
    - javascript
    - typescript
categories:
    - notes
keywords:
    - javascript
    - typescript
    - プログラミングTypeScript

---


### リテラル

```typescript
let a = 1 // number
let c : 3 = 3; // リテラル型 3
const b = 2 // リテラル型 2
const d: number = 4 // number
```

### 構造的型付け(structural typing)

ダックタイピング

→名前的型付け

### インデックスシグネチャ

```typescript
{
    [key: T]: U
}
```

### オブジェクトについて

**空のオブジェクトリテラル表記`{}`とオブジェクトプロトタイプ表記`Object`はできるだけ避けてください。**

```typescript
let foo: {}
foo = 1;
foo = {a: 1};
foo = [];
foo = 'abc';

let bar : Object;
bar = 1;
bar = {a: 1}
bar = []
bar = 'abc'

foo = {toString() {return  1}} // OK
bar = {toString() {return 1}} // Error: Type ‘() => number’ is not assignable to type ‘() => string’. Type ‘nubmer’ is not assignable to type ‘string’
```

良い宣言：
```typescript
let foo: {a: string}
let bar: object
```

## 呼び出しシグネチャ(call signature)

関数の型を表す構文です。
```typescript
// 省略記法
type foo = (name: string) => string

// 完全な呼び出しシグネチャ。オーバロードも表せる
type bar = {
    (name: string): string,
    (id: number, addr: string): string,
    (sex: string): void
}
```

## 文脈的型付け(contextual typing)

```typescript
function foo (
    bar: (index: number) => void
) {
    bar(1)
}

foo(n => console.log(n)) // OK when inline

function bah(n) { // Error: parameter ‘n’ implicitly has an ‘any’ type
    console.log(n)
}
```

上記インラインのの場合、`n => console.log(n)`のnが`number`であると、文脈から推論できる。インラインでないと当然エラーになる。


## ジェネリック型（総称型）

それぞれの宣言方法

* 一つのシグネチャに限られる。呼び出す時文脈的に推論され、具体的な型にバインドされる
```typescript
type  Filter1 = {
    <T>(array: T[], f: (item: T) => boolean): T[]
}

let filter1:Filter1
filter1 = (array, f) => {
    let res = [];
    for(let i = 0; i < array.length; i++) {
        if (f(array[i])) res[i] = array[i]
    }
    return res
} 

type  Filter2 = <T>(array: T[], f: (item: T) => boolean) => T[]
let filter2:Filter2
// ...
```

* 全体のシグネチャに制限する
```typescript
type  Filter3<T> = {
    (array: T[], f: (item: T) => boolean): T[]
} 
let filter3:Filter3<number>;
// ...

type  Filter4<T> = (array: T[], f: (item: T) => boolean) => T[]
let filter4:Filter4<number>;
// ...
```

* 名前付き関数。呼び出す時具体的な型に推論できる
```typescript
function filter5<T>(array: T[], f: (item: T) => boolean): T[] {
    return []
}
filter5([0,1,2,3], item => item > 0);
```


参考：typescriptの標準Arrayインタフェース定義。Array.filter, Array.map

### ディフォルトの型

```typescript
type Foo<T=string> = {
    name: T
} 
let foo:Foo

type  A = { a: string }
type  C = A & { b: number }
type Bar<T  extends  A = C> = {
    target: T
}
let bar:Bar
```

## クラスとインタフェース

### 戻り値としてthisが使える

チェイン呼び出されるAPIを定義する場合に便利です。

```typescript
  class DataList {
      add(value: number): this { // use this as return type instead of Set
          return this;
      }
  }

  class MutableDataList extends DataList {
      delete(value: number) : void {
          // do something
      }

      // no need to override add method
  }
```

### Interface

open ended.参照：[TypeScript Deep Dive](https://basarat.gitbook.io/typescript/type-system/interfaces)
宣言のマージ。（第１０章）

### インスタンス側とコンストラクタ側のことを考えつく
公式ドキュメント[^1]により、インスタンス側(instance side)と静的側(staic side)も言われる。
>Another way to think of each class is that there is an instance side and a static side.


### ポリモーフィズム

[インスタンス側とコンストラクタ側のことを考えつく](#インスタンス側とコンストラクタ側のことを考えつく)のは必要です。

```typescript
class MyMap<K, V> { // generic declaration at class scope
    set(k: K, v: V) { // can access the generic type
        // ...
    }
    merge<K1, V1>(map: MyMap<K1, V1>): MyMap<K | K1, V | V1> { // can declare new generic types
        let temp = new MyMap<K | K1, V | V1>();
        return temp
    }

    // static side cannot access the generic types so these errors will be raised:
    // Static members cannot reference class type parameters.(2302)
    // Parameter 'm' of public static method from exported class has or is using private name 'K'.(4070)
    // static copyFrom(m: MyMap<K, V>) { // error
    //     let temp = new MyMap<K, V>(); // error
    //     // copy
    //     return temp
    // }
    // So we need to declare the generic types we want at the method scope
    // K, V here is different things to those above
    static copyFrom<K, V>(m: MyMap<K, V>) {
        let temp = new MyMap<K, V>();
        // copy
        return temp
    }
    static of<K, V>(k: K, v: V): MyMap<K, V> {
        return new MyMap<K, V>();
    }
}

```

### ミックスイン

役割指向プログラミング(role-orientend programming)

### privateコンストラクタとファクトリーメソッドでfinalクラスを定義する

```typescript
class FinalFoo {
    private constructor() {
        console.log("constructor")
    }
    static create() {
        return new FinalFoo()
    }
}

class ExtendedFoo extends FinalFoo {} // Error: Cannot extend a class 'FinalFoo'. Class constructor is marked as private.(2675)

const foo = new FinalFoo() // Error: Constructor of class 'FinalFoo' is private and only accessible within the class declaration.(2673)

const foooo = FinalFoo.create() // OK
```

### より型安全なビルダーパターンの実装

第５章の練習４

a. setUrl --> setMethod --> sendの順で固定する

```typescript
class RequestBuilder {
    protected data: object | null = null

    setURL(url:string) {
        return new RequestBuilderWithUrl(url).setData(this.data)
    }

    setData(data: object | null) {
        this.data = data
        return this
    }
}

class RequestBuilderWithUrl extends RequestBuilder {
    protected url: string
    constructor(url: string) {
        super()
        this.url = url
    }
    setMethod(method: 'get' | 'post') {
        return new RequestBuilderWithUrlAndMethod(this.url, method).setData(this.data)
    }
}

class RequestBuilderWithUrlAndMethod extends RequestBuilderWithUrl {
    protected method: 'get' | 'post'
    
    constructor(url: string, method: 'get' | 'post') {
        super(url)
        this.method = method
    }
    send() {
        console.log(this.url)
        console.log(this.method)
        console.log(this.data)
        console.log('send')
    }
}

let builder = new RequestBuilder()
builder.setURL('')
    .setMethod('get')
    .setData({}) // 省略可
    .send()
```

[^1](https://www.typescriptlang.org/docs/handbook/classes.html#advanced-techniques)[