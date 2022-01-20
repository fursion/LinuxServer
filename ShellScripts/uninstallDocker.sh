#! /bin/bash
yum remove docker-ce docker-ce-cli containerd.io <<EOF
y
EOF
rm -rf /var/lib/docker
