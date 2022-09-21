# Zabbix安装
 需特别注意 zabbix 服务端 代理端 客户端 WebUI所运行的zabbix版本必须保持一致。
 zabbix各组件之间通过zabbix私有协议通讯，所以不能使用http代理
## Zabbix安装包下载
```shell
#下载地址 https://cdn.zabbix.com/zabbix/sources/stable/6.0/zabbix-6.0.4.tar.gz
    wget https://cdn.zabbix.com/zabbix/sources/stable/6.0/zabbix-6.0.4.tar.gz
    #在当前目录会得到zabbix-6.0.4.tar.gz压缩包
    gzip zabbix-6.0.4.tar.gz #解压安装包

```
## 为zabbix安装数据库
```shell
docker run --name zabbix-db-server --network mynet \
        -e MYSQL_ROOT_PASSWORD=$password \
        -e MYSQL_USER="zabbix" \
        -e MYSQL_PASSWORD=$password \
        -d -P mysql
```
## 从docker安装zabbix----[手册](https://hub.docker.com/r/zabbix/zabbix-server-mysql/)
--network 需要自建docker网桥 zabbix所有组件需要在统一网络
安装zabbix-server
```shell
docker pull zabbix/zabbix-server-mysql
docker run --name zabbix-server-mysql \
            -e DB_SERVER_HOST="zabbix-db-server" -e MYSQL_USER="zabbix" \
            -e MYSQL_DATABASE="zabbix" \
            -e PHP_TZ="Asia/Shanghai" \
            -e MYSQL_PASSWORD=$password  \
            -e MYSQL_ROOT_PASSWORD=$password \
            -p 10051:10051 \
            -v /etc/timezone:/etc/timezone \
            -v /etc/localtime:/etc/localtime \
            --restart unless-stopped \
            --network mynet \
            -d zabbix/zabbix-server-mysql:latest
``` 
### 安装zabbix-web页面
```shell
docker run --name zabbix-web-nginx-mysql -t \
             -e ZBX_SERVER_HOST="zabbix-server-mysql" \
             -e DB_SERVER_HOST="zabbix-db-server" \
             -e MYSQL_DATABASE="zabbix" \
             -e MYSQL_USER="zabbix" \
             -e PHP_TZ="Asia/Shanghai" \
             -e MYSQL_PASSWORD=$password \
             -e MYSQL_ROOT_PASSWORD=$password \
             -v /etc/timezone:/etc/timezone \
             -v /etc/localtime:/etc/localtime \
             --network mynet \
             --restart unless-stopped \
             -p 8080:8080 \
             -d zabbix/zabbix-web-nginx-mysql:6.0-alpine-latest
```
安装zabbix-agent检测端
```shell
docker run --name zabbix-server-agent \
    -e ZBX_HOSTNAME="zabbix-server-agent" \
    -e ZBX_SERVER_HOST="zabbix-server" \
    -e PHP_TZ="Asia/Shanghai" \
    -e ZBX_SERVER_PORT=10051 \
    -v /etc/timezone:/etc/timezone \
    -v /etc/localtime:/etc/localtime \
    --network mynet \
    -d zabbix/zabbix-agent:6.0-alpine-latest
```
被动检测模式
```shell
docker run --name some-zabbix-agent --link some-zabbix-server:zabbix-server -d zabbix/zabbix-agent:6.0-alpine-latest
```
### zabbix-proxy

```shell
docker run --name zabbix-proxy-mysql \
        -e DB_SERVER_HOST="zabbix-db-server"\
        -e MYSQL_USER="zabbix" \
        -e MYSQL_PASSWORD=$password  \
        -e MYSQL_ROOT_PASSWORD=$password \
        -e ZBX_HOSTNAME=zabbix-proxy-ub \
        -e ZBX_SERVER_HOST=zabbix-server.fursion.cn \
        -e ZBX_SERVER_PORT=10051 \
        -e PHP_TZ="Asia/Shanghai" \
        -v /etc/timezone:/etc/timezone \
        -v /etc/localtime:/etc/localtime \
        -p 10051:10051 \
        --network mynet \
        -d zabbix/zabbix-proxy-mysql:latest
```