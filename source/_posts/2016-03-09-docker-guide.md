---
layout: post
title: docker基础简记
category: 学习笔记
tags: [docker,基础,命令,原理]
keywords: docker,基础,命令,原理
description:
---

## Docker是什么

>Docker allows you to package an application with all of its dependencies into a standardized unit for software development.
            *----[What is Docker?](https://www.docker.com/what-docker#/copy1)*

Docker是近几年兴起的发展非常快速的开源项目，可用来创建非常轻量的“虚拟机”。在这里重要的两个概念是 __镜像__ 和 __容器__ 。



## docker命令简记

* `run` 启动
    - -t 在容器内指定一个终端
    - -i 允许对容器内的STDIN进行交互
    - -d 在容器内已后台进程模式运行
    - -P 将容器内部使用的网络端口随机映射到主机高端口上
    - -p 指定要绑定的端口，具体用法见文档
    - -e _KEY=value_ 设置环境变量
    - --name _container\_name_ 为容器命名
    - --rm 创建临时容器，停止后删除
* `ps` 查看正在运行的容器
    - -l 显示最后启动容器的详细信息
    - -a 显示所有容器，包括已经停止的
* `logs` _container\_name_ 查看容器内的标准输出
    - -f 保持活动状态，动态显示新添加的信息
* `stop` 停止正在工作的容器
* `version` 返回Docker 客户端和进程的版本信息
* `port` _container\_name_
* `top` 查看容器内部运行的进程
* `inspect` 查看容器的底层信息（配置和状态），JSON格式
    - -f '_{{ obj.child }}'_ 显示指定的信息
* `search` 搜索镜像
* `tag` 为镜像添加标签

