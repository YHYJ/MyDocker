# Docker Guide

---

[Docker官方文档](https://docs.docker.com/)

在本文档，**容器**是一项技术，**container**是容器实例

- 容器的基础之一是[cgroups](https://www.kernel.org/doc/Documentation/cgroup-v2.txt)，因此容器在Linux上本地运行，在Windows上是通过构建一个Linux kernel，在这个kernel上运行

---

## 基础

### Docker概念

Docker是一个平台，供开发人员和系统管理员使用容器构建、共享和运行程序，使用容器部署程序叫做容器化(*containerization*)

因为下列特点，容器化正在越来越流行：

- 灵活：即使最复杂的程序也可以容器化（包括系统及docker本身）
- 轻量：容器使用的是主机的内核，在系统资源消耗方面小于虚拟机，因此更加高效
- 可移植：一次构建，遍地开花
- 松耦合：容器是高度封装、自给自足的，可以在不破坏其他container的情况下进行升级等操作
- 可扩展：可以在Registry增加并自动分发image
- 安全：容器对程序进行积极的约束和隔离，无需用户进行多余的配置

![Docker](https://gitee.com/YJ1516/MyPic/raw/master/picgo/laurel-docker-containers2019.png)

#### 容器和虚拟机

容器在Linux上本地运行（在Windows上是通过构建一个Linux kernel，在这个kernel上运行），并与其他容器共享主机的内核。容器运行一个离散进程，除代码/二进制文件外不占用多余的内存，因此更加轻量；相比之下，虚拟机(VM)会产生大量开销

![Container & VM](https://gitee.com/YJ1516/MyPic/raw/master/picgo/container-vm.png)

#### image和container

从根本上讲，一个container是一个正在运行的进程，并对其附加了一些封装的功能，以使其与主机和其他container隔离，其中最重要的方面之一就是每个container都只与自己私有的文件系统进行交互，该文件系统由**image**提供，一个image包含了运行程序所需的所有内容——代码/二进制文件、运行时(runtime)、依赖或所需的其他任何东西

## 进阶

> 开发容器化程序并部署到Kubernetes和Swarm，然后分享到Docker Hub

### 开发

#### 创建image

> 在此示例中会对一个‘布告栏’程序进行容器化，该程序使用node.js编写

##### 配置

1. clone一个示例项目

    ```bash
    git clone -b v1 https://github.com/docker-training/node-bulletin-board
    cd node-bulletin-board/bulletin-board-app
    ```

    ![node-bulletin-board](https://gitee.com/YJ1516/MyPic/raw/master/picgo/node-bulletin-board.png)

2. 查看其中的`Dockerfile`文件

    ![Dockerfile](https://gitee.com/YJ1516/MyPic/raw/master/picgo/Dockerfile.png)

    Dockerfile描述了如何为容器组装文件系统，其中还包含一些元数据，这些元数据描述了如何基于该image运行container

    编写Dockerfile是开发容器化程序的第一步，docker根据Dockerfile逐步构建出需要的image，bulletin-board-app里的Dockerfile使用了以下指令：

    - `FROM`：启动'node:6.11.5'（本地没有的话会自动pull），这是由node.js官方提供的image，并且已经由Docker验证过是包含node 6.11.5解释器和基本依赖的高质量image
    - `WORKDIR`：指定工作目录，后续的操作默认是在image的文件系统的`/usr/src/app`路径下进行的（不是主机的文件系统）
    - `COPY`：将'package.json'从主机复制到image中的当前位置（根据`WORKDIR`，是`/usr/src/app/package.json`）
    - `RUN`：在image中执行的命令（读取`/usr/src/app/package.json`并在image中安装其指定的依赖）
    - `COPY`：将主机当前目录的文件复制到image的当前目录(`/usr/src/app`)

    上面的步骤构建了image的文件系统，还有一个`CMD`指令，这是一个用来指定元数据的指令，该元数据描述了如何基于该image运行container

    - `CMD`：**元数据**，指定基于该image运行的container中运行`npm start`命令

    Dockerfile里的指令与在主机上设置和安装程序的步骤几乎相同（多了COPY步骤），通过Dockerfile就可以构建一个可移植的image

    Dockerfile始终以`FROM`指令开头，然后逐步构建文件系统，并将该文件系统与元数据结合生成一个image

    > Dockerfile的指令有很多，有关完整列表，请参阅[Dockerfile reference](https://docs.docker.com/engine/reference/builder/)

##### 构建

Dockerfile配置完成之后（示例里是自带的），有了源代码和Dockerfile，就可以构建image了

1. 确保Dockerfile和源代码位于相同路径(`node-bulletin-board/bulletin-board-app`)，开始构建image

    ```bash
    docker build -t bulletinboard:1.0 .
    ```

    > 不要忽略最后的`.`，这代表从当前路径读取Dockerfile，如果当前不是和Dockerfile处于相同路径下，需要使用`-f`参数指定Dockerfile

    输出信息显示Docker逐步执行Dockerfile中的每条指令来构建image，如果构建成功，最后应该以`Successfully tagged bulletinboard:1.0`结尾：

    ![docker build](https://gitee.com/YJ1516/MyPic/raw/master/picgo/docker-build.png)

    构建完成以后，查看生成的image：

    ```bash
    docker images
    ```

    ![docker images](https://gitee.com/YJ1516/MyPic/raw/master/picgo/docker-images.png)

#### 使用image

##### 运行container

1. 使用构建的image启动container

    ```bash
    docker run --publish 8000:8080 --detach --name My-bulletinboard bulletinboard:1.0
    ```

    - `--publish`：将container的8080端口发布到主机的8000端口上，这样访问主机的8000端口的流量就等于访问container的8080端口（container都有自己专用的端口集，因此如果要从主机通过网络访问container的端口，需要进行流量转发，否则Docker的防火墙将会阻止所有到达container的流量，这是默认的安全状态）
    - `--detach`：要求Docker在后台运行此container
    - `-name`：将container命名为'My-bulletinboard'，后续命令中可以使用这个名字来引用container（默认命名是一个无规则字符串，不易记）

    注意！在命令中没有指定container要运行的进程，这是因为在构建image的时候，我们已经通过`CMD`指令设置了当启动container时要运行的命令(`nmp start`)

    ![My-bulletinboard](https://gitee.com/YJ1516/MyPic/raw/master/picgo/my-bulletinboard.png)

2. 浏览器访问`localhost:8000`，应该看到布告栏程序正在运行

    > 在这一步，我们应该竭尽所能保证container按照预期工作（例如进行单元测试）

    ![localhost:8000](https://gitee.com/YJ1516/MyPic/raw/master/picgo/localhost8000.png)


3. 确保container正常运行后，可以将其删除

    ```bash
    docker rm --force My-bulletinboard
    ```

    ![docker rm](https://gitee.com/YJ1516/MyPic/raw/master/picgo/docker-rm.png)

### 部署

至此，我们已经对程序进行了简单的容器化，并确保我们的image可以成功启动container并正常运行，接下来要在Kubernetes/Swarm上运行和管理该container

#### 部署到Kubernetes

> kubernetes（以下简称k8s）

**待完成**

#### 部署到Swarm

[Docker Swarm](https://docs.docker.com/engine/swarm/)

> Swarm -- Docker集群系统。使用Docker CLI创建集群、部署程序到集群以及管理集群行为
>
> Swarm提供了许多工具，可以对container进行扩展、联网、保护和维护，container本身无法提供这些工具

为了验证我们的容器化程序(bulletinboard)是否可以在Swarm上正常工作，我们将使用Docker内置的Swarm环境来部署我们的程序

Docker内置的Swarm环境具有完整的功能，这意味着它具有程序将在真正的集群上享受到的所有Swarm功能

##### 启动Swarm mode

在将container部署到Swarm之前，需要确保已经开启了Swarm mode：

```bash
docker info --format '{{.Swarm}}'
```

如果Swarm mode没有开启，返回结果是`inactive`：

![Swarm mode inactive](https://gitee.com/YJ1516/MyPic/raw/master/picgo/inactive.png)

使用以下命令开启Swarm mode：

```bash
docker swarm init
```

![docker swarm init](https://gitee.com/YJ1516/MyPic/raw/master/picgo/init-active.png)

开启Swarm mode之后，再次查看docker info，Swarm状态已经是`active`了

##### 使用stack file描述程序

Swarm不会像上一步（#开发-##使用image）中那样创建单个container。相反，所有Swarm工作负载都计划为*services*，它们是可伸缩的container组，具有由Swarm自动维护的附加网络功能。此外，所有Swarm对象都可以并且应该在stack file中进行定义，这些YAML文件描述了Swarm程序的所有组件和配置，可以在任何Swarm环境中轻松创建和销毁其中定义的程序

1. 编写一个stack file来运行和管理布告栏程序(bulletinboard)，将以下内容写入`bulletinboard-stack.yml`

    ```yaml
    version: '3.7'

    services:
      bulletinboard-app:
        image: bulletinboard:1.0
        ports:
          - "8000:8080"

      bulletinboard-copy:
        image: bulletinboard:1.0
        ports:
          - "8080:8080"
    ```

    在这个stack file中只有一个Swarm对象：`service`，描述了两组可伸缩的container，这两个container都将基于`bulletinboard：1.0`运行，我们还要求Swarm将访问主机8000/8080端口的流量分别转发到两个container的8080端口

    > k8s Services和Swarm Services完全不同：
    >
    > 在Swarm中，service同时提供*调度*和*联网*功能（创建container并提供将流量路由到container的工具）
    >
    > 在k8s中，*调度*和*联网*分别由不同组件处理：'deployments'（或者其他调度器）将container的调度作为**Pod**处理，而service仅负责将网络功能添加到这些Pod

##### 部署并检查程序

1. 将程序部署到Swarm

    ```bash
    docker stack deploy -c bulletinboard.yml demo
    ```

    > `stack`: 管理Docker stacks
    >
    > `deploy`: 部署一个新的stack或者更新已存在的stack
    >
    > `-c`: 即长参数`--compose-file`，Compose file的路径（或者使用`-`从STDIN读取）
    >
    > `demo`: 自定义的stack名

    如果一切顺利，Swarm将报告正在创建的stack对象：

    ![docker stack deploy](https://gitee.com/YJ1516/MyPic/raw/master/picgo/stack-deploy.png)

    > 注意！除了名为*demo_bulletinboard-\**的service外，Searm默认还创建了一个名为*demo_default*的网络，用来隔离作为stack的一部分部署的container

2. 确保程序部署正常

    - 列出所有stack

        ```bash
        docker stack ls
        ```

        ![docker stack ls](https://gitee.com/YJ1516/MyPic/raw/master/picgo/stack-ls.png)

        有一个名为'demo'的stack，里面有2个service，协调器是Swarm

    - 列出指定stack中的所有task

        ```bash
        docker stack ps demo
        ```

        ![docker stack ps](https://gitee.com/YJ1516/MyPic/raw/master/picgo/stack-ps2.png)

        名为'demo'的stack里有两个task，分别是'demo_bulletinboard-app.1'、'demo_bulletinboard-copy.1'，其他信息如图

    - 列出指定stack中的所有service

        ```bash
        docker stack services demo
        ```

        ![docker stack services](https://gitee.com/YJ1516/MyPic/raw/master/picgo/stack-services.png)

        名为的stack里有两个service，分别是'demo_bulletinboard-copy'、'demo_bulletinboard-app'，其他信息如图

        > 也可以使用`docker service ls`命令：
        >
        > - `docker service`针对所有service进行操作
        >
        > - `docker stack services`针对某个stack中的service进行操作

3. 浏览器访问`localhost:8000`和`localhost:8080`，应该看到两个端口上的布告栏程序都在正常运行

4. 一旦确定程序正常运行，就可以删除stack

    ```bash
    docker stack rm demo
    ```

    ![docker stack rm demo](https://gitee.com/YJ1516/MyPic/raw/master/picgo/stack-rm.png)

    service 'demo_bulletinboard-app'和'demo_bulletinboard-copy'以及network 'demo_default'被删除了

### 共享

开发容器化程序的最后一步是在[Docker Hub](https://hub.docker.com/)之类的Registry上共享image，以便以后可以轻松下载image并运行

#### 设置Docker Hub账户

如果还没有Docker Hub账户，按照以下步骤进行设置，这将允许你在Docker Hub上共享image

1. 访问[Docker Hub注册页面](https://hub.docker.com/signup)

2. 创建你的Docker ID

3. 使用`docker login`命令和你的Docker ID登录Docker Hub

#### 推送到Docker Hub

在确保已经有了Docker ID并且登录了Docker Hub的前提下，可以将image推送到Docker Hub了

1. 为image命名

    必须正确为image命名才能在Docker Hub上共享（不考虑共享到library的经过Docker官方认证的），命名规则是`<Docker ID>/<image Name>:<tag>`

    重命名我们的image

    ```bash
    docker tag bulletinboard:1.0 yhyj/bulletinboard:1.0
    ```

    > 将'yhyj'改为你自己的Docker ID

    ![docker tag](https://gitee.com/YJ1516/MyPic/raw/master/picgo/docker-tag.png)

2. 将image推送到Docker Hub

    ```bash
    docker push yhyj/bulletinboard:1.0
    ```

    > 将'yhyj'改为你自己的Docker ID

    ![docker push](https://gitee.com/YJ1516/MyPic/raw/master/picgo/docker-push.png)

    在Docker Hub中访问你的存储库将会看当刚刚推送上去的新image，默认情况下存储库是公开的

    ![Docker Hub](https://gitee.com/YJ1516/MyPic/raw/master/picgo/docker-hub.png)

必须通过你的Docker ID登陆了Docker Hub，并且按照规范正确命名了image才能推送到你的存储库中。如果看不到刚推送上去的image,请在几分钟后刷新浏览器

#### 其他

目前仅将image推送到了Docker Hub，Dockerfile、Kube YAML和stack file并不在其中，最佳方案是将这些文件和源代码一起进行版本控制并托管到某个平台（[Github](https://github.com/)或[Bitbucket](https://bitbucket.org/)，这两个是Docker支持的可以设置[自动构建(Automated)](https://docs.docker.com/docker-hub/builds/)的源代码托管服务平台），然后在Docker Hub存储库描述信息中添加指向这些文件的链接
