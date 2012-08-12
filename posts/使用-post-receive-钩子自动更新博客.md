---
title: 使用 post-receive 钩子自动更新博客
date: '2012-08-12'
description: Ruhoh 这个新生的东西还在缓慢的发展之中, 所以还没有成熟的 Hosting 方案出台, 官方只提供了一个基于 USERNAME.ruhoh.com 的三级域名下的托管方案. 不过幸运的是, 在 Jekyll Custom Deploy Options 的帮助下, 我对 Jekyll 提供的 Post-receive hook 稍微修改之后就能直接使用了. 下面直接上干货
categories: 我的博客
tags: [Ruhoh, Git, Bash]
---

[Ruhoh][] 这个新生的东西还在缓慢的发展之中, 所以还没有成熟的 Hosting 方案出台, 官方只提供了一个基于 __USERNAME.ruhoh.com__ 的三级域名下的托管方案. 不过幸运的是, 在 [Jekyll Custom Deploy Options][1] 的帮助下, 我对 [Jekyll][] 提供的 [_Post-receive hook_][2] 稍微修改之后就能直接使用了. 下面直接上干货:

[1]: https://github.com/mojombo/jekyll/wiki/Deployment "Deployment"
[Jekyll]: http://jekyllrb.com/
[Ruhoh]: http://ruhoh.com/
[2]: http://www.kernel.org/pub/software/scm/git/docs/githooks.html#post-receive "githooks(5) Manual Page"

	#!/bin/bash
	export PATH=$HOME/bin:$HOME/.rvm/bin:$PATH
	[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
	
	GIT_REPO=$HOME/ruhoh_blog/repo/crhan
	TMP_GIT_CLONE=`mktemp -d`
	PUBLIC_WWW=$HOME/ruhoh_blog/www/blog.crhan.com
	
	git clone $GIT_REPO $TMP_GIT_CLONE
	cd $TMP_GIT_CLONE
	ruhoh compile $PUBLIC_WWW
	rm -Rf $TMP_GIT_CLONE
	exit

说明一下, 因为我是用 [RVM][] 安装的 Ruby, 所以需要在二三两行先应用一下 [RVM][] 设置.

另外还有一点__很重要__: 如果第一行的 shebang 写的是 `#!/bin/sh` 的话, [RVM][] 会无法载入, 这大抵是兼容性问题

> 参考资料: [Jekyll Deployment Post-receive Hook][1]

[RVM]: https://rvm.io/ 