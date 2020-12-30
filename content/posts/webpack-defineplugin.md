---
title: "WebpackのDefinePluginで環境変数を定義する"
date: 2020-12-30T16:42:34+09:00
tags:
    - javascript
categories:
    - notes
keywords:
    - webpack
    - defineplugin
    - javascript
    - typescript
    - jest

---

webpackのDefinePluginでグローバル環境変数が定義できる。

```javascript
new webpack.DefinePlugin({
  // Definitions...
});
```

コンパイル時直接テキスト置換でインラインかされるので、文字列の値を定義したい場合、実際のクォーテーションを含める必要がある[^1]

>Note that because the plugin does a direct text replacement, the value given to it must include actual quotes inside of the string itself. Typically, this is done either with alternate quotes, such as '"production"', or by using JSON.stringify('production').

```javascript
new webpack.DefinePlugin({
  PRODUCTION: JSON.stringify(true), // true
  BROWSER_SUPPORTS_HTML5: true, // true
  VERSION: JSON.stringify('5fa3b9'), // '5fa3b9'
  'SERVICE_URL': 'https://dev.example.com', // highly possible to recieve a compile error
  'typeof window': '"object"',
  TWO: '1+1', // 2
  'process.env.NODE_ENV': JSON.stringify(process.env.NODE_ENV)
});
```


## ランタイム値も可能


## With Typescript

Typescriptコンパイラも認識できるように、declare定義が必要[^2]。

```typescript
// some.d.ts
declare var PRODUCTION: boolean;
declare var VERSION: string;
```

## With Jest

jest.config.jsに再定義が必要らしい[^3]

```javascript
"jest": {
    "globals": {
      "PRODUCTION": true
    }
  }
```

[^1]: https://webpack.js.org/plugins/define-plugin/

[^2]: https://github.com/TypeStrong/ts-loader/issues/37#issuecomment-135812276

[^3]: https://stackoverflow.com/questions/47875880/use-webpacks-defineplugin-vars-in-jest-tests