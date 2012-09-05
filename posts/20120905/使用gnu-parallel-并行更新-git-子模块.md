---
title: 使用GNU parallel 并行更新 git 子模块
date: '2011-09-14'
description: 如果你像我一样使用 pathogen 来管理你的 vim 插件，并且在 .vim/bundle/ 文件夹下面添加了好多个  submodule 的话，这个技巧应该对你有点帮助。
categories: 我的编辑器
tags: [Vim]
---
[1]: http://www.vim.org/scripts/script.php?script_id=2332 "pathogen"

如果你像我一样使用 [pathogen][1] 来管理你的 vim 插件，并且在 __.vim/bundle/__ 文件夹下面添加了好多个 __git submodule__ 的话，这个技巧应该对你有点帮助。

这里用到了GNU的 parallel 工具，如果你是 gentoo ，那你可以通过 `moreutils` 包来获得它。

	emerge moreutils

用法很简单，这里就直接给出可用的脚本了，将下面的脚本放到git的根目录下运行即可

	#!/bin/sh
	PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"
	CWD=$( cd $(dirname $0) && pwd )
	sub_modules=$(git submodule status |awk '{print $2}')
	 
	if [ -n "$sub_modules" ]
	then
	    if [ -x "$(which parallel)" ];then
	        parallel -i sh -c "cd {};pwd;git pull" -- $sub_modules
	    else
	        echo ' * Error： Util `Parallel` not found'
	    fi
	else
	    echo " * Error: Not any git submodules find"
	fi
