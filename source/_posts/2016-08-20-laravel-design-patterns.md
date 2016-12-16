---
title: laravel设计模式
date: 2016-08-20 23:29:17
category:
    - 学习笔记
tags:
    - laravel
    - php
keywords:
    - laravel
    - laravel5
    - php
    - 理解
    - 设计模式
---

## DI与IOC

laravel中实现了DI依赖注入，如：

```php
class UserController
{
    private $user;
    function __construct(UserModel $user) {
        $this->user = $user;
    }
}
$user = new UserController(new UserMonel());
```    

`UserController`依赖`UserModel`，在实例化时，laravel会自动主注入UserModel实例。
