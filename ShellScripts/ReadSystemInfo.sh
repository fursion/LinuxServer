#!/bin/bash
source ./ShellDll.sh
OutPutFile="fursions"
name="fursion"
mail="fursion@fursion.cn"
echo $(date) >$OutPutFile
echo "name is ${name} email is ${mail}" >>$OutPutFile
text=$(cat rule.json)
#echo $text
#for line in $(cat rule.json); do
#   echo $line
#done
mkdir Out
cd Out
touch test.txt
echo $(ps -al) > text
