---
title: "Springでjsonリクエスト情報のカスタマイズ処理（変換、バリデーション、共通処理）"
date: 2021-01-04T15:13:31+09:00
tags:
    - Spring
    - Java
categories:
    - notes
keywords:
    - Spring
    - ArgumentResolver
    - ControllerAdvice
    - RequestBodyAdvice
    - HandlerInterceptor
    - PropertyEditor
    - ConverterFactory
    - Java
---

内容要補足

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


## HandlerInterceptor

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

必要なcontrollerに`@InitBinder`でエディターを登録する。全体のcontrollerに登録したい場合ControllerAdviceに登録する

```java
@InitBinder
public void initBinder(WebDataBinder binder) {
    binder.registerCustomEditor(MyTargetType.class, 
        new MyCustomTypeEditor());
}
```

### 案３　カスタマイズタイプ変換ConverterとConverterFactory

ディフォルトでSpringはString, Interger, Booleanとかベーシックタイプの変換をサポートしている。
必要なオブジェクトに変換したい場合Converterを実装すればいい。

```java
public class StringToMyDataConverter
  implements Converter<String, MyData> {

    @Override
    public MyData convert(String from) {
        // your custom convertion
        return new MyData();
    }
}
```

WebMvcConfigurerのaddFormattersでConverterの登録が必要：

```java
@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addFormatters(FormatterRegistry registry) {
        registry.addConverter(new StringToMyDataConverter());
    }
}
```

https://spring.pleiades.io/spring-framework/docs/current/javadoc-api/org/springframework/core/convert/converter/Converter.html

階層的なオブジェクトの場合、カスタマイズConverterFactoryを実装することでジェネリクスな変換もできる。

https://spring.pleiades.io/spring-framework/docs/current/javadoc-api/org/springframework/core/convert/converter/ConverterFactory.html

### 案４　カスタマイズArgument Resolver

`HandlerMethodArgumentResolver`インタフェースを実装する

```java
public class MyArgumentResolver
  implements HandlerMethodArgumentResolver {

    @Override
    public boolean supportsParameter(MethodParameter methodParameter) {
        // 対象引数の判定。
        // methodParameterで引数のアノテーション、クラス、引数名とか色々な属性が取得できる
        // https://spring.pleiades.io/spring-framework/docs/current/javadoc-api/org/springframework/core/MethodParameter.html
        return methodParameter.getParameterType().equals(MyData.class)
    }

    @Override
    public Object resolveArgument(
      MethodParameter methodParameter, 
      ModelAndViewContainer modelAndViewContainer, 
      NativeWebRequest nativeWebRequest, 
      WebDataBinderFactory webDataBinderFactory) throws Exception {
 
        HttpServletRequest request 
          = (HttpServletRequest) nativeWebRequest.getNativeRequest();
        // urlパラメータから変換する
        return objectMapper.readValue(request.getParamter("data"), MyData.class);;
    }
}
```

## POSTの場合、RequestBodyの共通処理

めちゃくちゃ勉強になったブログ：
[Spring でリクエストボディの JSON に対してバリデーションを行う](https://tyru.hatenablog.com/entry/2016/10/14/021333)

postの場合、`RequestBodyAdvice`というインタフェースで`@RequestBody`取得前後にカスタマイズ処理を実装できる。

※注意：`HttpServletRequest#getInputStream()`でリクエストボディを取得しているので、一回読んで後EOFになるため、２回再取得するとリクエストボディが空になってしまう

* HttpInputMessage beforeBodyRead(HttpInputMessage inputMessage, MethodParameter parameter, Type targetType, Class<? extends HttpMessageConverter<?>> converterType)　リクエストボディストリームを読む前
* Object afterBodyRead(Object body, HttpInputMessage inputMessage, MethodParameter parameter, Type targetType, Class<? extends HttpMessageConverter<?>> converterType)　リクエストボディを読んで目標オブジェクトにキャストした後
* Object handleEmpty
* boolean supports

RequestBodyAdviceAdapterでいう便利なやつがある。supportsを実装するだけで使える。

## 参考

**下記のブロク、大変参考になった。ありがとうございました**
[Spring でリクエストボディの JSON に対してバリデーションを行う](https://tyru.hatenablog.com/entry/2016/10/14/021333)
[Spring MVC(+Spring Boot)上でのリクエスト共通処理の実装方法を理解する](https://qiita.com/kazuki43zoo/items/757b557c05f548c6c5db)


[Guide to Spring Type Conversions](https://www.baeldung.com/spring-type-conversions)
[JSON Parameters with Spring MVC](https://www.baeldung.com/spring-mvc-send-json-parameters)
[A Custom Data Binder in Spring MVC](https://www.baeldung.com/spring-mvc-custom-data-binder)

[^1]: https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-handlermapping-interceptor