# 在班信息生成工具部署
# docker安装 自行查询
## 新建Docker网络
```bash
docker network create -d bridge --getwat 192.168.10.1 --subnet 192.168.10.1/24 it-net
```
# 涉及到的服务 nginx   ITWebService   ITWebTools
## 服务说明
- nginx 对ITWebService 和 ITWebTools提供代理服务
- ITWebService 提供功能API
    - 镜像地址fursion/itwebservice:1.2.3
- ITWebTools 提供前端交互界面
    - 镜像地址fursion/itwebtools:1.1.1
# 部署
## 部署Nginx
```bash
docker run --name Nginx  --network it-net  -d -p 80:80 -p 443:443 -v /c/Nginx:/etc/nginx/conf.d nginx:latest
```
```yaml
```
## 部署ITWebService
```bash
docker run --name ITWebService -d -p 10510:80 -v /c/ITWebService:/var/ITWebService/DutyInfo --netwoek it-net fursion/itwebservice:1.2.4
```
## 部署ITWebTools
```bash
docker run --name ITWebTools -d -p 10520:80 --netwoek it-net fursion/itwebtools:1.1.1
```
# 配置 Nginx
nginx配置文件存放路径 /c/Nginx/
- ITWebService.conf
```yaml
server{
    listen 443 ssl;
    server_name webapi.fursion.cn;
    ssl_certificate /etc/nginx/conf.d/cret/8494071_webapi.fursion.cn.pem;
    ssl_certificate_key /etc/nginx/conf.d/cret/8494071_webapi.fursion.cn.key; 
    location / {
        proxy_pass http://ITWebService:80;
    }
}
```
- ITWebTools.conf
```yaml
server{
    listen 443 ssl;
    server_name tools.fursion.cn;
    ssl_certificate /etc/nginx/conf.d/cret/8494064_tools.fursion.cn.pem;
    ssl_certificate_key /etc/nginx/conf.d/cret/8494064_tools.fursion.cn.pem.key; 
    location / {
        proxy_pass http://ITWebTools:80;
    }
}
```
## nginx ssl证书配置
- 证书存放地址，在部署Nginx的时候已经将Nginx的conf.d配置文件夹与宿主机本地磁盘 /c/Nginx绑定，将配置文件存放在宿主机/c/Nginx 等同于存放在容器 /etc/nginx/conf.d/目录
    - 在/c/Nginx/目录下新建cret文件夹，将证书和证书密钥存放在该文件夹内
### 地址 https://tools.fursion.cn