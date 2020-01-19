---
title: Algorithms part1 programming assignments 1 - Percolation
date: 2017-02-08 20:48:32
category: notes学习笔记
tags:
  - algorithms
keywords:
  - algorithms
  - 算法
  - percolation
  - union-find
  - 并查集
---

坚持看了很久的algorithms公开课，终于决定回过头来整理一下作业。。
这次作业解决的是渗滤系统的阈值问题。渗滤（percolation)是一个常见的物理系统，描述为：

>We model a percolation system using an n-by-n grid of sites. Each site is either open or blocked. A full site is an open site that can be connected to an open site in the top row via a chain of neighboring (left, right, up, down) open sites. We say the system percolates if there is a full site in the bottom row. In other words, a system percolates if we fill all open sites connected to the top row and that process fills some open site on the bottom row. (For the insulating/metallic materials example, the open sites correspond to metallic materials, so that a system that percolates has a metallic path from top to bottom, with full sites conducting. For the porous substance example, the open sites correspond to empty space through which water might flow, so that a system that percolates lets water fill open sites, flowing from top to bottom.)

使用一个n*n的网格描述渗滤系统。每个格子可以是开放的或者封闭的。若一个开放的格子跟顶边存在由开放的格子组成的通路，则这个格子是满的。系统渗滤表现为存在由开放的格子组成的连接顶和底两条边的通路（也可以说是底边存在满的格子）。如果每个格子开放的概率是p, 我们要解决的问题就是系统渗滤的概率是多少？

课程规定了包含如下api的数据类型：
```Java
public class Percolation {
   public Percolation(int n)                // create n-by-n grid, with all sites blocked
   public    void open(int row, int col)    // open site (row, col) if it is not open already
   public boolean isOpen(int row, int col)  // is site (row, col) open?
   public boolean isFull(int row, int col)  // is site (row, col) full?
   public     int numberOfOpenSites()       // number of open sites
   public boolean percolates()              // does the system percolate?

   public static void main(String[] args)   // test client (optional)
}
```

使用蒙特卡罗模拟的方式来估计阈值，思路如下：

* 初始化所有的格子为封闭状态。
* 重复以下步骤：直到系统渗滤：
  - 随机选取一个封闭的格子
  - 开放改格子
* 开放格子的比例即为系统渗滤的阈值。

模拟实验的数据模型如下：
```Java
public class PercolationStats {
   public PercolationStats(int n, int trials)    // perform trials independent experiments on an n-by-n grid
   public double mean()                          // sample mean of percolation threshold
   public double stddev()                        // sample standard deviation of percolation threshold
   public double confidenceLo()                  // low  endpoint of 95% confidence interval
   public double confidenceHi()                  // high endpoint of 95% confidence interval

   public static void main(String[] args)        // test client (described below)
}
```

通常的解决思路是在顶和底设置两个虚拟节点，顶行和底行开放的格子均分别与顶节点和底节点相连。因此系统渗滤也就是顶节点和底节点相连。
这种思路在实现过程中遇到的一个难点就是回洗（backwash）问题：只跟底边相连的开放格子也会被当作是满的，这个是unacceptable的。
![img](http://coursera.cs.princeton.edu/algs4/checklists/percolation-backwash.png)

我采用的思路是：使用两个数组分别标记每个__连通分量（components）__跟顶行和底行的连通状态，当开放一个格子时，分别更新两个数组。
这里关键要利用好普林斯顿提供的`WeightedQuickUnionUF`数据结构，尤其是其中的`union()`方法（连通两个相邻的开放格子）和`find()`方法（返回参数节点所在的component identifier）。最终在时间和空间上都达到了比较理想的状态。

具体代码放在了github上。[Percolation.java](https://github.com/monkeyWzr/algorithms/blame/master/percolation/src/Percolation.java)
[PercolationStats.java](https://github.com/monkeyWzr/algorithms/blame/master/percolation/src/PercolationStats.java)
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTE4MTQ2NDY4NzJdfQ==
-->