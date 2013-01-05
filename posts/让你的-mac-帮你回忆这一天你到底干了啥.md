---
title: 让你的 Mac 帮你回忆这一天你到底干了啥?
date: '2013-01-05'
description:
categories: 我的苹果
tags: [MacOS]
uniq_id: '2013-01-05-2'
---
MacX 下的截屏实际上是调用了 `/usr/sbin/screencapture` 这个程序, 所以只要写个脚本定时跑就行了.

	#!/usr/bin/env bash
	echo $PATH
	dir="$HOME/Pictures/screen" # 存在这个位置
	[[ ! -d $dir ]] && mkdir -p $dir
	cd $dir
	filename="$(date +%Y%m%d-%H%M).png"
	/usr/sbin/screencapture -o -x $dir/$filename # 截屏!
	sips -Z 800 $dir/$filename # 优化一下大小, 缩小成 800px 宽
	find $dir -ctime 1 -name '*.png' -type f -delete # 删除一天以上的截图

脚本取名叫 `screenshot.sh`, 放在用户目录下的 `bin` 目录, 然后把它加入 crontab: `crontab -e`

	*/2 * * * * bash ~/bin/screenshot.sh  >> /tmp/screenshot.log 2>&1

这样就能每两分钟截图一次并保存在你的 `Pictures/screen` 文件夹下啦.