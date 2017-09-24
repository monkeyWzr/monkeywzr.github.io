---
layout: post
title: 基本的bash shell命令
category: 学习笔记
tags: [linux]
keywords: linux,bash,shell
description:
---

## 基本的bash shell命令

### 处理文件和目录

* `ls` 输出目录
    - -s 显示文件大小
    - -a 输出隐藏文件
    - -i 显示文件的索引值
    - -l 产生长列表的输出
    - -R 递归列出子目录内容
* `touch` 创建新文件或者改变访问/修改时间
    - -a 只改变访问时间
    - -m 只改变修改时间
    - -t 指定时间戳
* `cp` 复制文件
    - -f 强制覆盖不提示
    - -i 覆盖前提示
    - -r 递归的复制文件
    - -R 递归的复制目录
    - -l 创建文件链接（硬链接）
    - -s 创建符号链接（软连接）
    - -v 详细模式
* `mv` 移动文件（重命名）
* `rm` 删除文件
    - -i 删除前提示
    - -f 强制删除不提示
    - -r 递归删除非空目录
* `mkdir` 创建目录
* `stat` 提供文件的所有状态信息
* `file` 查看文件类型
* `cat` 显示文本数据
    - -n 给所有行加上行号
    - -b 给有文本的行加上行号
    - -s 多个空白行压缩为一行
    - -T 用^I替换制表符
* `more` 分页显示
    - 空格 显示下一屏
    - ENTER 显示下一行
    - /expression 查找
    - n 查找下一处匹配的内容
    - ' 调到匹配的第一处内容
    - !cmd 执行shell
    - v 在当前行启动vi
    - = 显示当前行号
    - . 执行前一条命令
* `sort` 读文本文件中的数据行排序
    - -n 数字识别为数字
    - -M 按月排序（常用于日志文件）
    - -r 反序
    - -b 忽略起始的空白
    - -t 指定字段分隔符
    - -k 指定排序字段
* `tail` 显示文件末尾的内容
    - -c *bytes* 显示文件最后的bytes字节的内容
    - -n *lines* 显示文件最后的lines行
    - -f 保持活动，有新内容添加到末尾就显示
    - -s sec 与-f一起，每次输出前休眠sec秒ps
    - -v 显示带文件名的头
    - -q 从不显示带文件名的头
* `head` 显示文件开头的内容，类似tail
* `grep` *[option] pattern [file]* 查找文件中大的一行数据
    - -v 输出不匹配的行
    - -n 显示匹配行的行号
    - -c 输出匹配的行数
    - -e 指定多个匹配字符串（满足任意一个），通常用正则表达式替代
    - -i 忽略大小写
* `tr` 替换或删除文件或文本中的字符
* `egrep` 支持POSIX扩展正则表达式
* `tar` *function [options] obj1 obj2* 归档
    - -A 将一个tar文件追加到另一个tar文件
    - -c 创建新的tar归档文件
    - -r 追加文件到tar文件末尾
    - -x 从tar文件中提取文件
    - -C 切换到指定目录
    - -f 输出结果到文件或设备
    - -j 将输出重定向为bzip2
    - -z 将输出重定向给gzip
    - -p保留所有文件权限
    - -v 处理文件时显示文件

<!-- more -->

实例：

        //解压.tgz
        tar -zxvf filename.tgz

* `ln` *option source_file dist_file*
	- -b 覆盖已有的链接
	- -f 强制执行
	- -i 交互模式，提示是否覆盖等
	- -n 把符号链接视为一般目录
	- -s 软链接（即符号链接）
	- -v 显示详细过程

### 进程和设备管理

* `ps` 检测进程
    - -A 显示所有进程
    - -e 显示所有进程
    - -p *pidlist* 显示指定pid的进程
    - -f 显示完整格式的输出
    - -F 显示更多额外输出（相对-f而言）
    - -l 显示长列表
    - -L 显示进程中的线程
    - -H 用层级格式显示进程
    - --forest 图表形式显示层级信息
* `top` 实时显示进程信息，__很有用__，详见man
* `pgrep` *pattern* 获取进程id
* `kill` *pid* 结束进程（默认发送TERM信号）
    - -s *signal* 发送其他信号
* `killall` *name* 通过进程名结束进程
* `mount` 挂载媒体设备，详见man
实例：

        //挂载iso文件
        mount -t iso9660 -o loop file_name.iso /path/to/

* `unmonut` 卸载设备
    >当提示设备繁忙无法卸载设备时可使用`lsof`命令获得使用它的进程信息
* `df` 查看已挂载磁盘的使用情况
    - -h human-readable
* `du` 显示当前目录下所有文件、目录、子目录占用的磁盘块数
    - -c 显示所有已列出文件的总大小
    - -h human-readable
    - -s 显示每个输出参数的总计

### 系统和权限

* `set` 显示进程的所有环境变量
* `export` *var* 将局部变量导出为全局变量
* `unset` *var* 删除环境变量
* `alias` 设置命令别名
    - -p 显示已有的别名列表
实例：

        //定义命令别名
        alias li='ls -il'

* `useradd` 创建用户
    - -c *comment* 添加备注
    - -d *home_dir* 为主目录指定一个名字（默认即home）
    - -D *YYYY-MM-DD* 显示设置用户的系统默认值
    - -g *initial_group* 指定用户登录组的GID或组名
    - -G *group* 指定除登录组外的附加组
    - -k 与-m一起使用，将/etc/skel目录的内容复制到HOME目录，（bash shell的标准启动文件）
    - -m 创建HOME目录
    - -r 创建系统用户
    - -p *passwd* 指定默认密码
    - -s *shell* 指定默认登录shell
    - -u *uid* 为账户指定唯一的uid
* `userdel` 删除用户（默认只删除/etc/passwd文件中的用户信息）
    -  -r 删除HOME目录和mail目录
* `usermod` 修改用户信息，参数与useradd基本相同
    - -l 修改用户登录名
    - -L 锁定账户，无法登录
    - -p 修改账户密码
    - -U 解除锁定
    - -G _groupname username_ 将用户添加至组
* `groupadd` 添加新组
* `umask` 设置默认权限（掩码）
* `chmod` 设置文件和目录权限
    - +r 添加读取权限
    - +w 写入权限
    - +x 执行权限
* `chown` _optoins owner[.group] filename_ 改变文件的属主
    - -h 改变文件的所有符号连接的所属关系
    - -R 递归
* `chgrp` 改变文件或目录的默认属组

## 脚本实战

>shell脚本常见以`#!`开头，这玩意叫做·`shebang`

### 终端打印

echo是用于终端打印的基本命令。默认情况下每次调用echo后都会添加一个换行符。
常用参数：
* -e 识别转义序列
* -n 不追加换行符

使用转义序列生成彩色输出：

        #红色文本
        echo -e "this is \e[1;31m red text \e[0m"
        #绿色背景
        echo -e "this is \e[1;42m green background \e[0m""

文本颜色：重置=0；黑色=30；红色=31；绿色=32；黄色=33；蓝色=34；洋红=35；青色=36；白色=37；
背景颜色：重置=0；黑色=40；红色=41；绿色=42；黄色=43；蓝色=44；洋红=45；青色=46；白色=47；

### 变量和环境变量

获取某个进程运行时的环境变量：

        # $PID为摸个进程的id，可用pgrep命令获取
        cat /proc/$PID/environ

为变量赋值时使用`var=value`的格式，而不是`var = value`，后者是相等操作。另外，如果value包含空格，则应使用引号将value括起。

添加环境变量：

        export PATH="$PATH:/path/to/sp"

获取字符串长度：

        echo ${#var}

获取当前使用的shell：

        echo $SHELL #/bin/bash
        echo $0 #-bash

一种shell参数扩展形式：

        ${paramater:+expression} #若paramater有值且不为空则使用expression的值

### 数学运算

几种整数运算的格式：

        no1=2;
        no2=3;
        let result=no1+no2
        result=$[$no1+$no2] #变量前可以不加$
        result=$(($no1+$no2)) #变量前可以不加$

还可以使用bc工具进行更高级的运算。

        echo "sqrt(250)" | bc #开方

### 设置别名

`alias`的作用只是暂时的，关闭当前终端后定义的别名将失效。可将定义放在`.bashrc`中。例如：

        echo 'alias rm="cp $@ ~/backup && rm $@"' >> ~/.bashrc

上面的指令为rm创建了一个别名，原有的rm将被这个新rm替换。
若想不使用别名而使用原本的命令，可用`\`进行转义。如：

        \rm

就是使用原本的rm指令而不是自己定义的别名。

###
