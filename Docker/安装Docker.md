# 安装Docker

安装环境 CentOS

```shell
 #1,卸载旧的版本
 yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine
#2, 需要的安装包
 yum install -y yum-utils
#3,设置镜像的仓库
	#docker官方库
 yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
 	#阿里云镜像库
 yum-config-manager \
    --add-repo \
    http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
#更新软件包索引 yum makecache fast
#4,安装Docker相关内容 docker-ce 社区版
 yum install docker-ce docker-ce-cli containerd.io
#5,启动Docker
	systemctl start docker
#6,使用docker version 查看是否安装成功
#7,查看下载的docker镜像 docker images
```

卸载docker

```shell
#卸载依赖
    yum remove docker-ce docker-ce-cli containerd.io
#删除资源
    rm -rf /var/lib/docker
```


# 配置Docker镜像加速
## 阿里云镜像加速

[阿里镜像服务控制台](https://cr.console.aliyun.com/cn-beijing/instances/mirrors)

```shell
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://4j91ddvq.mirror.aliyuncs.com"]         #此地址为专用地址
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
```
[docker中文教程](https://yeasy.gitbook.io/docker_practice/)