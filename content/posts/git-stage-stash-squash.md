---
title: "Gitのステージ(Stage)、スタッシュ(Stash)、スクワシュ(Squash) キーワード"
date: 2021-01-23T00:12:33+09:00
draft: true
tags:
    - git
categories:
    - notes
keywords:
    - git
    - git stage
    - git stash
    - git squash
---


### ステージ(Stage)

ステージ(Stage)又はステージング(Staging)、`git add`で変更をステージングエリアに追加することです。


### スタッシュ(Stash)

コミットしてない変更を一時退避することができます。

https://qiita.com/chihiro/items/f373873d5c2dfbd03250

* `git stash [save ["message"]] `
* `git stash list`
* `git stash show` stash@{0}のようなスタッシュの名前を指定する
* `git stash apply` stash@{0}のようなスタッシュの名前を指定する
* `git stash pop` stash@{0}のようなスタッシュの名前を指定する
* `git stash drop` stash@{0}のようなスタッシュの名前を指定する
* `git stash clear`

TODO

### スクワシュ(Squash)

これは直接のコマンドではなく、mergeのオプションの一つである。複数のコミットを一つにまとめる。

TODO

https://qiita.com/Syoitu/items/4c949231ca4a1be3c330#comments