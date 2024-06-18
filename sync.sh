#!/usr/bin/env bash

: << !
Name: sync.sh
Author: YJ
Email: yj1516268@outlook.com
Created Time: 2024-04-16 16:51:07

Description: 从 System 同步脚本和 git hook 等

Attentions:
-

Depends:
-
!

script_dir=$(dirname "$0")                 # 本脚本所在路径
repo_dir="${HOME}/Documents/Repos"         # 本地源库路径
tmp_dir="/tmp/sync-hook"                   # 临时源库路径
source_dir="System/git"                    # 来源路径
save_dir="${script_dir}/git"               # 本库路径
repo_name="git@github.com:YHYJ/System.git" # 云端 System 存储库

# 创建本库路径
mkdir -p "${save_dir}"

# 和 System/git 进行同步，本地未发现 Syste 则从云端下载
if [ -d "${repo_dir}/${source_dir}" ]; then
  echo -e "\x1b[35m-->\x1b[0m 从本地 \x1b[36mSystem\x1b[0m 存储库同步 shell 脚本和 git 钩子"
  cp -r "${repo_dir}/${source_dir}/"* "${save_dir}"
else
  echo -e "\x1b[35m-->\x1b[0m 从云端 \x1b[36mSystem\x1b[0m 存储库同步 shell 脚本和 git 钩子"
  git clone "${repo_name}" "${tmp_dir}/System"
  cp -r "${tmp_dir}/${source_dir}/"* "${save_dir}"
  rm -rf "${tmp_dir}"
fi

# 将脚本转移到存储库根路径下
echo -e "\x1b[35m-->\x1b[0m 处理 shell 脚本"
cp -r "${save_dir}/scripts/"* "${PWD}"
rm -rf "${save_dir}/scripts"
