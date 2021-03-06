#!/bin/bash
#TS3 Server crack install script
#Written by: 4cheat for www.4cheat.ru

#Configuration settings. Change those to your needs or leave them as provided for standart use.
timeout="5"													#Timeout for update check in s
COLOR1='\033[0;32m'											#green color
COLOR2='\033[0;31m'											#red color
NC='\033[0m'												#no color
check_for_updates="0"										#put 1=YES or 0=NO to check for updates
#Don't change the variables below to make sure the script runs without problems!
scriptversion="0516"										#scriptversion
tsversion="3.0.11.4"                                        #version of teamspeak server
call_home="http://4cheat.ru"								#check for updates
serverdir="/home/$teamspeakuser/teamspeak3-server$version"	#Don't change this!

#################################################################################################

show_credits(){
printf "${COLOR1}#######################################################\n#     TS3 Server вылеченный ${COLOR2}$scriptversion ${COLOR1}от ${COLOR2}4cheat${COLOR1}            #\n#     Посетите наш форум ${COLOR2}www.4cheat.ru${COLOR1}                #\n#######################################################\n${NC}"
}

show_special_credits(){
printf "${COLOR1}#######################################################\n#     Огромное спасибо:                               #\n#                                                     #\n#     - Team ${COLOR2}MESMERiZE / Kube${COLOR1} за создание таблетки    #\n#     - ${COLOR2}Asphyxia${COLOR1}                                      #\n#     - ${COLOR2}Derp${COLOR1}                                          #\n#     - ${COLOR2}Darksephiro${COLOR1}                                   #\n#######################################################\n${NC}"
}

show_success(){
printf "${COLOR1}#######################################################\n#     Спасибо за использование скрипта!                #\n#     Если у вас не возникают какие-либо ошибки значит        #\n#     ваш сервер успешно обновлен до версии $tsversion    #\n#######################################################\n${NC}"
}

show_menu(){
printf "${COLOR1}#######################################################\n#     1) Полная установка сервера                     #\n#     2) Обновление с 3.0.11.${COLOR2}X${COLOR1} до 3.0.11.${COLOR2}4${COLOR1}            #\n#     3) Скрипты антикраша                            #\n#     4) Скрипты автостарта                           #\n#     5) Антикряк                                     #\n#     6) Статус                                       #\n#     7) Дебаг                                        #\n#     8) Показать благодарности                       #\n#     9) Список изменений + инфо                      #\n#     CTRL-C выйти из скрипта                         #\n#######################################################\nAnswer:   ${NC}"
read answer
}

show_changelog(){
printf "${COLOR1}#######################################################\n#             ${COLOR2}Additional information:${COLOR1}                 #\n#                                                     #\n#   Alter the script with your favorite editor to     #\n#   change the following settings:                    #\n#                                                     #\n#   - change script colors                            #\n#   - script checking for updates: yes/no             #\n#   - change timout when checking for new s_versions  #\n#                                                     #\n#                                                     #\n#                    ${COLOR2}Changelog:${COLOR1}                       #\n#                                                     #\n#   v0.4.0.1 - added Status and debug                 #\n#   v0.4.2.1 - added anticrash and autostart scripts  #\n#   v0.4.3.6 - added Update function                  #\n#   v0.5.0.1 - added changelog to the script          #\n#   v0.5.07  - fixed some errors                      #\n#   v0.5.08  - added AntiCrack                        #\n#   v0.5.09  - fixed a c/p error                      #\n#   v0.5.10  - fixed a few typos                      #\n#   v0.5.11  - added infos                            #\n#            - fixed AntiCrash                        #\n#   v0.5.15  - fixed some errors                      #\n#   v0.5.16  - fixed iptables rule                    #\n#            - fixed anticrash again                  #\n#######################################################\n${NC}"
}

set_user(){
printf "${COLOR1}Выбирите пользователя для установки. Если пользователь не существует он будет создан:   ${NC}"
read answer
case $answer in
[rR][oO0][oO0][tT])
	printf "${COLOR1}Пользователь ${COLOR2}$answer${COLOR1} не верный. Завершение...\n${NC}"
	exit 1
;;
[a-zA-Z0-9]*)
	teamspeakuser="$answer"
	if id -u "$teamspeakuser" >/dev/null 2>&1;
	then	if [ ! -d /home/$teamspeakuser/ ]
			then	printf "${COLOR1}Не удалось найти домашний каталог, создаем каталог..\n${NC}"
					mkdir /home/$teamspeakuser
					chown $teamspeakuser:$teamspeakuser /home/$teamspeakuser
			fi
	else
       printf "${COLOR1}Пользователь не существует. Создание его ...\n${NC}"
	adduser $teamspeakuser
	fi
;;
*)	printf "${COLOR1}Пользователь '$answer' не верный. Завершение...\n${NC}"
	exit 1
;;
esac
}

set_hosts_file(){
grep -v '.*teamspeak.*' /etc/hosts > /etc/hosts_temporary
mv /etc/hosts_temporary /etc/hosts
grep -v '.*ocsp\.digicert.com.*' /etc/hosts > /etc/hosts_temporary
mv /etc/hosts_temporary /etc/hosts
sed -i '1i127.0.0.1     teamspeak.com' /etc/hosts
sed -i '1i127.0.0.1     accounting.teamspeak.com' /etc/hosts
sed -i '1i127.0.0.1     backupaccounting.teamspeak.com' /etc/hosts
sed -i '1i127.0.0.1     blacklist.teamspeak.com' /etc/hosts
sed -i '1i127.0.0.1     ipcheck.teamspeak.com' /etc/hosts
sed -i '1i127.0.0.1     ocsp.digicert.com' /etc/hosts
sed -i '1i127.0.0.1     hardy.teamspeak.4players.de' /etc/hosts
sed -i '1i::1           teamspeak.com' /etc/hosts
sed -i '1i::1           accounting.teamspeak.com' /etc/hosts
sed -i '1i::1           backupaccounting.teamspeak.com' /etc/hosts
sed -i '1i::1           blacklist.teamspeak.com' /etc/hosts
sed -i '1i::1           ipcheck.teamspeak.com' /etc/hosts
sed -i '1i::1           ocsp.digicert.com' /etc/hosts
sed -i '1i::1           hardy.teamspeak.4players.de' /etc/hosts
echo " "
}

set_ts3server_ini(){
printf 'machine_id=\ndefault_voice_port=9987\nvoice_ip=0.0.0.0\nlicensepath=\nfiletransfer_port=30033\nfiletransfer_ip=0.0.0.0\nquery_port=10011\nquery_ip=0.0.0.0\nquery_ip_whitelist=query_ip_whitelist.txt\nquery_ip_blacklist=query_ip_blacklist.txt\ndbplugin=ts3db_sqlite3\ndbpluginparameter=\ndbsqlpath=sql/\ndbsqlcreatepath=create_sqlite/\ndbconnections=10\nlogpath=logs\nlogquerycommands=1\ndbclientkeepdays=90\ndblogkeepdays=30\nlogappend=0\nquery_skipbruteforcecheck=0\n' > /home/$teamspeakuser/teamspeak3-server$version/ts3server.ini
printf "${COLOR1}Хотите изменить стандартный query порт (по умолчанию: 10011)? (Y)Да | (N)Нет  :${NC}"
read stuff
case "$stuff" in
N*|n*)
;;
*)
printf "${COLOR1}Введите новый query_port (по умолчанию: 10011)   :${NC}"
read qport
grep -v '.*query_port.*' /home/$teamspeakuser/teamspeak3-server$version/ts3server.ini > /home/$teamspeakuser/teamspeak3-server$version/ts3server.ini_temp
mv /home/$teamspeakuser/teamspeak3-server$version/ts3server.ini_temp /home/$teamspeakuser/teamspeak3-server$version/ts3server.ini
echo "query_port=$qport" >> /home/$teamspeakuser/teamspeak3-server$version/ts3server.ini
;;
esac
}

set_permissions(){
chown -R $teamspeakuser:$teamspeakuser /home/$teamspeakuser
}

check_os(){
unamestr=`uname`
unamever=`uname -m`
#check Linux or FreeBSD
if [[ "$unamestr" == 'Linux' ]]
then os="_linux"
elif [[ "$unamestr" == 'FreeBSD' ]]
then os="_freebsd"
fi
#check 32bit or 64bit
if [[ "$unamever" == 'x86_64' ]]
then osv="-amd64"
else osv="-x86"
fi
#set version
version="$os$osv"
}

download_server(){
cd /home/$teamspeakuser/
case $version in
\_linux\-x86)
wget 'https://github.com/4cheat/123456/raw/master/teamspeak3-server_linux-x86.tar.gz' -O crack.tar.gz
;;
\_linux\-amd64)
wget 'https://github.com/4cheat/123456/raw/master/teamspeak3-server_linux-amd64.tar.gz' -O crack.tar.gz
;;
\_freeBSD\-x86)
printf "${COLOR1}FreeBSD 32bit не поддерживается данным скриптом.\n${NC}"
exit 1
#wget --no-check-certificate '' -O crack.tar.gz
;;
\_freeBSD\-amd64)
echo "${COLOR1}FreeBSD 64bit не поддерживается данным скриптом.\n${NC}"
exit 1
#wget --no-check-certificate '' -O crack.tar.gz
;;
esac
tar xf crack.tar.gz
rm crack.tar.gz
}

update_server(){
case $version in
\_linux\-x86)
wget 'https://github.com/4cheat/123456/raw/master/ts3server_linux_x86' -O ts3server_linux_x86
stop_ts3_server
mv "ts3server_linux_x86" "$serverdir/ts3server_linux_x86"
chown "$teamspeakuser":"$teamspeakuser" "$serverdir/ts3server_linux_x86"
;;
\_linux\-amd64)
wget 'https://github.com/4cheat/123456/raw/master/ts3server_linux_amd64' -O ts3server_linux_amd64
stop_ts3_server
mv "ts3server_linux_amd64" "$serverdir/ts3server_linux_amd64"
chown "$teamspeakuser":"$teamspeakuser" "$serverdir/ts3server_linux_amd64"
;;
\_freeBSD\-x86)
printf "${COLOR2}FreeBSD 32bit не поддерживается данным скриптом.\n${NC}"
exit 1
#wget --no-check-certificate '' -O crack.tar.gz
;;
\_freeBSD\-amd64)
echo "${COLOR2}FreeBSD 64bit не поддерживается данным скриптом.\n${NC}"
exit 1
#wget --no-check-certificate '' -O crack.tar.gz
;;
esac
}

stop_ts3_server(){
su $teamspeakuser /home/$teamspeakuser/teamspeak3-server$version/./ts3server_startscript.sh stop
}

kill_ts3_server(){
pkill -f ts3server
}

stop_acc_server(){
pkill -f AccountingServerEmulator-Linux
}

start_ts3_server(){
su $teamspeakuser -c "/home/$teamspeakuser/teamspeak3-server$version/./ts3server_startscript.sh start"
}

start_acc_server(){
su - $teamspeakuser -c "/home/$teamspeakuser/teamspeak3-server$version/./AccountingServerEmulator-Linux"
}

check_for_root(){
if [ "$(id -u)" != "0" ]; then
	printf "${COLOR1}\nДанный скрипт должен быть запущен с правами суперадминистратора (root)!\n${NC}" 1>&2
	exit 1
fi
}

get_teamspeakuser(){
printf "${COLOR1}Ввидите пользователя от которого будет запускаться TeamSpeak:   ${NC}"
read teamspeakuser
serverdir="/home/$teamspeakuser/teamspeak3-server$version"
}

get_dir(){
printf "${COLOR1}Вы хотите установить TeamSpeak Server в ${COLOR2}$serverdir${COLOR1} ?\n (Y)Да | (N)Нет:   ${NC}"
read answer
case $answer in
n*|N*)	printf "${COLOR1}Укажите ${COLOR2}exact${COLOR1} путь установки (как показано выше):   ${NC}"
		read new_dir
		serverdir=$new_dir
;;
esac
}

install_anticrash(){
rm /etc/init.d/ts3anticrash.sh 2>/dev/null
printf "#!/bin/bash\ncase "\$1" in\nts3server)\nt3server=\`ps ax | grep ts3server$version | grep -v grep | wc -l\`\nif [ \$t3server -eq 1 ]\nthen exit\nelse cd $serverdir/\n./ts3server_startscript.sh start\nfi\n;;\nts3accounting)\nt3accounting=\`ps ax | grep AccountingServer | grep -v grep | wc -l\`\nif [ \$t3accounting -eq 1 ]\nthen exit\nelse\ncd $serverdir/\n./AccountingServerEmulator-Linux\nfi\n;;\nts3tsdns)\nt3tsdns=\`ps ax | grep tsdnsserver$version | grep -v grep | wc -l\`\nif [ \$t3tsdns -eq 2 ]\nthen exit\nelse\ncd $serverdir/tsdns\nscreen -AmdS tsdnsserver ./tsdnsserver$version\nfi\n;;\nesac\n" >> /etc/init.d/ts3anticrash.sh
chown $teamspeakuser:$teamspeakuser /etc/init.d/ts3anticrash.sh
chmod +x /etc/init.d/ts3anticrash.sh

printf "${COLOR1}Настройка скрипта антикраша для сервера TS3?\n(A)Активировать | (D)Деактивировать:   ${NC}"
read answer
case $answer in
	A*|a*)
	crontab -l -u $teamspeakuser > crontab_temp
	cat crontab_temp | grep -v ts3server >crontab_temp2
	printf "*/1 * * * * /etc/init.d/ts3anticrash.sh ts3server\n" >>crontab_temp2
	crontab -u $teamspeakuser crontab_temp2
	rm crontab_temp2 crontab_temp
	printf "${COLOR1}Антикраш активирован.\n${NC}"
	;;
	*)
	crontab -l -u $teamspeakuser > crontab_temp
	cat crontab_temp | grep -v ts3server >crontab_temp2
	crontab -u $teamspeakuser crontab_temp2
	rm crontab_temp2 crontab_temp
	printf "${COLOR2}Антикраш деактивирован.\n${NC}"
	;;
esac

printf "${COLOR1}Настройка скрипта антикраша для сервера лицензий TS3?\n(A)Активировать | (D)Деактивировать:   ${NC}"
read answer
case $answer in
	A*|a*) 
	crontab -l -u $teamspeakuser > crontab_temp
	cat crontab_temp | grep -v ts3accounting >crontab_temp2
	printf "*/25 * * * * /etc/init.d/ts3anticrash.sh ts3accounting\n" >>crontab_temp2
	crontab -u $teamspeakuser crontab_temp2
	rm crontab_temp2 crontab_temp
	printf "${COLOR1}Антикраш активирован.\n${NC}"
	;;
	*)
	crontab -l -u $teamspeakuser > crontab_temp
	cat crontab_temp | grep -v ts3accounting >crontab_temp2
	crontab -u $teamspeakuser crontab_temp2
	rm crontab_temp2 crontab_temp
	printf "${COLOR2}Антикраш деактивирован.\n${NC}"
	;;
esac

printf "${COLOR1}Настройка скрипта антикраша для TSDNS сервера TS3?\nЕсли Вы не уверенны в этом действии укажите - деактивировать.\n(A)Активировать | (D)Деактивировать:   ${NC}"
read answer
case $answer in
	A*|a*) 
	crontab -l -u $teamspeakuser > crontab_temp
	cat crontab_temp | grep -v ts3tsdns >crontab_temp2
	printf "*/1 * * * * /etc/init.d/ts3anticrash.sh ts3tsdns\n" >>crontab_temp2
	crontab -u $teamspeakuser crontab_temp2
	rm crontab_temp2 crontab_temp
	printf "${COLOR1}Антикраш активирован.\n${NC}"
	;;
	*)
	crontab -l -u $teamspeakuser > crontab_temp
	cat crontab_temp | grep -v ts3tsdns >crontab_temp2
	crontab -u $teamspeakuser crontab_temp2
	rm crontab_temp2 crontab_temp
	printf "${COLOR2}Антикраш деактивирован.\n${NC}"
	;;
esac

}

install_autostart_scripts(){
printf "#!/bin/sh\n### BEGIN INIT INFO\n# Provides:                     ts3server\n# Required-Start:               \$local_fs \$network\n# Required-Stop:                \$local_fs \$network\n# Default-Start:                2 3 4 5\n# Default-Stop:                 0 1 6\n# Description:                  Teamspeak 3 Server\n#\n### END INIT INFO#!/bin/sh\n\ncase "\$1" in\nstart)\nsleep 1\ncd $serverdir\nsu $teamspeakuser -c \"./ts3server_startscript.sh start\"\n;;\nstop)\ncd $serverdir\nsu $teamspeakuser -c \"./ts3server_startscript.sh stop\"\n;;\nesac\nexit 0" >> /etc/init.d/ts3server
printf "#!/bin/sh\n### BEGIN INIT INFO\n# Provides:                     accserver\n# Required-Start:               \$local_fs \$network\n# Required-Stop:                \$local_fs \$network\n# Default-Start:                2 3 4 5\n# Default-Stop:                 0 1 6\n# Description:                  AccountingServerEmulator-Linux\n#\n### END INIT INFO#!/bin/sh\n\ncase "\$1" in\nstart)\nsleep 1\ncd $serverdir\nsu $teamspeakuser -c \"./AccountingServerEmulator-Linux\"\n;;\nstop)\ncd $serverdir\nsu $teamspeakuser -c \"./AccountingServerEmulator-Linux stop\"\n;;\nesac\nexit 0" >> /etc/init.d/accserver
chmod +x /etc/init.d/ts3server
chmod +x /etc/init.d/accserver
update-rc.d ts3server defaults
update-rc.d accserver defaults
printf "${COLOR1}Установить скрипт автозапуска для TSDNS сервера?\nЕсли Вы не уверенны в этом укажите - Нет.\n(Y)Да | (N)Нет:   ${NC}"
read answer
case $answer in
Y*|y*|j|J*) 
printf "#!/bin/sh\n### BEGIN INIT INFO\n# Provides:                     tsdnsserver\n# Required-Start:               \$local_fs \$network\n# Required-Stop:                \$local_fs \$network\n# Default-Start:                2 3 4 5\n# Default-Stop:                 0 1 6\n# Short-Description:\n# Description:                  Teamspeak 3 TSDNS Server\n#\n### END INIT INFO#!/bin/sh\n\ncase "$1" in\nstart)\ncd $serverdir/tsdns\nsu $teamspeakuser -c \"screen -AmdS tsdnsserver ./tsdnsserver_$version\"\n;;\nstop)\nsu ts3 -c "screen -S tsdnsserver -X quit"\n;;\nesac\nexit 0" >> /etc/init.d/tsdnsserver
chmod +x /etc/init.d/tsdnsserver
update-rc.d tsdnsserver defaults
;;
esac
printf "${COLOR1}Скрипты автозапуска установленны.\n${NC}"
}

get_status_ts3server(){
t3server=`ps ax | grep ts3server | grep -v grep | wc -l`
printf "${COLOR1}#######################################################\n${NC}"
if [ $t3server -eq 0 ]
	then printf "${COLOR1}#       ${COLOR2}-> TeamSpeak сервер не запущен!${COLOR1}              #\n${NC}"
	else printf "${COLOR1}#       -> TeamSpeak сервер запущен.               #\n${NC}"
fi
}

get_status_accserver(){
t3accounting=`ps ax | grep AccountingServerEmulator-Linux | grep -v grep | wc -l`
if [ $t3accounting -eq 0 ]
	then printf "${COLOR1}#       ${COLOR2}-> Сервер лицензий не запущен!${COLOR1}          #\n${NC}"
	else printf "${COLOR1}#       -> Сервер лицензий запущен.              #\n${NC}"
fi
}

get_status_tsdnsserver(){
t3tsdns=`ps ax | grep tsdnsserver | grep -v grep | wc -l`
if [ $t3tsdns -eq 2 ]
	then printf "${COLOR1}#       -> TSDNS сервер запущен.                   #\n${NC}"
	else printf "${COLOR1}#       ${COLOR2}-> TSDNS сервер не запущен!${COLOR1}               #\n${NC}"
fi
}

get_status_hosts(){
ts3hosts=`grep -o '.*teamspeak.*' /etc/hosts | wc -l`
if [ $ts3hosts -gt 11 ]
	then printf "${COLOR1}#       -> Hosts файл настроен.              #\n${NC}"
	else printf "${COLOR2}#       ${COLOR2}-> Hosts файл не настроен!.${COLOR1}          #\n${NC}"
fi
printf "${COLOR1}#######################################################\n${NC}"
}

check_version(){
if [ $check_for_updates -eq 1 ]; then
	printf "${COLOR1}Checking for updates..."
	curl -s -m $timeout --head $call_home/script.php | head -n 1 | grep "HTTP/1.[01] [2].." > /dev/$
	if [ $? = 1 ];
	then  printf "${COLOR2}\nОбновлений скрипта не найдено.\nПерезагрузите скрипт чтобы повторить попыптку.\nПроверьте тему на форуме на наличие новостей\n${NC}"
	else
		sversion=$(wget $call_home/script.php?version -q -O -)
		if [ $sversion \> $scriptversion ];
			then printf "${COLOR1}\nНайдена новая версия, загрузка...\n${NC}"
			update_script
			else printf "${COLOR1}       ...скрипт обновлен!\n${NC}"
		fi
	fi
fi
}

update_script(){
slink=$(wget $call_home/script.php?link -q -O -)
wget $slink -q -O ts3crack_$sversion
chmod +x ts3crack_$sversion
rm ts3crack_$scriptversion
./ts3crack_$sversion
}

restart_script(){
printf "${COLOR1}Успешное выполнение. Нажмите любую клавишу для продолжения...\n${NC}"
read -n 1
clear
$0
}

check_packages(){
command -v iptables >/dev/null 2>&1 || error_iptables="1"
if [[ $error_iptables -eq 1 ]]
	then
	printf >&2 "${COLOR1}Утилита IPTABLES не установленна, она необходима для корректной работы.\n Введите ${COLOR2}apt-get install iptables${COLOR1} если используете Ubuntu и Debian, или ${COLOR2}yum install iptables${COLOR1} если используете CentOS\n${NC}"
	read answer
	$answer
	restart_script
fi
command -v curl >/dev/null 2>&1 || error_curl="1"
if [[ $error_curl -eq 1 ]]
	then
	printf >&2 "${COLOR1}Утилита CURL не установленна, она необходима для корректной работы.\n Введите ${COLOR2}apt-get install curl${COLOR1} если используете Ubuntu и Debian, или ${COLOR2}yum install curl${COLOR1} если используете CentOS\n${NC}"
	read answer
	$answer
	restart_script
fi
command -v screen >/dev/null 2>&1 || error_curl="1"
if [[ $error_curl -eq 1 ]]
	then
	printf >&2 "${COLOR1}Утилита Screen не установленна, она необходима для корректной работы.\n Введите ${COLOR2}apt-get install screen${COLOR1} если используете Ubuntu и Debian, или ${COLOR2}yum install curl${COLOR1} если используете CentOS\n${NC}"
	read answer
	$answer
	restart_script
fi
}

set_iptables(){
printf "${COLOR1}#######################################################\n#     Важно: Сервер будет выглядеть как               #\n#     \"not cracked\" для сервиса CrackCheckers если антикряк активирован.    #\n#     1) Активировать антикряк                           #\n#     2) Деактивировать антикряк                         #\n#######################################################\nAnswer:   ${NC}"
read answer
iptables -D INPUT -p tcp --dport 2008 -j DROP 2>/dev/null
iptables -D INPUT -p tcp --dport 2008 -s 127.0.0.1 -j ACCEPT 2>/dev/null
case $answer in
1)
iptables -I INPUT -p tcp --dport 2008 -j DROP
iptables -I INPUT -p tcp --dport 2008 -s 127.0.0.1 -j ACCEPT
iptables-save
printf "${COLOR1}Антикряк активирован.\n${NC}"
;;
*)
iptables-save
printf "${COLOR2}Антикряк деактевирован.\n${NC}"
;;
esac
}

help(){
printf "${COLOR1}#######################################################\n#       1) back to main menu                          #\n#       show_credits                                  #\n#       show_special_credits                          #\n#       show_success                                  #\n#       show_menu                                     #\n#       set_user                                      #\n#       set_hosts_file                                #\n#       set_ts3server_ini                             #\n#       set_permissions                               #\n#       check_os                                      #\n#       download_server                               #\n#       update_server                                 #\n#       stop_ts3_server                               #\n#       kill_ts3_server                               #\n#       stop_acc_server                               #\n#       start_ts3_server                              #\n#       start_acc_server                              #\n#       check_for_root                                #\n#       get_teamspeakuser                             #\n#       get_dir                                       #\n#       install_anticrash                             #\n#       install_autostart_scripts                     #\n#       check_version                                 #\n#       check_packages                                #\n#       set_iptables                                  #\n#       update_script                                 #\n#       help                                          #\n#######################################################\n${NC}"
}

debug(){
printf "${COLOR1}Выбирите команду:   ${NC}"
read command
case $command in
show_credits) 				show_credits				;;
show_special_credits)		show_special_credits		;;
show_success) 				show_success				;;
show_menu) 					show_menu					;;
set_user)					set_user					;;
set_hosts_file)				set_hosts_file				;;
set_ts3server_ini)			set_ts3server_ini			;;
set_permissions)			set_permissions				;;
check_os)					check_os					;;
download_server)			download_server				;;
update_server)				update_server				;;
stop_ts3_server)			stop_ts3_server				;;
kill_ts3_server)			kill_ts3_server				;;
stop_acc_server)			stop_acc_server				;;
start_ts3_server)			start_ts3_server			;;
start_acc_server)			start_acc_server			;;
check_for_root)				check_for_root				;;
get_teamspeakuser)			get_teamspeakuser			;;
get_dir)					get_dir						;;
install_anticrash)			install_anticrash			;;
install_autostart_scripts)	install_autostart_scripts	;;
get_status_ts3server)		get_status_ts3server		;;
get_status_accserver)		get_status_accserver		;;
get_status_tsdnsserver)		get_status_tsdnsserver		;;
check_version)				check_version				;;
update_script)				update_script				;;
check_packages)				check_packages				;;
set_iptables)				set_iptables				;;
help)						help						;;
1)							$0							;;
esac
}

#################################################################################################
# todo for debug/help:			-
#################################################################################################

show_credits
check_for_root
check_packages
check_os
check_version
show_menu
case $answer in
1*)
check_os
set_user
kill_ts3_server
stop_acc_server
set_hosts_file
download_server
set_ts3server_ini
set_permissions
start_ts3_server
start_acc_server
;;
2*)
get_teamspeakuser
get_dir
update_server
start_ts3_server
show_success
;;
3*)
check_os
get_teamspeakuser
get_dir
install_anticrash
sleep 0.5
restart_script
;;
4*)
check_os
get_teamspeakuser
get_dir
install_autostart_scripts
sleep 0.5
restart_script
;;
5)
set_iptables
restart_script
;;
6*)
check_os
get_status_ts3server
get_status_accserver
get_status_tsdnsserver
get_status_hosts
sleep 0.5
restart_script
;;
7*)
printf "${COLOR1}#######################################################\n#     Нажмите ${COLOR2}CTRL-C${COLOR1} чтобы выйти из режима!           #\n#     Введите ${COLOR2}help${COLOR1} чтобы просмотреть все команды      #\n#######################################################\n${NC}"
i=0
while [ $i -lt 1 ]
do
debug
done
;;
8*)
show_special_credits
sleep 0.5
restart_script
;;
9*)
show_changelog
sleep 0.5
restart_script
;;
*)
clear
show_menu
;;
esac
exit
