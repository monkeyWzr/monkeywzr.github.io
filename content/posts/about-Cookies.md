---
title: "CookieのSecure属性とHttpOnly属性"
date: 2021-01-27T15:57:23+09:00
draft: true
tags:
    - http
    - javascript
categories:
    - notes
keywords:
    - Cookie
    - javascript
---

どちらもアクセス制限用の属性です。適切に設定するとより安全なアプリケーションを作ることができます

## Secure属性

Secure属性を設定する場合、HTTPSの場合のみサーバにCookieを送信する。中間者攻撃防止するのに少し役立ちます。
（完全な安全ではありません）

## HttpOnly属性

HttpOnlyを設定する場合、JavaScriptが該当Cookieへのアクセスができなくなります。
