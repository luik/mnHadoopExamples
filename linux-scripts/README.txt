You could get ubuntu :

https://help.ubuntu.com/community/Installation/MinimalCD
http://archive.ubuntu.com/ubuntu/dists/xenial/main/installer-amd64/current/images/netboot/mini.iso

I'm using 64-bit PC (amd64, x86_64)  Ubuntu 16.04 "Xenial Xerus" and 


Networking

Review the ip of the computer 

ifconfig
ens33 inet addr: 192.168.202.128

We will use next configuration

master node
192.168.202.10

slave nodes
192.168.202.21
192.168.202.22

to generate a rsa key pair
>>
ssh-keygen


>>
cd ~ 
>>
sudo apt-get install vim git openjdk-8-jdk-headless ssh
>>
git clone https://github.com/luik/mnHadoopExamples
>>
mkdir .ssh
>>
chmod 700 .ssh
>>
cp mnHadoopExamples/keys/key.pub ~/.ssh/authorized_keys
>>
chmod 600 ~/.ssh/authorized_keys
>>
sudo service sshd restart
>>
sudo patch /etc/network/interfaces ~/mnHadoopExamples/linux-scripts/interfacesMaster.diff
sudo patch /etc/network/interfaces ~/mnHadoopExamples/linux-scripts/interfacesNode1.diff
sudo patch /etc/network/interfaces ~/mnHadoopExamples/linux-scripts/interfacesNode2.diff
>> 









