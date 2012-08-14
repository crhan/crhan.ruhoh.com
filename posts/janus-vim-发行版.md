---
title: Janus -- Vim 发行版
date: '2012-08-13'
description: Janus -- 这是一个 Vim(Gvim & MacVim) 插件和键映射的发行版, 它可以提供一个最简的工作环境, 并且包含了大多数著名的插件和最常用的键映射
categories: 我的编辑器
tags: [Vim]
---
[Janus][] 的首页是这么介绍它自己的: 

> Janus: Vim 的发行版

> 这是一个 Vim(Gvim & MacVim) 插件和键映射的发行版

> 它可以提供一个最简的工作环境, 并且包含了大多数著名的插件和最常用的键映射

> 这个发行版可以通过 `~/.vimrc.before` 和 `~/.vimrc.after` 配置来自定义 Vim RC 文件

在 Mac 和 Linux 下面安装 [Janus][] 很简单:

	curl -Lo- https://bit.ly/janus-bootstrap | bash

因为 Janus 是使用 [Pathogen][] 加载插件的, 并且自动加载 `~/.janus` 文件夹下的插件, 所以制作一个可以方便迁移的 vim 配置只要在 github 上面新建一个叫做 `.janus` 的项目, 然后同步即可.

	git clone https://github.com/crhan/.janus/ ~/.janus

然后写了一个[小脚本][1]放在 `.janus` 里面, 以供每次初始化用:

	#!/usr/bin/env bash
	CWD=$(cd $(dirname $0) && pwd )
	cd $CWD
	for i in vimrc* gvimrc*
	do
	  ln -sf $CWD/$i ~/.$i
	done
	git submodule init
	git submodule update

[Pathogen]: https://github.com/tpope/vim-pathogen "tpope / vim-pathogen"
[Janus]: https://github.com/carlhuda/janus "carlhuda / janus"
[1]: https://github.com/crhan/.janus/blob/master/mklink.sh