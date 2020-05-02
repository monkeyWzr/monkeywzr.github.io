---
title: ssh反向代理实现内网穿透（比较失败( ˙灬˙ )）
date: 2016-10-08 14:45:08
category: tech
tags:
    - ssh
    - 内网穿透
keywords:
    - ssh
    - 内网穿透
    - 反向代理
    - 端口暴露
---

有关背景请参见[http://www.upwzr.com/2016/10/08/run-ngrok/](http://www.upwzr.com/2016/10/08/run-ngrok/)，本文是在使用ngrok之前的依次失败的尝试。。。当然，ngrok实际上也是是ssh来实现的。

对于内网主机想要外网访问，最简单的办法当然是在路由器上做手脚，但是在不能操作路由设备的时候（比如说学校的内网网段），想要实现外网访问可通过ssh隧道实现。只需要一条很简单的命令：
```
ssh -N -f -R 80:127.0.0.1:8001 root@123.45.67.89
```
* -N 不执行远程命令
* -f 后台执行
* -R *remote_port:localhost:local_port* 远程端口转发
上面的命令就表示连接到123.45.67.89，将本地的8001端口转发到123.45.67.89的80端口。__公网主机的80端口转发必须使用root权限__，用root角色去连接公网主机。

<!-- more -->

### -g (GatewayPorts) option

先贴出一段鸟文：
>When you forward a TCP port (either locally or remotely), by default SSH only listens for connections to the forwarded port on the loopback address (localhost, 127.0.0.1). This means only other programs running on the same host as the listening side of the forwarding can connect to the forwarded port. This is a security feature, since there is no authentication applied to such connections. Also, such a forwarded connection is potentially insecure, since a portion of it is carried over the network in a plain TCP connection and not protected by SSH.

上面大概是在说，默认情况下远程转发端口只能绑定到到回环地址`127.0.0.1`上，这就是说内网主机的转发只能绑定到公网主机的本地地址上，只有公网本机才能访问，显然不是我们想要的。我们需要指定`-g`参数为yes，这样便可以绑定到公网主机的`0.0.0.0`（即本机的所有地址）。
打开`/etc/ssh/sshd_config`，加入如下参数：
```
GatewayPorts yes
```
重启ssh服务即可。

### 稳定性

基本上大家都在用autossh，或者sshpass配合脚本实现自动重连，这个我没有尝试。（因为半路转去用ngrok）。



以我这次的实战为例，用于代理的公网主机是腾讯云的vps，有公网ip一个123.45.67.89（伪），内网主机一台，需要转发的服务跑在8001端口。注意，__公网主机的80端口转发必须使用root权限__，形如上面的那一条指令，用root去连接公网主机。否则链接会建立失败。腾讯云现在貌似只能使用ubuntu角色连接ssh，改也改不了，所以我只能绑定到非80端口，这样地址就变成papapa.bulabula.xxx:xxxx，拖着端口在后面，感觉超级不爽，也就没去配置autssh这些东西，结果链接很容易就挂起，重连的时候公网主机还在监听这个端口，就建立不起链接。。。于是我干脆放弃了。。。

最后采用了这种办法：[http://www.upwzr.com/2016/10/08/run-ngrok/](http://www.upwzr.com/2016/10/08/run-ngrok/)

>相关链接：
>[SSH原理与运用（二）：远程操作与端口转发](http://www.ruanyifeng.com/blog/2011/12/ssh_port_forwarding.html)
>[ssh隧道反向代理实现内网到公网端口转发](http://www.netcan666.com/2016/09/28/ssh%E9%9A%A7%E9%81%93%E5%8F%8D%E5%90%91%E4%BB%A3%E7%90%86%E5%AE%9E%E7%8E%B0%E5%86%85%E7%BD%91%E5%88%B0%E5%85%AC%E7%BD%91%E7%AB%AF%E5%8F%A3%E8%BD%AC%E5%8F%91/)
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTE4ODI3NTY0NDksLTEzNTA2ODA4MThdfQ
==
-->