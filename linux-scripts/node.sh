#!/bin/bash

declare -A nodesMap

while read -r line
do
        read -ra values <<< "$line"
        nodesMap[${values[0]}]=${values[1]}
done < "nodes.conf"

is_master=false
node_name="name wasn't set"

while getopts "n:" opt; do
	case $opt in
		n)
			node_name=$OPTARG;
		;;
		#m)
		#	is_master=true;
		#;;
	esac
done

node_address=${nodesMap[$node_name]}
gateway_address=${nodesMap["gateway"]};

if [ "$node_name" == "master" ]
then
    echo "is master"
fi

cd ~ 
sudo apt-get install vim openjdk-8-jdk-headless ssh
mkdir .ssh
chmod 700 .ssh
cp mnHadoopExamples/keys/key.pub .ssh/authorized_keys
chmod 600 .ssh/authorized_keys
cp mnHadoopExamples/keys/key .ssh/
chmod 600 .ssh/key
sudo service sshd restart

echo "
--- a/etc/network/interfaces
+++ b/etc/network/interfaces
@@ -9,4 +9,9 @@
 
 # The primary network interface
 auto ens33
-iface ens33 inet dhcp
+iface ens33 inet static
+address $node_address
+netmask 255.255.255.0
+gateway $gateway_address
+dns-nameservers $gateway_address
+
" | sudo patch -u -N /etc/network/interfaces -

sudo service networking stop
sudo ip addr flush dev ens33
sudo service networking start

HADOOP_HOME=/home/hadoop

sudo useradd -b $HADOOP_HOME -d $HADOOP_HOME -p $(openssl passwd -1 'pass') hadoop
sudo rm -r $HADOOP_HOME
sudo mkdir $HADOOP_HOME
sudo chown hadoop:hadoop $HADOOP_HOME

cd $HADOOP_HOME
sudo -u hadoop mkdir .ssh
sudo -u hadoop chmod 700 .ssh
sudo -u hadoop cp ~/mnHadoopExamples/keys/key.pub .ssh/authorized_keys
sudo -u hadoop chmod 600 .ssh/authorized_keys
sudo -u hadoop cp ~/mnHadoopExamples/keys/key .ssh/
sudo -u hadoop chmod 600 .ssh/key

sudo service sshd restart

cp /etc/hosts  hosts
for key in ${!nodesMap[@]}; do
   if [ "$key" != "gateway" ]
   then
    echo ${key} ${nodesMap[${key}]} >> hosts
   fi
done

diff -u /etc/hosts hosts hosts.diff
sudo patch -u /etc/hosts hosts.diff




