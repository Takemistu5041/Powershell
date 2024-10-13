$mac_addr = @("44:8A:5B:15:C2:14","8C:89:A5:4A:55:CF","10:6F:3F:A6:8F:32","00:30:48:B3:2D:74","00:30:48:B3:2D:75")
$header=[byte[]](@(0xFF)*6)
 
foreach ($item in $mac_addr){
    Write-Host "send magic packet to:" $item
    $addr = [byte[]]($item.split(":") | %{ [Convert]::ToInt32($_, 16)});
    $magicpacket = $header + $addr * 16;
    $target = [System.Net.IPAddress]::Broadcast;
 
    $client = New-Object System.Net.Sockets.UdpClient;
    $client.Connect($target, 2304);
 
    $client.Send($magicpacket, $magicpacket.Length) | Out-Null
    $client.Close();
 
    Write-Host "Send magic packet to:" $item -ForegroundColor Green
}
