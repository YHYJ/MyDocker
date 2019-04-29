#!/bin/bash

:<<!
Author: YJ
Email: yj1516268@outlook.com
Created Time: 2019-04-28 11:04:27


!
echo ">>>>>>>>>Execute script: $0"


# 数据库 - redis
docker run -dit --name=redis --publish=6379:6379 --volume=redis:/data --restart=unless-stopped redis
