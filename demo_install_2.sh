#!/bin/bash

yum install nmap-ncat java curl java-1.8.0-openjdk-devel iperf openmpi openmpi-devel -y

# 判断0.4.2.zip文件是否存在，如果存在那么跳过下载的步骤
if [ -f "0.4.2.zip" ]
then
	echo "0.4.2.zip exists. skip download"
else
	echo "0.4.2.zip not exists, download it first"
	wget https://github.com/intel-cloud/cosbench/releases/download/v0.4.2/0.4.2.zip
	if [ "$?" -ne 0 ]
	then
		# 下载失败，程序中止
		echo "download 0.4.2.zip file occurs error err_code[$?]"
		exit -1
	fi

	if [ -f "0.4.2.zip" ]
	then
		echo "download  0.4.2.zip success"
	fi
fi

# 判断COSBench_0.4.2目录是否存在，如果存在，那么删除之前解压出来的文件，重新部署
if [ -d "COSBench_0.4.2" ]
then
	echo "directory COSBench_0.4.2 exists, rm it first to re-create it"
	rm -rf COSBench_0.4.2

	if [ "$?" -ne 0 ]
        then
                # 删除失败，程序中止
                echo "remove directory COSBench_0.4.2 occurs error err_code[$?]"
                exit -2
        fi
fi

unzip 0.4.2.zip
mv 0.4.2 COSBench_0.4.2
