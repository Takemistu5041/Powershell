# Set-ExecutionPolicy -scope process remotesigned
#
#   オン資端末DNS設定
#
#   Copyright 2021 By T.Tanaka
#
#   2021/4/14   初版
#   2021/5/24   既存設定を確認するように変更
#   2021/6/17   NTT東西向けのDNS削除（オン資向けのみ設定）

#   管理者権限
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators")) {
    Start-Process powershell.exe "-WindowStyle Hidden -executionpolicy remotesigned -File `"$PSCommandPath`"" -Verb RunAs
    exit
}


Add-Type -Assembly System.Windows.Forms

#   I/Fチェック
$TargetIF = "オン資用"

$IFCheck = Get-NetAdapter | Where-Object name -like $TargetIF

if ($null -eq $IFCheck){
    [System.Windows.Forms.MessageBox]::Show("ネットワーク名「 $TargetIF 」が見つかりません。", "処理終了")
}else{
    #[System.Windows.Forms.MessageBox]::Show("ネットワーク名「 $TargetIF 」が見つかりました！", "Debug")
    #   現在の設定を確認            AddressFamily 2:15 IPv4 23:15 IPv6　みたい
    $DNSValue_Old = Get-DnsClientServerAddress -InterfaceAlias $TargetIF -AddressFamily 23

    if ($DNSValue_Old.ServerAddresses.length -gt 0){

        $ChkDNS = 0
        $CurrentDNS =""

        foreach($STR_DNS in $DNSValue_Old.ServerAddresses){

            Write-Output $STR_DNS
            $CurrentDNS += $STR_DNS + "`r`n"

            switch ($STR_DNS){
                #東1
                "2404:1A8:F583:D00::53:1"{
                    $ChkDNS += 0x1
                    ;Break
                }
                #東2
                "2404:1A8:F583:D00::53:2"{
                    $ChkDNS += 0x2
                    ;Break
                }
                #東3
                "2404:1a8:7f01:a::3"{
                    $ChkDNS += 0x4
                    ;Break
                }
                #東4
                "2404:1a8:7f01:b::3"{
                    $ChkDNS +=  0x8
                    ;Break
                }
                #西1
                "2001:a7ff:f014:d00::53:1"{
                    $ChkDNS +=  0x10
                    ;Break
                }
                #西2
                "2001:a7ff:f014:d00::53:2"{
                    $ChkDNS +=  0x20
                    ;Break 
                }
                #西3
                "2001:a7ff:5f01::a"{
                    $ChkDNS +=  0x40
                    ;Break
                }
                #西4
                "2001:a7ff:5f01:1::a"{
                    $ChkDNS +=  0x80
                    ;Break
                }
            }

        }

        Write-Output $ChkDNS
        write-output $CurrentDNS


    }

    switch ($ChkDNS){
        #NTT東設定済み（旧）
        0x0f{$ConfigDNS = "NTT東（旧）"}

        #NTT東設定済み（新）
        0x03{$ConfigDNS = "NTT東（新）"}
        
        #NTT西設定済み（旧）
        0xf0{$ConfigDNS = "NTT西（旧）"}

        #NTT西設定済み（新）
        0x30{$ConfigDNS = "NTT西（新）"}

        #その他
        default{$ConfigDNS = $null}
    }
    if ($ConfigDNS){
        #   設定済み、再設定確認
        
        if ($ConfigDNS.indexof("新") -gt 0){
            $ReConfig = [System.Windows.Forms.MessageBox]::Show("$ConfigDNS で設定済みです。`r`n$CurrentDNS 再設定しますか？","$ConfigDNS で設定済み",[System.Windows.Forms.MessageBoxButtons]::YesNo)
        
            if ($ReConfig -eq "No"){
                [System.Windows.Forms.MessageBox]::Show("設定は変更されませんでした。", "処理終了")
                Exit
            }
        }else{
            [System.Windows.Forms.MessageBox]::Show("$ConfigDNS で設定されています。`r`n$CurrentDNS 再設定して下さい","$ConfigDNS で設定されています")
        }
    }

    $EastWest = [System.Windows.Forms.MessageBox]::Show("DNSサーバアドレスを設定します。`r`n`r`nNTT東の場合は「YES」、`r`nNTT西の場合は「NO」をクリックして下さい。","NTT東西確認",[System.Windows.Forms.MessageBoxButtons]::YesNo)

    if ($EastWest -eq "Yes"){
        #   NTT東
        #Set-DnsClientServerAddress -InterfaceAlias $TargetIF -ServerAddress "2404:01A8:F583:0D00::53:1","2404:01A8:F583:0D00::53:2","2404:1a8:7f01:a::3","2404:1a8:7f01:b::3"
        Set-DnsClientServerAddress -InterfaceAlias $TargetIF -ServerAddress "2404:01A8:F583:0D00::53:1","2404:01A8:F583:0D00::53:2"
        [System.Windows.Forms.MessageBox]::Show("NTT東でDNS設定しました！", "処理終了(NTT東)")
    }else {
        #   NTT西
        #Set-DnsClientServerAddress -InterfaceAlias $TargetIF -ServerAddress "2001:a7ff:f014:d00::53:1","2001:a7ff:f014:d00::53:2","2001:a7ff:5f01::a","2001:a7ff:5f01:1::a"
        Set-DnsClientServerAddress -InterfaceAlias $TargetIF -ServerAddress "2001:a7ff:f014:d00::53:1","2001:a7ff:f014:d00::53:2"
        [System.Windows.Forms.MessageBox]::Show("NTT西でDNS設定しました！", "処理終了(NTT西)")
    }
}
