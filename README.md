# tencent_script

## Shell脚本

 - awk_demo.sh 从cos访问日志中统计某一天内所有的操作的次数，并按照次数从高到低排序。再统计每次分片上传都上传了多少数据，并按照上传数据量从高到低排序
 - collection.sh 从指定机器列表中收集某种日志，并从所有收集的日志中查找出包含某个关键字的条目
 - demo_install_1.sh 简单的安装，执行yum install，wget以及unzip和重命名
 - demo_install_2.sh 在demo_install_1的基础上增加返回值判断
 - demo_install_3.sh 使用sed和简单的正则表达式来批量修改配置文件

## Python脚本

 - index.py 某个对象上传到bucket后触发，从A用户的a bucket下载文件，并上传到B用户的b bucket

