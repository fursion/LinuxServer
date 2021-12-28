# Docker的常用命令

## 帮助命令

```shell
docker version     	 #显示docker的版本信息
docker info	   	 #显示docker的系统信息，包括镜像和容器的数量
docker 命令 --help	 #帮助命令
```

帮助文档地址：https://docs.docker.com/engine/reference/commandline/build/

## 镜像命令

docker images 查看所有本地镜像

```shell
[root@learning ~]# docker images
REPOSITORY    TAG       IMAGE ID       CREATED        SIZE
hello-world   latest    feb5d9fea6a5   3 months ago   13.3kB
```

docker search 搜索镜像

```shell
[root@learning ~]# docker search mysql
NAME                              DESCRIPTION                                     STARS     OFFICIAL   AUTOMATED
mysql                             MySQL is a widely used, open-source relation…   11880     [OK]   
mariadb                           MariaDB Server is a high performing open sou…   4541      [OK]   
mysql/mysql-server                Optimized MySQL Server Docker images. Create…   888                  [OK]

```

## 容器命令
