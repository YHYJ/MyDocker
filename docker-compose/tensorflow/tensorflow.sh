#!/bin/bash

:<<!
Author: YJ
Email: yj1516268@outlook.com
Created Time: 2019-05-17 11:45:52


!
echo ">>>>>>>>>Execute script: $0"

docker run -it --name=tensorflow -p 8888:8888 tensorflow/tensorflow
