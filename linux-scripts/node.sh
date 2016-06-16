#!/bin/bash

node_address="node address wasn't set";
gateway_address="gateway address wasn't set";
broadcast_address="broadcast address wasn't set"

while getopts ":a:" opt; do
	case $opt in
		a)
			ip_address=$OPTART;
		;;
		g)
			gateway_address=$OPTART;
		;;
		b)
			broadcast_address=$OPTART;
		;;
	esac
done

cd ~ 
sudo apt-get install vim git openjdk-8-jdk-headless ssh
git clone https://github.com/luik/mnHadoopExamples
mkdir .ssh
chmod 700 .ssh
cp mnHadoopExamples/keys/key.pub ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
sudo service sshd restart

echo "
--- a/etc/network/interfaces
+++ b/etc/network/interfaces
@@ -9,4 +9,10 @@ iface lo inet loopback

 # The primary network interface
 auto ens33
-iface ens33 inet dhcp
+iface ens33 inet static
+ address $node_address
+ netmask 255.255.255.0
+ broadcast $broadcast_address
+ gateway $gateway_address
+dns-nameservers 192.168.202.2
+
" | sudo patch -u -N /etc/network/interfaces -

sudo service network restart
