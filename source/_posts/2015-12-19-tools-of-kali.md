---
layout: post
title: Kali的一些工具
category: 学习笔记
tags: [Kali,渗透]
keywords: Kali,渗透
description: 
---

## 信息收集

### DNS信息

- host 查询/etc/resolv.conf中指定的DNS服务器 
- dig 可处理文件内的所有DNS指令
- dnsenum 可通过google搜素子域名；课使用字典对子域名进行暴力破解；
- dnsdict6 IPv6子域名枚举
- fierce 能对不连续的IP空间和主机名进行测试
- DMitry 具有DNS分析和路由分析功能，可进行简单端口探测
- Maltego 图形化综合工具

### 路由信息

- tcptraceroute 利用TCP SYN数据包进行路由信息探测
- tctrace -i<device> -h<targethost>

### 搜索引擎

- theharvester 通过多个公共资源搜集所需信息（Email、用户名、主机名等）
- Metagoofil 通过google搜索目标域的文件的元数据信息，kali2默认貌似没有安装

## 目标识别

### 识别主机

- ping 老朋友。。
- ping6 用来ping IPv6
- fping 可同时探测多个主机或者整个网段
- arping 使用ARP请求检测局域网内主机是否在线，IP或者MAC地址都可作为目标
- hping3 端口扫描、防火墙规则检测、IDS检测等，功能强大
- nping 支持多种协议探测模式；可做压力测试、ARP中毒、Dos攻击
- nbtscan 审计局域网内windows系统IP地址、NetBIOS信息等

### 识别操作系统

- p0f 被动方式探测目标主机
- nmap 神器之一

## 服务枚举

### 端口扫描

- nmap 端口扫描；主机探测；服务/版本检测；操作系统检测；网络路由跟踪；脚本引擎
    * -sT TCP连接扫描
    * -sS SYN扫描（半开连接扫描）
    * -sN NULL扫描（不设置任何控制位）
    * -sF FIN扫描
    * -sM TCP Maimom扫描，常用于探测BSD衍生出来的操作系统
    * -sA TCP ACK扫描，能检测防火墙，确定定被屏蔽端口
    * -sW TCP窗口扫描
    * -sI 通过僵尸主机发动扫描
    * --scanflags 自定义URG、ACK、PSH、RST、SYN、FIN、ECE、CWR、ALL和NONE组合
    * -sU UDP扫描
    * -sV 服务版识别
    * -O 识别操作系统
    * -p 指定端口或端口范围
    * -F 快速扫描，近扫描常用100个端口
    * -r 顺序扫描
    * -oN 正常输出
    * -oX 将结果生成为XML文件
    * -A 强力扫描，相当于 -sV -O -sC --traceroute
    * -sC 使用默认类的脚本进行扫描 相当于--script=default
    * --script 根据指定文件名、类别名、目录名执行相应脚本
    * -f 使用小数据包，避免目标IDS识别
    * --mtu 调整数据包大小，必须是8的倍数
    * -D 在侦测数据包中掺杂一些假源IP的数据包。
    * -g 模拟源端口
    * --data-length 改变数据包默认长度
    * --scan-delay 控制发送探测数据的时间间隔
- Unicornscna 扫描UDP端口性能卓越
- zenmap nmap的图形化扫描工具
- amap 检测指定端口上运行的应用程序信息

### SNMP枚举

>SNMP 简单网络管理协议，运行于161端口的应用层协议，用于网络设备运行状态的监控，
>SNMP协议有三个版本v1/v2/v3

- onesixytone 扫描设备是否支持某些特定SNMP字符串
- snmpcheck 差不多
- SNMP Walk 强大的SNMP信息采集工具，可以使用三个版本的协议

### VPN枚举

- ike-scan 探测IPSec VPN系统

## 漏洞映射

### 模糊分析

- BED 检测缓冲区溢出、格式化字符串漏洞、整数溢出、DoS条件等漏洞，支持多种协议
- JBroFuzz 模拟HTTP/HTTPS请求；XSS、SQl注入、缓冲区溢出、格式字符串错误等测试

### SMB分析

>SMB Server Message Block，又称为CIFS（Common Internet File System）协议，作用
>于应用层，常用于文件与打印机共享服务。NetBIOS是SMB协议的组成部分。DEC
>/RPC服务程序实现的网络节点间跨进程通信（IPC）也使用SMB协议。

- ImpacketSamrdump 列举同一局域网目标主机上所有系统共享、用户账户等信息

### 数据库评估

- sqlmap 又一个神器，详情看文档
- sqlninja 专门评估SQL Server的进阶工具，配置较复杂。

### Web应用程序评估

- Burp Suite 还是一神器，完整的攻击框架。
- Nikto2 支持跨平台部署、SSL、多种IDS规避技术
- Paros Proxy 主动/被动评估工具
- W3AF 识别、审计、攻击，有丰富的插件和exploits。
- wafw00f 检测防web防火墙（WAF）的脚本
- webscarab 集成了众多工具，OWASP Project之一，功能强大




