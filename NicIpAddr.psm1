function Get-NicIpConfig{
<# Usage
Get-NetAdapter|? InterfaceDescription -Match "Gigabit|GBE|Network Connection"|Get-NicIpConfig;
#>
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
    [uint32]$InterfaceIndex
  )
  Process{
    Get-NetIPConfiguration -InterfaceIndex $InterfaceIndex|
    ForEach-Object{[PSCustomObject]@{
      InterfaceIndex = [uint32]($_.InterfaceIndex);
      InterfaceAlias = [string]($_.InterfaceAlias);
      InterfaceDescription = [string]($_.InterfaceDescription);
      "NetAdapter.Status" = [string]($_.NetAdapter.Status);
      "NetProfile.Name" = [string]($_.NetProfile.Name);
      "NetProfile.NetworkCategory" = [string]($_.NetProfile.NetworkCategory);
      IPv4Dhcp = [string]($_.NetIPv4Interface.Dhcp);
      IPv6Dhcp = [string]($_.NetIPv6Interface.Dhcp);
      IPv4Address = [string[]]($_.IPv4Address|Where-Object{$_}|ForEach-Object{"$($_.IPAddress)/$($_.PrefixLength)"});
      IPv6Address = [string[]]($_.IPv6Address|Where-Object{$_}|ForEach-Object{"$($_.IPAddress)/$($_.PrefixLength)"});
      IPv4DefaultGateway = [string[]]($_.IPv4DefaultGateway.NextHop);
      IPv6DefaultGateway = [string[]]($_.IPv6DefaultGateway.NextHop);
      DNSServer = [string[]]($_.DNSServer.ServerAddresses);
    }};
  }
}
function Set-NicDhcp{
<# Usage
Get-NetAdapter|? InterfaceDescription -Match "Gigabit|GBE|Network Connection"|Set-NicDhcp;
#>
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
    [uint32]$InterfaceIndex
  )
  Process{
    # disable dhcp
    ### "Tcpip"/"Tcpip6" Services EnableDHCP property set to disabled
    $ifGuid = (Get-NetAdapter -InterfaceIndex $InterfaceIndex).InterfaceGuid;
    Set-ItemProperty -Path(
      "HKLM:\SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\$ifGuid",
      "HKLM:\SYSTEM\CurrentControlSet\services\Tcpip6\Parameters\Interfaces\$idGuid"
    ) -Name EnableDHCP -Value 0;
    ### "Set-NetIPInterface -Dhcp Disabled" Cmdlet cannot affect IPv4 DHCP Disconnected NIC
    Set-NetIPInterface -InterfaceIndex $InterfaceIndex -Dhcp Disabled -Confirm:$false;
    # remove ipaddr
    Remove-NetIPAddress -InterfaceIndex $InterfaceIndex -Confirm:$false;
    # remove route
    Remove-NetRoute -InterfaceIndex $InterfaceIndex -Confirm:$false;
    # remove dnsserver
    Set-DnsClientServerAddress -InterfaceIndex $InterfaceIndex -ResetServerAddresses -Confirm:$false;
    # enable dhcp
    Set-NetIPInterface -InterfaceIndex $InterfaceIndex -Dhcp Enabled -Confirm:$false;
    # get nicipconfig
    Get-NicIpConfig -InterfaceIndex $InterfaceIndex;
  }
}
function Set-NicStaticIpAddr{
<# Usage
Get-NetAdapter|? InterfaceDescription -like "*USB 3.0 to Gigabit Ethernet Adapter*")|
Set-NicStaticIpAddr -IpAddress 192.168.100.10 -PrefixLength 24 -DefaultGateway 192.168.100.1 -DnsServer 192.168.100.1;
#>
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
    [uint32]$InterfaceIndex,
    [string]$IpAddress,
    [byte]$PrefixLength,
    [string]$DefaultGateway,
    [string[]]$DnsServer
  )
  Process{
    # disable dhcp
    ### "Tcpip"/"Tcpip6" Services EnableDHCP property set to disabled
    $ifGuid = (Get-NetAdapter -InterfaceIndex $InterfaceIndex).InterfaceGuid;
    Set-ItemProperty -Path(
      "HKLM:\SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\$ifGuid",
      "HKLM:\SYSTEM\CurrentControlSet\services\Tcpip6\Parameters\Interfaces\$ifGuid"
    ) -Name EnableDHCP -Value 0;
    ### "Set-NetIPInterface -Dhcp Disabled" Cmdlet cannot affect IPv4 DHCP Disconnected NIC
    Set-NetIPInterface -InterfaceIndex $InterfaceIndex -Dhcp Disabled -Confirm:$false;
    # remove netroute
    Remove-NetRoute -InterfaceIndex $InterfaceIndex -Confirm:$false;
    # remove dnsserver
    Set-DnsClientServerAddress -InterfaceIndex $InterfaceIndex -ResetServerAddresses -Confirm:$false;
    # remove ipaddr
    Remove-NetIPAddress -InterfaceIndex $InterfaceIndex -Confirm:$false;
    # new ipaddr
    New-NetIPAddress -InterfaceIndex $InterfaceIndex -IPAddress $IpAddress -PrefixLength $PrefixLength -DefaultGateway $DefaultGateway -Confirm:$false|Out-Host;
    # set dnsserver
    Set-DnsClientServerAddress -InterfaceIndex $InterfaceIndex -ServerAddresses $DnsServer -Confirm:$false;
    # get nicipconfig
    Get-NicIpConfig -InterfaceIndex $InterfaceIndex;
  }
}
class WlanProfIpData{
  [int]$type;
  [Net.IpAddress]$ipv4;
  [Net.IpAddress]$ipv6;
  [byte]$masklen;
  WlanProfIpData(){
    $this.type = 0;
    $this.ipv4 = "0.0.0.0";
    $this.ipv6 = "::";
    $this.masklen = 0;
  }
  [byte[]]GetBytes(){
    $r = $();
    $r += [BitConverter]::GetBytes($this.type);
    $r += $this.ipv4.MapToIPv4().GetAddressBytes();
    $r += $this.ipv6.MapToIPv6().GetAddressBytes();
    $r += @([byte]0) * 104;
    return $r;
  }
  [byte[]]GetCidrBytes(){
    $r = $this.GetBytes();
    $r += @($this.masklen);
    $r += @([byte]0) * 7;
    return $r;
  }
  [string]ToString(){
    switch ($this.type){
      2{
        if($this.masklen -gt 0){
          return "{0}/{1}" -f $this.ipv4,$this.masklen;
        } else{
          return $($this.ipv4);
        }
      }
      23{
        if($this.masklen -gt 0){
          return "{0}/{1}" -f $this.ipv6,$this.masklen;
        } else{
          return $($this.ipv6);
        }
      }
    }
    return [void]$null;
  }
  [Net.IpAddress]GetAddr(){
    switch ($this.type){
      2{ return $this.ipv4.MapToIPv4(); }
      23{ return $this.ipv6.MapToIPv6(); }
    }
    return [void]$null;
  }
  static [WlanProfIpData]Parse([byte[]]$bytes){
    $r = New-Object WlanProfIPData;
    $r.type = [BitConverter]::ToInt32($bytes, 0);
    $r.ipv4 = [byte[]]($bytes[4..7]);
    $r.ipv6 = [byte[]]($bytes[8..23]);
    return $r;
  }
  static [WlanProfIpData]CidrParse([byte[]]$bytes){
    $r = New-Object WlanProfIPData;
    $r.type = [BitConverter]::ToInt32($bytes, 0);
    $r.ipv4 = [byte[]]($bytes[4..7]);
    $r.ipv6 = [byte[]]($bytes[8..23]);
    $r.masklen = $bytes[128];
    return $r;
  }
  static [WlanProfIpData]V4([Net.IpAddress]$addr, [byte]$masklen){
    $r = New-Object WlanProfIPData;
    $r.type = 2;
    $r.ipv4 = $addr.MapToIPv4();
    $r.ipv6 = "::";
    $r.masklen = $masklen;
    return $r;
  }
  static [WlanProfIpData]V6([Net.IpAddress]$addr, [byte]$masklen){
    $r = New-Object WlanProfIPData;
    $r.type = 23;
    $r.ipv4 = "0.0.0.0";
    $r.ipv6 = $addr.MapToIPv6();
    $r.masklen = $masklen;
    return $r;
  }
}
class WlanProfIpConfigData{
  [WlanProfIpData[]]$ipaddr;
  [WlanProfIpData[]]$gateway;
  [WlanProfIpData[]]$dnsserver;
  WlanProfIpConfigData(){
    $this.ipaddr = @();
    $this.gateway = @();
    $this.dnsserver = @();
  }
  [byte[]] GetBytes(){
    $len_ipaddr = $this.ipaddr.Length;
    $len_gateway = $this.gateway.Length;
    $len_dnsserver = $this.dnsserver.Length;
    $off_ipaddr = 28;
    $off_gateway = 136 * $len_ipaddr + $off_ipaddr;
    $off_dnsserver = 136 * $len_gateway + $off_gateway;
    if($len_ipaddr -eq 0){ $off_ipaddr = 0; }
    if($len_gateway -eq 0){ $off_gateway = 0; }
    if($len_dnsserver -eq 0){ $off_dnsserver = 0; }
    $r = [BitConverter]::GetBytes([int]0);
    $r += [BitConverter]::GetBytes($len_ipaddr);
    $r += [BitConverter]::GetBytes($off_ipaddr);
    $r += [BitConverter]::GetBytes($len_gateway);
    $r += [BitConverter]::GetBytes($off_gateway);
    $r += [BitConverter]::GetBytes($len_dnsserver);
    $r += [BitConverter]::GetBytes($off_dnsserver);
    for($i = 0; $i -lt $len_ipaddr; $i++){
      $r += $this.ipaddr[$i].GetCidrBytes();
    }
    for($i = 0; $i -lt $len_gateway; $i++){
      $r += $this.gateway[$i].GetCidrBytes();
    }
    for($i = 0; $i -lt $len_dnsserver; $i++){
      $r += $this.dnsserver[$i].GetBytes();
    }
    return $r;
  }
  static [WlanProfIpConfigData] Parse([byte[]]$bytes){
    $r = New-Object WlanProfIpConfigData;
    if(-not $bytes){ return $r; }
    $len_ipaddr    = [BitConverter]::ToInt32($bytes,  4);
    $off_ipaddr    = [BitConverter]::ToInt32($bytes,  8);
    $len_gateway   = [BitConverter]::ToInt32($bytes, 12);
    $off_gateway   = [BitConverter]::ToInt32($bytes, 16);
    $len_dnsserver = [BitConverter]::ToInt32($bytes, 20);
    $off_dnsserver = [BitConverter]::ToInt32($bytes, 24);
    for($i = 0; $i -lt $len_ipaddr; $i++){
      $off = $i * 136 + $off_ipaddr;
      $r.ipaddr += ([WlanProfIpData]::CidrParse($bytes[$off..($off+135)]));
    }
    for($i = 0; $i -lt $len_gateway; $i++){
      $off = $i * 136 + $off_gateway;
      $r.gateway += [WlanProfIpData]::CidrParse($bytes[$off..($off+135)]);
    }
    for($i = 0; $i -lt $len_dnsserver; $i++){
      $off = $i * 128 + $off_dnsserver;
      $r.dnsserver += [WlanProfIpData]::Parse($bytes[$off..($off+127)]);
    }
    return $r;
  }
  static [WlanProfIpConfigData]V4(
    [Net.IPAddress]$ipaddr,
    [byte]$masklen,
    [Net.IPAddress]$gateway,
    [Net.IPAddress]$dnsserver1,
    [Net.IPAddress]$dnsserver2
  ){
    $r = New-Object WlanProfIpConfigData;
    $r.ipaddr = @($ipaddr)|
      Where-Object{$_}|
      ForEach-Object{[WlanProfIpData]::V4($_, $masklen)};        
    $r.gateway = @($gateway)|
      Where-Object{$_}|
      ForEach-Object{[WlanProfIpData]::V4($_, 0)};
    $r.dnsserver = @($dnsserver1,$dnsserver2)|
      Where-Object{$_}|
      ForEach-Object{[WlanProfIpData]::V4($_, 0)};
    return $r;
  }
  static [WlanProfIpConfigData]V6(
    [Net.IPAddress]$ipaddr,
    [byte]$masklen,
    [Net.IPAddress]$gateway,
    [Net.IPAddress]$dnsserver1,
    [Net.IPAddress]$dnsserver2
  ){
    $r = New-Object WlanProfIpConfigData;
    $r.ipaddr = @($ipaddr)|
      Where-Object{$_}|
      ForEach-Object{[WlanProfIpData]::V6($_, $masklen)};        
    $r.gateway = @($gateway)|
      Where-Object{$_}|
      ForEach-Object{[WlanProfIpData]::V6($_, 0)};
    $r.dnsserver = @($dnsserver1,$dnsserver2)|
      Where-Object{$_}|
      ForEach-Object{[WlanProfIpData]::V6($_, 0)};
    return $r;
  }
}
function Get-WlanProfilePlace{
<# Usage
Get-WlanProfilePlace
#>
  [CmdletBinding()]
  Param()
  Process{
    $adapters = Get-NetAdapter;
    Get-ChildItem (Join-Path ([Environment]::GetFolderPath("CommonApplicationData")) "Microsoft\Wlansvc\Profiles\Interfaces") -Recurse|
    Where-Object Extension -EQ .xml|
    Where-Object{Test-Path -Path "HKLM:\SOFTWARE\Microsoft\WlanSvc\Interfaces\$($_.Directory.Name)\Profiles\$($_.BaseName)\Metadata"}|
    ForEach-Object{
      $interfaceGuid = [Guid]($_.Directory.Name);
      $wlanProfileGuid = [Guid]($_.BaseName);
      $adapter = $adapters|Where-Object{[Guid]($_.InterfaceGuid) -eq $interfaceGuid};
      if($adapter){
        $xml = [Xml]($_|Get-Content);
        [PSCustomObject]@{
          ProfileName = $xml.WLANProfile.name;
          SSID = $xml.WLANProfile.SSIDConfig.SSID.name;
          InterfaceGuid = $interfaceGuid;
          WlanProfileGuid = $wlanProfileGuid;
          InterfaceIndex = $adapter.InterfaceIndex;
          InterfaceAlias = $adapter.InterfaceAlias;
          InterfaceDescription = $adapter.InterfaceDescription;
        };
      }
    };
  }
}
function Get-WlanProfileStaticIPv4{
<# Usage
Get-WlanProfilePlace|? SSID -eq test|Get-WlanProfileStaticIPv4
#>
  [OutputType([WlanProfIpConfigData])]
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
    [Guid]$InterfaceGuid,
    [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
    [Guid]$WlanProfileGuid
  )
  Process{
    [WlanProfIpConfigData]::Parse((Get-ItemProperty -Path(
      "HKLM:\SOFTWARE\Microsoft\WlanSvc\Interfaces\{$InterfaceGuid}\Profiles\{$WlanProfileGuid}\Metadata"
    )).ProfileIpConfigurationV4);
  }
}
function Get-WlanProfileStaticIPv6{
<# Usage
Get-WlanProfilePlace|? SSID -eq test|Get-WlanProfileStaticIPv6
#>
  [OutputType([WlanProfIpConfigData])]
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
    [Guid]$InterfaceGuid,
    [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
    [Guid]$WlanProfileGuid
  )
  Process{
    [WlanProfIpConfigData]::Parse((Get-ItemProperty -Path(
      "HKLM:\SOFTWARE\Microsoft\WlanSvc\Interfaces\{$InterfaceGuid}\Profiles\{$WlanProfileGuid}\Metadata"
    )).ProfileIpConfigurationV6);
  }
}
function Remove-WlanProfileStaticIP{
<# Usage
Get-WlanProfilePlace|? SSID -eq test|Remove-WlanProfileStaticIP
#>
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
    [Guid]$InterfaceGuid,
    [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
    [Guid]$WlanProfileGuid
  )
  Process{
    if(([Environment]::OSVersion.Version) -lt ([Version]"10.0.16299")){
      "Set-WlanProfileStaticIP: not affect before Windows 10 Version 1709"|Out-Error;
    }
    Remove-ItemProperty -Path(
      "HKLM:\SOFTWARE\Microsoft\WlanSvc\Interfaces\{$InterfaceGuid}\Profiles\{$WlanProfileGuid}\Metadata"
    ) -Name ProfileIpConfigurationV4;
    Remove-ItemProperty -Path(
      "HKLM:\SOFTWARE\Microsoft\WlanSvc\Interfaces\{$InterfaceGuid}\Profiles\{$WlanProfileGuid}\Metadata"
    ) -Name ProfileIpConfigurationV6;
  }
}
function Set-WlanProfileStaticIPv4{
<# Usage
Get-WlanProfilePlace|? SSID -eq test|Set-WlanProfileStaticIPv4 -IpAddress 192.168.100.10 -PrefixLength 24 -DefaultGateway 192.168.100.1 -DnsServer1 192.168.100.1
#>
[CmdletBinding()]
  Param(
    [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
    [Guid]$InterfaceGuid,
    [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
    [Guid]$WlanProfileGuid,
    [Net.IPAddress]$IpAddress,
    [byte]$PrefixLength,
    [Net.IPAddress]$DefaultGateway,
    [Net.IPAddress]$DnsServer1,
    [Net.IPAddress]$DnsServer2
  )
  Process{
    if(([Environment]::OSVersion.Version) -lt ([Version]"10.0.16299")){
      "Set-WlanProfileStaticIP: not affect before Windows 10 Version 1709"|Out-Error;
    }
    $data = [WlanProfIpConfigData]::V4($IPAddress, $PrefixLength, $DefaultGateway, $DnsServer1, $DnsServer2);
    New-ItemProperty -Path(
      "HKLM:\SOFTWARE\Microsoft\WlanSvc\Interfaces\{$InterfaceGuid}\Profiles\{$WlanProfileGuid}\Metadata"
    ) -Name ProfileIpConfigurationV4 -Value $data.GetBytes() -PropertyType Binary -Force|Out-Null;
    $data;
  }
}
function Set-WlanProfileStaticIPv6{
<# Usage
Get-WlanProfilePlace|? SSID -eq test|Set-WlanProfileStaticIPv6 -IpAddress 2001:db8:beef::dead -PrefixLength 60 -DefaultGateway 2001:db8:beef:1::1 -DnsServer1 2001:db8:beef:1::2 -DnsServer2 2001:db8:beef:1::3
#>
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
    [Guid]$InterfaceGuid,
    [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
    [Guid]$WlanProfileGuid,
    [Net.IPAddress]$IpAddress,
    [byte]$PrefixLength,
    [Net.IPAddress]$DefaultGateway,
    [Net.IPAddress]$DnsServer1,
    [Net.IPAddress]$DnsServer2
  )
  Process{
    if(([Environment]::OSVersion.Version) -lt ([Version]"10.0.16299")){
      "Set-WlanProfileStaticIP: not affect before Windows 10 Version 1709"|Out-Error;
    }
    $data = [WlanProfIpConfigData]::V6($IPAddress, $PrefixLength, $DefaultGateway, $DnsServer1, $DnsServer2);
    New-ItemProperty -Path(
      "HKLM:\SOFTWARE\Microsoft\WlanSvc\Interfaces\{$InterfaceGuid}\Profiles\{$WlanProfileGuid}\Metadata"
    ) -Name ProfileIpConfigurationV4 -Value $data.GetBytes() -PropertyType Binary -Force|Out-Null;
    $data;
  }
}

Export-ModuleMember -Function *;
