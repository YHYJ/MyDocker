# Docker Guide

---

- 可以根据ID的前3~4个字符确定一个image或container
- 一下内容中，`...`代表image/container的NAME/ID

---

## 基础

### 操作Container

| 命令                             | 功能                                                         | 备注                                                         | 示例                       |
| -------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | -------------------------- |
| docker start ...                 | 启动一个或多个停止状态的container                            |                                                              | `docker start f4c`         |
| docker restart ...               | 重启一个或多个container                                      |                                                              | `docker restart f4c`       |
| docker run <IMAGE> <command arg> | 使用<IMAGE>创建一个container并运行命令                       | **command**是要运行的命令，**arg**是该命令的参数             | `docker run ubuntu ls -al` |
| docker create <IMAGE>            | 使用<IMAGE>创建一个container，并准备运行指定的命令，但此时不会启动该container | 类似`docker run -d；`创建以后可以随时运行`docker start ...`启动该container | `docker create ubuntu ls`  |
| docker stop ...                  | 停止一个或多个正在运行的container                            | 发送信号SIGTERM给container                                   | `docker stop f4c`          |
| docker kill ...                  | 杀掉一个或多个运行中的container                              | 默认发送SIGKILL信号给container                               | `docker kill f4c`          |
| docker ps                        | 查看container的信息                                          | **-a**查看所有container，默认只给出**running**状态的；**-l**查看最新创建的container | `docker ps -l`             |
| docker logs ...                  | 获取container的日志                                          | 包括**stdout**和**stderr**                                   | `docker logs f4c`          |
|                                  |                                                              |                                                              |                            |
|                                  |                                                              |                                                              |                            |
|                                  |                                                              |                                                              |                            |
|                                  |                                                              |                                                              |                            |

### 操作Image

| 命令                  | 功能                        | 备注                                                         | 示例                   |
| --------------------- | --------------------------- | ------------------------------------------------------------ | ---------------------- |
| docker search <IMAGE> | 从Registry搜索指定的<IMAGE> | Registry可自定义，默认是Docker Hub                           | `docker search ubuntu` |
| docker pull <IMAGE>   | 拉取指定的<IMAGE>           | 官方image直接用**image-name**，非官方镜像要用**username/image-name** | `docker pull ubuntu`   |
|                       |                             |                                                              |                        |

### 查看状态

| 命令              | 功能                                     | 备注         | 示例                 |
| ----------------- | ---------------------------------------- | ------------ | -------------------- |
|                   |                                          |              |                      |
| docker inspec ... | 查看docker对象的底层信息                 | 输出信息很多 | `docker inspec c163` |
|                   |                                          |              |                      |
| docker events     | 从docker服务器获取实时事件               |              |                      |
| docker port <ID>  | 列出端口映射或容器的特定映射             |              | `docker port f4c`    |
| docker top <ID>   | 查看容器的进程信息                       |              | `docker top f4c`     |
| docker diff <ID>  | 检查容器文件系统上的文件或目录的前后变化 |              | `docker diff f4c`    |

---

## 进阶

### 启动停止

| 命令                                        | 功能                                | 备注                                                | 示例                                                |
| ------------------------------------------- | ----------------------------------- | --------------------------------------------------- | --------------------------------------------------- |
| docker run <IMAGE> apt-get install -y <PKG> | 起一个<IMAGE>容器，并在其中运行命令 | 需要加**-y**参数，因为**apt-get**命令会进入交互模式 | `docker run learn/tutorial apt-get install -y ping` |
|                                             |                                     |                                                     |                                                     |

### 保存修改

| 命令                                | 功能                           | 备注                                                         | 示例                                              |
| ----------------------------------- | ------------------------------ | ------------------------------------------------------------ | ------------------------------------------------- |
| docker commit <ID> <new_image_name> | 基于容器的变化创建一个新的镜像 | **<ID>**指`docker ps -l`列出的**CONTAINER ID**，使用前面3~4位即可 | `docker commit -m "install ping" 3b39 learn/ping` |
|                                     |                                |                                                              |                                                   |

### 介入容器

| 命令               | 功能                                             | 备注 | 示例                |
| ------------------ | ------------------------------------------------ | ---- | ------------------- |
| docker attach <ID> | 将本地标准输入，输出和错误流附加到正在运行的容器 |      | `docker attach f4c` |
| docker wait <ID>   | 阻塞直到一个或多个容器停止运行，然后打印退出代码 |      | `docker wait f4c`   |
|                    |                                                  |      |                     |

### 导出容器

| 命令                                     | 功能                                   | 备注                            | 示例                                   |
| ---------------------------------------- | -------------------------------------- | ------------------------------- | -------------------------------------- |
| docker cp <LOCAL_PATH> \<CONTAINER:PATH> | 将本地文件或文件夹拷贝到容器指定的路径 |                                 | `docker cp foo.txt container:/foo.txt` |
| docker cp \<CONTAINER:PATH> <LOCAL_PATH> | 将容器中的文件或文件夹拷贝到本地路径   |                                 | `docker cp mycontainer:/src/. target`  |
| docker export <ID>                       | 导出容器的文件系统位tar格式            | 不包含**layers**、**tag**等信息 | `docker export f4c`                    |

