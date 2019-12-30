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

ML supportstuplesby allowing any number of parts. Pairs and tuples can be nested however you want.

```ML
val x = (3, (4, (5,6))); (* int * (int * (int * int)) *)
val y = (#2 x, (#1 x, #2 (#2 x))); (* (int * (int * int)) * (int * (int * int)) *)
val ans = (#2 y, 4); (* (int * (int * int)) * int *)
```
