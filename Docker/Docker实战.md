# docker安装tomcat
```shell
# 官方示例
docker run -it --rm tomcat:9.0 #运行结束后即删除，一般用来做测试

#先下载再启动
docker pull tomcat
#启动运行
docker run -it -d -p 3355:8080 --name tomcat01 tomcat
#测试访问
#进入容器
docker exce -it tomcat01 /bin/bash

#发现问题 linux命令少了 没有webapps。 阿里云镜像的原因。默认是最小镜像，所有不必要的都剔除掉了。
#保证最小可运行的环境！
```
# 部署 es+kibana
```shell
#es 暴露的端口很多
#es 十分的耗内存
#es 的数据一般需要放到安全目录挂载
# -e 修改配置文件 
docker run -d --name elasticsearch  -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" -e ES_JAVA_OPTS="-Xms64m -Xmx512m" elasticsearch:7.16.3
#查看 docker stats
```
# 可视化
portainer
```shell

```
# commit镜像

```shell
docker commit 提交容器成为一个新的副本
#命令和git原理类似
docker commit -m="提交的描述信息" -a="作者" 容器id 目标镜像名:[TAG]

```
# 安装MySQL
思考：MySQL数据持久化的问题！
```shell
# 获取镜像
    docker pull mysql
# 运行容器，需要做数据挂载！ 安装启动mysql,需要配置密码的，这是注意点！
# 官方测试：docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:tag
```