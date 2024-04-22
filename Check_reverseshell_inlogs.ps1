do{
$date = Get-Date | select date
$date2 = $date.date.ToString()
$date3 = $date2[6]+$date2[7]+$date2[8]+$date2[9]+$date2[3]+$date2[4]+$date2[0]+$date2[1]
$loglocation = "c:\windows\logs\$date3"
$transscripts =(Get-ChildItem -Recurse $loglocation).FullName
$transscripts_old =(Get-ChildItem -Recurse $loglocation)
$transscripts | ForEach-Object -Process {
$content = Get-Content $_
#define your Paniccommands you want to check for
$paniccontent = "System.Net.Sockets.TCPClient"
$paniccontent2 = "wget"
if($content -match $paniccontent)
{
write-host -ForegroundColor Red "potencial tcp reverseshell in logfile $_ detected!!! ACT ASAP"
}
if($content -match $paniccontent2)
{
write-host -ForegroundColor Red "wget command in logfile $_ detected!!! ACT ASAP"
}
}
start-sleep -seconds 1
}while($true)
