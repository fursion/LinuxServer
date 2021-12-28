阿里云镜像加速

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
