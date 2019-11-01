# Docker Compose文档

---

Compose是用来一次定义和运行多个container的工具。Compose使用YAML格式的compose file来定义程序的service依赖，然后一个命令就可以从compose file创建并启动所有的service

使用Compose的三部曲：

1. 创建一个Dockerfile，在Dockerfile里设置程序运行需要的环境

    > Dockerfile用来生成image，有了Dockerfile，在任何机器上都可以创建自己的image

2. 根据程序的实际依赖在docker-compose.yml里定义相应的service

    > 这些service可以在一个独立的环境里一起运行

3. 运行`docker-compose up`来启动程序

Compose可以管理程序的全生命周期：

- 启动、停止或者重建service
- 查看service的状态
- 流式追踪service的log输出
- 在service中运行一键命令

---

## Compose的功能

### 相互隔离的环境

每个compose file都有其project name来定义其独立的环境
默认的project name是compose file所在路径的基本名称（即其所在文件夹），可以使用`-p`参数或者`COMPOSE_PROJECT_NAME`来自定义project name
隔离的环境有以下便利：

- 开发时为项目的每个功能分支使用同一环境创建多个副本
- 在CI服务器上，为保证build过程不受干扰，可以设置一个独一无二的project name
- 在共享或者开发服务器上，防止可能使用了相同service name的不同项目相互干扰

### 数据持久化

Compose使用volume（数据卷）持久化container的数据
当执行`docker=compose up启动`AppX的时候，如果Compose找到了AppX已有的旧的container，会将volume从旧container复制到新container，从而确保数据不丢失

### 仅重建已更改的container

Compose会缓存compose file里的配置，当重启未更改的service时，Compose会继续使用已有的container，只有当compose file里的配置项改变时才会使用新的配置项重建对应的container

###  宿主机环境变量传递

Compose支持读取宿主机的环境变量，因此可以在不同的宿主机/用户/环境设置同名但不同值的变量用来定义compose file
