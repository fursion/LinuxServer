
```shell
docker run -d -p 80:80 --name $name --network $networkname -v $ConfigPath:/etc/nginx -v $logPath:/var/log/nginx nginx
```