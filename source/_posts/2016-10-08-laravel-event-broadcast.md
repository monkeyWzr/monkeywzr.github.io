---
title: laravel 5.2 事件广播
date: 2016-10-08 00:38:47
category: notes
tags:
    - laravel
    - php
keywords:
    - laravel
    - php
    - 事件
    - 广播
    - websocket
    - 即时通信
---

## 简介

Laravel 事件提供了简单的观察者模式实现，允许你订阅和监听应用中的事件。事件类通常存放在 `app/Events` 目录，监听器存放在 `app/Listeners`。

## 配置

所有的事件广播配置选项都存放在 `config/broadcasting.php` 配置文件中。Laravel 支持多种广播驱动：`Pusher`、`Redis`以及一个服务于本地开发和调试的`Log`日志驱动。每一个驱动都已经有一个配置示例。基本上所有配置信息全可以在`.env`中指定，不需要改动`broadcasting.php`配置文件，如：

```
#在.env中配置驱动
BROADCAST_DRIVER=redis
```

<!-- more -->

## 注册事件和监听器

Laravel 自带的 `EventServiceProvider`（在 app/Providers/EventServiceProvider.php 中） 为事件注册提供了方便之所。其中的 listen 属性包含了事件（键）和对应监听器（值）数组。如果应用需要，你可以添加多个事件到该数组。例如，让我们添加 `SomeEvent` 事件：
```
/**
 * 事件监听器映射
 *
 * @var array
 */
protected $listen = [
    'App\Events\SomeEvent' => [
        'App\Listeners\SomeEventListener',
    ],
];
```

接下来使用`event:generate`命令生成对应的事件和监听器：

```
php artisan event:generate
```

执行后将会创建`app/Events/SomeEvent.php` 和 `app/Listener/SomeEventListener.php`。

>除了上面在 `EventServiceProvider` 中注册事件的方式，还可以使用 `Event` 门面或者 `Illuminate\Contracts\Events\Dispatcher` 契约的具体实现类作为事件分发器手动注册事件：

```
/**
 * Register any other events for your application.
 *
 * @param  \Illuminate\Contracts\Events\Dispatcher  $events
 * @return void
 */
public function boot(DispatcherContract $events)
{
    parent::boot($events);

    $events->listen('event.name', function ($foo, $bar) {
        //
    });
}
```

你还可以使用通配符*来注册监听器，从而允许你通过同一个监听器捕获多个事件。通配符监听器接收整个事件数据数组作为参数：

```
$events->listen('event.*', function (array $data) {
    //
});
```

## 定义事件为广播

如果事件需要被广播，則必须让Event类实现一个 `Illuminate\Contracts\Broadcasting\ShouldBroadcast` 接口，并且实现一个方法 `broadcastOn` 。broadcastOn返回一个数组，包含了事件发送到的channel(频道)。在SomeEvent类中添加：

```

use App\Events\Event;
use Illuminate\Queue\SerializesModels;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;

//实现ShouldBroadcast接口
class SomeEvent extends Event implements ShouldBroadcast
{
    # other codes ...

    # 添加broadcastOn()方法
    public function broadcastOn()
    {
        return ['test-channel'];
    }
```

默认情况下，Event中的所有public属性都会被序列化后广播。你也可以使用broadcastWith这个方法，明确的指出要广播什么数据。

```
public function broadcastWith()
{
    return ['bilibili' => $this->bilibili];
}
```

## 触发事件

在控制器或什么地方使用`event()``辅助函数触发即可：

```
event(new SomeEvent($bilibili));
```

## 应用广播的数据

使用redis作为驱动的话需要启动一个redis服务。事件广播主要依赖的就是redis的sub/pub功能。配合websocket服务器读取redis中的广播数据与客户端实时通信。

>__相关链接__：
>[laravel Events](https://laravel.com/docs/5.2/events)
>[Laravel5.1 事件广播(Event Broadcasting)](https://segmentfault.com/a/1190000002921506)
>[ Laravel 5.2 文档 服务 —— 事件](http://laravelacademy.org/post/3162.html)
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTE5MjMzNjAyNjUsLTE5NDEzNjE4NDNdfQ
==
-->