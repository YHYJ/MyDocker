#!/bin/bash

:<<!
Author: YJ
Email: yj1516268@outlook.com
Created Time: 2019-04-28 11:03:37


!
echo ">>>>>>>>>Execute script: $0"


# AMQP - rabbitmq
# --hostname=YJ-Arch    <--- 该rabbitmq节点的节点名(Node Name)，rabbitmq根据节点名存储数据
docker run -dit --name=rabbitmq --publish=5672:5672 --publish=15672:15672 --hostname=YJ-Arch --volume=rabbitmq:/var/lib/rabbitmq --restart=unless-stopped rabbitmq:management
