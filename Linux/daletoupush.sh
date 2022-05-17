#! /bin/bash
#添加此定时任务到crontab任务文件中 0 9 * * * /home/fursion/Py/daletoupush.sh
OIFS=$IFS
receivers="receiver.list"
IFS=$'\n'
for line in $(cat $receivers);
do 
    re=$(echo $line | awk '{print $1}') 
    co=$(echo $line | awk '{print $2}') 
    python3 SendMail.py -S 大乐透机选 -sn 大乐透 -r $re -t  "$(python3 daletou.py -C ${co})"
done
IFS=$OIFS