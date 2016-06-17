#!/bin/bash

declare -A nodesMap

while read -r line
do
	read -ra values <<< "$line"
	nodesMap[${values[0]}]=${values[1]}
done < "nodes.conf"

#echo "gateway "${nodesMap["gateway"]}

echo "" > host.txt
for key in ${!nodesMap[@]}; do
   if [ "$key" != "gateway" ] 
   then
    echo ${key} ${nodesMap[${key}]} >> host.txt
   fi
done

