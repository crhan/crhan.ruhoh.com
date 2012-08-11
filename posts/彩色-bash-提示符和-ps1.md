---
title: 彩色 Bash 提示符和 $PS1
date: '2011-09-10'
description: Color Bash Prompt and $PS1
categories:
tags: [Bash, PS1]
---
今天又折腾了一下自己的PS1，蓝本是从 [TX主席][1] 那里弄来的。

[1]: http://imtx.me/archives/1298.html
修改的地方有：

* 在 shell prompt 之前增加了一个换行
* 当前工作目录的显示换成了始终显示完整路径
* 修改了一些颜色

```
\n\[\e[01;37m\][`a=$?;if [ $a -ne 0 ]; then echo -n -e "\[\e[01;32;41m\]{$a}"; fi`\[\033[01;32m\]\u\[\033[01;33m\]@\[\033[01;35m\]\h\[\033[00m\] \[\033[01;34m\]`pwd``B=$(git branch 2>/dev/null | sed -e "/^ /d" -e "s/* \(.*\)/\1/"); if [ "$B" != "" ]; then S="git"; elif [ -e .bzr ]; then S=bzr; elif [ -e .hg ]; then S="hg"; elif [ -e .svn ]; then S="svn"; else S=""; fi; if [ "$S" != "" ]; then if [ "$B" != "" ]; then M=$S:$B; else M=$S; fi; fi; [[ "$M" != "" ]] && echo -n -e "\[\e[33;40m\]($M)\[\033[01;32m\]\[\e[00m\]"`\[\033[01;34m\]\[\e[01;37m\]]\n\[\e[01;34m\]$ \[\e[00m\]
```

同样，我的bashrc，vimrc，vim插件，gentoo的配置，也都在 [Github 里][2] 可以随意查阅。

[2]: https://github.com/crhan/myconf

效果图如下:

![]({{urls.media}}/PS1.png)
