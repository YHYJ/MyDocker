#!/bin/bash

:<<!
Author: YJ
Email: yj1516268@outlook.com
Created Time: 2019-04-28 11:05:59


!
echo ">>>>>>>>>Execute script: $0"


# 数据库 - postgres
# -e POSTGRES_DB=postgres     <--- 创建的数据库，来源于odoo示例
# -e POSTGRES_USER=odoo       <--- 创建的数据库用户，来源于odoo示例
# -e POSTGRES_PASSWORD=odoo   <--- 创建的用户密码，来源于odoo示例
docker run -dit --name=postgres --publish=5432:5432 --volume=postgres:/var/lib/postgres/data --volume=postgres:/var/lib/postgresql/data -e POSTGRES_DB=postgres -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres --restart=unless-stopped postgres
