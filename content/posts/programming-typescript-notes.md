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
