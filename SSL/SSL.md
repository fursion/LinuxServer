# Linux SSH证书验证登录
## 密码登录和密钥登录优缺点
    密码登录和密钥登录，都有各自的缺点。
    密码登录需要输入服务器密码，这非常麻烦，也不安全，存在被暴力破解的风险。
    密钥登录需要服务器保存用户的公钥，也需要用户保存服务器公钥的指纹。这对于多用户、多服务器的大型机构很不方便，如果有员工离职，需要将他的公钥从每台服务器删除。

## 证书登录是什么
    证书登录就是为了解决上面的缺点而设计的。它引入了一个证书颁发机构（Certificate1 authority，简称 CA），对信任的服务器颁发服务器证书，对信任的用户颁发用户证书。
    登录时，用户和服务器不需要提前知道彼此的公钥，只需要交换各自的证书，验证是否可信即可。
    证书登录的主要优点有两个：
    （1）用户和服务器不用交换公钥，这更容易管理，也具有更好的可扩展性。
    （2）证书可以设置到期时间，而公钥没有到期时间。针对不同的情况，可以设置有效期很短的证书，进一步提高安全性。
## 证书登录的流程
    SSH 证书登录之前，如果还没有证书，需要生成证书。具体方法是：（1）用户和服务器都将自己的公钥，发给 CA；（2）CA 使用服务器公钥，生成服务器证书，发给服务器；（3）CA 使用用户的公钥，生成用户证书，发给用户。

    有了证书以后，用户就可以登录服务器了。整个过程都是 SSH 自动处理，用户无感知。

    第一步，用户登录服务器时，SSH 自动将用户证书发给服务器。

    第二步，服务器检查用户证书是否有效，以及是否由可信的 CA 颁发。

    第三步，SSH 自动将服务器证书发给用户。

    第四步，用户检查服务器证书是否有效，以及是否由信任的 CA 颁发。

    第五步，双方建立连接，服务器允许用户登录。
## 生成CA密钥
```shell
# ssh-keygen
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/user_ca -C user_ca  #
    #-t rsa：指定密钥算法 RSA。
    #-b 4096：指定密钥的位数是4096位。安全性要求不高的场合，这个值可以小一点，但是不应小于1024。
    #-f ~/.ssh/user_ca：指定生成密钥的位置和文件名。
    #-C user_ca：指定密钥的识别字符串，相当于注释，可以随意设置。
```
## CA签发服务器证书
    有了 CA 以后，就可以签发服务器证书了。
    签发证书，除了 CA 的密钥以外，还需要服务器的公钥。一般来说，SSH 服务器（通常是sshd）安装时，已经生成密钥/etc/ssh/ssh_host_rsa_key了。如果没有的话，可以用下面的命令生成。
        
        sudo ssh-keygen -f /etc/ssh/ssh_host_rsa_key -b 4096 -t rsa
签发证书
```shell
ssh-keygen -s host_ca -I host.example.com -h -n  host.example.com -V +52 ssh_host_rsa_key.pub
    #-s：指定 CA 签发证书的密钥。
    #-I：身份字符串，可以随便设置，相当于注释，方便区分证书，将来可以使用这个字符串撤销证书。
    #-h：指定该证书是服务器证书，而不是用户证书。
    #-n host.example.com：指定服务器的域名，表示证书仅对该域名有效。如果有多个域名，则使用逗号分隔。用户登录该域名服务器时，SSH 通过证书的这个值，分辨应该使用哪张证书发给用户，用来证明服务器的可信性。
    #-V +52w：指定证书的有效期，这里为52周（一年）。默认情况下，证书是永远有效的。建议使用该参数指定有效期，并且有效期最好短一点，最长不超过52周。
    #ssh_host_rsa_key.pub：服务器公钥。
    chmod 600 ssh_host_rsa_key-cert.pub     #更改证书权限
```
## CA签发用户证书
```shell
ssh-keygen -f ~/.ssh/user_key -b 4096 -t rsa
#上面命令会在~/.ssh目录，生成user_key（私钥）和user_key.pub（公钥）。然后，将用户公钥user_key.pub，上传或复制到 CA 服务器。接下来，就可以使用 CA 的密钥user_ca为用户公钥user_key.pub签发用户证书。
```
签发用户证书
```
ssh-keygen -s user_ca -I user@example.com -n user -V +1d user_key.pub
    #   上面的命令会生成用户证书user_key-cert.pub（用户公钥名字加后缀-cert）。这个命令各个参数的含义如下。

    #   -s：指定 CA 签发证书的密钥
    #   -I：身份字符串，可以随便设置，相当于注释，方便区分证书，将来可以使用这个字符串撤销证书。
    #   -n user：指定用户名，表示证书仅对该用户名有效。如果有多个用户名，使用逗号分隔。用户以该用户名登录服务器时，SSH 通过这个值，分辨应该使用哪张证书，证明自己的身份，发给服务器。
    #   -V +1d：指定证书的有效期，这里为1天，强制用户每天都申请一次证书，提高安全性。默认情况下，证书是永远有效的。
    #   user_key.pub：用户公钥。
ssh-keygen -L -f 证书文件  #可以查看证书的细节
chmod 600 user_key-cert.pub #修改密钥权限为600 rw- --- ---
```
## 证书安装
### 服务器证书安装
在/etc/ssh/sshd_config配置文件中添加
```
HostCertificate /etc/ssh/ssh_host_rsa_key-cert.pub
#上述命令告诉sshd，服务器证书是哪一个文件
```

### 服务器安装CA公钥
为了让服务器信任用户证书，必须将CA签发用户证书的公钥user_ca.pub，拷贝到服务器

在/etc/ssh/sshd_config配置文件中添加
```
TrustedUserCAKeys /etc/ssh/user_ca.pub
```
上面的做法是将user_ca.pub加到/etc/ssh/sshd_config，这会产生全局效果，即服务器的所有账户都会信任user_ca签发的所有用户证书。

另一种做法是将user_ca.pub加到服务器某个账户的~/.ssh/authorized_keys文件，只让该账户信任user_ca签发的用户证书。具体方法是打开~/.ssh/authorized_keys，追加一行，开头是@cert-authority principals="..."，然后后面加上user_ca.pub的内容，大概是下面这个样子。
```
@cert-authority principals="user" ssh-rsa AAAAB3Nz...XNRM1EX2gQ==
```
上面代码中，principals="user"指定用户登录的服务器账户名，一般就是authorized_keys文件所在的账户。

重新启动 sshd。







# 注意
## 服务器端
sshd服务必须配置服务端ca证书和用户公钥
## 客户端配置
客户端 ～/.ssh/known_hosts文件必须添加服务端公钥 客户端私钥和证书保存在同一位置
证书和密钥文件的权限必须是 600 及只能文件所有者可读写 rw-  
```
chmod 600 user_key               #user_key为私钥文件
chmod 600 user_key_cret.pub      #user_key_cret.pub为用户证书
```
    #测试  
    ssh -i user_key user@exp.com


参考博客[阮一峰的网络日志-SSH 证书登录教程](https://www.ruanyifeng.com/blog/2020/07/ssh-certificate.html)