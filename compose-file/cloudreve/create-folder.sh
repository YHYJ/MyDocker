#!/usr/bin/env bash

: << !
Name: create-folder.sh
Author: YJ
Email: yj1516268@outlook.com
Created Time: 2022-05-26 15:00:58

Description: 创建Cloudreve运行所需的文件/文件夹

Attentions:
-

Depends:
-
!

mkdir -vp cloudreve/{uploads,avatar} \
&& touch cloudreve/conf.ini \
&& touch cloudreve/cloudreve.db \
&& mkdir -p aria2/config \
&& mkdir -p data/aria2 \
&& chmod -R 777 data/aria2
