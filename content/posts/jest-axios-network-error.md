---
title: "Jestでaxiosはネットワークエラーになってしまう件"
date: 2020-12-30T18:02:38+09:00
tags:
    - javascript
    - typescript
categories:
    - notes
keywords:
    - jest
    - javascript
    - typescript
---

JestでAPIを検証しようとした時、axiosからネットワークエラーが発生した。
背景：localhost:9090のwebpack-server経由でlocalhost:8080のバックサービスを叩く


色々調べると、ランタイム環境に関係ありそう。ちゃんとわかってないけど

## 解決案１

axiosアダプタをnode環境用のhttpアダプタを使うように変更する[^1]。今回これを使って解決した

```javascript
import axios from 'axios'
import httpAdapter from 'axios/lib/adapters/http'

const instance = axios.create({
    adapter: httpAdapter,
    // ...
});
```

## 解決案２

jestのディフォルト環境はブラウザ風のjsdomなので、nodeに変更すればできるはず[^2]
```javascript
// jest.config.js
module.exports = {
  testEnvironment: "node"
};
```

又は`jest --env=node`で実行する[^3]

## 参考

[Jestは、axiosで認証されたリクエストを行うと「ネットワークエラー」を返します](https://www.it-swarm-ja.tech/ja/javascript/jest%E3%81%AF%E3%80%81axios%E3%81%A7%E8%AA%8D%E8%A8%BC%E3%81%95%E3%82%8C%E3%81%9F%E3%83%AA%E3%82%AF%E3%82%A8%E3%82%B9%E3%83%88%E3%82%92%E8%A1%8C%E3%81%86%E3%81%A8%E3%80%8C%E3%83%8D%E3%83%83%E3%83%88%E3%83%AF%E3%83%BC%E3%82%AF%E3%82%A8%E3%83%A9%E3%83%BC%E3%80%8D%E3%82%92%E8%BF%94%E3%81%97%E3%81%BE%E3%81%99/831518115/)

[configuration#testenvironment-string](https://jestjs.io/docs/en/configuration#testenvironment-string)

[Jestでaxiosを使おうとするとNetwork Errorになってうまくいかないときの対処方法](https://dev.classmethod.jp/articles/jest-axios-network-error/)


[^1]: https://stackoverflow.com/a/42678578

[^2]: https://www.tolog.site/aws/jest-sam-network-error/

[^3]: https://github.com/axios/axios/issues/938