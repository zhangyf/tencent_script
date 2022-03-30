#!/bin/bash

#yum install nmap-ncat java curl java-1.8.0-openjdk-devel iperf openmpi openmpi-devel -y

# 判断goosefs-1.2.0-bin.tar.gz文件是否存在，如果存在那么跳过下载的步骤
#if [ -f "goosefs-1.2.0-bin.tar.gz" ]
#then
#	echo "goosefs-1.2.0-bin.tar.gz exists. skip download"
#else
#	echo "goosefs-1.2.0-bin.tar.gz not exists, download it first"
#	wget https://cos-data-lake-release-1253960454.cos.ap-guangzhou.myqcloud.com/goosefs/1.2.0/release/goosefs-1.2.0-bin.tar.gz
#	if [ "$?" -ne 0 ]
#	then
#		# 下载失败，程序中止
#		echo "download goosefs-1.2.0-bin.tar.gz file occurs error err_code[$?]"
#		exit -1
#	fi
#
#	if [ -f "goosefs-1.2.0-bin.tar.gz" ]
#	then
#		echo "download  goosefs-1.2.0-bin.tar.gz success"
#	fi
#fi

# 判断goosefs-1.2.0目录是否存在，如果存在，那么删除之前解压出来的文件，重新部署
#if [ -d "goosefs-1.2.0" ]
#then
#	echo "directory goosefs-1.2.0 exists, rm it first to re-create it"
#	rm -rf goosefs-1.2.0
#
#	if [ "$?" -ne 0 ]
#        then
#                # 删除失败，程序中止
#                echo "remove directory goosefs-1.2.0 occurs error err_code[$?]"
#                exit -2
#        fi
#fi
#
#tar zxf goosefs-1.2.0-bin.tar.gz

# 获取本机IP
local_ip=`ifconfig | grep en0 -A 5  | grep "inet " | awk '{print $2}' `

echo "will replace goosefs.master.hostname from localhost to ${local_ip}"

# 先复制一份配置文件出来，防止把原始文件改错
cp -f goosefs-1.2.0/conf/goosefs-site.properties.template goosefs-1.2.0/conf/goosefs-site.properties

# 用sed替换配置文件中master的地址
# MAC 的sed命令与Linux的sed命令不同，MAC的sed命令在-i时，需要多加一个""，Linux版本的sed不需要该参数
sed -i "" 's/# goosefs.master.hostname=localhost/goosefs.master.hostname='${local_ip}'/g' goosefs-1.2.0/conf/goosefs-site.properties

# 用sed将配置文件中所有的<TO_BE_REPLACED>都替换为本机IP
# MAC 的sed命令与Linux的sed命令不同，MAC的sed命令在-i时，需要多加一个""，Linux版本的sed不需要该参数
sed -i "" 's/<TO_BE_REPLACED>/'${local_ip}'/g' goosefs-1.2.0/conf/goosefs-site.properties

