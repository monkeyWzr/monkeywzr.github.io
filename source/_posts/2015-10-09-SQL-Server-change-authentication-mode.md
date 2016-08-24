---
layout: post
title: SQL Server更改服务器身份验证模式
category: 技术
tags: SQLServer
keywords: SQL Server 2008 r2,身份验证
description: 
---


## 使用 SQL Server Management Studio

### 更改安全身份验证模式
1. 在 SQL Server Management Studio 的对象资源管理器中，右键单击服务器，再单击“属性”。

2. 在“安全性”页上的“服务器身份验证”下，选择新的服务器身份验证模式，再单击“确定”。

3. 在 SQL Server Management Studio 对话框中，单击“确定”以确认需要重新启动 SQL Server。

4. 在对象资源管理器中，右键单击您的服务器，再单击“重新启动”。如果运行有 SQL Server 代理，则也必须重新启动该代理。

### 启用 sa 登录名

1. 在对象资源管理器中，依次展开“安全性”、“登录名”，右键单击“sa”，再单击“属性”。

2. 在“常规”页上，您可能需要为登录名创建密码并确认该密码。

3. 在“状态”页上的“登录”部分，单击“启用”，然后单击“确定”

## 使用 Transact-SQL

### 启用 sa 登录名

1. 在“对象资源管理器”中，连接到 数据库引擎的实例。
2. 在标准菜单栏上，单击“新建查询”。
3. 将以下示例复制并粘贴到查询窗口中，然后单击“执行”。下面的示例启用 sa 登录名并设置一个新密码。

		ALTER LOGIN sa ENABLE ;
		GO
		ALTER LOGIN sa WITH PASSWORD = '<enterStrongPasswordHere>' ;
		GO

>__相关链接__
>[MSDN-管理数据库引擎服务](https://msdn.microsoft.com/zh-cn/library/ms188670(v=sql.120).aspx#Anchor_2)