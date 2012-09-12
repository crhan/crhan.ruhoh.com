---
title: Ruhoh Plugin 第二弹 -- Sitemap Generator
date: '2012-09-07'
description: 实现一个对 Google Webmaster 友好的 Sitemap Generator
categories: 我的博客
tags:
  - Ruby
  - Ruhoh

type: draft
---
网站地图(Sitemaps)是一个让搜索引擎了解你站点所有可抓取网页的最快方法. 网站地图是一个列出 URL 以及像是最后修改时间, 更新频率, 重要度, 关联度这些信息的 XML 文件. 所以它可以让搜索引擎更加智能的抓取你的站点.

我根据 [sitemaps.org][1] 的标准写了这个 Sitemap Generator. 该文档要求每个页面都需要有

 - `<loc>`: 用以描述网页的位置

可以有

 - `<lastmod>`: 用 [W3C Datetime][5] 或者 *YYYY-MM-DD* 来描述最后修改时间
 
 - `<changefreq>`: 可用以下几种内容来描述该页面的更新频率

   - always
   - hourly
   - daily
   - weekly
   - monthly
   - yearly
   - never

 -  `<priority>`: 用来描述同一站点里面页面的相对权重, 默认 0.5 (意在通过搜索引擎搜出你自己站点多个页面的时候可以通过这个属性进行自定义排序, 权重大的排在前面. 你设得再大也不能跑到别人前面去啦)

参考了 [ruhoh.rb][2] 的 [rss.rb][3] 用的 `Nokogiri::XML::Builder` 搞成的简易工具. 顺便还支持了一些小的自定义, 具体的还请移步 [Ruhoh Sitemap Generator][4]

[1]: http://www.sitemaps.org/protocol.html#xmlTagDefinitions "Sitemaps XML format"
[2]: https://github.com/ruhoh/ruhoh.rb/ "http://ruhoh.com"
[3]: https://github.com/ruhoh/ruhoh.rb/blob/master/lib/ruhoh/compilers/rss.rb "rss.rb"
[4]: https://gist.github.com/3705998 "Ruhoh Sitemap Generator"
[5]: http://www.w3.org/TR/NOTE-datetime