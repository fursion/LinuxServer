# Docker的常用命令

## 帮助命令

```shell
docker version     	 #显示docker的版本信息
docker info	   	 #显示docker的系统信息，包括镜像和容器的数量
docker 命令 --help	 #帮助命令
```

[帮助文档](https://docs.docker.com/engine/reference/commandline/build/):https://docs.docker.com/engine/reference/commandline/build/

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

### docker pull 下载镜像

```shell
#下载镜像
```

### docker rmi 删除镜像

```shell
#删除镜像
docker rmi ID                        	#通过镜像ID删除指定的镜像
docker rmi -f $(docker images -aq)  	#删除所有镜像
```

## 容器命令

有了镜像之后才可以创建容器，以下以centos镜像举例

```shell
docker pull centos
```

### 新建容器并启动
```shell
#参数说明
--name="Name"   容器名字 ，用来区分容器
-d              后台方式运行
-it             用交互方式运行，进入容器查看内容
-p              指定容器的端口 -p 8080:8080
    -p ip:主机端口:容器端口
    -p 主机端口:容器端口
    -p 容器端口
-P              随机指定端口
# 测试,启动并进入容器
    docker run -it centos /bin/bash
[root@4095c908b77f /]# ls #查看容器内的centos ，基础版本，很多命令都是不完善的
bin  dev  etc  home  lib  lib64  lost+found  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
# 从容器中推回主机
    exit
```
**查看运行中的容器**
```shell
# docker ps命令
          #查看当前正在运行的容器
   -a     #查看当前正在运行的容器+带出历史运行过的容器
   -n=?   #现实最近创建的容器
   -q     #只显示容器的编号
```
**退出容器**
```shell
    exit #直接暂停容器并退出
    Ctrl + P + Q #容器不停止退出
```
**删除容器**
```shell
docker rm id                  #容id
docker rm -f $(docker ps -aq) #删除所有容器
```
**启动和停止容器的操作**
```shell
docker start 容器id     #启动容器
docker restart 容器id   #重启容器
docker stop 容器id      #停止当前运行的容器
docker kill 容器id      #强制停止当前运行的容器
```
## 其他常用命令
```shell
docker run -d centos #后台运行容器，但容器必须有一个前台运行程序。
# 命令 docker logs
    -f            #显示日志
    -t            #显示时间戳
    --tail number #要显示的日志条数
```
查看容器中进程信息
```shell
# 命令 docker top 容器id
docker top 容器id
``` 
查看容器元数据
```shell
#命令 
    docker inspect 容器id
#测试
    docker inspect bf415be10d10
[root@learning ~]# docker inspect bf415be10d10
[
    {
        "Id": "bf415be10d103c8e929621e60533c9f74b7d773b54cd0dcbb9b17f888aaac3e5",
        "Created": "2022-01-06T04:58:18.512420255Z",
        "Path": "/bin/sh",
        "Args": [
            "-c",
            "while true;do echo docker log test;sleep 1;done"
        ],
        "State": {
            "Status": "running",
            "Running": true,
            "Paused": false,
            "Restarting": false,
            "OOMKilled": false,
            "Dead": false,
            "Pid": 1854945,
            "ExitCode": 0,
            "Error": "",
            "StartedAt": "2022-01-06T04:58:18.87340459Z",
            "FinishedAt": "0001-01-01T00:00:00Z"
        },
        "Image": "sha256:5d0da3dc976460b72c77d94c8a1ad043720b0416bfc16c52c45d4847e53fadb6",
        "ResolvConfPath": "/var/lib/docker/containers/bf415be10d103c8e929621e60533c9f74b7d773b54cd0dcbb9b17f888aaac3e5/resolv.conf",
        "HostnamePath": "/var/lib/docker/containers/bf415be10d103c8e929621e60533c9f74b7d773b54cd0dcbb9b17f888aaac3e5/hostname",
        "HostsPath": "/var/lib/docker/containers/bf415be10d103c8e929621e60533c9f74b7d773b54cd0dcbb9b17f888aaac3e5/hosts",
        "LogPath": "/var/lib/docker/containers/bf415be10d103c8e929621e60533c9f74b7d773b54cd0dcbb9b17f888aaac3e5/bf415be10d103c8e929621e60533c9f74b7d773b54cd0dcbb9b17f888aaac3e5-json.log",
        "Name": "/funny_ellis",
        "RestartCount": 0,
        "Driver": "overlay2",
        "Platform": "linux",
        "MountLabel": "",
        "ProcessLabel": "",
        "AppArmorProfile": "",
        "ExecIDs": null,
        "HostConfig": {
            "Binds": null,
            "ContainerIDFile": "",
            "LogConfig": {
                "Type": "json-file",
                "Config": {}
            },
            "NetworkMode": "default",
            "PortBindings": {},
            "RestartPolicy": {
                "Name": "no",
                "MaximumRetryCount": 0
            },
            "AutoRemove": false,
            "VolumeDriver": "",
            "VolumesFrom": null,
            "CapAdd": null,
            "CapDrop": null,
            "CgroupnsMode": "host",
            "Dns": [],
            "DnsOptions": [],
            "DnsSearch": [],
            "ExtraHosts": null,
            "GroupAdd": null,
            "IpcMode": "private",
            "Cgroup": "",
            "Links": null,
            "OomScoreAdj": 0,
            "PidMode": "",
            "Privileged": false,
            "PublishAllPorts": false,
            "ReadonlyRootfs": false,
            "SecurityOpt": null,
            "UTSMode": "",
            "UsernsMode": "",
            "ShmSize": 67108864,
            "Runtime": "runc",
            "ConsoleSize": [
                0,
                0
            ],
            "Isolation": "",
            "CpuShares": 0,
            "Memory": 0,
            "NanoCpus": 0,
            "CgroupParent": "",
            "BlkioWeight": 0,
            "BlkioWeightDevice": [],
            "BlkioDeviceReadBps": null,
            "BlkioDeviceWriteBps": null,
            "BlkioDeviceReadIOps": null,
            "BlkioDeviceWriteIOps": null,
            "CpuPeriod": 0,
            "CpuQuota": 0,
            "CpuRealtimePeriod": 0,
            "CpuRealtimeRuntime": 0,
            "CpusetCpus": "",
            "CpusetMems": "",
            "Devices": [],
            "DeviceCgroupRules": null,
            "DeviceRequests": null,
            "KernelMemory": 0,
            "KernelMemoryTCP": 0,
            "MemoryReservation": 0,
            "MemorySwap": 0,
            "MemorySwappiness": null,
            "OomKillDisable": false,
            "PidsLimit": null,
            "Ulimits": null,
            "CpuCount": 0,
            "CpuPercent": 0,
            "IOMaximumIOps": 0,
            "IOMaximumBandwidth": 0,
            "MaskedPaths": [
                "/proc/asound",
                "/proc/acpi",
                "/proc/kcore",
                "/proc/keys",
                "/proc/latency_stats",
                "/proc/timer_list",
                "/proc/timer_stats",
                "/proc/sched_debug",
                "/proc/scsi",
                "/sys/firmware"
            ],
            "ReadonlyPaths": [
                "/proc/bus",
                "/proc/fs",
                "/proc/irq",
                "/proc/sys",
                "/proc/sysrq-trigger"
            ]
        },
        "GraphDriver": {
            "Data": {
                "LowerDir": "/var/lib/docker/overlay2/04ee193f548d531687e9308ab44e3c9ccf7e64a9741517f2305d1768156308f6-init/diff:/var/lib/docker/overlay2/c07fadb01d12db7c25f0f1bfa3a781c9ced8e5e0d2fc335e4fb1095113a772e8/diff",
                "MergedDir": "/var/lib/docker/overlay2/04ee193f548d531687e9308ab44e3c9ccf7e64a9741517f2305d1768156308f6/merged",
                "UpperDir": "/var/lib/docker/overlay2/04ee193f548d531687e9308ab44e3c9ccf7e64a9741517f2305d1768156308f6/diff",
                "WorkDir": "/var/lib/docker/overlay2/04ee193f548d531687e9308ab44e3c9ccf7e64a9741517f2305d1768156308f6/work"
            },
            "Name": "overlay2"
        },
        "Mounts": [],
        "Config": {
            "Hostname": "bf415be10d10",
            "Domainname": "",
            "User": "",
            "AttachStdin": false,
            "AttachStdout": false,
            "AttachStderr": false,
            "Tty": false,
            "OpenStdin": false,
            "StdinOnce": false,
            "Env": [
                "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
            ],
            "Cmd": [
                "/bin/sh",
                "-c",
                "while true;do echo docker log test;sleep 1;done"
            ],
            "Image": "centos",
            "Volumes": null,
            "WorkingDir": "",
            "Entrypoint": null,
            "OnBuild": null,
            "Labels": {
                "org.label-schema.build-date": "20210915",
                "org.label-schema.license": "GPLv2",
                "org.label-schema.name": "CentOS Base Image",
                "org.label-schema.schema-version": "1.0",
                "org.label-schema.vendor": "CentOS"
            }
        },
        "NetworkSettings": {
            "Bridge": "",
            "SandboxID": "d191004052f9439faefea9f88d8d6a3b1560b89321a9408e11c5610bb52ffcda",
            "HairpinMode": false,
            "LinkLocalIPv6Address": "",
            "LinkLocalIPv6PrefixLen": 0,
            "Ports": {},
            "SandboxKey": "/var/run/docker/netns/d191004052f9",
            "SecondaryIPAddresses": null,
            "SecondaryIPv6Addresses": null,
            "EndpointID": "8cb235b22f17ae722875beb1ee874b0fae4c518a68f1ac5242a33b18e7779ee3",
            "Gateway": "172.17.0.1",
            "GlobalIPv6Address": "",
            "GlobalIPv6PrefixLen": 0,
            "IPAddress": "172.17.0.2",
            "IPPrefixLen": 16,
            "IPv6Gateway": "",
            "MacAddress": "02:42:ac:11:00:02",
            "Networks": {
                "bridge": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": null,
                    "NetworkID": "c6bd52729fd8f47c5d2c3b306fc11350a586efef12b29e765a3d05cc12445c11",
                    "EndpointID": "8cb235b22f17ae722875beb1ee874b0fae4c518a68f1ac5242a33b18e7779ee3",
                    "Gateway": "172.17.0.1",
                    "IPAddress": "172.17.0.2",
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "MacAddress": "02:42:ac:11:00:02",
                    "DriverOpts": null
                }
            }
        }
    }
]

```
**进入当前正在运行的容器**
```shell
# 容器通常是使用后台方式运行的，需要进入容器修改一些配置
#方式一
# 命令
docker exec -it 容器id bashshell  #进入容器后开启新的终端，可以进行操作
# 测试
[root@learning ~]# docker exec -it bf415be10d10 /bin/bash
[root@bf415be10d10 /]# ls
bin  dev  etc  home  lib  lib64  lost+found  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
[root@bf415be10d10 /]# 
# 方式二
docker attach 容器id

# docker attach bf415be10d10 #进入容器正在执行的终端，不会启动新的进程
```
从容器拷贝文件到主机
```sheel
docker cp 容器id：容器内路径 目的主机路径
[root@learning home]# ll
总用量 0
[root@learning home]# docker cp 24c261848d56:/home/hello.html /home/
[root@learning home]# ll
总用量 4
-rw-r--r-- 1 root root 14 1月   8 21:52 hello.html
[root@learning home]# 
#拷贝是一个手动过程，未来可以使用 -v 卷技术同步
```
# commit镜像

```shell
docker commit 提交容器成为一个新的副本
#命令和git原理类似
docker commit -m="提交的描述信息" -a="作者" 容器id 目标镜像名:[TAG]

```
# 容器数据卷
## 什么是容器数据卷
### docker的理念
将应用和环境打包成镜像（容器之间数据共享的技术，将Docker容器中产生的数据同步到本地）
## 使用数据卷
### 方式一：直接使用命令挂载
```shell
docker run -it -v 主机目录：容器目录
```
### 具名和匿名挂载
```shell
# 匿名挂载
-v 容器内路径
docker run -d -p --name nginx01 -v /etc/nginx nginx
#查看所有volume 的情况
[root@Server1 ~]# docker volume ls
DRIVER    VOLUME NAME
local     bdf9eee2c151a6a5ce9be9364174daeefaf63bf4f5baa5aaa5e9479c49899574
#上述举例就是匿名挂载，在 -v 只写了容器内的路径，没有写容器外的路径！
#具名挂载
[root@Server1 ~]# docker run -d -P --name nginx02 -v t-nginx:/etc/nginx nginx
23c0b58171d86589a31e55e5971911e64ebd99eb26a0e74f2fe86227005cc1ff
[root@Server1 ~]# docker volume ls
DRIVER    VOLUME NAME
local     t-nginx
#通过卷名：容器内路径
#查看卷路径 docker volume inspect 卷名
[root@Server1 ~]# docker volume inspect t-nginx 
[
    {
        "CreatedAt": "2022-01-20T21:19:38+08:00",
        "Driver": "local",
        "Labels": null,
        "Mountpoint": "/var/lib/docker/volumes/t-nginx/_data",
        "Name": "t-nginx",
        "Options": null,
        "Scope": "local"
    }
]
```
所有的docker容器内的卷，在没有指定目录的情况下都是在`/var/lib/docker/volumes/xxxx/_data`
我们通过具名挂载的方式，可以方便的找到卷，大多数情况下使用的都是`具名挂载`
```shell
# 如何确定是具名挂载还是匿名挂载，还是指定路径挂载！
-v 容器路径                 #匿名挂载
-v 卷名:容器路径             #具名挂载
-v /宿主机路径:容器路径       #指定路径挂载
```
扩展：
```shell
# 通过 -v 容器内路径:ro rw 改变读写权限
ro readonly #只读
rw readwrite #可读可写
# 一但设置了这个容器权限，容器对我们挂载出来的内容就有限定了！
docker run -d -P --name nginx02 -v t-nginx:/etc/nginx:ro nginx
docker run -d -P --name nginx02 -v t-nginx:/etc/nginx:rw nginx
# ro 只要看到ro 就说明这个路径只能通过宿主机来操作，容器内部是无法操作的！
```
# 初识Dockerfile
## 使用dockerfile生成镜像
Dockerfile就是用来构建docker镜像的构建文件！命令脚本！
通过这个脚本可以生成镜像
```shell
#创建一个dockerfile文件， 通过这个文件可以生成镜像，镜像是一层一层的，脚本的一个个命令就对应镜像的每一层。
FROM centos

VOLUME ["volume01","volume02"]

CMD echo "----end----"
CMD /bin/bash
#生成镜像 docker build [OPTIONS] PATH | URL | -
docker build -f /home/docker-test-volume/dockerfile01 -t fursion-centos:1.0 .
```
### 测试生成的镜像
```shell
#启动生成的镜像
[root@Server1 docker-test-volume]# docker images
REPOSITORY       TAG       IMAGE ID       CREATED          SIZE
fursion-centos   1.0       71ad3658866b   24 minutes ago   231MB
elasticsearch    7.16.3    3a5e93284781   2 weeks ago      611MB
nginx            latest    605c77e624dd   3 weeks ago      141MB
tomcat           latest    fb5657adc892   4 weeks ago      680MB
mysql            latest    3218b38490ce   4 weeks ago      516MB
centos           latest    5d0da3dc9764   4 months ago     231MB
[root@Server1 docker-test-volume]# docker run -it 71ad3658866b /bin/bash
[root@ce56a965a0ea /]# ls -l
total 0
lrwxrwxrwx   1 root root   7 Nov  3  2020 bin -> usr/bin
drwxr-xr-x   5 root root 360 Jan 22 04:01 dev
drwxr-xr-x   1 root root  66 Jan 22 04:01 etc
drwxr-xr-x   2 root root   6 Nov  3  2020 home
lrwxrwxrwx   1 root root   7 Nov  3  2020 lib -> usr/lib
lrwxrwxrwx   1 root root   9 Nov  3  2020 lib64 -> usr/lib64
drwx------   2 root root   6 Sep 15 14:17 lost+found
drwxr-xr-x   2 root root   6 Nov  3  2020 media
drwxr-xr-x   2 root root   6 Nov  3  2020 mnt
drwxr-xr-x   2 root root   6 Nov  3  2020 opt
dr-xr-xr-x 133 root root   0 Jan 22 04:01 proc
dr-xr-x---   2 root root 162 Sep 15 14:17 root
drwxr-xr-x  11 root root 163 Sep 15 14:17 run
lrwxrwxrwx   1 root root   8 Nov  3  2020 sbin -> usr/sbin
drwxr-xr-x   2 root root   6 Nov  3  2020 srv
dr-xr-xr-x  13 root root   0 Jan 22 04:01 sys
drwxrwxrwt   7 root root 171 Sep 15 14:17 tmp
drwxr-xr-x  12 root root 144 Sep 15 14:17 usr
drwxr-xr-x  20 root root 262 Sep 15 14:17 var
drwxr-xr-x   2 root root   6 Jan 22 04:01 volume01
drwxr-xr-x   2 root root   6 Jan 22 04:01 volume02
[root@ce56a965a0ea /]# 
```
