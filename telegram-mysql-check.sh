#!/bin/bash

##########################################################################
# Linux envio de alerta de perda de conexão com Mysql pelo Telegram
# Author's: Diego Maia - diegosmaia@yahoo.com.br Telegram - @diegosmaia
# 			Carlos Markennede 					 Telegram - @Markennede
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


mysql --user="${dbuser}" --host="${dbserver}" --password="${dbpass}" -e exit 2>/dev/null
dbstatus=`echo $?`
if [ $dbstatus -ne 0 ]; then
	echo "Servidor não consegue se conectar ao servidor Mysql"
	${CURL} -k -s -c ${COOKIE} -b ${COOKIE} -s -X GET "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage?chat_id=${USER}&text=Impossível se conectar ao BD, o mesmo parece estar Down - Data:  $(date '+%d/%m/%Y-%H:%M:%S')"  > /dev/null
	echo $dbstatus > /tmp/telegram-mysql-check.msg
else
	echo "Success!"
	if [ -f "/tmp/telegram-mysql-check.msg" ]; then
		${CURL} -k -s -c ${COOKIE} -b ${COOKIE} -s -X GET "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage?chat_id=${USER}&text=Conexao com BD - Normalizado - Data:  $(date '+%d/%m/%Y-%H:%M:%S')"  > /dev/null
		rm -rf /tmp/telegram-mysql-check.msg
	fi
	exit 0
fi


exit 0
