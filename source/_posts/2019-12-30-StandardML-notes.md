---
title: Standard ML notes
tags:
    - SML
category: 技术
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
val x = "hello\n"; 
val y = "hello " ^ ""
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
* `valOf` to get the value carried by `SOME`

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

### Some More Expressions

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
<!--stackedit_data:
eyJoaXN0b3J5IjpbMjExNTEwNTY2NiwxNDI2NTExMzE5LC03MD
c2NzgzMDddfQ==
-->