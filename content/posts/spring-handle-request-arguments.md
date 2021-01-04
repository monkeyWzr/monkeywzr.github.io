---
title: "Springでjsonリクエスト情報のカスタマイズ処理（変換、バリデーション、共通処理）"
date: 2021-01-04T15:13:31+09:00
draft: true
tags:
    - Spring
    - Java
categories:
    - notes
keywords:
    - Spring
    - Java
---

メカニズム：
Data Binder, Type Casting

## 共通処理

* HandlerInterceptor
* ControllerAdvice/RestControllerAdvice
* RequestBodyAdvice @RequestBodyの共通処理に適用。
* Filter 不勉強すみません
* AOP 不勉強againすみません


カスタマイズ変換の視点から、下記の方法がある（特に@RequestParamから取得したStringからオブジェクトへのカスタマイズ変換）
* RequestBodyAdvice @RequestBodyに適用
* ConverterFactory
* ArgumentResolver @RequestParamとかの制御に適用（カスタマイズ変換）
* PropertyEditor @RequestParamとかの制御に適用（カスタマイズ変換）


## Handlerinterceptor

[インターフェース HandlerInterceptor](https://spring.pleiades.io/spring-framework/docs/current/javadoc-api/org/springframework/web/servlet/HandlerInterceptor.html)


リクエストがハンドルされる前後にインタセプトするインタフェースです。（Controllerは当然handlerであると認識しているが、なぜこのインタフェースの名前がControllerIntercepterになってないでしょうか）

インタフェースによりインタセプトタイミングを見ると、Restアプリケーションの場合（特に共通バリデーションとかをしたい場合）に役割が少ないと思った[^1]

* preHandle: ハンドラー(controller)メソッドが呼び出される前に呼び出される。httpRequestとhttpResponseがパラメータであるので、一部の前処理とかを実装できる
* postHandle: ハンドラーメソッドが呼び出された後、DispatcherServlet がビューをレンダリングする前に呼び出される
* afterCompletion:　ビューのレンダリング後のコールバック

最近のプロジェクトに、preHandleでログ出力の初期設定を行う、afterCompletionでMDCのクリアを行う、のような仕組みを応用した。


## ControllerAdvice/RestControllerAdvice

Controllerクラスの間に、`@ExceptionHandler` `@InitBinder` `@ModelAttribute`の処理を共通定義できる

Data Binder, Model, Exceptionの共通カスタマイズ処理とかに適用

```java

@ControllerAdvice
// @RestControllerAdvice // RestControllerの場合
class SomeCustomControllerAdvice {
    @InitBinder
    public void initDataBinder(WebDataBinder dataBinder) {
        // dataBinder.registerCustomEditorでカスタマイズエディターの登録を行ったり
        // dataBinder.getTarget()でハンドラーメソッドに渡すPOJOオブジェクトのインスタンスも取得できる
    }

    @ModelAttribute
    public void addSomething(@RequestParam("someKey") String someValue, Model model) {
        // モデルを更新するとか
        // ハンドラーのようにリクエストパラメータを取得できるので、前処理とか実装できる
    }

    @ExceptionHandler
    // @ExceptionHandler({NullPointerException.class}) // 異常種類も指定できる
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public String handleException(Exception e) {

    }
}
```

RequestBodyAdviceに合わせて利用できる。

## GETの場合、ReqeustParamのタイプマッピング

`@RequestParam`はString、intのようなシンプルなデータタイプしかサポートしてないため、GETでJSONデータをオブジェクに変換したい場合、別途変換処理が必要となる。

### 案１　JacksonライブラリのObjectMapper

### 案２　カスタマイズPropertyEditor

https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/beans/propertyeditors/PropertiesEditor.html

https://www.baeldung.com/spring-mvc-custom-property-editor

`@InitBinder`で登録する


### 案３　カスタマイズタイプ変換ConverterFactory

階層的なオブジェクトの場合適用

### 案４　カスタマイズArgument Resolver

`HandlerMethodArgumentResolver`インタフェースを実装する

## POSTの場合、RequestBodyの共通処理




postの場合、`RequestBodyAdvice`というインタフェースで@RequestBody取得前と取得後にカスタマイズ処理を実装できる。

※注意：`HttpServletRequest#getInputStream()`でリクエストボディを取得しているので、一回読んで後EOFになるため、２回再取得するとリクエストボディが空になってしまう

* HttpInputMessage beforeBodyRead(HttpInputMessage inputMessage, MethodParameter parameter, Type targetType, Class<? extends HttpMessageConverter<?>> converterType)　リクエストボディストリームを読む前
* Object afterBodyRead(Object body, HttpInputMessage inputMessage, MethodParameter parameter, Type targetType, Class<? extends HttpMessageConverter<?>> converterType)　リクエストボディを読んで目標オブジェクトにキャストした後
* Object handleEmpty
* boolean supports

RequestBodyAdviceAdapterでいう便利なやつがある。supportsを実装するだけで使える。




## 参考

**下記２つのブロク、大変参考になった。ありがとうございました**
[Spring でリクエストボディの JSON に対してバリデーションを行う](https://tyru.hatenablog.com/entry/2016/10/14/021333)
[Spring MVC(+Spring Boot)上でのリクエスト共通処理の実装方法を理解する](https://qiita.com/kazuki43zoo/items/757b557c05f548c6c5db)



[^1]: https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-handlermapping-interceptor