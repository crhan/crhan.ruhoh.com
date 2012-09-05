---
title: 在 Mac 10.8 下使用 Passenger & Rvm 的 Rails 应用部署
date: '2012-08-17'
description: 本文在 MacOSX 10.8 MountainLion 下测试通过 -- 在 Mac 10.8 下使用 Passenger & Rvm 的 Rails 应用部署
categories: 我的苹果
tags: [Passenger, Rvm]
---
[1]: http://blog.ninjahideout.com/posts/a-guide-to-a-nginx-passenger-and-rvm-server "A Guide to a Nginx, Passenger and RVM Server"
[2]: https://github.com/mxcl/homebrew/wiki/Installation "InstallationNew Page Edit Page Page History"
[3]: http://trevorturk.com/2010/09/22/passenger-with-nginx-on-mac-os-x-2nd-edition-2/ "Passenger with nginx on Mac OS X (2nd edition)"
[Installing Rvm]: https://rvm.io/rvm/install/ "Quick (guided) Install"
[Passenger]: http://www.modrails.com/ "Phusion Passenger"
[Nginx]: http://nginx.org/ "nginx [engine x] is an HTTP and reverse proxy server, as well as a mail proxy server"
[Homebrew]: http://mxcl.github.com/homebrew/ "The missing package manager for OS X"


> 本文在 MacOSX 10.8 MountainLion 下测试通过

## 安装 Homebrew

嘿, 先安装 [Homebrew][] 不需要我再介绍了把?

	ruby <(curl -fsSkL raw.github.com/mxcl/homebrew/go)

> 参考资料: [Homebrew Install][2]

## 安装 RVM

RVM 是 ruby 的环境隔离工具

	curl -L https://get.rvm.io | bash -s stable --ruby

> 参考资料: [Installing RVM][]

## 用 Gem 安装 Passenger

[Passenger][] 是在 apache 或 nginx 上面部署 Rack 应用的程序

	gem install passenger

> 参考资料: [Passenger with nginx on Mac OS X (2nd edition)][3]

这里还需要创建专门给 Passenger 用的, 包含 RVM 完整路径信息的专用 Ruby => `passenger_ruby`

	rvm wrapper passenger

## 用 Homebrew 安装 nginx

[Nginx][] 是一个轻量快速流行的网页服务器

	brew install nginx --with-passenger

检查一下 Passenger 模块

	nginx -V 2>&1 | grep passenger

## 给 Nginx 配置 Passenger

`nginx.conf`:

	worker_processes 1;
	user crhan _www;

	events {
	  worker_connections 1024;
	}

	http {
	  include mime.types;
	  default_type application/octet-stream;
	  sendfile on;
	  keepalive_timeout 65;

	  passenger_root /Users/crhan/.rvm/gems/ruby-1.9.3-p125/gems/passenger-3.0.15;
	  passenger_ruby /Users/crhan/.rvm/bin/passenger_ruby;

	  server {
	    listen 80;                   
	    server_name redmine.local;   
	    root /Users/crhan/src/redmine/public;
	    passenger_enabled on;
	    rack_env production;         
	  }
	}

* 配置中的 passenger_root 替换成 `passenger-config --root` 的值
* 配置中的 passenger_ruby 替换成 `which passenger_ruby` 的值

> 参考资料: [A Guide to a Nginx, Passenger and RVM Server][1]

## 测试 Nginx 并启动

	sudo nginx -t # 测试 nginx 配置
	sudo nginx #启动
