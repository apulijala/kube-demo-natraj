#!/bin/bash
# script that runs 
# https://kubernetes.io/docs/setup/production-environment/container-runtime

yum install -y vim yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# notice that only verified versions of Docker may be installed
# verify the documentation to check if a more recent version is available

# AP. adde cli package. 
yum install -y docker-ce docker-ce-cli
[ ! -d /etc/docker ] && mkdir /etc/docker

cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}
EOF

mkdir -p /etc/systemd/system/docker.service.d
cat <<HOSTS >> /etc/hosts 
192.168.33.13 control.example.com control
192.168.33.15 worker1.example.com worker1
192.168.33.14 worker2.example.com worker2
192.168.33.16 worker3.example.com worker3
HOSTS

systemctl daemon-reload
systemctl restart docker
systemctl enable docker

systemctl disable --now firewalld
