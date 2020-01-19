---
title: Standard ML notes
tags:
    - SML
category: tech
keywords:
    - SML
---

## Basics

### Comments

```ML
(* SML comment *)
```

### Variable bindings and Expressions

```ML
val x = 34;
(* static environment: x : int *)
(* dynamic environment: x --> 34 *)
val y = x + 1;

(* Use tilde character instead of minus to reprsent negation *)
val z = ~1;

(* Integer Division *)
val w = y div x
```

Strings:

```ML
(* `\n`のようなエスケープシーケンスが利用できる *)
val x = "hello\n"; 
(* 文字列の連結には'^'を使う *)
val y = "hello " ^ "world";
```

An ML program is a sequence of bindings. Each binding gets **type-checked** and then **evaluated**. 
What type a binding has depends on a static environment. How a binding is evaluated depends on a dynamic environment.
Sometimes we use just `environment` to mean dynamic environment and use `context` as a synonym for static environment.

* Syntaxs : How to write it.
* Semantics: How it type-checks and evaluates
* Value: an expression that has no more computation to do

### Shadowing

**Bindings are immutable** in SML. Given `val x = 8 + 9;` we produce a dynamic environment where x maps to 17. 
In this environment x will always map to 17; there is no "assignment statement" in ML for changing what x maps to. 
You can have another binding later, say `val x = 19;`, but that just creates a differnt environment 
where the later binding for x **shadows** the earlier one.

### Function Bindings

```ML
fun pow (x:int, y:int) = (* correct only for y >= 0 *)
    if y = 0
    then 1
    else x * pow(x, y-1);

fun cube (x : int) = 
    pow(x, 3);

val ans = cube(4);
(* The parentheses are not necessary if there is only one argument
     val ans = cube 4; *)
```

* Syntax: `fun x0 (x1 : t1, ..., xn : tn) = e`
* Type-checking: 
    - `t1 * ... * tn -> t`
    - The type of a function is "argument types" -> "reslut types"
* Evaluation:
    - A function is a value
    - The environment we extends arguments with is that “was current” when the function was defined, not the one where it is being called.
    
### Pairs and other Tuples

```ML
fun swap (pr : int*bool) =
    (#2 pr, #1 pr);

fun sum_two_pairs (pr1 : int * int, pr2 : int * int) =
    (#1 pr1) + (#2 pr1 ) + (#1 pr2) + (#2 pr2);

fun div_mod (x : int, y: int) =
    (x div y, x mod y);

fun sort_pair(pr : int * int) =
    
    if (#1 pr) < (#2 pr) then
	pr
    else
	(#2 pr, #1 pr);
```

ML supportstuplesby allowing any number of parts. Pairs and tuples can be nested however you want. For example, a 3-tuple (i.e., a triple) of integers has type int*int*int. An example is (7,9,11) and you retrieve the parts with #1 e, #2 e, and #3 e where e is an expression that evaluates to a triple.

```ML
val a = (7, 9, 11) (* int * int * int *)
val x = (3, (4, (5,6))); (* int * (int * (int * int)) *)
val y = (#2 x, (#1 x, #2 (#2 x))); (* (int * (int * int)) * (int * (int * int)) *)
val ans = (#2 y, 4); (* (int * (int * int)) * int *)
```

### Lists

```ML
val x = [7,8,9];
5::x; (* 5 consed onto x *)
6::5::x;
[6]::[[1,2],[3,4];
```

To append a list t a list, use list-append operator `@`:
[Reference：# The Standard ML Basis Library]([http://sml-family.org/Basis/list.html](http://sml-family.org/Basis/list.html))
>Interface:
>  **val**  [@](http://sml-family.org/Basis/list.html#SIG:LIST.@:VAL)  **:**  _'a_ list *  _'a_ list **->**  _'a_ list

```
val x = [1,2] @ [3,4,5]; (* [1,2,3,4,5] *)
```
Accessing:
```ML
val x = [7,8,9];
null x; (* False *)
null []; (* True *)
hd x; (* 7 *)
tl x; (* [8, 9] *)
```

### List Functions

```ML
fun sum_list(xs : int list) =
    if null xs
    then 0
    else hd xs + sum_list(tl xs);

fun list_product(xs : int list) =
    if null xs
    then 1
    else hd xs * list_product(tl xs);

fun countdown(x : int) =
    if x = 0
    then []
    else x :: countdown(x - 1);

fun append (xs : int lisst, ys : int list) =
    if null xs
    then ys
    else (hd xs) :: append((tl xs), ys);

fun sum_pair_list(xs : (int * int) list) =
    if null xs
    then 0
    else #1 (hd xs) + #2 (hd xs) + sum_pair_list(tl xs);

fun firsts (xs : (int * int) list) =
    if null xs
    then []
    else (#1 (hd xs)) :: firsts(tl xs);

fun seconds (xs : (int * int) list) =
    if null xs
    then []
    else (#2 (hd xs)) :: seconds(tl xs);

fun sum_pair_list2 (xs : (int * int) list) =
    (sum_list(firsts xs)) + (sum_list(seconds xs));

```

Functions that make and us lists are almost always recursice becasue a list has an unknown length. To write a recursive function the thought process involves two steps:
* think about the _base case_	
* think about the _recursive case_

### Let Expressions

* Syntax: `let b1 b2 ... bn in e end`
    - Each `bi` is any binding an `e` is any expression
    
```ML
let val x = 1
in
    (let val x = 2 in x+1 end) + (let val y = x+2 in y+1 end)
end

fun countup_from1 (x:int) =
    let fun count (from:int) =
        if from=x
        then x::[]
        else from :: count(from+1)
    in
        count(1)
    end
```

### Options

An option value has either 0 or 1 thing: `None` is an option value carrying nothing whereas `SOME e` evaluates e to a value v and becomes the option carrying the one value v. The type of `NONE` is `'a option` and the type of `SOME e` is `t option` if e has type t.

We have:
* `isSome` which evaluates to false if its argument is NONE
* `valOf` to get the value carried by `SOME`(raising exception for `NONE`)

```ML
fun max1( xs : int list) =
    if null xs
    then NONE
    else
	let val tl_ans = max1(tl xs)
	in
	    if isSome tl_ans andalso valOf tl_ans > hd xs
	    then tl_ans
	    else SOME (hd xs)
	end;
```

## Some More Expressions

Boolean operations:
* `e1 andalso e2`
    - if result of e1 is false then false else result of e2
* `e1 orelse e2`
* `not e1`

**※Syntax `&&` and `||` don't exist in ML and `!` means something different.**

**※`andalso` and `orelse` are just keywords. `not` is a pre-defined function.**

Comparisons:
* `=` `<>` `>` `<` `>=` `<=`
    - `=` and `<>` can be used with any "equality type" but not with real

## Build New Types

To Create a compound type, there are really only three essential building blocks:

* **Each-of** : A compound type t describes values that contain each of values of type `t1` `t2` ... `tn`
* **One-of**: A compound type t describes values that contain a value of one of the types `t1` `t2` ... `tn`
* **Self-refenence**: A compound type t may refer to itself in its definition in order to describe recursive data structures like lists and trees.

### Records

Record types are "each-of" types where each component is a named field. The order of fields never matters.
```ML
val x = {bar = (1+2,true andalso true), foo = 3+4, baz = (false,9) }
#bar x (* (3, true) *)
```

Tupels are actually syntactic sugar for records. `#1 e`, `#2 e`, etc. mean: get the contents of the field named 1, 2, etc.
```ML
- val x = {1="a",2="b"};
val x = ("a","b") : string * string
- val y = {1="a", 3="b"};
val y = {1="a",3="b"} : {1:string, 3:string}
```


### Datatype bindings

```ML
datatype mytype = TwoInts of int*int
		                       | Str of string
                               | Pizza;
val a = Str "hi"; (* Str "hi" : mytype *)
val b = Str; (* fn : string -> mytype *)
val c = Pizza; (* Pizza : mytype *)
val d = TwoInts(1+2, 3+4); (* TwoInts (3,7) : mytype *)
val e = a; (* Str "hi" : mytype *)
```
The example above adds four things to the environment:
* A new type mytype that we can now use just like any other types
* Three constructors `TwoInts`, `Str`, `Pizza`

We can also create a type synonmy which is entirely interchangeable with the existing type.
```ML
type foo = int
(* we can write foo wherever we write int and vice-versa *)
```

## Case Expressions

To access to datatype values, we can use a case expression:
```ML
fun f (x : mytype) =
    case x of
	    Pizza => 3
      | Str s => 8
      | TwoInts(i1, i2) => i1 + i2;

f(Str("a")); (* val it = 8 : int *)
```
We separate the branches with the `|` character. Each branch has the form `p => e` where p is a pattern and e is an expression. Patterns are used to match against the result of evaluating the case's first expression. This is why evaluating a case-expression is called pattern-matching.

## Lists and Options are Datatypes too

`SOME` and `NONE` are actually constructors. So you can use them in a case like:
```ML
fun inc_or_zero intoption =
    case intoption of
	    NONE => 0
      | SOME i => i+1;
```

As for list, `[]` and `::` are also constructors. `::` is a little unusual because it is an infix operator so when in patterns:
```ML
fun sum_list xs =
    case xs of
	    [] => 0
      | x::xs' => x + sum_list xs';

fun append(xs, ys) =
    case xs of
	    [] => ys
      | x::xs' => x :: append(xs', ys);
```

## Pattern-matching

Val-bindings are actually using pattern-matching.
```ML
val (x, y, z) = (1,2,3);
(*
    val x = 1 : int
    val y = 2 : int
    val z = 3 : int
*)
```

When defining a function, we can also use pattern-matching
```ML
fun sum_triple (x, y, z) =
    x + y + z;
```
Actually, all functions in ML takes one tripple as an argument. There is no such thing as a mutli-argument function  or zero-argument function in ML.
The binding `fun () = e` is using the unit-pattern `()` to match against calls that pass the unit value `()`, which is the only value fo a pre-defined datatype `unit`.

The definition of patterns is recursive. We can use nested patterns instead of nested cae expressions.

We can use wildcard pattern `_` in patterns.
```ML
fun len xs =
    case xs of
	[] => 0
      | _::xs' => 1 + len xs';

```

### Function Patterns

In a function binding, we can use a syntactic sugar instead of using case expressions:

```ML
fun f p1 = e1
  | f p2 = e2
  ...
  | f pn = en
```

for example
```ML
fun append ([], ys) = ys
  | append (x::xs', ys) = x :: append(xs', ys);
```

## Exceptions

To create new kinds of exceptions we can use exception bindings.
```ML
exception MyUndesirableCondition;
exception MyOtherException of int * int;
```

Use `raise` to raise exceptions. Use `handle` to catch exceptions.
```ML
fun hd xs =
    case xs of
	[] => raise List.Empty
      | x::_ => x;

(* The type of maxlist will be int list * exn -> int *)
fun maxlist(xs, ex) =
    case xs of
	[] => raise ex
      | x::[] => x
      | x::xs' => Int.max(x, maxlist(xs', ex));

(* e1 handle ex => e2 *)
val y = maxlist([], MyUndesirableCondition)
	handle MyUndesirableCondition => 42;
```

## Tail Recursion

There is a situation in a recursive call called **tail call**:
>when f makes a recursive call to f, there is nothing more for the caller to do after the callee returns except return the callee's result.

Consider a sum function:
```ML
fun sum1 xs =
    case xs of
        [] => 0
      | i::xs' => i + sum1 xs'
```

When the function runs, it will keep a call stack
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTIyNjc0MjI5MywtMTg3ODM0NDI0NiwtMT
k1OTkyMDI3Myw2NDU4OTc1OTIsLTE0ODI1NzkyNDMsMTgwNDM1
MTE0MSwtMjA3NzI4Njk0MCw0OTE2MjM4NTEsLTEyOTk3MTkxNC
wtMTkxNzQwMjk1OCwxNjUyODI4NDYwLDI0NzM1ODcwNywtNzcy
ODY1NDM5LDIxODA1MDgwLDg2MTgxMjY1NCw1NjMwMjM5MzMsLT
EyNDMxOTUzNTgsLTEyODE5OTYxNjEsLTE4NTQ0MzU0OTUsMTQy
NjUxMTMxOV19
-->