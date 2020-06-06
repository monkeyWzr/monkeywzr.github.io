---
title: Algorithms - String Sorts
tags:
    - Algorithms
category: notes
keywords:
    - Algorithms
    - String
    - radix sort
mathjax: true
---

## Key-indexed counting

Sort an array a[] of N integers between 0 and R-1.
```Java
int N = a.length;
// the temp array during sorting
int[] aux = new int[N];
// the index of count[] is the integer
int[] count = new int[R+1];

// count frequencies of N integers
// offset by one(a[0] = 0)
for (int i = 0; i < N; i++) {
    count[a[i]+1]++;
}

// compute frequency cumulates which specify destinations
// (how many intgers < the integer r)
for (int r = 0; r < R; R++) {
    count[r+1] += count[r];
}

// access cumulates using key as index to move items
for (int i = 0; i < N; i++) {
    aux[count[a[i]]++] = a[i];
}

// copy back
for (int i = 0; i < N; i++) {
    a[i] = aux[i];
}
```

* Key-indexed counting is **stable**.

## Least-significant-digit-first(LSD) String Radix Sort

* consider characters from right to left
* stably sort using $d^th$ character as the key (using key-indexed counting)

```Java
public class LSD {
    // fixed-length W strings
    public static void sort(String[] a, int w) {
        int R = 256;
        int N = a.length;
        String[] aux = new String[N];

        for (int d = W-1; d >= 0; d--) {
            int[] count = new int[R+1];
            // key-indexed counting
        }
    }
}
```

Application: Sort one million 32-bit integers.

## Most-significant-digit-first(MSD) String Radix Sort

* partition array into R pieces according to first character (use key-indexed counting)
* Recursively sort all strings that start with each character (key-index counting)

```Java
public static void sort(String[] a) {
    // can recycle aux
    String[] aux = new String[a.length];
    sort(a, 0, a.length-1, 0, aux);
}

// sort from a[lo] to a[hi], starting at the dth character
private static void sort(String[] a, int lo, int hi, int d, String[] aux) {
    if (hi <= lo) return;
    // can not recycle count
    int[] count = new int[R+2];
    // compute frequency counts
    for (int i = lo; i <= hi; i++) {
        count[charAt(a[i], d) + 2]++;
    }
    // compute frequency cumulates to transform counts to indicies
    for (int r = 0; r < R; R++) {
        count[r+1] += count[r];
    }
    // access cumulates using key as index to move items
    for (int i = lo; i < hi; i++) {
        aux[count[charAt(a[i], d)+1]++] = a[i];
    }

    // copy back
    for (int i = lo; i < hi; i++) {
        a[i] = aux[i - lo];
    }

    // recursively sort R subarrays for each character
    for (int r = 0; r < R; r++) {
        sort(a, lo + count[r], lo + count[r+1] -1, d + 1, aux);
    }
}
private static int charAt(String s, int d) {
    if (d < s.length()) {
        return s.charAt(d);
    } else {
        return -1;
    }
}
```

Observations:
* Much too slow for small subarrays.
* Huge number of small subarrays (because of recursion).

Solution: **Cutoff to insertion sort for small subarrays**.

```Java

private static final int CUTOFF        =  15;   // cutoff to insertion sort
// sort from a[lo] to a[hi], starting at the dth character
private static void sort(String[] a, int lo, int hi, int d, String[] aux) {
    // cutoff to insertion sort for small subarrays
    if (hi <= lo + CUTOFF) {
        for (int i = lo; i <= hi; i++) {
            for (int j = i; j > lo && less(a[j],  a[j-1], d); j--) {
                // exchange a[i] and a[j-1]
                exch(a, j ,j-1);
            }
        }
        return;
    }
    // ...
}

// is v less than w, starting at character d
private static boolean less(String v, String w, int d) {
    for (int i = d; i < Math.min(v.length(), w.length()); i++) {
        if (v.charAt(i) < w.charAt(i)) return true;
        if (v.charAt(i) > w.charAt(i)) return false;
    }
    return v.length() < w.length();
}
```

## 3-way Radix QuickSort

Disadvantages of MSD string sort
* Extra space for aux[]
* Extra space for count[]
* Inner loop has a lot of instructions
* Accesses memory randomly (cache inefficient)

Disadvantages of standard quicksort:
* Linearithmic number of string compares (not linear)
* Has to rescan many characters in keys with long prefix matches.

3-way string quicksort does 3-way partitioning on the $d^th$ character.
* Less overhead than R-way partitioning in MSD string sort
* Does not re-examine characters equal to the partitioning char (but does re-examine characters not equal to the partitioning char).
* ~$2N\ln{N}$ character comparions on average for random strings
* Avoid re-comparing long common prefixes

```Java
public static void sort(String[] a) {
    sort(a, 0, a.length - 1, 0);
}

private static void sort(String[] a, int lo, int hi, int d) {
    if (hi <= lo) return;

    int lt =lo, gt = hi;
    int v = charAt(a[lo], d);
    int i = lo + 1;
    while (i <= gt) {
        int t = charAt(a[i], d);
        if (t < v) exch(a, lt++)
        else if (t > v) exch(a, i, gt--)
        else i++;
    }

    sort(a, lo, lt-1, d);
    // v is the char at position d, so if v < 0, that's the end of the string a[lo]
    if (v >= 0) sort (a, lt, gt, d+1);
    sort(a, gt+1, hi, d);
}
```

## Manber-Myers MSD algorithm

* Phase 0; sort on first character using key-indexed counting sort
* Phase i: given array of suffixes sorted on first $2^{i-1}$ characters, create array of suffixes sorted on first $2^i$ characters.

TODO: implementation

## Which algorithm to use

TODO: Textbook Pg.724 performance characteristics of string-sorting algorithms