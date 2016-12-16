layout: post
title: 简记oath2.0
category: 学习笔记
tags: [oauth2]
keywords: oauth2
description:
---

## 简介

OAuth2就是第三方应用获取授权的一套开放网络标准。它在客户端和服务端提供了一层中间授权层，客户端提供登录信息给授权层，登录成功后会拿到一张自己的通行令牌（token），客户端凭借此令牌别可以得到相行的服务端访问权限。

### 授权流程

![img](/img/2016-04-13-understanding-oauth2_1.png)

<!-- more -->

* 客户端向用户提示授权
* 用户同意授权，向客户端提供授权许可（grant）
* 客户端向认证服务器发送认证请求，请求中包含用户提供的授权许可
* 认证成功后认证服务器向客户端发放令牌（token）
* 客户端使用令牌向服务器端请求资源
* 资源服务器验证令牌有效，答复请求

## 授权许可方式

在用户向客户端提供授权许可这一环节，OAuth2定义了四种类型：授权码模式（authorization code）、简化模式（implicit）、密码模式（resource owner password credentials）、客户端模式（client credentials）。

### 授权码（authorization code）

这种模式中，客户端将用户引导到授权服务器上，用户同意授权后授权服务器将会令用户重定向至客户端指定的回调地址，并带有授权码。客户端收到授权码后便会自行请求认证服务器，认证服务器核对无误即会返回给客户端访问令牌和更新令牌。整个流程中用户实际上只是跟认证服务器提交了认证，并未与客户端分享任何登录信息。

### 简化模式（implicit）

（懒得简化了，先贴出来放在这=。=）
The implicit grant is a simplified authorization code flow optimized
for clients implemented in a browser using a scripting language such
as JavaScript.  In the implicit flow, instead of issuing the client
an authorization code, the client is issued an access token directly
(as the result of the resource owner authorization).  The grant type
is implicit, as no intermediate credentials (such as an authorization
code) are issued (and later used to obtain an access token).
When issuing an access token during the implicit grant flow, the
authorization server does not authenticate the client.  In some
cases, the client identity can be verified via the redirection URI
used to deliver the access token to the client.  The access token may
be exposed to the resource owner or other applications with access to
the resource owner's user-agent.
Implicit grants improve the responsiveness and efficiency of some
clients (such as a client implemented as an in-browser application),
since it reduces the number of round trips required to obtain an
access token.  However, this convenience should be weighed against
the security implications of using implicit grants, such as those
described in Sections 10.3 and 10.16, especially when the
authorization code grant type is available.

### 密码凭证（resource owner password credentials）

这种授权模式适用于客户端具有高可信度的情况。用户将会给客户端提供自己的的登录信息（如用户名和密码），客户端使用这些信息向认证服务器发送请求获取令牌。原则上客户端是不允许存储这些登录信息的，但是客户端有没有真的遵守就不知道了。。。

### 客户端凭证（client credentials）

这种模式下用户并没有与认证服务器进行交流，而是在客户端进行注册或登录，登录成功后客户端会以自己的名义去请求认证服务器获取令牌。也就是说认证服务器是看在客户端的面子上给用户提供了相应的权限。

## 实例

this is a deep hole。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。
