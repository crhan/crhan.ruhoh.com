---
title: 使用 udev 解决小红点的移动速度问题
date: '2011-05-04'
description: Thinkpad 启动时自动设置 trackpoint 的 speed 和 sensitivity 的完美解决
categories: 我的 Linux
tags: [Thinkpad, udev, Gentoo]
---
[ThinkWiki]: http://www.thinkwiki.org/wiki/How_to_configure_the_TrackPoint#Sensitivity_.26_Speed "Sensitivity and Speed"
[udev]: http://en.wikipedia.org/wiki/Udev "the device manager for the Linux kernel"
[rules]: http://www.reactivated.net/writing_udev_rules.html "writing udev rules"
[1]: http://renkai.org/2011/08/linux%E4%B8%8Bthinkpad%E5%B0%8F%E7%BA%A2%E7%82%B9%E7%9A%84%E9%80%9F%E5%BA%A6%E5%92%8C%E7%81%B5%E6%95%8F%E5%BA%A6%E8%AE%BE%E7%BD%AE/ "linux下thinkpad小红点的速度和灵敏度设置"

用小黑的朋友们最爱的就是小红点了吧，但是小红点的移动速度对于大多数人来讲确实是有一点慢，那么当然需要将它调教的更灵敏一些咯。本篇先介绍了如何手动修改小红点的两项属性，接着介绍了如何使用 udev rules 来让小红点被检测到的时候自动设置属性。

# 如何设置 #

其实很简单咯，在 [ThinkWiki][] 上面就给出最简单的解决方案：

```
echo -n 120 > /sys/devices/platform/i8042/serio1/serio2/speed
echo -n 250 > /sys/devices/platform/i8042/serio1/serio2/sensitivity
```

这个操作一定要拥有 root 权限，如果只是 sudo 的话只能提升 echo 的权限，然后就会因为重导向（redirection）的权限不足而无法修改。

想必你一定不会满足于每次启动都使用 root 权限运行这两行指令，
那么如何自动在启动时候修改这两个值就是一个问题:
放在 rc.local 中？有些人成功了，而大多数人都失败了。
原因大抵是 rc.local 文件执行的时候小红点还没有被检测到，
也就是说上述的对应文件还没有产生，所以所有操作都变成了徒劳。

# 如何启动自动设置？#

这里我采用的方法是写 [udev][] 的 rules，
同样在 [ThinkWiki][]上也有说明：但是对于我的 udev r151 来说，wiki上的配置并不可行，可能是因为udev的rules规则修改了。
接着我参考了 dsd 的 [Writing udev rules][rules]，在/etc/udev/rules.d里添加一个规则文件，比如叫做 __10-trackpoint.rules__。内容：

```
SUBSYSTEM=="serio", DRIVERS=="psmouse", ENV{SERIO_TYPE}=="05", WAIT_FOR="/sys/devices/platform/i8042/serio1/serio2/sensitivity", ATTR{sensitivity}="156", ATTR{speed}="255"
```

这一条的意思是如果匹配到了前面三条，并且 "__wait_for__" 的文件出现，
那么就给后面两个属性赋值。那么问题就是如何确定前面的匹配？
我的做法是从 Thinkwiki 上找到了小红点对应的位置
`/sys/devices/platform/i8042/serio1/serio2` 
然后用 udevadmin 去测试它

```
udevadm test /sys/devices/platform/i8042/serio1/serio2
```

他会在最后给出这个设备的信息：

```
UDEV_LOG=6
DEVPATH=/devices/platform/i8042/serio1/serio2
DRIVER=psmouse
SERIO_TYPE=05
SERIO_PROTO=00
SERIO_ID=00
SERIO_EXTRA=00
MODALIAS=serio:ty05pr00id00ex00
ACTION=add
SUBSYSTEM=serio
```

应该可以看懂了吧？用 ENV 去匹配 SERIO_TYPE 的值用 DRIVER 去匹配 psmouse 等等

----

# 注意：#

* 我的小红点的 __ERIO_TYPE==05__，而你的不一定。

* 我的小红点的 udev 位置是 __/sys/devices/platform/i8042/serio1/serio2__，而你的也不一定（尽管大多数都是这个）<ins datetime="2011-09-11T06:33:36+00:00">（Sep 11,2011 新增：根据 [这篇文章][1]，他的小红点就是 __serio4/serio5__）

* 在 udev r151 规则中的 ATTRS 似乎只可以用来匹配，但是不能用来赋值，如果 ATTRS 用了一个等号的话就会出 "__invalid ATTRS operation__" 错误提示。而 ATTR 既可以用来赋值也可以用来匹配，比如如果上面改成 `ATTR{sensitivity}=="156"`，那就是说如果匹配了这条之后才修改 speed 属性。