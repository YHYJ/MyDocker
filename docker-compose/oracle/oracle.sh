#!/bin/bash

:<<!
Author: YJ
Email: yj1516268@outlook.com
Created Time: 2019-04-28 11:06:43


!
echo ">>>>>>>>>Execute script: $0"


# 数据库 - oracle
# --privileged  <--- 授予该容器特殊权限
docker run -dit --name=oracle --publish=1521:1521 --publish=5500:5500 --publish=8080:8080 --volume=oracle:/u01/app/oracle --privileged --restart=unless-stopped absolutapps/oracle-12c-ee
