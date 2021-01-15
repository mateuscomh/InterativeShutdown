
#!/usr/bin/env bash

#-----------HEADER-------------------------------------------------------------|
# AUTOR             : Matheus Martins 3mhenrique@gmail.com
# HOMEPAGE          : https://github.com/mateuscomh
# DATA CRIAÇÃO   :
# PROGRAMA          : Shell-Base
# VERSÃO            : 1.3
# LICENÇA           : GPL3
# PEQUENA-DESCRIÇÃO : Programa para criação de template.
#
# CHANGELOG :
#29/07/2020 11:00
# -Criado Script de desligamento
# -Função adicionado para aproeitamento de código
#
#03/08/2020 18:00
# -Ajustado script corrigindo erro ao cancelar agendamento
# -Adicionado segurança para evitar inserção de nao numeros
#------------------------------------------------------------------------------|


#----------FUNCOES-------------------------------------------------------------|
_cancela_agenda(){
  zenity --info --text='Agendamento Cancelado'
  sudo /usr/sbin/shutdown -c
  exit 0
}
#----------FIM FUNCOES---------------------------------------------------------|

timer=$(zenity --entry --text="Desligamento do sistema (Em Minutos)");
[ "$?" -eq "1" ] && _cancela_agenda
[ -z "$timer" ] && zenity --question --text="O sistema será encerrado AGORA!! Posso confirmar?" && sudo /usr/sbin/shutdown now

[[ ${timer} =~ ^([0-9]+)$ ]]
if [ "$?" -gt "0" ]; then
  zenity --error --text='Informe o valor em minutos (apenas números)'
  exit 1
fi

if [ "$timer" = "0" ] || [ -z "$timer" ]; then
  zenity --question --text="O sistema será encerrado AGORA!! Posso confirmar?"
  [ "$?" -eq "0" ] && sudo /usr/sbin/shutdown now || exit 1
else
  zenity --question --text="Sistema encerrará em $timer minutos. Posso confirmar?"
  [ "$?" -eq "0" ] && sudo /usr/sbin/shutdown +$timer && /usr/bin/wall "Desligando em $timer minutos." && /usr/bin/wall "Desligamento agendado para $(date --date @$(head -1 /run/systemd/shutdown/scheduled |cut -c6-15))" || exit 1

fi
