---
title: "プログラミングTypeScriptの読書メモ - 型"
date: 2021-03-22T16:31:57+09:00
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

難しすぎて、一回3−4ページ文しか進められてない、、

**よく自分に聞く：Is this something about TYPEScript(exists only during compile time) or not(to be dealt at runtime)?**

聞きながら勉強すると大変助かります。


## 高度な型
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


### タグ付き合併型


<!-- ```typescript
type A  = { value: string, target: HTMLInputElement }
type B = { value: [number, number], target: HTMLElement }
type C = A | B

function handle(event: C) {
    if (typeof event.value == "string") {
        event.target // HTMLInputElement or HTMLElement
        return
    }
    event.target // HTMLInputElement or HTMLElement
}
``` -->


**TODO: 本の例が理解できてない**

typeofで型を絞り込んでも、型が十分に推論できない場合がある

下記の推論はなぜ？？

```typescript
type Cat = { id: number, purrs: boolean, eat: boolean }
type Dog = { id: string, bark: boolean, eat: () => void }
type Pet = Cat | Dog

function playWith(pet: Pet) {
    if (typeof pet.id == "number") {
        pet.eat // (property) eat: boolean | (() => void)
        return
    }
    pet.eat // (property) eat: boolean | (() => void)
}
```

本によると、「合併型のメンバーは型が重複する可能性があるので」、Unionのどちらは推論できない。
具体の場合は思いつかないT.T. TODO

一意であるリテラル型を使ってタグ付けをすると、その分岐を特定できる
```typescript
type Cat = { type: 'nyan', id: number, purrs: boolean, eat: boolean }
type Dog = { type: 'wan', id: string, bark: boolean, eat: () => void }
type Pet = Cat | Dog

function playWith(pet: Pet) {
    if (pet.type == "nyan") {
        pet.eat // (property) eat: boolean
        return
    }
    pet.eat // (property) eat: (() => void)
}
```

### 完全性(noImplicitReturns)

`noImplicitReturns`オプションはstrictフラグに含まれないため、有効したい場合は明示的に指定する必要がある

### ルックアップ型

```typescript
type User = {
    name: string,
    friendList: {
        count: number,
        friends: {
            name: string
        }[]
    }
}

type FriendList = User['friendList']
type FriendInfo = User['friendList']['friends'][number] // note this!
```
### keyof演算子

```typescript
type keys = keyof {a: string, b: number, c: boolean} // type keys = "a" | "b" | "c"
```

### レコード(Record)型

One of [Utility Types](https://www.typescriptlang.org/docs/handbook/utility-types.html#recordkeystype).
→　[Map型](#Map型)

```typescript
let r: Record<'a' | 'b' | 'c', string> = { // Error: Property 'c' is missing in type '{ a: string; b: string; }' but required in type 'Record<"a" | "b" | "c", string>'.
    a: "",
    b: ""
}
```

### Map型

[Utility Types](https://www.typescriptlang.org/docs/handbook/utility-types.html#recordkeystype).

汎用なユーティリティ機能です。強い!
マイナス演算子`-`で省略可能、readonlyなど制約の撤去ができる

```typescript
type OptionalUser = {
    [K in keyof User]?: User[K]
}

// ! we can remove optional constraint
type RequiredUser = {
    [K in keyof OptionalUser]-?: User[K]
}

type NullableUser = {
    [K in keyof User]: User[K] | null
}
type ReadonlyUser = {
    readonly [K in keyof User]: User[K]
}

// ! we can remove readonly constraint
type ModifiableUser = {
    -readonly [K in keyof User]: User[K]
}
```

## 関数にまつわる型

### Tupleの型推論

マジックだこれ。

```typescript
const a = [1, true] // a is (number | boolean)[]

function tuple<T extends unknown[]>(...t: T): T {
    return t
}

const b = tuple(1, true) // b is [number, boolean]
```

### 型ガイド

面白い

```typescript
// this works at runtime so TypeScript do not know the type at compile type
function isString(p: unknown): boolean {
    return typeof p == 'string'
}

// now TypeScript knows the type is string when this function return true
function isStringType(p: unknown): p is string {
    return typeof p == 'string'
}
```

## 条件型

```typescript
type x = string
type A = x extends string ? true : false // type of A is true
type B = x extends number ? true : false // type of B is false
```

### 分配法則

本の例`Without<T, U>`について、分配法則がなかったとする場合の推論が間違ったようだ。
[『プログラミングTypeScript』の正誤表](https://github.com/oreilly-japan/programming-typescript-ja/wiki/errata#%E7%AC%AC1%E5%88%B7)

```typescript
// type of C is boolean | number | string, which is T.
type T = (boolean | number | string)
type C =  T extends boolean ? T : never

// type of E is boolean !!
type Select<T, U> = T extends U ? T : never
type E = Select<boolean | number | string, boolean>
// because it is the same as Select<boolean> | Select<number> | Select<string>
```
### inferキーワードで型変数を宣言する

```typescript
type ElementType<T> = T extends (infer U)[] ? U : T
```

### 明確な割立てアサーション

```typescript

let userId: string

function fetchUser() {
    userId = 'abc'
}

fetchUser()

userId.toUpperCase(); // Error: Variable 'userId' is used before being assigned.
```

To fix this, 

```typescript
let userId!: string
// OR
userId!.toUpperCase()
```

### 名前的型

TypeScriptの型は構造的なので、型のブランド化というテクニックで名前的な型を作る

https://qiita.com/suin/items/ae9ed911ebab48c98835
https://qiita.com/suin/items/57cfc0ec9bb1a6995aa5
https://typescript-jp.gitbook.io/deep-dive/main-1/nominaltyping