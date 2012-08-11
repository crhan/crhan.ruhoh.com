---
title: 搭建 Girocco
date: '2011-12-16'
description: git hosting solution from from repo.or.cz
categories: 我的玩具
tags: []
---
# 起因


由于学校社团的开发团队开始慢慢扩张, 
为了避免自己被开发没日没夜的代码提交等问题困扰, 
所以决定找一个好用一点的版本控制软件和代码托管的网站. 
因为涉及的都是内部的代码, 再加上教育网到国外代码托管网站的速度太慢, 
所以寻找部署一个开源解决方案就变的异常重要. 
因为在 [dvcs][1] 里面我只会 [git][] , 
所以就选择了 [git][] 作为了我们的版本控制软件. 
最开始选择的Git代码托管方案是 [Gitolite][], 
因为所有的权限控制都需要修改特殊版本库 "__gitolite-admin__",
所以第一次给所有人开设账号变得 __非常麻烦__
( 比如先要普及关于公私钥对的知识等等). 
在使用了一段时间之后, 还遇到了如下问题:



* 用户随意建立的版本库无法自行删除 (似乎使用 [gitolite-adc][2]可以解决,但是尚未尝试 )
* 用户需要更新公钥时候必须麻烦管理员进行操作
* gitweb界面不够美观

所以尝试寻找一些新的解决方案, 在 [stackoverflow的帖子][3]
里面选择了看起来最简单的 [Girocco][] 进行尝试.

[Girocco][] 是 [repo.or.cz][] 采用的代码托管方案, 简单易用.
[Girocco][] 的 [介绍页面在此][4] . 在介绍中,他把自己与 [Gitorious][], [Github][], [Gitosis][] & [Gitolite][] 进行了对比, 称 [Gitolite][] 和 [Gitosis][] 根本不能算是一种 _hosting solution_, [Gitorious][] 又不能体现 _gitweb_ 的简约美, 而 [Github][] 不开源.

# 经过

## 第一步 检出代码 & 修改安装文件 

先把代码检出 `git://repo.or.cz/girocco.git` 按照 _INSTALL_ 文件的说明, 先按需修改 _Girocco/Config.pm_ 文件, 然后 `make install`

```
our $basedir = "/opt/Girocco/base";
our $reporoot = "/opt/Girocco/repo";
our $chroot = "/opt/Girocco/j";
our $webroot = "/opt/Girocco/WWW";
our $cgiroot = "/opt/Girocco/WWW";
our $webreporoot = "/opt/Girocco/WWW/r";
```

这时候出了点问题, 发现这个项目并不是这么完善. 我的搭建环境是:  
__'Gentoo hardened/linux/amd64/no-multilib 3.0.4-hardened-r4'__


_Girocco_ 提供的 _jailsetup.sh_ 中的 __shabong__ 是 __/bin/sh__ 然后在第七行写着 `. shlib.sh` 结果运行中提示 __file not found__ 错误. 后来尝试性的改成了 `. ./shlib.sh` 就找到这个文件了, 这是第一个没有良好兼容性的问题.

重新运行, 接着又提示找不到 __git-index-pack__

```
for i in git git-index-pack git-receive-pack git-shell git-update-server-info git-upload-archive git-upload-pack git-unpack-objects; do
    pull_in_bin /usr/bin/$i bin
done
```

接着我在 _/usr/libexec/git-core/_ 里面找到了所有的文件, 于是把循环体改成了 `pull_in_bin /usr/libexec/git-core/$i bin`

还有一处改动也在类似的位置, 他又写死了 __nc__ 的路径 `/bin/nc.openbsd`, 只好根据 _gentoo_ 的设定, 把他改成了 `/usr/bin/nc`

最后还要修改一个脚本变量, 在 __jobs/fixupcheck.sh__ 的第15, 17行, 将两个变量改成与 __Girocco/Config.pm__ 中的设定一致

```
reporoot="/opt/Girocco/repo"
chroot="/opt/Girocco/j"
```

然后把他复制到 __/root__ 目录下

	cp jobs /root/repomgr -r

## 第二步 设置 apache 服务器

设置 _apache_, 没有什么难点, 就根据第一步中设置的 _Girocco/Config.pm_ 设置修改他提供给你的 __apache.conf__ 文件即可.

## 第三步 设置 chroot 环境

### a. 自动挂载repo目录至 chroot 环境

```
cat >> /etc/fstab <<EOF
/proc /opt/Girocco/j/proc none defaults,bind 0 0
/opt/Girocco/repo /opt/Girocco/j/srv/git none defaults,bind 0 0
EOF
mount -a
```

### b. 让 syslog-ng 监听 chroot 的 log 设备

在 __/etc/syslog-ng/syslog-ng/conf__ 的 __source__ 部分加上额外的监听, 并重启进程:

```
source jail1{
    unix-stream("/opt/Girocco/j/dev/log");
};
```

> 参考资料: [syslog-ng faq][5]

## c. 启动 chroot 中的 sshd, 监听 git 请求

因为启动 sshd 的时候他总是告诉我找不到 __/etc/ssh/ssh_host_ecdsa_key__ 文件, 要给他强制指定一个 _RSA key_: 在 _sshd_ 的配置文件 __/opt/Girocco/j/etc/ssh/sshd_config__ 加上一行

	HostKey /etc/ssh/ssh_host_rsa_key

然后还提示缺少 __/var/empty__ 文件夹

	mkdir /opt/Girocco/j/var/empty


最后启动 _sshd_

	chroot /opt/Girocco/j /sbin/sshd


## 第四步 添加 crontab

使用命令 `crontab -e 添加两个任务

	*/2  * * * * /usr/bin/nice -n 18 /root/fixupcheck.sh # adjust frequency based on number of repos
	*/30 * * * * /usr/bin/nice -n 18 /opt/Girocco/base/jobd/jobd.sh -q --all-once


## 完成

---

# 结果

搭建完了才发现, 我们其实并不需要一个权限这么开放的系统, 就现在而言, [Girocco][] 并没有显示出比 [Gitolite][] 好得多的优越性, 还不足以驱动我去把已有的 [Gitolite][] 给替换掉

遗憾之余只好决定把这段经历记录下来, 以慰藉我失去的那 <big>__5个小时__</big>时光

[![]({{urls.media}}/girocco_crhan.jpeg)](http://www.flickr.com/photos/cncrhan/6572992149/)



[1]: http://en.wikipedia.org/wiki/Distributed_Version_Control_System
[2]: http://www.worldhello.net/2011/11/30/05-gitolite-adc.html
[3]: http://stackoverflow.com/questions/438163/whats-the-best-web-interface-for-git-repositories "What's the best Web interface for Git repositories?"
[4]: http://repo.or.cz/w/girocco.git/blob/HEAD:/README
[5]: http://www.campin.net/syslog-ng/faq.html#chroot
[git]: http://git-scm.com/
[Gitolite]: http://www.ossxp.com/doc/git/gitolite.html
[Girocco]: http://repo.or.cz/w/girocco.git/
[repo.or.cz]: http://repo.or.cz/
[Gitorious]: http://gitorious.org/
[Github]: https://github.com
[Gitosis]: http://progit.org/book/zh/ch4-7.html