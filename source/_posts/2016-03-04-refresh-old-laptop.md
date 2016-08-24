---
layout: post
title: 超老本子CF-W2安装lubuntu
category: 技术
tags: CF-w2,Linux,Lubuntu
keywords: [CF-w2,Linux,Lubuntu]
description:
---

## 祭出大杀器CF-W2

前几年亲戚去日本出差给我老爸带回来一台二手本本，2003年左右的机器，质量确实过硬，没换过一个零件。。奔腾M 1GHz + 760MB内存，用xp勉强可以看个新闻玩玩同城游戏。到我手里后，实在是食之无味弃之可惜，索性装个linux敲代码好了。

## 老机器真蛋疼

轻量级的linux有不少，`lubuntu` `xubuntu` `PuppyLinux`这些都是很常见的了。`lubuntu`号称256M内存就能跑起来，`LXDE`也比puppy用的`JVM`好看一点（私人观点），那就先搞这个试试（15.04）。最开始做了个U盘启动盘，结果BIOS里死活读不出usb，只好又刻了个CD。
lubuntu在12.04开始需要cpu支持pae，幸运的是我这老古董貌似完全不支持，因此在进入到grub后光标移动到install lubuntu选项，F6然后esc，进入编辑，在最后面加入`forcepae`,最后大概是下面这样的：

    Boot Options file=/cdrom/preseed/ubuntu.seed boot=casper initrd=/casper/initrd.lz quiet splash -- forcepae

这么改完后可以正常启动安装。__安装过程语言最好选择English__，不然后面会出现乱码，完全辨认不出选项。

## 优化

### 显卡问题

除了开机有（chao）些（ji）慢，编译有（shi）些（fen）慢，总体上还是非常流畅的。不过每次开机后桌面壁纸会变成一坨颜色。在官方wiki上找到了应对老Intel显卡的处理办法。

    sudo vim /etc/X11/xorg.conf

添加如下语句：

    Section "Device"
        Identifier "Intel Graphics"
        Driver "intel"
        Option "AccelMethod" "uxa"
    EndSection

重启X，问题解决。

### 中文乱码

安装过程中如果选择中文会出现乱码，安装好之后的系统人类基本无法操作。不过update完了之后问题即可解决。建议用英文安装好，update完事再切换中文。

>相关链接
>[AdvancedMethods](https://wiki.ubuntu.com/Lubuntu/AdvancedMethods)

