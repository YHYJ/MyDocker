#!/usr/bin/env bash

: << !
Name: run_datax.sh
Author: YJ
Email: yj1516268@outlook.com
Created Time: 2021-09-17 14:06:17

Description: 运行DataX容器的脚本
- datax不作为守护进程运行，因此不使用compose文件

Attentions:
- 该脚本需要一个json文件名做为参数，并且该文件在resource文件夹中存在
!

####################################################################
#+++++++++++++++++++++++++ Define Variable ++++++++++++++++++++++++#
####################################################################
#------------------------- Program Variable
# program name
name=$(basename "$0")
readonly name

#------------------------- Exit Code Variable
readonly normal=0           # 一切正常

#------------------------- Parameter Variable
# description variable
readonly desc="是运行DataX容器的脚本"

####################################################################
#+++++++++++++++++++++++++ Define Function ++++++++++++++++++++++++#
####################################################################
#------------------------- Info Function
function helpInfo() {
  echo -e ""
  echo -e "\e[32m$name\e[0m\e[1m$desc\e[0m"
  echo -e "--------------------------------------------------"
  echo -e "Usage:"
  echo -e ""
  echo -e "     $name [file.json]"
}

####################################################################
#++++++++++++++++++++++++++++++ Main ++++++++++++++++++++++++++++++#
####################################################################
case $1 in
  resource/*.json)
    docker run -it -v "$PWD"/resource:/opt/resource --name datax --rm beginor/datax /opt/"$1"
    ;;
  *.json)
    docker run -it -v "$PWD"/resource:/opt/resource --name datax --rm beginor/datax /opt/resource/"$1"
    ;;
  *)
    helpInfo
    exit $normal
    ;;
esac
