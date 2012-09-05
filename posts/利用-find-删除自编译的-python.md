---
title: 利用 find 删除自编译的 Python
date: '2012-09-05'
description: 使用 find 检索出一段时间内创建的文件并删除
categories: 我的 Linux
tags: [Python, find]
---
以前编译 Python 的时候没有修改 `prefix`, 它默认就安装到 **/usr/local** 文件夹中, 导致后来想要清理掉这些文件的时候遇到了一点困难. 今天终于下定决心搞定了这个问题.

> 使用 **find** 命令找出那段时间创建的文件, 然后再将其删除

首先先确定 `/usr/local/bin/python` 文件的创建时间

	python_mtime=$(stat -c %Y /usr/local/bin/python)
	# 1345534652

然后确认现在时间和 Python 安装时间的时间差(单位是分钟)

	time_period_min=$(( ( $(date +%s) - python_mtime )/60 ))

最后就能确认出那一小段时间内被修改的文件

	find -newermt @$(( python_mtime -1 )) -mmin +$time_period_min | tee find.output

文件列表搞出来了你还删不掉吗.?

	cat find.output | xargs rm -rf

最后献上完整的脚本

	#!/usr/bin/env bash
	file_name=$1
	mtime=$(stat -c%Y $file_name)
	mtime_p_min=$(( ( $(date +%s) - mtime )/60 ))
	find . -newermt @$(( mtime -1 )) -mmin +$mtime_p_min | tee find.output