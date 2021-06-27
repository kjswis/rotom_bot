#!/bin/zsh

echo "Initializing Setup"
echo "----------------->"

SCRIPT_PATH=${0:A:h}
cd $SCRIPT_PATH
cd ../

bot_const="ROTOM_DIR=$PWD"
fun_path="$SCRIPT_PATH/bash_functions.zsh"
fun_src="[ -f $fun_path ] && source $fun_path"

grep -qxF "$bot_const" ~/.zshrc || echo "$bot_const" >> ~/zshrc
grep -qxF "$fun_src" ~/.zshrc || echo "$fun_src" >> ~/.zshrc

source ~/.zshrc
source $fun_path
echo

echo "Preparing Configuration Files"
echo "---------------------------->"
touch ~/.bash_aliases

echo "Please enter the requested information"
echo "database name:"
read dbname
echo
echo "database user:"
read dbuser
echo
echo "database password:"
read dbpasswd
echo
echo "Create a discord bot and enter the following"
echo "client id:"
read client
echo
echo "secret:"
read secret
echo
echo "bot token:"
read token
echo

echo "Creating Configuration Files"
echo "--------------------------->"
temp_path=templates/env.yml
dest_file=.env
cp "$temp_path" "$dest_file"
while read line; do
  sed -i -e "s/\${dbuser}/${dbuser}/g" "$dest_file"
  sed -i -e "s/\${dbpasswd}/${dbpasswd}/g" "$dest_file"
  sed -i -e "s/\${dbname}/${dbname}/g" "$dest_file"
  sed -i -e "s/\${client}/${client}/g" "$dest_file"
  sed -i -e "s/\${secret}/${secret}/g" "$dest_file"
  sed -i -e "s/\${token}/${token}/g" "$dest_file"
done < "$temp_path"

echo
