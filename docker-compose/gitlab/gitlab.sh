#!/bin/bash

:<<!
Author: YJ
Email: yj1516268@outlook.com
Created Time: 2019-04-28 16:59:20


!
echo ">>>>>>>>>Execute script: $0"


# 系统 - gitlab
# 需要几分钟进行初始化和检测，在这个过程中`docker ps -a`显示的'STATUS'是'(health: starting)'，成功启动以后显示的是'(healthy)'
# 第一次运行不确定能否通过检测时最好去掉`-d`参数
docker run -it --name=gitlab --publish=22:22 --publish=80:80 --publish=443:443 --volume=$HOME/Documents/MyDockeroot/data/gitlab/config:/etc/gitlab --volume=$HOME/Documents/MyDockeroot/data/gitlab/logs:/var/log/gitlab --volume=$HOME/Documents/MyDockeroot/data/gitlab/data:/var/opt/gitlab --restart=unless-stopped gitlab/gitlab-ce
