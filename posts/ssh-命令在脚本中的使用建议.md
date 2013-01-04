---
title: ssh 命令在脚本中的使用建议
date: '2013-01-05'
description: ssh 命令在脚本中使用的时候与 cli 中使用有一些细节可以注意
categories: 我的 Linux
tags: [Linux]
uniq_id: '2013-01-05'
---
以下内容摘自 `man ssh_config`

### BatchMode

> 	If set to “yes”, passphrase/password querying will be disabled.  This option is useful in scripts and other batch jobs where no user is present to supply the password.  The argument must be “yes” or “no”.  The default is “no”.

如果你觉得与其让 ssh 命令跳出个输入密码的提示还不如让其自动失败, 那这个选项值得打开

### ConnectTimeout

> Specifies the timeout (in seconds) used when connecting to the SSH server, instead of using the default system TCP timeout.  This value is used only when the target is down or really unreachable, not when it refuses the connection.

别等这么久了, 你在处理本地环境的机器的时候, 要是一秒还没连上机器基本上再等十秒也不能给你太大帮助, 不如将这条超时调短

----

以下摘自 `man ssh`

### -n

> Redirects stdin from /dev/null (actually, prevents reading from stdin).  This must be used when ssh is run in the background.  A common trick is to use this to run X11 programs on a remote machine.  For example, ssh -n shadows.cs.hut.fi emacs & will start an emacs on shadows.cs.hut.fi, and the X11 connection will be automatically forwarded over an encrypted channel.  The ssh program will be put in the background.  (This does not work if ssh needs to ask for a password or passphrase; see also the -f option.)

我只想说括号里的这一点, 如果你配合 `while read` 的时候使用 ssh, 请务必加上 `-n` 选项, 否则 ssh 会读完你剩下的 __STDIN__ 缓冲区, 让你的下一个 while 循环直接结束

### 综上所述, 你可以这样用 ssh

	ssh -o ConnectTimeout=2 -o BatchMode=yes -n $host 'command'