---
title: 使用 xmodemap 工具使 Capslock 按键成为附加的 Ctrl 键
date: '2011-09-12'
description: Use xmodmap to make CapsLk an addtional Ctrl
categories: 我的 Linux
tags: [XModeMap]
---
结果很简单，过程很曲折，完整的代码如下，将其放入 `~/.Xmodmap` 中即可：

```
!add capsLK additional ctrl
remove lock = Caps_Lock
add control = Caps_Lock
keycode 66 = Control_L
```

PS: keycode 66 就是CapsLk键

> 参考资料：

> * [CSDN xmodmap修改键映射][1]
> * [Remap Caps Lock][2]

[1]: http://blog.csdn.net/lqk1985/article/details/5152115 "xmodmap修改键映射"
[2]: http://c2.com/cgi/wiki?RemapCapsLock "Remap Caps Lock"