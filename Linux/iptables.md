# Iptables介绍
    iptables是Linux内核集成的IP信息包过滤系统
## iptables结构
    iptables自上而下由 Tables,Chains,Rules组成
    iptables有Filter, NAT, Mangle, Raw四种内建表
* Filter
* NAT
* Mangle
* Raw
# 命令总览
```shell
iptables -ADC 指定链的规则 [-A 添加 -D 删除 -C 修改] 
iptables - RI 
iptables -D chain rule num[option] 
iptables -LFZ 链名 [选项] 
iptables -[NX] 指定链 
iptables -P chain target[options] 
iptables -E old-chain-name new-chain-name
```