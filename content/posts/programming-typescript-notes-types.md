---
title: "プログラミングTypeScriptの読書メモ - 型"
date: 2021-02-14T16:31:57+09:00
draft: true
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

### サブタイプとスーパータイプ

* anyはすべての型のスーパータイプ
* neverはすべての型のサブタイプ

### 変性

* 不変性(invariance)
* 共変性(covariance)
* 反変性(contravariance)
* 双変性(bivariance)

ディフォルトでTypescriptの型に関して共変です。
`{"strictFunctionTypes": true}`の場合、関数型にはそのパラメータの型が反変にと扱うようにする。具体は[下記](#関数型の関係と反変)を参照ください。

### 関数型の関係と反変
```typescript
class Animal {}
class Bird extends Animal {
    chirp() {}
}
class Crow extends Bird {
    caw() {}
}

function clone (f: (b:Bird) => Bird): void {

}
```

clone関数は、関数型のパラメータを期待する。`(b: Bird) => Bird`型の関数、とそのサブタイプの関数を渡すことができる。
ここまでは普通の共変であり、反変に関係ない。

ではどんな関数は`(b: Bird) => Bird`のサブタイプでしょうか

```typescript
// これをベースとして考えてみる
function bToB(b: Bird) : Bird {
    return new Bird();
};

function bToC(b: Bird) : Crow {
    return new Crow();
}

function bToA(b:Bird) : Animal{
    return new Animal()
}

function aToB(a:Animal) : Bird {
    return new Bird();
}

function cToB(c: Crow) : Bird {
    return new Bird()
}

clone(bToB) // OK

clone(bToC) // OK

clone(bToA) // Error 2345

clone(aToB) // OK

clone(cToB) // Error 2345
```

`(b: Bird) : Crow`は`(b: Bird) => Bird`のサブタイプであり、`(b:Bird) : Animal`はサブタイプではない。この戻り値の振舞いはまだ共変です。（戻り値はサブタイプの関係　→　関数はサブタイプの関係）

`(a:Animal) : Bird`は`(b: Bird) => Bird`のサブタイプであり、`(c: Crow) : Bird`はサブタイプではない。このパラメータ部分の振舞いは**反変**です。（パラメータはスーパータイプの関係　→　関数はサブタイプの関係）

### 過剰プロパティチェック(excess property checking)

6.1.4.2
