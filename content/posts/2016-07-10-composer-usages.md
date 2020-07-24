---
title: composer用法
date: 2016-07-10 12:21:46
categories: notes
tags:
    - php
keywords:
    - php
    - composer
    - 包管理
    - 依赖管理
---

## composer.json

要开始在你的项目中使用 Composer，你只需要一个`composer.json`文件。该文件包含了项目的依赖和其它的一些元数据。

首先需要指定`require key`的值
```
{
    "require": {
        "monolog/monolog": "1.0.*"
    }
    "require-dev": {
        "phpunit/phpunit": "4.8.*"
    }
}

```

`require`属性列出组件依赖的组件，`require-dev`属性列出的是开发时所需依赖，在生产环境下不会安装。

<!-- more -->

## 包名

包名应该包含供应商名和项目名

### 包版本

* 指定版本号 `1.0.2`，`1.0.0-dev`，`1.0.0-alpha3`
* 范围 `>=1.0` `>=1.0,<2.0` `>=1.0,<1.1|>=1.2` `,`的优先级高于`|`
* 通配符 `1.0.*`
* 赋值运算符 `~1.2` 相当于`>=1.2,<2.0`
* 允许依赖不稳定包 `@beta` `@dev`

形如`1.0.*@beta`，或者`dev-master#2eb0c0978d290a1c45346a1955188929cb4e5db7`这种明确了版本号的也是支持的。

波浪号运算符的意义在于，防止大版本更新而产生的兼容性问题。

### Dist
dist 指向一个存档，该存档是对一个资源包的某个版本的数据进行的打包。通常是已经发行的稳定版本。

### Source
source 指向一个开发中的源。这通常是一个源代码仓库，例如`git`。当你想要对下载下来的资源包进行修改时，可以这样获取。

你可以使用其中任意一个，或者同时使用。这取决于其它的一些因素，比如`user-supplied` 选项和包的稳定性，前者将会被优先考虑。

### repositories

默认情况下 composer 只使用 packagist 作为包的资源库。通过指定资源库，你可以从其他地方获取资源包。

Repositories 并不是递归调用的，只能在Root包的 `composer.json` 中定义。附属包中的 `composer.json` 将被忽略。

支持一下类型的资源库：
* composer: 一个 composer 类型的资源库，是一个简单的网络服务器（HTTP、FTP、SSH）上的 `packages.json` 文件，它包含一个 `composer.json` 对象的列表，有额外的 `dist` 和/或 `source` 信息。这个 `packages.json` 文件是用一个 PHP 流加载的。你可以使用 `options` 参数来设定额外的流信息。
* vcs: 从 `git`、`svn` 和 `hg` 取得资源。
* pear: 从 `pear` 获取资源。
* package: 如果你依赖于一个项目，它不提供任何对 composer 的支持，你就可以使用这种类型。你基本上就只需要内联一个 `composer.json` 对象。

```
{
    "require": {
        "vendor/my-private-repo": "dev-master"
    },
    "repositories": [
        {
            "type": "vcs",
            "url":  "git@github.com:vendor/my-private-repo.git"
        }
    ]
}
```

### config

config字段仅适用于root项目。

几个常用的值：
* use-include-path: 默认为 `false`。如果为 `true`，Composer autoloader 还将在 PHP include path 中继续查找类文件。
* preferred-install: 默认为 `auto`。它的值可以是 `source`、`dist` 或 `auto`。这个选项允许你设置 Composer 的默认安装方法。
* github-protocols: 默认为 ["git", "https", "ssh"]。从 github.com 克隆时使用的协议优先级清单。
* vendor-dir: 默认为 `vendor`。指定依赖安装目录
* bin-dir: 默认为 `vendor/bin`。如果一个项目包含二进制文件，它们将被连接到这个目录。
* cache-dir: unix 下默认为 `$home/cache`，Windows 下默认为 `C:\Users\<user>\AppData\Local\Composer`。用于存储 composer 所有的缓存文件。其子文件夹`cache-files-dir` `cache-repo-dir` `cache-vcs-dir`也可以分别指定路径。

```
{
    "config": {
        "bin-dir": "bin"
    }
}
```

### 发布包相关

`name` `description` 必填，`license` `authors` `support` 等是强烈建议填写的可选项。

```
{
    "authors": [
        {
            "name": "Nils Adermann",
            "email": "naderman@naderman.de",
            "homepage": "http://www.naderman.de",
            "role": "Developer"
        },
        {
            "name": "Jordi Boggiano",
            "email": "j.boggiano@seld.be",
            "homepage": "http://seld.be",
            "role": "Developer"
        }
    ],
    "license": "MIT",
    "support": {
        "email": "support@example.org",
        "irc": "irc://irc.freenode.org/composer"
    }
}

```

## 安装依赖

在`composer.json`所在目录调用`install`命令

```
composer install

```

install命令会将依赖下载到`vendor`目录，并会生成`composer.lock`锁文件。

## composer.lock

安装依赖后composer会把当前的确切版本号全部写入`composer.lock`，用来锁定版本。install命令会首先检查锁文件并根据锁文件指定的版本下载依赖。如果需要更新依赖的版本需要执行`update`命令。

```
composer update [monolog/monolog]

```

>在团队协作开发时，__应提交你应用程序的 composer.lock （包括 composer.json）到你的版本库中__

## 自动加载

Composer 生成了一个 `vendor/autoload.php` 文件，可在项目中引用它得到一个简单的自动加载支持。

```
require 'vendor/autoload.php';

```

也可以在 `composer.json` 的 `autoload` 字段中增加自己的 `autoloader`。当前composer支持`PSR-0` ` PSR-4` `classmap` 和文件包含。官方提倡使用PSR-4标准的方式。

>PSR-4 is the recommended way though since it offers greater ease of use (no need to regenerate the autoloader when you add classes).

在 `composer.json` 中配置 `autoloader`

```
{
    "autoload": {
        "psr-4": {"Wzr\\": "src/"}
    }
}

```

Composer 将注册一个 `PSR-4 autoloader` 到 `Wzr` 命名空间，且该命名空间映射到根目录的 `src` 文件夹，比如 `src/IsMonkey.php` 文件应该包含 `Wzr\IsMonkey` 类。

添加 `autoload` 字段后应该再次执行 `install` 来重新生成 `vendor/autoload.php` 文件。

命名空间一定要以`\\`来分隔，好处在这：（懒得翻译了<(￣3￣)>)

>Namespace prefixes must end in `\\` to avoid conflicts between similar prefixes. For example Foo would match classes in the FooBar namespace so the trailing backslashes solve the problem: `Foo\\` and `FooBar\\` are distinct.

## 发布

### 发布到 packagist

去[网站](https://packagist.org/)上发布，提交库来源地址即可。composer有些字段需要定义。移步[composer.json](#发布包相关)

### 发布到vcs

只要包含着`composer.json`的项目上传到版本仓库，你的库就可以通过composer安装。在`composer.json`中需要定义`name`和`description`字段。当然，依赖这类库时需要在`repositories`中声明库的来源。参见[repositories](#repositories)

## 命令行

在日常使用中，运行 `composer` 或者 `composer list` 命令得到命令列表，然后结合 --help 命令获得详细的帮助信息。

### 全局参数

下列参数可与每一个命令结合使用：

* *--verbose (-v)*: 增加反馈信息的详细度。
    -v 表示正常输出。
    -vv 表示更详细的输出。
    -vvv 则是为了 debug。
* *--help (-h)*: 显示帮助信息。
* *--quiet (-q)*: 禁止输出任何信息。
* *--no-interaction (-n)*: 不要询问任何交互问题。
* *--working-dir (-d)*: 如果指定的话，使用给定的目录作为工作目录。
* *--profile*: 显示时间和内存使用信息。
* *--ansi*: 强制 ANSI 输出。
* *--no-ansi*: 关闭 ANSI 输出。
* *--version (-V)*: 显示当前应用程序的版本信息。

### init

`init`命令可进行初始化,生成`composer.json`。
参数列表：
* *--name*: 包的名称。
* *--description*: 包的描述。
* *--author*: 包的作者。
* *--homepage*: 包的主页。
* *--require*: 需要依赖的其它包，必须要有一个版本约束。并且应该遵循 `foo/bar:1.0.0` 这样的格式。
* *--require-dev*: 开发版的依赖包，内容格式与 `--require` 相同。
* *--stability (-s)*: `minimum-stability` 字段的值。

### install

参数列表：
* *--prefer-source*: 下载包的方式有两种： source 和 dist。对于稳定版本 composer 将默认使用 dist 方式。而 source 表示版本控制源 。如果 --prefer-source 是被启用的，composer 将从 source 安装（如果有的话）。如果想要使用一个 bugfix 到你的项目，这是非常有用的。并且可以直接从本地的版本库直接获取依赖关系。
* *--prefer-dist*: 与 --prefer-source 相反，composer 将尽可能的从 dist 获取，这将大幅度的加快在 build servers 上的安装。这也是一个回避 git 问题的途径，如果你不清楚如何正确的设置。
* *--dry-run*: 如果你只是想演示而并非实际安装一个包，你可以运行 --dry-run 命令，它将模拟安装并显示将会发生什么。
* --dev: 安装 require-dev 字段中列出的包（这是一个默认值）。
* *--no-dev*: 跳过 require-dev 字段中列出的包。
* *--no-scripts*: 跳过 composer.json 文件中定义的脚本。
* *--no-plugins*: 关闭 plugins。
* *--no-progress*: 移除进度信息，这可以避免一些不处理换行的终端或脚本出现混乱的显示。
* *--optimize-autoloader (-o)*: 转换 PSR-0/4 autoloading 到 classmap 可以获得更快的加载支持。特别是在生产环境下建议这么做，但由于运行需要一些时间，因此并没有作为默认值。

### update

update命令可以升级依赖到最新版本，并更新`composer.lock`，也可指定包名单独更新一个或几个包。
参数列表：
`install`的所有参数均适用于`update`。
* *--lock*: 仅更新 lock 文件的 hash，取消有关 lock 文件过时的警告。
* *--with-dependencies* 同时更新白名单内包的依赖关系，这将进行递归更新。

### require

require命令可以增加新的依赖包到当前目录的`composer.json`，在添加或改变依赖时， 修改后的依赖关系将被安装或者更新。

```
composer require vendor/package:2.* vendor/package2:dev-master
```

参数列表：
* *--prefer-source*: 当有可用的包时，从 source 安装。
* *--prefer-dist*: 当有可用的包时，从 dist 安装。
* *--dev*: 安装 require-dev 字段中列出的包。
* *--no-update*: 禁用依赖关系的自动更新。
* *--no-progress*: 移除进度信息，这可以避免一些不处理换行的终端或脚本出现混乱的显示。
* *--update-with-dependencies* 一并更新新装包的依赖。

### global

全局执行命令。

```
composer global require fabpot/php-cs-fixer:dev-master
```

现在 php-cs-fixer 就可以在全局范围使用了（假设你已经设置了你的 PATH）。

### search

参数：
* *--only-name (-N)*: 仅搜索制定的名称，即完全匹配

### show

列出所有可用的软件包
```
composer show
```

也可以指定包名显示包的详细信息，也可以一并输入版本号查看某特定版本的包的详细信息。

参数：
* *--installed (-i)*: 列出已安装的依赖包。
* *--platform (-p)*: 仅列出平台软件包（PHP 与它的扩展）。
* *--self (-s)*: 仅列出当前项目信息。

### depends

depends命令可以查出已安装在你项目中的某个包，是否正在被其它的包所依赖，并列出他们。

参数：
* *--link-type*: 检测的类型，默认为 `require` 也可以是 `require-dev`。

```
composer depends --link-type=require monolog/monolog

nrk/monolog-fluent
poc/poc
propel/propel
symfony/monolog-bridge
symfony/symfony
```

### validate

在提交 `composer.json` 文件，和创建 tag 前，你应该始终运行 `validate` 命令。它将检测你的 `composer.json` 文件是否是有效的。

参数：
* *--no-check-all*: Composer 是否进行完整的校验。

### status

如果你经常修改依赖包里的代码，并且它们是从 source（自定义源）进行安装的，那么 status 命令允许你进行检查，如果你有任何本地的更改它将会给予提示。
你可以使用 `--verbose` 系列参数（-v|vv|vvv）来获取更详细的详细：
```
composer status -v
```

### self-update

将 Composer 自身升级到最新版本，只需要运行 `self-update` 命令。它将替换你的 `composer.phar` 文件到最新版本。
如果你想要升级到一个特定的版本，可以这样简单的指定它：
```
php composer.phar self-update 1.0.0-alpha7
```
如果你已经为整个系统(linux)安装 Composer，你可能需要在 root 权限下运行它.

参数：
* *--rollback (-r)*: 回滚到你已经安装的最后一个版本。
* *--clean-backups*: 在更新过程中删除旧的备份，这使得更新过后的当前版本是唯一可用的备份。

### create-project

你可以使用 Composer 从现有的包中创建一个新的项目。这相当于执行了一个 `git clone` 或 `svn checkout` 命令后将这个包的依赖安装到它自己的 vendor 目录。

此命令有几个常见的用途：

* 你可以快速的部署你的应用。
* 你可以检出任何资源包，并开发它的补丁。
* 多人开发项目，可以用它来加快应用的初始化。

要创建基于 Composer 的新项目，你可以使用 "create-project" 命令。传递一个包名，它会为你创建项目的目录。如果该目录目前不存在，则会在安装过程中自动创建。你也可以在第三个参数中指定版本号，否则将获取最新的版本。
如laravel应用的安装：
```
php composer.phar create-project laravel/laravel myapp --prefer-dist
```
此外，你也可以无需使用这个命令，而是通过现有的 composer.json 文件来启动这个项目。

默认情况下，这个命令会在 packagist.org 上查找你指定的包。
参数：
* *--repository-url*: 提供一个自定义的储存库来搜索包，这将被用来代替 packagist.org。可以是一个指向 composer 资源库的 HTTP URL，或者是指向某个 packages.json 文件的本地路径。
* *--stability (-s)*: 资源包的最低稳定版本，默认为 stable。
* *--prefer-source*: 当有可用的包时，从 source 安装。
* *--prefer-dist*: 当有可用的包时，从 dist 安装。
* *--dev*: 安装 require-dev 字段中列出的包。
* *--no-install*: 禁止安装包的依赖。
* *--no-plugins*: 禁用 plugins。
* *--no-scripts*: 禁止在根资源包中定义的脚本执行。
* *--no-progress*: 移除进度信息，这可以避免一些不处理换行的终端或脚本出现混乱的显示。
* *--keep-vcs*: 创建时跳过缺失的 VCS 。如果你在非交互模式下运行创建命令，这将是非常有用的。

### dump-autoload

某些情况下你需要更新 autoloader，例如在你的包中加入了一个新的类。你可以使用 `dump-autoload` 来完成，而不必执行 `install` 或 `update` 命令。

此外，它可以打印一个优化过的，符合 PSR-0/4 规范的类的索引，这也是出于对性能的可考虑。在大型的应用中会有许多类文件，而 autoloader 会占用每个请求的很大一部分时间，使用 classmaps 或许在开发时不太方便，但它在保证性能的前提下，仍然可以获得 PSR-0/4 规范带来的便利。
参数:
* *--optimize (-o)*: 转换 PSR-0/4 autoloading 到 classmap 获得更快的载入速度。这特别适用于生产环境，但可能需要一些时间来运行，因此它目前不是默认设置。
* *--no-dev*: 禁用 autoload-dev 规则。

### licenses

列出已安装的每个包的名称、版本、许可协议。可以使用 `--format=json` 参数来获取 JSON 格式的输出。


### run-script

你可以运行此命令来手动执行 脚本，只需要指定脚本的名称，可选的 `--no-dev` 参数允许你禁用开发者模式。


### diagnose

如果你觉得发现了一个 bug 或是程序行为变得怪异，你可能需要运行 `diagnose` 命令，来帮助你检测一些常见的问题。

### archive

此命令用来对指定包的指定版本进行 zip/tar 归档。它也可以用来归档你的整个项目，不包括 excluded/ignored（排除/忽略）的文件。
```
composer archive vendor/package 2.0.21 --format=zip
```

参数：

* *--format (-f)*: 指定归档格式：tar 或 zip（默认为 tar）。
* *--dir*: 指定归档存放的目录（默认为当前目录）。

### help

使用 `help` 可以获取指定命令的帮助信息。
```
composer help install
```

## 环境变量

你可以设置一些环境变量来覆盖默认的配置。建议尽可能的在 `composer.json` 的 `config` 字段中设置这些值，而不是通过命令行设置环境变量。值得注意的是环境变量中的值，将始终优先于 `composer.json` 中所指定的值。

>参考资料：
>http://docs.phpcomposer.com/03-cli.html
