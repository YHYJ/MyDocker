#!/bin/bash

:<<!
Author: YJ
Email: yj1516268@outlook.com
Created Date: 2019-01-06 15:32:41


!


groupmod -o -g $audio_gid audio

if [[ $GID != $(echo `id -g netease`) ]]; then
  groupmod -o -g $GID netease
fi

if [[ $UID != $(echo `id -u netease`) ]]; then
  usermod -o -g $UID netease
fi

chown netease:netease /home/netease/Music

su netease << EOF

if [[ !-e "/home/netease/.inited" ]]; then
  echo "初始化"
  mkdir -p "/home/netease/Music/.config" "/home/netease/Music/.cache" "/home/netease/.config" "/home/netease/.cache"
  ln -s "/home/netease/Music/.config" "/home/netease/.config/netease-cloud-music"
  ln -s "/home/netease/Music/.cache" "/home/netease/.cache/netease-cloud-music"
  touch "/home/netease/.inited"
fi

echo "启动 $app"
netease-cloud-music $1
exit 0
EOF
