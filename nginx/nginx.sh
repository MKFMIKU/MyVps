#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#安装依赖环境
yum install -y patch openssl make cmake gcc gcc-c++ gcc-g77 flex bison file libtool libtool-libs autoconf kernel-devel libjpeg libjpeg-devel libpng libpng-devel libpng10 libpng10-devel gd gd-devel freetype freetype-devel libxml2 libxml2-devel zlib zlib-devel glib2 glib2-devel bzip2 bzip2-devel libevent libevent-devel ncurses ncurses-devel curl curl-devel e2fsprogs e2fsprogs-devel krb5 krb5-devel libidn libidn-devel openssl openssl-devel vim-minimal nano fonts-chinese gettext gettext-devel ncurses-devel gmp-devel pspell-devel unzip libcap diffutils

#用于转发的PCRE
wget http://downloads.sourceforge.net/project/pcre/pcre/8.36/pcre-8.36.tar.gz
tar zxf pcre-8.36.tar.gz
cd pcre-8.36/
./configure && make && make install
cd ../

#安装Nginx
wget http://nginx.org/download/nginx-1.8.1.tar.gz
tar zxf nginx-1.8.1.tar.gz
cd nginx-1.8.1
./configure --user=nobody --group=nobody --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module --with-http_gzip_static_module --with-ipv6 --with-http_sub_module --with-http_spdy_module
make && make install
cd ../

#关联一些重要的库文件
ln -s /usr/local/lib/libpcre.so.1 /lib
ln -s /usr/local/nginx/sbin/nginx /usr/bin/nginx
#创建log目录
mkdir -p /home/wwwlogs
chmod 777 /home/wwwlogs
#替换配置
rm -f /usr/local/nginx/conf/nginx.conf
cp init.d.nginx /etc/init.d/nginx
chmod +x /etc/init.d/nginx
chkconfig --level 345 nginx on
/sbin/iptables -I INPUT -p tcp --dport 80 -j ACCEPT
/sbin/iptables-save
ldconfig
mv nginx.conf /usr/local/nginx/conf/
/etc/init.d/nginx start

