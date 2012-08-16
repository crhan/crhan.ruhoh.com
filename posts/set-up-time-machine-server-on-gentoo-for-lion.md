---
title: Set up Time Machine Server on Gentoo for Lion
date: '2011-10-03'
description: Set up server on gentoo
categories: 我的苹果
tags: [Gentoo, TimeMachine]
---
> 重点参考来源： http://www.kremalicious.com/2008/06/ubuntu-as-mac-file-server-and-time-machine-volume/

# Set up server on gentoo

```
# macOX 10.7 need netatalk-2.2.0 or above
echo 'net-fs/netatalk ~amd64' >> /etc/portage/package.keywords
emerge netatalk avahi

# Make folder `/opt/TimeMachie' a shared volumn to your mac.
# Option `tm' is important, which means this volumn is used by timemachine
echo '/opt/TimeMachine TimeMachine cnidscheme:dbd options:tm' >> /etc/netatalk/AppleVolumes.default
echo '- -tcp -noddp -uamlist uams_dhx.so,uams_dhx2.so -nosavepassword' >> /etc/netatalk/afpd.conf
cat << EOF >/etc/avahi/services/afpd.service
<!--?xml version="1.0" standalone='no'?--><!--*-nxml-*-->
<?xml version="1.0" standalone='no'?><!--*-nxml-*-->
<!DOCTYPE service-group SYSTEM "avahi-service.dtd">
<service-group>
<!-- Customize this to get a different name for your server in the Finder. -->
<name replace-wildcards="yes">%h</name>
<service>
<type>_device-info._tcp</type>
<port>0</port>
<!-- Customize this to get a different icon in the Finder. -->
<txt-record>model=Xserver</txt-record>
</service>
<service>
<type>_afpovertcp._tcp</type>
<port>548</port>
</service>
</service-group>
EOF

rc-update add avahi-daemon default
rc-update add netatalk default
rc
```

# Set up Time Machine on OS X lion

```
# Make Time Machine could use disks through the network
defaults write com.apple.systempreferences TMShowUnsupportedNetworkVolumes 1
```

![]({{urls.media}}/time_machine.png)
