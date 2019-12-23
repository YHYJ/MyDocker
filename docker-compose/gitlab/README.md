# gitlab - docker

---

---

## docker

### 下载gitlab镜像

```shell
docker pull gitlab/gitlab-ce
```

### 数据持久化

> 自定义一个文件夹用来持久化存储数据。需要持久化的对象：
>
> - `/etc/gitlab`           # 配置文件
> - `/var/log/gitlib`       # 日志文件
> - `/var/opt/gitlab`       # 数据文件

### 端口映射

为了使git可以使用ssh协议操作git仓库，需要将主机的22端口映射到gitlab容器中，因此要解除sshd服务对22的占用：

> 运行以下命令查看sshd服务是否运行，没有运行的话就可以直接使用22端口：
>
> ```shell
> systemctl status sshd
> ```
>
> sshd已运行的话修改`/etc/ssh/sshd_config`中`Port 22`这行，将22替换为其他未使用的端口，运行以下命令重启sshd服务即可：
>
> ```shell
> systemctl restart sshd
> ```

### 设置私有证书

```shell
vim /etc/pki/tls/openssl.cnf

[ v3_ca ]
subjectAltName=IP:192.168.253.131
```

```shell
openssl req -x509 -nodes -days 36500 -newkey rsa:2048 -keyout gitlab.key -out gitlab.crt -subj "/C=US/CN=gitlab/O=gitlab.com"

openssl dhparam -out dhparam.pem 2048
```



### 运行gitlab

> 需要几分钟时间进行初始化和健康检查，耐心等待

```shell
docker-compose up       # 成功运行以后加上`-d`参数使容器在后台运行
```
