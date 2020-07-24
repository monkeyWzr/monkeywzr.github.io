---
title: tcp拥塞控制算法总结（含BBR）
date: 2017-05-02 15:38:54
categories: notes
tags:
    - tcp
keywords:
    - tcp
    - 计算机网络
    - computing networking
    - BBR
---

## Tahoe

Tahoe是早期包含在 BCD 4.2 中的一个TCP早期版本。它在连接之初处于慢启动阶段。若遇到丢包事件，无论是超时还是快速重传，都会无条件将cwnd减为1个MSS，重新开始慢启动阶段，将ssthresh减为当前拥塞窗口的一半。对于有较大BDP（带宽延迟积）的链路来说，该方法会使得带宽利用率低下。


## Vaegas

Vegas算法试图在维持较好吞吐量的同时避免拥塞。它通过观察RTT来预测网络拥塞。当RTT增大时，Vegas认为网络正在发生拥塞，于是线性降低发送速率。利用RTT判断拥塞使得Vegas算法有较高的效率，但也导致采用Vegas的连接有较差的带宽竞争力。

## Reno & NewReno

Reno算法相当于是Tahoe算法的改进。它综合了快速恢复机制，当检测到快速重传时，Reno算法将cwnd减为当前窗口的一半加上3MSS，并将ssthresh设置为当前窗口的一半，然后cwnd进入线性增长。Reno算法存在的问题是它不能有效解决同一窗口丢失多个分组的情况（局部ACK），可能会严重影响网络吞吐性能。NewReno算法对这一问题进行了改进。它记录了上一个数据传输窗口的最高序列号（ACK恢复点），当结束到的ACK序列号不小于恢复点序列号时才会停止快速恢复阶段。NewReno是目前比较常用的一个TCP版本。

## BIC-TCP

BIC-TCP算法的主要目的在于，即使在拥塞窗口非常大的情况下也能满足线性RTT公平性。使用二分 __搜索增大__ 和 __加法增大__ 两种算法探测饱和点，通过 __最大值探测__ 机制实现。Linux 2.6.8 至 2.6.17 内核版本中默认开启该算法。

## CUBIC

CUBIC算法改进了BIC-TCP算法中在某些情况下（低速网络）增长过快的不足，并对窗口增长机制进行了简化。它通过一个三次函数来控制窗口的增长。除此之外CUBIC还有 `TCP友好` 策略，确保在低速网络中CUBIC的友好性。从Linux 2.6.18 内核版本开始CUBIC成为了Linux默认的TCP拥塞控制算法。

## BBR

BBR是goole在2016年下半年公开的一种开源拥塞控制算法，已经包含在了Linux 4.9 内核版本中。采用丢包作为拥塞信号的代价就是，在有一定错误丢包率的链路上，标准拥塞控制算法通常会收敛到一个比较小的发送窗口上，并没有占满网络带宽。BBR不再关注丢包作为拥塞信号，而是通过交替测量带宽和延迟，用一段时间内的带宽极大值和延迟极小值作为估计值的乘积作为窗口估计值，因此BBR可以更充分的利用带宽。目前对BBR的评价有褒有贬，有人说时黑科技，有人说其抢占带宽不道德，有人说这是TCP发展的一大进步也是拥塞控制的未来发展方向，还有人说大范围部署BBR将是一场灾难。。。我对TCP/IP的学习还很皮毛，就不贸然站队了。不过我在境外vps上部署了BBR之后，跑在vps上的ss速度提升非常显著，个人来讲还是很喜欢的:).

> 相关链接
> [BBR: Congestion-Based Congestion Control](http://queue.acm.org/detail.cfm?id=3022184)
> [https://www.zhihu.com/question/53559433](https://www.zhihu.com/question/53559433)
> [http://www.cqvip.com/read/read.aspx?id=23783845#](http://www.cqvip.com/read/read.aspx?id=23783845#)
<!--stackedit_data:
eyJoaXN0b3J5IjpbMTMxNDUxMzA4LDIwMjE0NTkzNTBdfQ==
-->