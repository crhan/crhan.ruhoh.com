---
title: 使用 Tmux 代替 Screen
date: '2012-08-16'
description:
categories: 我的 Linux
tags: [Tmux, Screen]
---
[1]: http://www.ibm.com/developerworks/cn/linux/l-cn-screen/ "linux 技巧：使用 screen 管理你的远程会话"
[Byobu]: https://launchpad.net/byobu/ "byobu"
[Screen]: http://www.gnu.org/software/screen/ "GNU Screen"
[tmux]: http://tmux.sourceforge.net/ "tmux is a terminal multiplexe"
[2]: {{urls.media}}/tmux_split_screen.png
[3]: https://wiki.freebsdchina.org/software/t/tmux?utm_source=twitterfeed&utm_medium=twitter "使用tmux"

我已经慢慢的开始使用 [tmux][] 来代替 [screen][] 和 [byobu][].

最初接触 screen 是因为看了 IBM DeveloperWorks 上的文章 [《linux 技巧：使用 screen 管理你的远程会话》][1]. Screen 刚安装好不做配置的时非常不好用, 所以后来出现了 Ubuntu 出品的 Screen 配置 wrapper: [Byobu][]. [Byobu][] 挺好用的, 不过它的问题是除了 ubuntu 以外, 没有其他系统把 [byobu][] 给做进默认仓库并且对它的版本更新做出及时的反应.

经过了这么两年的折腾之后, 我发现, 作为一个 SA, 顺手工具迁移性的难易成为了一个选择工具中的重要指标, 所以我才开始慢慢的向 Tmux 转移. Tmux 似乎是作为 screen 的替代品出现的, 大多数操作都很相似, 而且不需要配置也可以很舒服的使用. 另外 Tmux 还有一个很不错的特性叫分屏, 嗯, 如下图所示.

![][2]

列举一下常用的命令吧:

* `tmux`: 运行一个新的 tmux 窗口
* `tmux ls`: 查看已经在运行的 tmux 进程
* `tmux attach`: 附着(attach)已有的 tmux 进程

Tmux 默认的 Prefix 是 `C-b`, 如果已经很熟练 Screen 的话, 可以把 Prefix 换成 `C-a`, 只要在 __~/.tmux.conf__ 文件中写入:

	set-option -g prefix C-a
	unbind-key C-b
	bind-key C-a send-prefix

Tmux 到底应该怎么用? 你还是另外找资料把, 比如[这里][3]