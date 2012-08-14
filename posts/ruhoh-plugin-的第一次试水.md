---
title: Ruhoh Plugin 的第一次试水
date: '2012-08-11'
description: 由于 Ruhoh 的设计, 没法通过添加文章或者页面的方式来实现认证, 但是可以通过 Plugin 的方式来搞定, 并且还可以将这个设置添加到网站配置中. Let's Do it.
categories: 我的博客
tags: [Ruhoh, Ruby]
---
比起使用现成的博客大巴, 自己搭 [WP][] 博客起来会有很多乐趣 (以及麻烦), 而像用 [Jekyll][] 或者我现在正用着的 [Ruhoh][] 从头设计一个博客的结构, 则又有另外一番收获和体验.


这次 Ruhoh 插件的首次试水的目标是增加 [Google WebMaster][] 的认证支持. 这种认证很简单, 只需要登陆 [GWM][Google WebMaster] 然后添加网站, 然后在目标网站根目录下放置 Google 提供的文件即可. 

由于 [Ruhoh][] 的设计, 没法通过添加文章或者页面的方式来实现认证, 但是可以通过 [Plugin][] 的方式来搞定, 并且还可以将这个设置添加到网站配置中. 只需要两步:

# 两步走起!

1. 新建 __plugins__ 文件夹, 并在里面新建 '[google\_site\_verification.rb][]' 文件并输入以下内容:


	```
	class Ruhoh
	  module Compiler
	    module GoogleSiteVerification
	      def self.run(target, page)
	        google_verify = Ruhoh::DB.payload.dup["site"]["google_site_verification"]

	        if google_verify
	          FileUtils.cd(target) do
	            File.open("#{google_verify}.html", 'w:UTF-8') do |p|
	              p.puts "google-site-verification: #{google_verify}.html"
	           end
	          end
	        end
	      end
	    end
	  end
	end
	```

2. 在 '[/site.yml][]' 里面加入一行属性(属性左侧必须没有空格, 也就是必须是第一级属性, 详参 [YAML][]) `google_site_verification: googlef056ebc4b89ca27a` (该值就是 Google 要求下载的文件名)

	![Google 网站管理员工具-验证网络所有权][3]

---

# 下一步计划?

1. 导入以前 [WordPress 博客](b.crhan.com) 上面的文章
2. 研究一下 [Atom RSS][1] 并且想办法输出这种 RSS, 然后使用 [feedBurner][2] 来支持 [PubHubSubBub][]
3. 研究一下如何让 [Google Reader][] 可以直接通过添加首页的方式找到本博客的 RSS 源
4. 重新设计页面

[1]: http://en.wikipedia.org/wiki/Atom_(standard) "Atom RSS"
[2]: http://feedburner.google.com/ "Feed Burner"
[3]: {{urls.media}}/google_site_verify.png "Google 网站管理员工具-验证网络所有权"
[PubHubSubBub]: https://code.google.com/p/pubsubhubbub/ "A simple, open, web-hook-based pubsub protocol & open source reference implementation."
[Google Reader]: https://www.google.com/reader
[google\_site\_verification.rb]: https://github.com/crhan/crhan.ruhoh.com/blob/babaaac3a5630dbceeedc96c4bfe5ea10a46016c/plugins/google_site_verification.rb "/plugins/google_site_verification.rb"
[plugin]: http://ruhoh.com/usage/plugins/ "Ruhoh Plugins"
[WP]: http://wordpress.org/ "WordPress"
[Jekyll]: http://jekyllrb.com/ "Jekyll"
[Ruhoh]: http://ruhoh.com/ "Ruhoh"
[Google WebMaster]: http://webmaster.google.com/ "Google WebMaster"
[/site.yml]: https://github.com/crhan/crhan.ruhoh.com/blob/babaaac3a5630dbceeedc96c4bfe5ea10a46016c/site.yml#L17 "/site.yml"
[YAML]: http://www.yaml.org/ "YAML Ain't Markup Language"