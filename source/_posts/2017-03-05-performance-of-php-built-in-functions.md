---
title: 有关php内建函数复杂度的一点探究
date: 2017-03-05 00:16:38
category: tech
tags:
    - php
keywords:
    - performance
    - 性能
    - 复杂度
    - php
---

在用php实现CtCI里面的习题时，算法中常常要用到`array_key_exists()`方法。然而通常在数组中检索的复杂度为`O(n)`，那么这是否会对php实现的算法产生比较大的影响呢？

在php的 [manual](http://php.net/manual/zh/function.array-key-exists.php) 中有人提到，`isset()`比`array_key_exists()`快的多，但是两者对null的处理方式是不一样的。

```php
<?php //test.php
$t['a'] = null;
if (isset($t['a']))
    echo "a is set\n";
else
    echo "a is not set\n";

if (array_key_exists('a', $t))
    echo "a exists\n";
else
    echo "a doesn't exists\n";

// 运行上面的代码，会输出：
// a is not set
// a exists
```

在开发中可以采用如下方法：
```php
if (isset(..) || array_key_exists(...))
{
...
}
```

大大提升了运行速度又保证了结果。

>Benchmark (100000 runs):
>array_key_exists() : 205 ms
>is_set() : 35ms
>isset() || array_key_exists() : 48ms

另外 [stackoverflow](http://stackoverflow.com/questions/2473989/list-of-big-o-for-php-functions) 上有人对`array_*`的复杂度做过一番调查：

<!-- more -->

* `array_key_exists()` O(n)但是非常接近O(1)。 - this is because of linear polling in collisions, but because the chance of collisions is very small, the coefficient is also very small. I find you treat hash lookups as O(1) to give a more realistic big-O. For example the different between N=1000 and N=100000 is only about 50% slow down.

* `isset()` O(n)但是非常接近O(1)。 - it uses the same lookup as array_key_exists. Since it's language construct, will cache the lookup if the key is hardcoded, resulting in speed up in cases where the same key is used repeatedly.
* `in_array()` O(n) - this is because it does a linear search though the array until it finds the value.

* `array_search()` O(n) - it uses the same core function as in_array but returns value.

* `array_push` O(∑ var_i, for all i)

* `array_pop()` O(1)

* `array_shift()` O(n) - it has to reindex all the keys

* `array_unshift()` O(n + ∑ var_i, for all i) - it has to reindex all the keys

* `array_intersect_key()` if intersection 100% do O(Max(param_i_size)*∑param_i_count, for all i), if intersection 0% intersect O(∑param_i_size, for all i)

* `array_intersect()` if intersection 100% do O(n^2*∑param_i_count, for all i), if intersection 0% intersect O(n^2)

* `array_intersect_assoc()` if intersection 100% do O(Max(param_i_size)*∑param_i_count, for all i), if intersection 0% intersect O(∑param_i_size, for all i)

* `array_diff()` O(π param_i_size, for all i) - That's product of all the param_sizes

* `array_diff_key()` O(∑ param_i_size, for i != 1) - this is because we don't need to iterate over the first array.

* `array_merge()` O( ∑ array_i, i != 1 ) - doesn't need to iterate over the first array

* `+ (union)` O(n), where n is size of the 2nd array (ie array_first + array_second) - less overhead than array_merge since it doesn't have to renumber

* `array_replace()` O( ∑ array_i, for all i )

* `shuffle()` O(n)

* `array_rand()` O(n) - Requires a linear poll.

* `array_fill()` O(n)

* `array_fill_keys()` O(n)

* `range()` O(n)

* `array_splice()` O(offset + length)

* `array_slice()` O(offset + length) or O(n) if length = NULL

* `array_keys()` O(n)

* `array_values()` O(n)

* `array_reverse()` O(n)

* `array_pad()` O(pad_size)

* `array_flip()` O(n)

* `array_sum()` O(n)

* `array_product()` O(n)

* `array_reduce()` O(n)

* `array_filter()` O(n)

* `array_map()` O(n)

* `array_chunk()` O(n)

* `array_combine()` O(n)

很佩服原文作者的探究精神，文章很值得仔细读一读。链接附在下面。

### 参考链接

>[List of Big-O for PHP functions](http://stackoverflow.com/questions/2473989/list-of-big-o-for-php-functions)
>[array_key_exists - User Contributed Notes ](http://php.net/manual/zh/function.array-key-exists.php#107786)
