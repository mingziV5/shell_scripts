#!/bin/bash
#启动docker-etcd
#本机安装etcd并启动，监听在本机IP
#./etcd --initial-advertise-peer-urls http://192.168.31.2:2380 --listen-peer-urls http://192.168.31.2:2380  --advertise-client-urls http://192.168.31.2:2379 --listen-client-urls http://192.168.31.2:2379

HOST_IP=`ifconfig eth0 | grep "inet addr" | awk '{ print $2}' | awk -F: '{print $2}'`
ETCD_HOST=${HOST_IP}:2379

docker rm -f docker-register
docker run --name docker-register -d -e HOST_IP=$HOST_IP -e ETCD_HOST=$ETCD_HOST -v /var/run/docker.sock:/var/run/docker.sock -t jwilder/docker-register

docker rm -f whoami-1
docker rm -f whoami-2
docker run -d -p :8000 --name whoami-1 -t jwilder/whoami
docker run -d -p :8000 --name whoami-2 -t jwilder/whoami

docker rm -f docker-register-2
docker run --name docker-register-2 -d -e HOST_IP=$HOST_IP -e ETCD_HOST=$ETCD_HOST -v /var/run/docker.sock:/var/run/docker.sock -t jwilder/docker-register

docker rm -f docker-discover
docker run -d --net host --name docker-discover -e ETCD_HOST=$ETCD_HOST -p 1936:1936 -t jwilder/docker-discover
