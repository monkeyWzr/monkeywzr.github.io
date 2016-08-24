---
layout: post
title: vps搭建私人pptp vpn,新姿势GET！
category: 技术
tags: [pptp,vpn,vps,科学上网]
keywords: pptp,vpn,vps,科学上网
description: 
---

一直用hosts和goagent的姿势搞学(ke)术(xue)研(shang)究(wang)，苦于两种方式限制颇多不稳定又不安全。不久前咬牙花了5刀开了DO的vps（当然，DO赠送了10刀回来），穷学生一枚的我终于能换换新姿势了，直接动手搭建了vpn。由于本人不太喜欢用额外的客户端，再加上pptp以简单著称，我决定采用pptp server。

## DigitalOcean购买VPS

在网上查了大家的经验攻略，自己看了下DO、搬瓦工、bugdetVM，最后还是选了DO，反正现在感觉速度很不错，挺满意的。

这个流程很简单，在官网上注册账号，用PayPal下个5刀的订单，DO会赠送10美元回来。Paypal支持银联的卡，我就是用建行的借记卡支付的。支付完成后按照流程创建Droplet，我用的ubuntu14.04 x64,旧金山的服务器，创建过程中添加SSH,用puttyputtygen即可。具体内容在下面相关链接。

## 安装pptp和配置

putty登陆，速度可以，直接开始安装。这期间我试了试DO网站上的console，感觉不好用。还是putty方便。

		# sudo apt-get update
		# sudo apt-get install pptpd

事实证明我朝GFW有多坑，服务器在美国的ubuntu从官方源下载速度炒鸡快，瞬间完事儿。

### 修改pptp配置

修改/etc/pptpd.cong文件

		# sudo nano /etc/pptpd.conf

在末尾添加server IP 和 client IP

		localip 192.168.0.1
		remoteip 192.168.0.100-200

这里用的是nano编辑器，不熟悉的同学（比如我）可以参见相关链接里面的“Linux下的Nano命令”。其实用不到啥。。就是一个保存和退出而已。。nano还是比较简单的。

### 修改DNS配置

		# sudo nano /etc/ppp/pptpd-options

添加google的DNS

		ms-dns 8.8.8.8
		ms-dns 8.8.4.4

这个文件里还开启了其他的一些选项，课根据需要开启我从别的大神那里复制来了一些资料：

>name pptpd（pptpd服务名，可以随便填写。）
>refuse-pap（拒绝pap身份认证模式。）
>refuse-chap（拒绝chap身份认证模式。）
>refuse-mschap（拒绝mschap身份认证模式。）
>require-mschap-v2（在端点进行连接握手时需要使用微软的 mschap-v2 进行自身验证。）
>require-mppe-128（MPPE 模块使用 128 位加密。）
>ms-dns 8.8.8.8 (ppp 为 Windows 客户端提供 DNS 服务器 IP 地址。)
>proxyarp (建立 ARP 代理键值。)
>nodefaultroute（不替换默认路由）
>debug（开启调试模式，相关信息记录在 /var/logs/message 中。现在默认是被注释掉的。）
>lock（锁定客户端 PTY 设备文件。）
>nobsdcomp (禁用 BSD 压缩模式。)


### 添加VPN用户

打开chap-secrets文件添加用户

		# sudo nano /etc/ppp/chap-secrets

第一行是文件里已经存在的注释

		# client        server  secret                  IP addresses
		username * myPassword *

第一段和第三段字符串就不用说了吧，第二段是服务器名称，默认的是pptpd，也就是上面pptpd-options的`name`选项的值。最后一段是登陆的ip，*即可。

到这里可以重启下pptpd

		# /etc/init.d/pptpd restart

### 设置路由转发

### 开启IPv4转发

打开sysctl.conf

		# sudo nano /etc/sysctl.conf

开启IPv4转发选项，即取消下面语句的注释

		net.ipv4.ip_forward=1

刷新下配置文件

		# sudo sysctl -p

### 设置iptables NAT转发和MTU

打开rc.local

		# sudo nano /etc/rc.local

把这两个配置添加到这里可以保证重启有效，否则重启系统之后iptables的配置会重置。注意要添加到`exit 0`上面

		iptables -t nat -A POSTROUTING -s 192.168.0.0/24 -o eth0 -j MASQUERADE
		iptables -A FORWARD -p tcp --syn -s 192.168.0.0/24 -j TCPMSS --set-mss 1356

第一句话设置NAT转发，我使用了192.168.0网段，这里要根据自己上面的配置修改。`eth0`就是vps的网卡，如果不确定可以用ifconfig确认。

第二句话设置MTU包大小，防止有较大包时发生数据丢失。

到现在所有的配置已经完成了。在自己电脑上连接上vpn，直接上油管测试，视频基本秒开。

好，接下来就用此姿势玩耍了，麻麻再也不用担心我的那啥了%_%


## 相关链接

>[ubuntu官网PPTPServer帮助](https://help.ubuntu.com/community/PPTPServer)
>[Linux下的nano命令](http://www.cnblogs.com/haichuan3000/articles/2125943.html)>