---
title: SpringMVC初使用心得
date: 2018-10-10 17:25:25
tags:
    - SpringMVC
    - Java
categories: tech
keywords:
    - android
    - java
    - configuration
    - status
---

进入公司第一个实践的项目是用SpringMVC开发的。在前辈指导跳过了Spring庞大的学习内容直接上手了SpringMVC。磕磕碰碰中也算是对Spring有了一个初步的了解。

# SpringMVC框架初识

SpringMVC是Spring提供的一个web框架。

## 架构

`SpringMVC`是`Spring`的一部分，主要模块如下图所示。

![img](https://docs.spring.io/spring/docs/3.0.x/spring-framework-reference/html/images/spring-overview.png)

在SpringMVC为架构的项目中的代码逻辑主要有如下几层:

### Controller层

Controller层起到了路由的作用，通过Spring提供的`@RequestMapping`注解将请求路径和请求方法（GET/POST等）与Controller的方法绑定，接受请求参数，进行验证权限等操作并调用Service执行业务逻辑。Controller类需要表明`@Controller`注解。

### Service层

Service层实现了业务的主要逻辑。处理参数，调用负责数据库操作的Dao层，组装返回数据并将结果返回给Controller。Service类需要标注`@Service`注解。

### Dao层

Data access的部分在项目中体现为`Dao`层。Dao层的类以Model为载体，借助JDBC或者Hibernate的方法封装了对表的各种操作。通常Dao层的类和数据表是一一对应的。Dao层的类需要添加`@Repository`注解。

### Model

Model层就是数据表的Java载体。需要添加`@Entity`注解标明该类为实体，并使用`@Table(name = "table_name")`来绑定数据表。Model类中要添加`@Id` `@GeneratedValue`注解配置主键（具体含义还需进一步学习。参考链接:[https://www.baeldung.com/hibernate-identifiers](https://www.baeldung.com/hibernate-identifiers) [https://www.thoughts-on-java.org/jpa-generate-primary-keys/](https://www.thoughts-on-java.org/jpa-generate-primary-keys/)。）Model中的`getter` `setter`通过`@Column(name = "id", unique = true, nullable = false)`注解表字段。

## 调度流程

首先在项目最外层的`web.xml`中指定了Spring提供的`dispatcherServlet`作为调度请求的核心servlet。

__未完待续__
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTEzNTM2NjM3ODEsMTM0OTk5NTc4Nl19
-->