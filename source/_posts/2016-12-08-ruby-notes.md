---
title: ruby学习笔记
date: 2016-12-08 22:54:49
category: 学习笔记
tags:
    - ruby
keywords:
    - ruby
    - 教程
    - 笔记
---

## regular expressions

`=~`是用于正则表达式的匹配操作符。返回匹配到的字符串位置或nil。

```ruby
"abcdef" =~ /d/ # return 3
"aaaaaa" =~ /d/ # return nil
```

## !和?

The exclamation point (!, sometimes pronounced aloud as "bang!") indicates something potentially destructive, that is to say, something that can change the value of what it touches.
```
ruby> s1 = "forth"
  "forth"
ruby> s1.chop!       # This changes s1.
  "fort"
ruby> s2 = s1.chop   # This puts a changed copy in s2,
  "for"
ruby> s1             # ... without disturbing s1.
  "fort"
```

You'll also sometimes see chomp and chomp! used. These are more selective: the end of a string gets bit off only if it happens to be a newline.

The other method naming convention is the question mark (?, sometimes pronounced aloud as "huh?") indicates a "predicate" method, one that can return either true or false.

## 四种内部中断循环的方式

* `break`
* `next` 等同与continue
* `redo` restarts the current iteration
* `return`

## 迭代器 iterator

Ruby's String type has some useful iterators. `each_byte` is an iterator for each character in the string.

```shell
irb(main):001:0> "abc".each_byte{|c| printf "<%c>", c}; print "\n"
<a><b><c>
=> nil
```

Another iterator of String is `each_line`.

```shell
irb(main):002:0> "a\nb\nc\n".each_line{|l| print l}
a
b
c
=> "a\nb\nc\n"
```

ruby的 `for in` 也是一种迭代。We can use a control structure `retry` in conjunction with an iterated loop, and it will retry the loop from the beginning.

### yield

`yield` occurs sometimes in a definition of an iterator. `yield` moves control to the block of code that is passed to the iterator (this will be explored in more detail in the chapter about procedure objects). The following example defines an iterator repeat, which repeats a block of code the number of times specified in an argument.

```ruby
irb(main):003:0> def repeat(num)
irb(main):004:1>     while num > 0
irb(main):005:2>         yield
irb(main):006:2>         num -= 1
irb(main):007:2>     end
irb(main):008:1> end
=> :repeat
irb(main):009:0> repeat(3) { puts "foo" }
foo
foo
foo
=> nil
```

## class

### 继承

继承的格式为:
```ruby
class Superclass
    def breathe
        puts "inhale and exhale"
    end
    def identify
        puts "I'm super"
    end
    def speak(word)
        puts word
    end
end

class Subclass<Superclass
    # code...
end
```

可在在子类中重新声明基类方法，也可以使用`super`关键字来扩展基类方法。`super`也允许我们传递参数给基类方法。
```ruby
class Subclass<Superclass
    def identify
        super
        puts "I'm sub too"
    end
    def speak(word)
        super("this is from Superclass")
        puts "now it's from Subclass: #{word}"
    end
end
```
