#!/bin/bash -xe

cd /

yum update -y
yum install -y https://github.com/cli/cli/releases/download/v2.14.3/gh_2.14.3_linux_amd64.rpm

git clone https://github.com/level-up-program/coder-controller.git
cd /coder-controller
make bootstrap-ec2

wget https://github.com/caddyserver/caddy/releases/download/v2.5.2/caddy_2.5.2_linux_amd64.tar.gz
tar -zxvf caddy_2.5.2_linux_amd64.tar.gz
mv caddy /usr/bin/

sudo groupadd --system caddy
useradd --system \
    --gid caddy \
    --create-home \
    --home-dir /var/lib/caddy \
    --shell /usr/sbin/nologin \
    --comment "Caddy web server" \
    caddy
wget https://raw.githubusercontent.com/caddyserver/dist/master/init/caddy.service
mv caddy.service /etc/systemd/system/caddy.service
chmod +r /etc/systemd/system/caddy.service

cat <<EOF > Caddyfile
coder.jpw3.me {
	reverse_proxy localhost:9000
}
coder.jpw3.me:8001 {
    reverse_proxy localhost:9001
}
coder.jpw3.me:8002 {
    reverse_proxy localhost:9002
}
coder.jpw3.me:8003 {
    reverse_proxy localhost:9003
}
coder.jpw3.me:8004 {
    reverse_proxy localhost:9004
}
coder.jpw3.me:8005 {
    reverse_proxy localhost:9005
}
coder.jpw3.me:8006 {
    reverse_proxy localhost:9006
}
EOF

mkdir -p /etc/caddy
mv Caddyfile /etc/caddy/Caddyfile

make start NUM_TEAMS=6

systemctl daemon-reload
systemctl enable --now docker.service
systemctl enable --now containerd.service
systemctl enable --now caddy
