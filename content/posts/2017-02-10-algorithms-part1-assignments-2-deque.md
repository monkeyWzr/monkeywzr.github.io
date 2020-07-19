---
title: Algorithms part1 programming assignments 2 - deque
date: 2017-02-10 18:33:59
category: notes
tags:
  - Algorithms
keywords:
  - Algorithms
  - 算法
  - deque
  - queues
  - stacks
---

这次作业内容是关于栈和队列的。要求为实现两种数据类型：`deque` 和 `randomized queues`。

### Deque

>Deque: A double-ended queue or deque (pronounced "deck") is a generalization of a stack and a queue that supports adding and removing items from either the front or the back of the data structure.

deque就是个双向队列，从两头都可以添加和删除。用链表实现起来比较方便。要求的api如下：

```Java
public class Deque<Item> implements Iterable<Item> {
   public Deque()                           // construct an empty deque
   public boolean isEmpty()                 // is the deque empty?
   public int size()                        // return the number of items on the deque
   public void addFirst(Item item)          // add the item to the front
   public void addLast(Item item)           // add the item to the end
   public Item removeFirst()                // remove and return the item from the front
   public Item removeLast()                 // remove and return the item from the end
   public Iterator<Item> iterator()         // return an iterator over items in order from front to end
   public static void main(String[] args)   // unit testing (optional)
}
```

题目要求每个deque的操作都必须是 O(1) 的时间复杂度，迭代器的操作也是 O(1) 的时间复杂度。包含n个元素的deque最多占用48n + 192 bytes。综合考虑采用双向链表比较合适。

### Randomized queue

>A randomized queue is similar to a stack or queue, except that the item removed is chosen uniformly at random from items in the data structure.

随机队列跟普通栈和队列基本一致，只是随机队列删除元素时是随机选取的元素。api如下：

```Java
public class RandomizedQueue<Item> implements Iterable<Item> {
   public RandomizedQueue()                 // construct an empty randomized queue
   public boolean isEmpty()                 // is the queue empty?
   public int size()                        // return the number of items on the queue
   public void enqueue(Item item)           // add the item
   public Item dequeue()                    // remove and return a random item
   public Item sample()                     // return (but do not remove) a random item
   public Iterator<Item> iterator()         // return an independent iterator over items in random order
   public static void main(String[] args)   // unit testing (optional)
}
```

题目要求每个操作的平均复杂度为 O(1) ，包含n个元素的随机队列最多占用48n + 192 bytes。迭代器的`next()`和`hasNext()`的时间复杂度为 O(1)，构造函数为 O(n)。由于有个随机操作，采用数组方式实现比较合适。

__两种数据结构的性能要求在下表里面做了总结：__

![img](/img/2017-02-12_performance_requirements.png)

### Permutation client

题目还要求实现一个客户端，要求为线性的时间复杂度。

代码：
[deque.java](https://github.com/monkeyWzr/algorithms/blame/master/deque/src/Deque.java)  [RandomizedQueue.java](https://github.com/monkeyWzr/algorithms/blob/master/deque/src/RandomizedQueue.java)
<!--stackedit_data:
eyJoaXN0b3J5IjpbNTMxNDU5Nzc4LC0xOTcyMDIyNzYwXX0=
-->