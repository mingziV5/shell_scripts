#!/bin/bash -xe
#docker id might be given as a Parameter
DID=$1

if [ ! -n "$DID" ];then
    #if no id given simply just connect to the first running instance
    DID=`docker ps | grep -Eo -m 1 "^[0-9a-z]{8,}\b"`
fi

docker exec -i -t $DID /bin/bash
