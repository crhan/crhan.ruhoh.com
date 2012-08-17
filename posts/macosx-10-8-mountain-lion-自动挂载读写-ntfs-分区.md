---
title: MacOSX 10.8 Mountain Lion 自动挂载读写 ntfs 分区
date: '2012-08-10'
description: 使用 ntfs-3g 替换 macOSX 原生的 ntfs 自动挂载程序, 实现 macOSX 自动挂载读写的 ntfs 分区, Mountain Lion 测试可行.
categories: 我的苹果
tags: [MacOS]

---
[HomeBrew]: http://mxcl.github.com/homebrew/ "HomeBrew"
[MacPorts]:  http://www.macports.org/ "MacPorts"
[macVim]: http://code.google.com/p/macvim/ "macVim"
[Xcode]: http://itunes.apple.com/us/app/xcode/id497799835 "Xcode"
[iTerm2]: http://www.iterm2.com/ "iTerm2"
[Command Line Tools for Xcode]: https://developer.apple.com/downloads "Command Line Tools for Xcode"

使用 **ntfs-3g** 替换 macOSX 原生的 **ntfs** 自动挂载程序, 实现 macOSX 自动挂载读写的ntfs分区, **Mountain Lion** 测试可行.

需要以下准备:

1. [Command Line Tools for Xcode][] 或者 [Xcode][] (软件中心下载)
1. [HomeBrew][] 或者 [MacPorts][] (未验证)
1. 熟悉的文本编辑器一枚(我用 [macVim][], 也可用 [HomeBrew][] 安装)
1. 终端一只 (*spotlight* 搜索 *Terminal* 即可, 另外推荐下 [iTerm2][])

---

# 步骤 #
## 第一步 安装 HomeBrew

	/usr/bin/ruby <(curl -fsSk https://raw.github.com/mxcl/homebrew/go)

> 参考链接: [https://github.com/mxcl/homebrew/wiki/installation](https://github.com/mxcl/homebrew/wiki/installation "HomeBrew")

## 第二步 安装 ntfs-3g

	brew install ntfs-3g
	sudo /bin/cp -rfX $(brew --prefix fuse4x-kext)/Library/Extensions/fuse4x.kext /System/Library/Extensions
	sudo chmod +s /System/Library/Extensions/fuse4x.kext/Support/load_fuse4x

> 参考链接: [http://fuse4x.org/](http://fuse4x.org/ "fuse4x.org")

## 第三步 替换原生的挂载程序

	# 备份原有的挂载程序
	sudo mv /sbin/mount_ntfs /sbin/mount_ntfs.orig
	# 创建新的挂载程序并调整权限
	sudo touch /sbin/mount_ntfs
	sudo chmod 0755 /sbin/mount_ntfs
	sudo chown 0:0 /sbin/mount_ntfs
	# 编辑文件
	sudo mvim /sbin/mount_ntfs

输入以下内容:

    #!/bin/bash
    
    VOLUME_NAME="${@:$#}"
    VOLUME_NAME=${VOLUME_NAME#/Volumes/}
    USER_ID=501
    GROUP_ID=20
    TIMEOUT=20
    
    if [ `/usr/bin/stat -f "%u" /dev/console` -eq 0 ]; then
      USERNAME=`/usr/bin/defaults read /library/preferences/com.apple.loginwindow | /usr/bin/grep autoLoginUser | /usr/bin/awk '{ print $3 }' | /usr/bin/sed 's/;//'`
      if [ "$USERNAME" = "" ]; then
        until [ `stat -f "%u" /dev/console` -ne 0 ] || [ $TIMEOUT -eq 0 ]; do
          sleep 1
          let TIMEOUT--
        done
        if [ $TIMEOUT -ne 0 ]; then
          USER_ID=`/usr/bin/stat -f "%u" /dev/console`
          GROUP_ID=`/usr/bin/stat -f "%g" /dev/console`
        fi
      else
        USER_ID=`/usr/bin/id -u $USERNAME`
        GROUP_ID=`/usr/bin/id -g $USERNAME`
      fi
    else
      USER_ID=`/usr/bin/stat -f "%u" /dev/console`
      GROUP_ID=`/usr/bin/stat -f "%g" /dev/console`
    fi
    
	# 这里指向安装好的`ntfs-3g'文件
    /usr/local/bin/ntfs-3g \
      -o volname="${VOLUME_NAME}" \
      -o local \
      -o noappledouble \
      -o negative_vncache \
      -o auto_xattr \
      -o auto_cache \
      -o noatime \
      -o windows_names \
      -o user_xattr \
      -o inherit \
      -o uid=$USER_ID \
      -o gid=$GROUP_ID \
      -o allow_other \
      "$@" &> /var/log/ntfsmnt.log
    
    exit $?;

# 搞定

## 附加步骤: 万一你想复原

	sudo mv /sbin/mount_ntfs{.orig,}
	# 运行上面这段代码即可
	
## 	常见问题

如果你升级了 **Fuse4x**, 需要先卸载旧的内核扩展再进行上面的第二步. 首先确认一下那些基于 FUSE 的文件系统有没有跑着:

  mount -t fuse4x

接着卸载那些 FUSE 文件系统和内核扩展:

  sudo kextunload -b org.fuse4x.kext.fuse4x

> 参考资料: [NTFS WRITE SUPPORT ON OSX LION WITH NTFS-3G](	http://fernandoff.posterous.com/ntfs-write-support-on-osx-lion-with-ntfs-3g-f 'NTFS WRITE SUPPORT ON OSX LION WITH NTFS-3G')