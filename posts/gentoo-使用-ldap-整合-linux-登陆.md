---
title: Gentoo 使用 LDAP 整合 linux 登陆
date: '2012-01-06'
description: 配置 LDAP 并且使 Linux 可以通过 LDAP 信息认证登陆
categories: 我的 Linux
tags: [LDAP, Gentoo]
---

* LDAP的初步介绍请看: [l-penguin的LDAP入门][1] && [LDAP - 整合 Linux user login][2]
* Gentoo 的 LDAP 重要参考: [Gentoo Guide to OpenLDAP Authentication][3]
* [LDAP Authentication In Linux][4]
* LDAP目录树的缺省结构: [缺省目录信息树 (Directory Information Tree, DIT)][5]


# 简略步骤

1. 安装 [openLDAP][6] && [nss_ldap][7] && [pam_ldap][8] 组件

		emerge openldap nss_ldap pam_ldap

1. 配置 [slapd.conf][9]

		include /etc/openldap/schema/core.schema
		include /etc/openldap/schema/cosine.schema
		include /etc/openldap/schema/inetorgperson.schema
		include /etc/openldap/schema/nis.schema
		include /etc/openldap/schema/misc.schema
		include /etc/openldap/schema/openldap.schema
		 
		pidfile     /var/run/openldap/slapd.pid
		argsfile    /var/run/openldap/slapd.args
		 
		modulepath  /usr/lib64/openldap/openldap
		 
		# userPassword 属性仅供验证, 不可显示
		access to attrs=userPassword
		    by dn="uid=crhan,ou=SA,ou=Tech,ou=People,dc=myzjut,dc=org" write
		    by anonymous auth
		    by self write
		    by * none
		access to *
		    by self write
		    by users read
		    by anonymous read
		access to dn.base="" by * read
		access to dn.base="cn=Subschema" by * read
		 
		database    hdb
		suffix      "dc=myzjut,dc=org"
		checkpoint  32  30 
		rootdn      "cn=Manager,dc=myzjut,dc=org"
		rootpw      secret
		directory   /opt/openldap-data
		index   objectClass eq
		index   cn,uid      eq
		index   uidNumber   eq
		index   gidNumber   eq


1. 配置[名称服务转换器][10] [nsswitch.conf][11]

[10]: http://docs.oracle.com/cd/E24847_01/html/E22302/a12swit-89620.html "关于名称服务转换器"
[11]: http://linux.die.net/man/5/nsswitch.conf "man 5 nsswitch.conf"
[12]: http://www.padl.com/OSS/nss_ldap.html "nss_ldap"

		passwd:      files ldap
		shadow:      files ldap
		group:       files ldap

1. 配置 [/etc/ldap.conf][12]

		base dc=myzjut,dc=org
		uri ldap://ldap.yx.zjut.in
		ldap_version 3
		scope sub
		bind_timelimit 2
		bind_policy soft
		 
		pam_filter objectclass=posixAccount
		pam_login_attribute uid
		pam_member_attribute memberUid
		# 默认密码的加密方式 (passwd修改密码相关)
		pam_password exop
		 
		nss_base_passwd ou=People,dc=myzjut,dc=org?sub
		nss_base_shadow ou=People,dc=myzjut,dc=org?sub
		nss_base_group  ou=Group,dc=myzjut,dc=org?sub

1. 加入 [pam_ldap][8] 验证模块到 `/etc/pam.d/system-auth`

		auth            required        pam_env.so 
		auth            sufficient      pam_unix.so try_first_pass likeauth nullok 
		auth            sufficient      pam_ldap.so use_first_pass
		auth            required  pam_deny.so
		 
		account         sufficient      pam_unix.so 
		account         sufficient      pam_ldap.so
		 
		password        required        pam_cracklib.so difok=2 minlen=8 dcredit=2 ocredit=2 retry=3 
		password        sufficient      pam_unix.so try_first_pass use_authtok nullok sha512 shadow 
		password        sufficient      pam_ldap.so use_first_pass
		password                required  pam_deny.so
		 
		session         required        pam_limits.so 
		session         required        pam_env.so 
		session         required        pam_unix.so 
		session         optional        pam_ldap.so

1. 搞定


# 添加 LDAP 用户

	ldapadd -x -D 'cn=Manager,dc=myzjut,dc=org' -w secret -f init.ldif


使用以下 `init.ldif` 文件添加用户

	dn: dc=myzjut,dc=org
	objectClass: dcObject
	objectClass: organization
	o: MyZJUT
	dc: myzjut

	dn: cn=Manager,dc=myzjut,dc=org
	objectClass: organizationalRole
	cn: Manager

	dn: ou=People,dc=myzjut,dc=org
	ou: People
	objectClass: top
	objectClass: organizationalUnit

	dn: ou=Tech,ou=People,dc=myzjut,dc=org
	ou: 技术部
	ou: Tech
	objectClass: top
	objectClass: organizationalUnit

	dn: ou=SA,ou=Tech,ou=People,dc=myzjut,dc=org
	ou: 服务器管理
	ou: SA
	objectClass: top
	objectClass: organizationalUnit

	dn: ou=Dev,ou=Tech,ou=People,dc=myzjut,dc=org
	ou: 后台开发
	ou: Dev
	objectClass: top
	objectClass: organizationalUnit

	dn: cn=test test.local,ou=SA,ou=Tech,ou=People,dc=myzjut,dc=org
	givenName: test
	sn: test.local
	cn: test test.local
	uid: test_ldap
	uidNumber: 5000
	gidNumber: 600
	homeDirectory: /home/users/ttest.local
	objectClass: inetOrgPerson
	objectClass: posixAccount
	objectClass: top
	loginShell: /bin/bash
	userPassword: 123123

	dn: ou=Group,dc=myzjut,dc=org
	ou: Group
	objectClass: organizationalUnit
	objectClass: top

	dn: cn=SA,ou=Group,dc=myzjut,dc=org
	cn: SA
	objectClass: posixGroup
	objectClass: top
	gidNumber: 600
	memberUid: ttest.local
	description: group for SA from myZjut

	dn: ou=Hosts,dc=myzjut,dc=org
	ou: Hosts
	objectClass: organizationalUnit
	objectClass: top

# 验证

1. 名称服务, 若完全按照上面的步骤, 输入下面的命令, 应该都有输出

		getent passwd | grep test_ldap
		getent group  | grep SA

1. 修改密码, 使用 `passwd` 修改密码时显示 __LDAP__ 字样

		passwd test_ldap
		=> Enter login(LDAP) password: 

# 恭喜成功

[1]: http://www.l-penguin.idv.tw/article/ldap-1.htm "LDAP 入門"
[2]: http://www.l-penguin.idv.tw/article/ldap-3.htm "LDAP - 整合 Linux user login"
[3]: http://www.gentoo.org/doc/en/ldap-howto.xml "Gentoo Guide to OpenLDAP Authentication"
[4]: http://www.howtoforge.com/linux_ldap_authentication "LDAP Authentication In Linux"
[5]: http://docs.oracle.com/cd/E24847_01/html/E22302/ldapsecure-89.html#scrolltoc "缺省目录信息树 (Directory Information Tree, DIT)"
[6]: http://gpo.zugaina.org/net-nds/openldap "openldap"
[7]: http://gpo.zugaina.org/sys-auth/nss_ldap "nss_ldap"
[8]: http://linux.die.net/man/5/pam_ldap "man 5 pam_ldap"
[9]: http://linux.die.net/man/5/slapd.conf "man 5 slapd.conf"