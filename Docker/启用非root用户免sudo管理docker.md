# 非root用户免输入[sudo]进行docker命令行操作

```shell
# 创建docker用户组
sudo groupadd docker
# 将需要免sudo的用户加入docker 用户组
sudo usermod -aG docker $USER
```