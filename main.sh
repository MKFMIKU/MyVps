#!/bin/bash
#This is the back Vps record for centos

#Install the nginx
cd nginx
bash ./nginx.sh

#Install the node
cd node
bash ./node.sh