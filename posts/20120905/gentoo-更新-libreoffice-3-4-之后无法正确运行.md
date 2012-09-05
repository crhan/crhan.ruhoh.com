---
title: Gentoo 更新 libreoffice-3.4 之后无法正确运行
date: '2011-06-15'
description: 解决的方法很简单，参考 gentoo-user 用户组的提示，原因在这几个 libreoffice 程序的 desktop 执行脚本的 Exec 是错误的。应为 "libreoffice"，而在文件里面写的是 "libreoffice3.4"。那么解决方法就是将其都修改成 libreoffice 或者在 "/usr/bin"，下面添加一个软链接也可。
categories: 我的 Linux
tags: [Gentoo]
---
前几天更新了 libreoffice3.4 之后居然无法开启 office 程序，运行的时候提示

> Failed to execute child process "libreoffice3.4" (No such file or directory).

解决的方法很简单，参考 [gentoo-user][1] 用户组的提示，原因在这几个 libreoffice 程序的 desktop 执行脚本的 Exec 是错误的。应为 "libreoffice"，而在文件里面写的是 "libreoffice3.4"。那么解决方法就是将其都修改成 libreoffice 或者在 "/usr/bin"，下面添加一个软链接也可。

[1]: https://groups.google.com/d/topic/linux.gentoo.user/NtVmtpmUIqk/discussion "gentoo user 用户组"

批量修改运行脚本：

	sed -i 's/\(libreoffice\)3.4/\1/' /usr/share/applications/libreoffice-*

建立软链接：

	ln -s libreoffice /usr/bin/libreoffice3.4
