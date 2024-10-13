# Set-ExecutionPolicy -scope process remotesigned
# Set-ExecutionPolicy -scope currentuser remotesigned
# Server-Syslog.ps1 -f C:\example\syslog.log
# Server-Syslog.ps1 -p 10514

param([int]$port=514,[string]$file)

$ErrorActionPreference="stop"

$enc=New-Object System.Text.ASCIIEncoding

$facility=@("kernel",
            "user",
            "mail",
            "daemon",
            "auth",
            "syslog","
            lpr",
            "news",
            "uucp",
            "cron",
            "auth",
            "ftp",
            "ntp",
            "log audit",
            "log alert",
            "cron",
            "local0",
            "local1",
            "local2",
            "local3",
            "local4",
            "local5",
            "local6",
            "local7")

$severity=@("emerg",
            "alert",
            "crit",
            "err",
            "warning",
            "notice",
            "info",
            "debug")



if($file.Length -gt 0){
    if(!(Test-Path (Split-Path $file))){
        Write-Host "No such path. ($file)"
        exit
    }
}

$client=New-Object System.Net.Sockets.UdpClient($port)
Write-Host "Start listening UDP/$port"

while($true){
    $handler=$client.BeginReceive($null,$null)
    while(!$handler.IsCompleted){
        sleep -Milliseconds 100
    }
    $rcvTime=(Get-Date).ToString("yyyy/MM/dd HH:mm:ss")
    $remoteEnd=New-Object System.Net.IPEndPoint([System.Net.IPAddress]::Any,$null)
    $rcvByte=$client.EndReceive($handler,[ref]$remoteEnd)

    $msg=$enc.GetString($rcvByte,0,$rcvByte.Length)
    if($msg -match "((?<=^<)[0-9]*)>(.*)"){
        $sevCode=[int]$Matches[1]%8
        $facCode=([int]$Matches[1]-$sevCode)/8

        $log=$rcvTime+" "+$facility[$facCode]+" "+$severity[$sevCode]+" :"+$Matches[2]
        Write-Host $log
        if($file.Length -gt 0){
            $log |Out-File -Encoding default -Append $file
        }
    }
}
