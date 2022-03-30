#!/bin/sh

LOG_FILES_PATH=2022/03


# 统计某一天内所有操作的次数，并按照次数从高到低进行排序
echo "=============== 统计2022/03/17 这一天每种操作各执行了多少次 ================="
awk '{print $6}' ${LOG_FILES_PATH}/17/* | sort | uniq -c | sort -k 1 -n -r

# 统计每个分片上传到底分别上传了多少数据
echo "=============== 统计2022/03/17 这一天每个分片上传各上传了多少数据量 ================="
grep UploadPart ${LOG_FILES_PATH}/17/* | awk '{
					if(hash[$8]>=0) {
						hash[$8]+=$11
					}
				    }
				    END {
					for(k in hash) {
						printf"%s\t%sMB\n", k,hash[k]/1024/1024
				        } 
				    }' | sort -k2 -n -r
