---
title: 使用 Alfred 代替系统自带 Spotlight
date: '2012-09-04'
description: Alfred 是使用系统 Spotlight 相同的索引的桌面搜索服务.
categories: 我的苹果
tags: [MacOS, Alfred]
---
首先明确一点, Alfred 使用的是与 SpotLight 相同的系统索引, 所以千万别用 `sudo mdutil -a -i off` 把系统的文件索引给关了哦.

首先在 System Preferences -> Spotlight 里面去掉 Spotlight 的全局快捷键 

![][11]

接着去掉顶栏右边的放大镜

	sudo chmod 600 /System/Library/CoreServices/Search.bundle/Contents/MacOS/Search
	# 重启系统 UI
	killall SystemUIServer


然后下载 [Alfred][], 修改快捷键到 Spotlight 原有的默认快捷键 `<c-space>`

最后确认一下 Alfred -> Alfred Preferences -> Advanced -> Keyboard -> Force Keybord 是不是 U.S. 键盘. 这个功能可以强制指定使用 Alfred 时使用的输入法

[Alfred]: http://www.alfredapp.com/ "Alfred"
[11]: {{urls.media}}/disable_spotlight_shortcut.png