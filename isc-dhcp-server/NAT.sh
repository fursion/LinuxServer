#! /bin/bash
subnet=192.168.1.0/255.255.255.0
targ=10.88.178.53
(iptables -t nat -A POSTROUTING -s $subnet -j SNAT --to $targ)