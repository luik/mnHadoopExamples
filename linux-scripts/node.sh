#!/bin/bash

node_address="node address wasn't set";
gateway_address="gateway address wasn't set";

while getopts "a:g:b:" opt; do
	case $opt in
		a)
			node_address=$OPTARG;
		;;
		g)
			gateway_address=$OPTARG;
		;;
	esac
done

cd ~ 
sudo apt-get install vim openjdk-8-jdk-headless ssh
mkdir .ssh
chmod 700 .ssh
cp mnHadoopExamples/keys/key.pub ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
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

