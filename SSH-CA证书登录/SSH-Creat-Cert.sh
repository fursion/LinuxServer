#!/bin/bash
CheckCA() {
    if test -e /etc/ssh/USER_CA -a -e /etc/ssh/USER_CA.pub; then
        echo 'USER CA 已经就位!'
    else
        CreateCA /etc/ssh/USER_CA USER_CA
    fi
    if test -e /etc/ssh/HOST_CA -a -e /etc/ssh/HOST_CA; then
        echo 'HOST CA 已经就位!'
    else
        CreateCA /etc/ssh/HOST_CA HOST_CA
    fi
}
ChechHostUserCA() {
    if grep -q "TrustedUserCAKeys /etc/ssh/USER_CA.pub" /etc/ssh/sshd_config; then
        echo 'USER_CA已安装'
    else
        echo 'USER_CA未安装'
        InstallUserCret
    fi
}
#检查服务端证书是否安装
CheckHostCert() {
    if test -e /etc/ssh/ssh_host_rsa_key-cert.pub; then
        if grep -q "HostCertificate /etc/ssh/ssh_host_rsa_key-cert.pub" /etc/ssh/sshd_config; then
            echo '证书已安装'
        else
            echo '证书未安装'
            InstallHostCret
        fi
    else
        echo '证书不存在'
        IssuingHostCertificate /etc/ssh/HOST_CA +52w $1 /etc/ssh/ssh_host_rsa_key.pub
        InstallHostCret
    fi
}
#凭证CA密钥对生成函数
CreateCA() {
    sudo ssh-keygen -t rsa -b 4096 -f $1 -C $2
}
InstallHostCret() {
    sudo chmod 666 /etc/ssh/sshd_config
    sudo echo "HostCertificate /etc/ssh/ssh_host_rsa_key-cert.pub" >>/etc/ssh/sshd_config
    sudo chmod 644 /etc/ssh/sshd_config
    echo 'HOST证书已安装'
}
InstallUserCret() {
    sudo chmod 666 /etc/ssh/sshd_config
    sudo echo "TrustedUserCAKeys /etc/ssh/USER_CA.pub" >>/etc/ssh/sshd_config
    sudo chmod 644 /etc/ssh/sshd_config
}
#服务器证书key生成函数
IssuingHostCertificate_key() {
    #
    sudo ssh-keygen -f /etc/ssh/ssh_host_rsa_key -b 4096 -t rsa
}
IssuingHostCertificate() {
    host_ca=$1 #服务器证书签发密钥
    validity=$2
    domain=$3
    host_pub=$4
    sudo ssh-keygen -s $host_ca -I host.$domain -h -n $domain -V $validity $host_pub
    #dd if=/dev/urandom bs=16 count=1 2>/dev/null | base64 | sed 's/=//g'  可生成16位密码短语
    sudo chmod 600 /etc/ssh/ssh_host_rsa_key-cert.pub
}
#生成用户证书
IssuingUserCertificate() {
    user_ca=$1
    user_key_pub=$3
    #第二个参数为用户名，第四个为服务器域名
    sudo ssh-keygen -s $user_ca -I $2@$4 -n $2 -V +1d $user_key_pub
}
#用户证书生成函数key -username
IssuingUserCertificate_key() {
    #生成公钥和密钥
    mkdir ~/.ssh/$1
    ssh-keygen -f ~/.ssh/$1/$1_key -b 4096 -t rsa
}
CheckUser() {
    if id -u $1 >/dev/null 2>&1; then
        echo "用户已经存在!"Ï
    else
        echo "用户$1不存在,是否创建此用户"
        echo "请选择操作项"
        echo "1 : 创建用户" \
             "Q :退出"
        while :
        do
            read item
            case $item in
            1)
                echo "input ${item}"
                break
                ;;
            Q) exit 1 ;;
            *) echo "无效输入！请重新输入！" ;;
            esac
        done
    fi
}
echo "证书颁发工具 1.0.0 by fursion@fursion.cn"
echo "请输入用户名和服务器域名"
read username domain
echo "正在为用户：$username 请求主机：$domain 的证书"
#检查系统中是否存在该用户
CheckUser $username
#检查CA密钥对是否存在，不存在则生成 保存路径位/etc/ssh/CA
CheckCA
ChechHostUserCA
CheckHostCert $domain

if test -e /etc/ssh/ssh_host_rsa_key -a -e /etc/ssh/ssh_host_rsa_key.pub; then
    echo '服务器证书密钥对已经存在'
else
    IssuingHostCertificate_key
fi

IssuingUserCertificate_key $username
IssuingUserCertificate /etc/ssh/USER_CA $username ~/.ssh/$username/${username}_key.pub $domain
cp /etc/ssh/HOST_CA.pub ~/.ssh/$username/
cd ~/.ssh/$username
echo "证书已生成,保存在:$(`pwd`)"
sudo tree "~/.ssh/$username"
echo 'scp -r $user@domain'":~/.ssh/$username" 'Host_TargetPath'
