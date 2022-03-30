#!/bin/bash

yum install nmap-ncat java curl java-1.8.0-openjdk-devel iperf openmpi openmpi-devel -y

wget https://github.com/intel-cloud/cosbench/releases/download/v0.4.2/0.4.2.zip

unzip 0.4.2.zip

mv 0.4.2 COSBench_0.4.2
