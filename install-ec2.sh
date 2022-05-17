#!/bin/bash -xe

cd /

yum update -y
yum install -y https://github.com/cli/cli/releases/download/v2.9.0/gh_2.9.0_linux_amd64.rpm

git clone https://github.com/level-up-program/coder-controller.git
cd /coder-controller
make bootstrap-ec2

wget https://github.com/caddyserver/caddy/releases/download/v2.5.0/caddy_2.5.0_linux_amd64.tar.gz
tar -zxvf caddy_2.5.0_linux_amd64.tar.gz
make start NUM_TEAMS=6

cat <<EOF > Caddyfile
coder.jpw3.me {
	reverse_proxy /admin/* localhost:9000
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

