#!/bin/bash -xe

cd /

yum update -y
yum install -y https://github.com/cli/cli/releases/download/v2.9.0/gh_2.9.0_linux_amd64.rpm

yum install yum-plugin-copr
yum copr enable @caddy/caddy
yum install caddy

git clone https://github.com/level-up-program/coder-controller.git
cd /coder-controller
make bootstrap-ec2
make start NUM_TEAMS=6

cat <<EOF > Caddyfile
coder.jpw3.me {
    reverse_proxy localhost:9000
}
coder.jpw3.me:9001 {
    reverse_proxy localhost:9001
}
coder.jpw3.me:9002 {
    reverse_proxy localhost:9002
}
coder.jpw3.me:9003 {
    reverse_proxy localhost:9003
}
coder.jpw3.me:9004 {
    reverse_proxy localhost:9004
}
coder.jpw3.me:9005 {
    reverse_proxy localhost:9005
}
coder.jpw3.me:9006 {
    reverse_proxy localhost:9006
}
coder.jpw3.me:10001 {
    reverse_proxy localhost:10001
}
coder.jpw3.me:10002 {
    reverse_proxy localhost:10002
}
coder.jpw3.me:10003 {
    reverse_proxy localhost:10003
}
coder.jpw3.me:10004 {
    reverse_proxy localhost:10004
}
coder.jpw3.me:10005 {
    reverse_proxy localhost:10005
}
coder.jpw3.me:10006 {
    reverse_proxy localhost:10006
}
coder.jpw3.me:11001 {
    reverse_proxy localhost:11001
}
coder.jpw3.me:11002 {
    reverse_proxy localhost:11002
}
coder.jpw3.me:11003 {
    reverse_proxy localhost:11003
}
coder.jpw3.me:11004 {
    reverse_proxy localhost:11004
}
coder.jpw3.me:11005 {
    reverse_proxy localhost:11005
}
coder.jpw3.me:11006 {
    reverse_proxy localhost:11006
}
EOF

caddy start
