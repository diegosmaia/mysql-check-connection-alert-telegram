#!/bin/bash

##########################################################################
# Linux envio de alerta de perda de conexão com Mysql pelo Telegram
# Author: Diego Maia - diegosmaia@yahoo.com.br Telegram - @diegosmaia
##########################################################################

CURL="/usr/bin/curl"

SERVIDOR=$(hostname)

# Mysql user e password para conexao
dbuser="root"
dbpass="oldpassword"
dbserver="192.168.0.20"

# O ID DO SEU USUARIO NO TELEGRAM
USER='150000000'

############################################
# O Bot-Token o codigo enviado pelo BotFather
############################################

BOT_TOKEN='161080402:AAGah3HIxM9jUr0NX1WmEKX3cJCv9PyWD58'

############################################
# Envio Mensagem de Texto do Alerta
############################################

######################################################################################
# http://linuxtitbits.blogspot.com.br/2011/01/checking-mysql-connection-status.html
######################################################################################

dbaccess="denied"
count=0
while [ $dbaccess = "success" ] || [ $count -lt 3 ] ; do
	count=$((count+1))
	echo "Checking MySQL connection..."
	mysql --host="${dbserver}" --user="${dbuser}" --password="${dbpass}" -e exit 2>/dev/null
	dbstatus=`echo $?`      
	if [ $dbstatus -ne 0 ]; then
		${CURL} -k -s -c ${COOKIE} -b ${COOKIE} -s -X GET "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage?chat_id=${USER}&text=Banco de dados Mysql no servidor $SERVIDOR esta Down - Data:  $(date '+%d/%m/%Y-%H:%M:%S')"  > /dev/null  
	else
		dbaccess="success"
		echo "Success!"
		exit 0
	fi
done

exit 0
