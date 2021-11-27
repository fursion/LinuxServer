ubuntu net配置
============================
# 网卡配置
默认没有安装ifconfig 需要可以使用  
    
    apt install ifconfig安装
设置静态IP  

    #ubuntu 网卡配置文件位置
    /etc/netplan/01-network-manager-all.yaml
    #配置完成之后 运行 
    netplan apply #生效
## 图片展示
[isc-dhcp-server](./../isc-dhcp-server/isc-dhcp-server.md)  
![图片](../src/s.png)