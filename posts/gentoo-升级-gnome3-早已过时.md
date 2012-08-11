---
title: Gentoo 升级 Gnome3 (早已过时)
date: '2011-05-22'
description: Gentoo 里面升级到 Gnome3 还是比较方便的，只要添加 gnome 的 overlay，然后更新就可以完成了，下面是一点点详述
categories: 我的 Linux
tags: [Gentoo, Gnome]
---
## <ins datetime="2012-08-11T12:23:43+00:00">__本文内容早已过时__</ins>
-----

Gentoo 里面升级到 Gnome3 还是比较方便的，只要添加 gnome 的 overlay，然后更新就可以完成了，下面是一点点详述

```
# 安装 layman
emerge layman

# 添加 gnome overlay
layman -a gnome

# 添加 overlay 配置
echo "source /var/lib/layman/make.conf" >> /etc/make.conf

# 让 eix-sync 自动更新所有 layman 里的 overlay
echo "*" >> /etc/eix-sync.conf

# 更新 portage 树
eix-sync

# 用 gnome overlay 提供的文件 unmask 所有 gnome3 相关的包
[ -d /etc/portage/profile/ ] || mkdir -p /etc/portage/profile/
ln -sf /var/lib/layman/gnome/status/portage-configs/package.use.mask.gnome3 /etc/portage/profile/package.use.mask
ln -sf /var/lib/layman/gnome/status/portage-configs/package.unmask.gnome3 /etc/portage/profile/package.unmask


# 升级
emerge -uDav world

# 根据提示进行操作，该mask的mask，该unmask的unmask，gentoo的提示很完善，跟着做就ok了。
```

在这些步骤里面只有一件事情碰到了一点困难，就是更新 evolution3.0 的时候居然编译失败，错误显示是被 /usr/lib64/libebook-1.2.so 所引用的 /usr/lib64/libcamel-1.2.so.19 找不到。去irc上面求助之后终于解决。

这是因为 evolution-data-server 有点坏掉了，将它 re-emerge 之后就 ok 了。当然确定是这个包的问题也用到了一个小技巧，就是 `qfile libcamel-1.2.so`。这个命令会告诉你包含这个文件的包，是由此而确定到 evolution-data-server 的。

还有一件事情就是终于弄懂了 emerge 的时候有些 USE flag 被括号包围怎么去除括号： 添加到 __/etc/portage/profile/package.use.mask__ 中，比如像这样：`gnome-base/gconf -introspection`。

现在就是还有一个小问题，首先是 pidgin 对 gnome3 的信息机制支持不是特别的好，然后我就想换用 empathy。但是 empathy 的 Accounts 页面显示不出来，并且 "System Settings" 里面的 "Messages and VoIP Management" 页面也是显示空白<del>，暂时还没有解决</del>。

<span style="color: #ff6600;">__2011-06-15更新：__</span><ins datetime="2011-06-15T12:23:43+00:00">解决方法是，给 "net-voip/telepathy-connection-managers" 添加USE FLAGS，然后重新编译这个程序即可</ins>

> 参考文章：

> * [Install GNOME3 on Gentoo Linux][1]
> * [Gentoo Overlays: Users' Guide][2]

[1]: http://bone.twbbs.org.tw/blog/archives/2139 "Install GNOME3 on Gentoo Linux." 
[2]: http://www.gentoo.org/proj/en/overlays/userguide.xml#doc_chap2 "Gentoo Overlays: Users' Guide"