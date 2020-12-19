---
title: "Spring Bean Scope: Singleton and Prototype"
date: 2020-12-13T16:36:42+09:00
tags:
    - Spring
    - Java
categories:
    - notes
keywords:
    - Spring
    - Java
    - Bean scope
---


## シングルトンsingleton

Only one instance is created and managed in the Spring container. This instance is shared by all requests so we should use this for stateless beans. Singleton scope is the default scope in Spring.

```java
@Service
public class SomeService{
    // DANGER! This property is shared by all requests so one user might use others' password
    private String password;
    public void authByPassword(){
        // ...
    }
}
```

## prototype

A new instance is created by each request for that bean. This should be used when the bean is designed for stateful usage.

```java
@Service
@Scope("prototype")
public class SomeService{
    private String password;
    public void authByPassword(){
        // ...
    }
}
```

But be cautious about the Controller's class. If the controller which use the SomeService, is singleton scope, one new instance of the service is injected when and only when the controller is instanced.

[1.5.3. プロトタイプ Bean 依存関係を持つシングルトン Bean](https://spring.pleiades.io/spring-framework/docs/current/reference/html/core.html#beans-factory-scopes-sing-prot-interaction)


[Spring の @Scope のデフォルト挙動](http://kusamakura.hatenablog.com/entry/2016/02/23/Spring_%E3%81%AE_%40Scope_%E3%81%AE%E3%83%87%E3%83%95%E3%82%A9%E3%83%AB%E3%83%88%E6%8C%99%E5%8B%95)
