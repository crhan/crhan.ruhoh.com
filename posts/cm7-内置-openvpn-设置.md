---
title: CM7 内置 openvpn 设置
date: '2011-05-04'
description: CM7早已内置了openvpn的功能，但是似乎在官网上面没有写明如何使用，这给我的openvpn设置带来了一点麻烦. 不过还好, 使用 pkcs12 格式文件就能解决这个问题
categories: 我的手机
tags: [Android, Openvpn]
---
CM7 早已内置了 openvpn 的功能，但是似乎在官网上面没有写明如何使用，这给我的openvpn 设置带来了一点麻烦，因为我 openvpn 总共有四个文件：ca.crt, client.crt, client.key 和 client.ovpn，我找不到地方能把它们全部添加进 android 的存储凭证中。不过还好 [@dickeny][1] 给了我一点提示:
可以把几个证书文件打包成 [pkcs12][4] 格式放入 SD 卡中。接着就找到了篇文章参考: [CyanogenMod OpenVPN GUI – how to load keys&certs][2](_已404_),
还有openvpn上的文件功能解释：[OpenVpn HOWTO][3]。

[1]: https://twitter.com/#!/dickeny/status/65096019158904835
[2]: http://olorin.info/blog/2010/03/cyanogenmod-openvpn-gui-how-to-load-keyscerts
[3]: http://openvpn.net/index.php/open-source/documentation/howto.html#pki
[4]: http://en.wikipedia.org/wiki/PKCS12

简单的描述一下：

1. 准备好openvpn所需要的四个文件（可以没有其中的client.ovpn）
1. 制作pkcs12包  
  `openssl pkcs12 -export -in client.crt -inkey client.key	-certfile ca.crt -name nameYouWant -out packName.p12`
1. 将pkcs12包放进SD卡
1. 进入 设置 --> 位置和安全 --> 凭证存储 --> 从SD卡安装 --> 选择pkcs12包</li>
1. 进入 设置 --> 无线和网络 --> 虚拟专用网设置 --> 添加虚拟专用网DONE!

一般的openvpn的连接信息（IP地址，端口，协议等）均在ovpn文件里面有描述，或者向vpn提供商询问即可。

> 参考文章: [CyanogenMod OpenVPN GUI – how to load keys&certs][2]
