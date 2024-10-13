# Set-ExecutionPolicy -scope process remotesigned

#   管理者権限
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators")) {
    Start-Process powershell.exe "-WindowStyle Hidden -executionpolicy remotesigned -File `"$PSCommandPath`"" -Verb RunAs
    exit
}


Add-Type -Assembly System.Windows.Forms

#   I/Fチェック
$TargetIF = "オン資"

$IFCheck = Get-NetAdapter | ? name -like $TargetIF

if ($IFCheck -eq $null){
    [System.Windows.Forms.MessageBox]::Show("ネットワーク名「 $TargetIF 」が見つかりません。", "処理終了")
}else{
    #[System.Windows.Forms.MessageBox]::Show("ネットワーク名「 $TargetIF 」が見つかりました！", "Debug")

    $EastWest = [System.Windows.Forms.MessageBox]::Show("DNSサーバアドレスを設定します。`r`n`r`nNTT東の場合は「YES」、`r`nNTT西の場合は「NO」をクリックして下さい。","NTT東西確認",[System.Windows.Forms.MessageBoxButtons]::YesNo)

    if ($EastWest -eq "Yes"){
        #   NTT東
        Set-DnsClientServerAddress -InterfaceAlias $TargetIF -ServerAddress "2404:01A8:F583:0D00::53:1","2404:01A8:F583:0D00::53:2","2404:1a8:7f01:a::3","2404:1a8:7f01:b::3"
        [System.Windows.Forms.MessageBox]::Show("NTT東でDNS設定しました！", "処理終了(NTT東)")
    }else {
        #   NTT西
        Set-DnsClientServerAddress -InterfaceAlias $TargetIF -ServerAddress "2001:a7ff:f014:d00::53:1","2001:a7ff:f014:d00::53:2","2001:a7ff:5f01::a","2001:a7ff:5f01:1::a"
        [System.Windows.Forms.MessageBox]::Show("NTT西でDNS設定しました！", "処理終了(NTT西)")
    }
}
