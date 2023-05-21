#!/usr/bin/env bash
certs=/etc/docker/certs.d/192.168.1.10:8443
mkdir /registry-image
mkdir /etc/docker/certs
mkdir -p $certs
openssl req -x509 -config $(dirname "$0")/tls.csr -nodes -newkey rsa:4096 \
-keyout tls.key -out tls.crt -days 365 -extensions v3_req

apt install sshpass -y
for i in {1..3}
  do
    sshpass -p vagrant ssh -o StrictHostKeyChecking=no root@192.168.1.10$i mkdir -p $certs
    sshpass -p vagrant scp tls.crt 192.168.1.10$i:$certs
  done

cp tls.crt $certs
mv tls.* /etc/docker/certs
