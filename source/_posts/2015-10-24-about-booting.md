---
layout: post
title: 开机流程中的事儿
category: 技术
tags: [UEFI,GPT,BIOS,MBR]
keywords: UEFI,BIOS,开机引导
description: 
---

## 一些基本概念

### MBR分区表

>MBR - Master Boot Record 主引导记录/主引导扇区

MBR分区方案中硬盘的每个扇区通过32位二进制数逻辑块地址（LBA）来标识。计算机开机后访问硬盘时要先读取第一个扇区，这个扇区（通常有512bytes）储存着主引导记录MBR（446bytes）和分区表DPT（64bytes）。主引导记录中装有开机管理程序（boot loader），分区表中记录了磁盘分区情况。由于每一条分区记录需要16个字节，因此MBR分区结构只能支持4个主分区，想得到4个以上的分区需要采用扩展分区，注意扩展分区只能有一个，在windows系统中默认划分一个主分区给系统，其余的全部划入扩展分区。扩展分区可以划分出多个逻辑分区。
![img](/assets/img/images/2015-10-23-about-booting_1.png)

MBR的局限性在于，分区表大小固定，只能支持4个主分区，而且最大只能支持到2.2TB的分区容量。随着硬盘技术的发展，MBR分区方案有些撑不住了，再加上win8/8.1的催化，GPT分区表逐渐成为主流。

### GPT分区表

>GPT - GUID Partition Table 全局唯一标识分区表

有些硬盘厂商注意到了MBR分区方案的容量局限，就把容量较大的产品升级到了4KB的扇区，这样使得MBR可以支持最大到16TB,但同时带来了关于在有较大的块的设备从BIOS启动时，如何最佳的划分分区。GPT分区方案中LBA是64位2进制数，因此对于扇区为512bytes的硬盘，容量可以达到9.4ZB。。。
GPT表的最开头，有一块类似MBR的表头，称为PMBR，存有引导程序和一个特殊标识用来表示次硬盘使用GPT分区方式。接下来的LBA1是GPT的分区表头，记录了硬盘的可用空间和分区表项的大小和数目，还有备份分割的位置。GPT有34个LBA区块记录，从LBA2到LBA33每个区块都可以记录4条分区记录，每条记录都达到128bytes。

![img](/assets/img/images/2015-10-23-about-booting_2.png)

在一些MBR/GPT混合硬盘中，不同系统实现有些不一致，windows系统通常优先使用MBR。
再来一张windows的分区类型GUID
![img](/assets/img/images/2015-10-23-about-booting_3.png)

>__相关链接__
>[4K对齐](https://zh.wikipedia.org/wiki/4K%E5%AF%B9%E9%BD%90)

### BIOS

>BIOS - Basic Input/Output System 基本输入输出系统

BIOS是一种业界标准的固件接口，用于开机自检以及加载引导程序。BIOSB其实就是一个16位汇编代码，寄存器参数调用方式，静态链接，以及1MB以下内存固定编址形式的程序。现在的BIOS储存在主板上的只读储存器（EEPROM）或者是闪存（flash）中，可以更新也不怕断电了。

### CMOS

>CMOS - Complementary Metal Oxide Semiconductor 互补金属氧化物半导体 (-.-)

在计算机领域，CMOS就是一块重要的随机储存器（RAM），BIOS的所有信息都存在这里，最怕被抠电池。。

### EFI(UEFI)

>EFI - Extensible Firmware Interface 可扩展固件接口
>UEFI - Unified Extensible Firmware Interface 统一可扩展固件接口

UEFI是一种详细描述全新类型接口的标准，是适用于电脑的标准固件接口，旨在代替BIOS。UEFI通过C语言开发，拥有很多BIOS不具备的功能，比如图形化界面、多种多样的操作方式、允许植入硬件驱动程序（.efi）。

>__相关链接__
>[UEFI官方首页](http://www.uefi.org/)
>[“暗云”bootkit木马详细技术分析](http://drops.wooyun.org/binary/4788)


## 开机方式

BIOS并不支持GPT，目前主要的开机方式无非BIOS+MBR引导和UEFI+GPT引导

### BIOS+MBR

这种方式的流程大概为以下几步：
1. BIOS加电，初始化芯片组和存储器子系统，将自己解压到系统主存中，读取CMOS中的配置信息，跳转到自检程序对系统进行自检。
2. 根据CMOS中的储存设备读取顺序，BIOS将读取相应设备中的MBR，启动引导程序。此时BIOS的工作已经完成。
3. 引导程序接受控制权开始工作。

引导程序主要任务也不多，提供开机选单、载入核心档案和转交其他的boot loader。硬盘的每个分区都可以有一个开机磁区，boot loader除了可以安装在MBR中外也可以安装到开机磁区中。
假设一个采用MBR分区的硬盘装有Windows和Linux双系统，整个流程可以用下图表示：
![img](/assets/img/images/2015-10-23-about-booting_4.png)

>__安装Windows/Linux双系统最好先安装Windows的原因__
>
>* Linux在安装的时候，你可以选择将开机管​​理程式安装在MBR或各别分割槽的开机磁区， 而且Linux的loader可以手动设定选单(就是上图的M1, M2...)
>，所以你可以在Linux的boot loader里面加入Windows开机的选项；
>
>* Windows在安装的时候，他的安装程式会主动的覆盖掉MBR以及自己所在分割槽的开机磁区，你没有选择的机会， 而且他没有让我们自己选择选单的功能

### UEFI+GPT

UEFI主要是依靠载入各种驱动程序来完成系统自检等工作，读取GPT分区表，载入系统。这楼里又要介绍一个ESP分区的概念。

#### ESP分区

>ESP - EFI System partition

ESP分区是一个FAT格式的系统分区，在windows系统下是不可见的，独立于操作系统之外。当操作系统被引导之后就不会在使用这个分区。因此一些系统级的维护工具以及数据非常适合存放在这里，比如boot loader，驱动程序，系统备份等等，甚至可以安装一个特殊的操作系统（PE）。


开机时UEFI将先读取照硬盘的ESP分区，通过这个分区中的引导文件进行系统引导。

UEFI添加了一个新的安全启动机制（secure boot），这个机制会验证即将启动的系统，通过验证系统才可以正常启动。这个机制为了解决的是黑客常用的rootkit攻击手段，但是同时也导致一些系统（包括Linux）不能正常启动。因此有时可能会需要关闭这个功能。


