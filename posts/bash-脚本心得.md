---
title: Bash 脚本心得
date: '2011-09-11'
description: 之前对 shell 脚本的认识还十分浅薄，认为他不过是一系列命令的组合罢了。经过这段时间的实践之后，发现 shell 脚本远不止于此，他最精华的部分在于对变量的处理而产生很多丰富的功能实现
categories: 我的程序
tags: [Bash]
---
受到了 [主席][1] 的鼓励，分享一下我前段时间实习写bash脚本学到的一些东西。

[1]: http://imtx.me

之前对 __shell__ 脚本的认识还十分浅薄，认为他不过是一系列命令的组合罢了。经过这段时间的实践之后，发现 __shell__ 脚本远不止于此，他最精华的部分在于对变量的处理而产生很多丰富的功能实现

# 变量

## 哈希实现

当你想要一个哈希数组的时候，你并不只有一种方法去拥有它。最简单的当然是

```
declare -A hash_name
hash_name{key}=value
```

除此之外，你也可以用最普通的变量名来实现哈希，方法来自于 [StackOverflow][1]：

[2]: http://stackoverflow.com/questions/1494178/how-to-define-hash-tables-in-bash

利用 `${!var_var_name}` 和 `${!var_prefix*}` 的 shell 自动展开来实现。

前者是通过定义 `var_var_name` 变量来显示以该变量的值为变量名的变量的值。举个例子:

```
ocal SYSTEM_64="rhel 6.0 x86_64 release"
local i="SYSTEM_64"
echo ${!i}
# output: rhel 6.0 x86_64 releasen
```

后者可以展开以 `var_prefix` 为前缀的所有变量名，把这两点结合起来也就能实现一个哈希数组的遍历：

```
local SYSTEM_32="rhel 6.0 x86 release"
local SYSTEM_64="rhel 6.0 x86_64 release"
for i in "${!SYSTEM_@}"
do
    echo ${!i}
done
```

这样实现的好处还是比较明显的：你可以不受到shell的一维数组的限制，实现多维数组。

参考： man bash "Parameter Expansion" 部分

## 一维变量元素检查 && 重新生成

```
${parameter:+word}
``` 

也许你也会像我一样，让脚本的传入一些文件名，并且还希望这些文件是必然存在的。可惜大部分时候并非如此，而且你也绝对不会希望因为使用者的错误输入而导致整个脚本朝着一个不可预期的方向前进。

当然，处理起来很简单，只需要循环test一次就可以解决，但是保存文件名的变量的重新生成也许就没有这么完美了，似乎没有简单的方法可以避免变量值中多出来的分割符？

bash会告诉你事实，并非如此，你只需要

```
var_name=${var_name:+${var_name} }${new_var}
```

就可以实现了

> 参考： man bash "Parameter Expansion" 部分

## $* 和 $@
这两个变量会展开所有的 __positional parameters__($0, $1, $2, etc...)，而如果他们在双引号内展开，展开的结果会非常不一样，但又不这么容易被察觉。

* `$*` 变量在双引号内展开之后，结果还是在一个双引号之内的字符串。
* `$@` 变量在双引号内展开之后，结果是多个被空格分隔的字符串。

如何发现他们的不同？试试看下面这个脚本，保存并传入多个参数后运行

```
#!/bin/bash
echo "Positional Parameters in $@"
for i in "$@"
do
    echo $i
done
echo "Positional Parameters in $@"
for i in "$*"
do
    echo $i
done
```

# 日志 && exec 信息流重导向

完善的log输出对出错后的问题定位的贡献是毋庸置疑的，但是如果在bash中运行了大量程序，可能你的屏幕会被搞的一团糟，这时候你可能会想到自定义信息流的重导向。

重导向？不想让它上屏？很简单啦，`1>/dev/null 2>&1`。但是这很麻烦诶，每个命令后面都要打一次吗？当然也不是啦，你可以 `{ cmd; cmd; cmd; } 1>/dev/null 2>&1` 将一个范围内的指令的输出给统一重导向掉。但但是，如果你认为这还是很麻烦，如果能像 perl 的 `select` 语句一样，把所有的默认输出都改到一个地方怎么办？那只能请出身为 __shell builtin__ 的 `exec` 大神啦。`exec`可以改变shell中默认的文件描述符。

这一部分内容在 [tldp][3] 上讲的特别清楚，他详细的讲述了什么是文件描述符 (file descriptor)，也告诉你了 bash 默认把 __0__ 号文件描述符打开为 __stdin__，__1__ 号打开为 __STDOUT__，__2__ 号打开为 __STDERR__。而正常的 __*nux__ 程序都会把标准输出导向 __&1__（表示一号描述符），把标准错误导向 __&2__。

[3]: http://tldp.org/LDP/abs/html/io-redirection.html "io redirection"

了解这些之后，生成有意义的输出就变得简单多了。

```
exec 6>&1 #将 &6 的输出，重定向到 &1, 此时的 &1 是 stdout
exec 7>&2 #将 &7 的输出，重定向到 &2, 此时的 &2 是 stderr
exec 1>/dev/null #将 &1 的输出，全部丢弃，（当然你也可以将它导入到一个文件做留档）
exec 2>/dev/null #同上
echo "This message will be directed to '/dev/null'"
echo "This message will be directed to STDOUT" >&6
```

# 工作目录切换 && 外部脚本引用

如果脚本里面需要用到 __相同目录下的其他脚本__，怎么办？虽然这个问题困扰了我挺久，但是解决起来还是比较方便的，只要在脚本开头切换工作目录即可

```
CWD="$( cd "$( dirname "$0" )" && pwd )"
cd $CWD
```

# 小结

bash 的功能很强大，写完这个 bash 脚本后，3000 多行的 bash 手册我也才翻熟了三分之一，shell 脚本虽小，但也能做到五脏俱全，能写完这个脚本，我打心底里感谢 __Funtoo Fundation__ 出品的 [__keychain__][4] 脚本，从里面获得了不少灵感。

[4]: http://www.funtoo.org/wiki/Keychain

<img class="alignnone" title="fly" src="https://lh3.googleusercontent.com/-cSo1Y6rDcl0/TmCORE-iaJI/AAAAAAAAAjw/wn295ulkR8E/s720/DSCF1599-1.JPG" alt="" width="554" height="369" />