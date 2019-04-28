#!/bin/bash

:<<!
Author: YJ
Email: yj1516268@outlook.com
Created Time: 2019-04-28 11:02:15


!
echo ">>>>>>>>>Execute script: $0"


# docker监控 - portainer/portainer
docker run -dit --name=portainer --publish=9000:9000 --volume=/var/run/docker.sock:/var/run/docker.sock --volume=portainer:/data --restart=unless-stopped portainer/portainer
