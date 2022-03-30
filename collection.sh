#!/bin/sh

for node in `cat node_list`
do
	scp -P 36000 root@${node}:~/list.key.log ${node}_list.key.log
done

grep 8907f6634d62b9a9977ca70174b5cee7 *_list.key.log
