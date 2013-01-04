---
title: 善于使用 bash builtin -- read
date: '2013-01-04'
description: 工作半年的一些小积累
categories: 我的 Linux
tags: [Linux]
uniq_id: '2013-01-04'
---
正确的在脚本中使用 while read 可以得到诸多好处, read 命令从标准输入中取得输入存入变量. 使用 read 的脚本都可以获得 linux pipe 的所有优点.

## 将你的脚本放入管道

	while read host ip; do
		echo "$host ip is $ip";
	done

比如这个脚本名叫 `echo_host_ip.sh`.  再有一个文件 `host_info`, 每行都是主机名和 IP 的对应关系. 

	host1 1.2.3.4
	host2 2.3.4.5
	host3 3.4.5.6

## 你可以这样用

* linux 管道: `cat host_info | ./echo_host_ip.sh`

* bash 标准输入导入 `./echo_host_ip.sh < host_info`

* 直接在 bash 中输入一条信息测试 `./echo_host_ip.sh <<< 'host4 4.5.6.7'`