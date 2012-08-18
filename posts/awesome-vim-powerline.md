---
title: Awesome Vim-PowerLine
date: '2012-08-13'
description: 让你呆板的 Vim 编辑器变成高富帅?
categories: 我的编辑器
tags: [Vim]
---
[1]: https://github.com/Lokaltog/vim-powerline/ "Lokaltog / vim-powerline"
[2]: https://github.com/Lokaltog/vim-powerline/tree/develop/fontpatcher
[3]: https://gist.github.com/1634235 "Monaco for vim-powerline"
[4]: {{urls.media}}/vim-powerline.png
[Pathogen]: https://github.com/tpope/vim-pathogen "tpope / vim-pathogen"
[Janus]: https://github.com/carlhuda/janus/ "carlhuda / janus"

让你呆板的 Vim 编辑器变成高富帅? -> [Vim-Powerline][1] 可以做到

如果你使用基于 [Pathogen][] 的 [Janus Vim Distribution][Janus] 管理 Vim 配置的话, 只需要运行这行即可.

	git clone https://github.com/Lokaltog/vim-powerline.git ~/.janus/vim-powerline

如果还想要更帅的效果, 那你就在 __vimrc__ 里面加上一行

	let g:Powerline_symbols = 'fancy'

接着你当然会发现效果似乎和图片里的不太一样. 因为它用到了一些不存在的字符, 你需要用它提供的 [fontpather][2] 对你需要的字体进行处理.

当然当然, 网络上已经提供了好些已经打好 patch 的字体, 比如 Mac 系统上最常用的 [Monaco for Vim-powerline][3], 把解压出来的文件放到 `~/Library/Fonts` 文件夹内, 然后在终端字体里面选择 __Monaco for vim-powerline__ 就能正常显示了.

![][4]
