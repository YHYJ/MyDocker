#!/bin/bash

:<<!
Author: YJ
Email: yj1516268@outlook.com
Created Time: 2019-04-28 11:07:05


!
echo ">>>>>>>>>Execute script: $0"


# 系统 - odoo
# -e HOST=<postgresql容器名>
# --link <postgresql容器名>:db  <--- 将postgresql容器链接到odoo容器，并必须将该连接命名为db
docker run -dit --name=odoo -e HOST=pg4odoo --publish=8069:8069 --volume=odoo:/var/lib/odoo --volume=odoo:/mnt/extra-addons --link pg4odoo:db --restart=unless-stopped odoo
