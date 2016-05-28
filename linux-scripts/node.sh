#!/bin/bash

cd ~ 
sudo apt-get install vim git openjdk-8-jdk-headless ssh
git clone https://github.com/luik/mnHadoopExamples
mkdir .ssh
chmod 700 .ssh
cp mnHadoopExamples/keys/key.pub ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
sudo service sshd restart
