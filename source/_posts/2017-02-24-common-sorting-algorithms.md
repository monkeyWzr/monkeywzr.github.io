---
title: 常用算法总结
date: 2017-02-24 19:47:40
category: notes
tags:
    - Algorithms
keywords:
    - 算法
    - Algorithms
    - 排序
    - 查找
---

>基于比较的排序算法的最优性能是`O(n log n)`

文中代码通用的两个方法：
```java
private static boolean less(Comparable v, Comparable w)
{
    return v.compareTo(w) < 0;
}

private static void exch(Comparable[] a, int i, int j)
{
    Comparable swap = a[i];
    a[i] = a[j];
    a[j] = swap;
}
```


## 插入排序

* Time Complexity: `O(n ^ 2)` 最好情况`O(n)`
* 稳定
* in place

```java
public class Insertion
{
    public static void sort(Comparable[] a)
    {
        int N = a.length;
        for (int i = 0; i < N; i++)
            for (int j = i; j > 0; j--)
                if (a[j] < a[j - 1]) {
                    exch(a, j, j-1);
                }
                else
                    break;
    }
}
```

## 选择排序

* Time Complexity: `O(n ^ 2)`
* 不稳定
* in place

```java
public class Selection
{
    public static void sort(Comparable[] a)
    {
        int N = a.length;
        for (int i = 0; i < n; i++)
        {
            int min = i;
            for (int j = i + 1; j < N; j++)
                if (a[j] < a[min])
                    min = j;
            exch(a, i, min);
        }
    }
}
```

## 希尔排序

* Time Complexity: `O(n)`
* not stable
* in palce

```java
public class shell
{
    public static void sort(Comparable[] a)
    {
        int N = a.length;

        int h = 1;
        while (h < N/3)
            h = 3*h + 1;

        while (h >= 1)
        {
            for (int i = h; i < N; i++)
            {
                for (int j = i; j >= h && less(a[j], a[j-h]); j-=h)
                    exch(a, j , j-h);
            }

            h = h/3;
        }
    }
}
```

## 快速排序

* Time Complexity: `O(n log n)` 最坏情况`O(n ^ 2)`
* 不稳定
* in place

```java
public class Quick
{
    private static int partition(Comparable[] a, int lo, int hi)
    {
        int i = lo, j = hi + 1;
        while (true)
        {
            while(less(a[++i], a[lo]))
                if (i == hi) break;
            while(less(a[lo], a[--j]))
                if (j == lo) break;

            if (i >= j) break;
            exch(a, i, j);
        }

        exch(a, lo, j);
        return j; //return index of item new known to be in place
    }

    public static void sort(Comparable[] a, int lo, int hi)
    {
        StdRandom.shuffle(a); // for performance guarantee against worst case
        sort(a, 0, a.length - 1);
    }

    private static void sort(Comparable[] a, int lo, int hi)
    {
        if (hi <= lo) return;
        int j = partition(a, lo, hi);
        sort(a, lo, j-1);
        sort(a, j+1, hi);
    }
}
```

## 归并排序

* Time Complexity: `O(n log n)`
* 稳定
* not in place, need extra space

```java
public class Merge
{

    public static void sort(Comparable[] a)
    {
        Comparable[] aux = new Comparable[a.length];
        sort(a, aux, 0, a.length - 1);
    }

    private static void sort(Comparable[] a, Comparable[] aux, int lo, int hi)
    {
        if (hi <= lo) return;
        int mid = (lo + hi) / 2;
        sort(a, aux, lo, mid);
        sort(a, aux, mid+1, hi);
        merge(a, aux, lo, mid, hi);
    }

    private static void merge(Comparable[] a, Comparable[] aux, int lo, int mid, int hi)
    {
        for (int k = lo; k <= hi; k++)
            aux[k]= a[k];

        int i = lo; j = mid + 1;
        for (int k = lo; k <= hi; k++)
        {
            // if i is already greater than mid, that means the rest elements
            // is already in the final place
            if (i > mid)
                a[k] = aux[j++];
            else if (j > hi) // the same as above
                a[k] = aux[i++];
            else if (less(aux[j], aux[i]))
                a[k] = aux[j++];
            else
                a[k] = aux[i++];
        }
    }
}
```

## 基数排序

基数排序的思路很简单，是根据每一位上的数字对数据进行分组排序，最终合并。

* Time Complexity: `O(kn)` k是数据中最大数的位数
* 不稳定
* not in place

## 堆排序

* Time Complexity: `O(n log n)`
* not stable
* in place

```java
public class Heap
{
    public static void sort(Comparable[] a)
    {
        int N = a.length;
        for (int k = N/2; k >= 1; k--)
            sink(a, k, N);
        while (N > 1)
        {
            exch(a, 1, N);
            sink(a, 1, --N);
        }
    }

    private static void sink(Comparable[] a, int k, int N)
    {
        while (2*k <= N)
        {
            int j = 2*k;
            if (j < N && less(j, j+1))
                j++;
            if (!less(k, j))
                break;
            exch(a, k, j);
            k = j;
        }
    }
}
```


<!--stackedit_data:
eyJoaXN0b3J5IjpbNjAxNjgxNDIwLDQ2OTE2MDI5MF19
-->