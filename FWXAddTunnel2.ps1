#Set-ExecutionPolicy -Scope Process RemoteSigned

$Str_Target = Get-Clipboard -Format Text 

Add-Type -Assembly System.Windows.Forms

if ($Str_Target)
    {
    
    #処理開始
    $Ary_Config = $Str_Target -split "`r`n"
    $Target_Tunnel = $False
    $Added = $False 
    $Add_TunnelNumber = 0 
    $Target_TunnelNumber = 2    #　配布用Configだとスタティックルート設定がTUNNEL設定より下にあるので、拾った時にはTUNNELの処理が終わってしまってる…
                                #　本来は一度Target_TUNNEL設定の為に読んで、そのあと再度処理すべきだけど、面倒なので初期値を「2」で
    $KeepAlive = "【KeepAlive】"
    $LocalAddress = "【LocalAddress】"
    $PSK = "【PSK】"
    $FQDN = "【FQDN】"
        
    foreach($Str_Source in $Ary_Config){
        #write-output $Str_Source
        Switch -Wildcard ($Str_Source){
            "*serial=S*"{
                $DM = $Str_Source.Trim()  -replace "  * ", " " -split " "
                $FWX_Serial = $DM[3]
                #write-output $FWX_Serial
                ;break
                }
            "*ip route 10.1.100.2 gateway tunnel*"{
                $DM = $Str_Source.Trim() -replace "  * ", " " -split " "
                $Added_Tunnel = $DM[5]
                $Added = $True 
                ;break
                }
            "ip route 10.1.100.0/24 gateway tunnel *"{
                $Target_Tunnel = $True
                $DM = $Str_Source.Trim() -replace "  * ", " " -split " "
                $Target_TunnelNumber = [int]$DM[5]
                $Add_TunnelNumber = $Target_TunnelNumber + 1
                ;break  
            }
            "tunnel select *"{
                $DM = $Str_Source.Trim() -replace "  * ", " " -split " "
                $Add_TunnelNumber = [int]$DM[2] + 1
                ;break   
                }
            ("*ipsec ike keepalive use " + $Target_TunnelNumber + " *"){
                $DM = $Str_Source.Trim() -replace "  * ", " " -split " "
                $KeepAlive = $DM[5] + " " + $DM[6]
                ;break
                }
            ("*ipsec ike local address " + $Target_TunnelNumber + " *"){
                $DM = $Str_Source.Trim() -replace "  * ", " " -split " "
                $LocalAddress = $DM[5]
                ;break
                }
            ("*ipsec ike pre-shared-key " + $Target_TunnelNumber + " *"){
                $DM = $Str_Source.Trim() -replace "  * ", " " -split " "
                $PSK = $DM[5]
                ;break
                }
            ("*ipsec ike remote name " + $Target_TunnelNumber + " *"){
                $DM = $Str_Source.Trim() -replace "  * ", " " -split " "
                $FQDN = $DM[5]
                ;break
                }
 
        }

    } 
    if ($Added){
        #既に追加済み
        [System.Windows.Forms.MessageBox]::Show("TUNNEL " + $Added_Tunnel + "に追加済みです", "追加済み")
        #クリップボードクリア(もどき)
        write-output "" | clip
        exit
    }
    if ($Target_Tunnel){
        #Tunnel検出できた場合
        #[System.Windows.Forms.MessageBox]::Show("追加コンフィグを作成します", "Tunnel検出")

        #追加コンフィグ作成
        $Ary_AddConfig = @()

        $Ary_AddConfig += "no ip route 10.1.100.0/24"
        $Ary_AddConfig += "ip route 10.1.100.1/32 gateway tunnel " + $Target_TunnelNumber
        $Ary_AddConfig += "ip route 10.1.100.2/32 gateway tunnel " + $Add_TunnelNumber
        $Ary_AddConfig += ""
        $Ary_AddConfig += "tunnel select "+ $Add_TunnelNumber
        $Ary_AddConfig += " tunnel name ShrewVPN-2"
        $Ary_AddConfig += " description tunnel ShrewVPN-2"
        $Ary_AddConfig += " ipsec tunnel "+ $Add_TunnelNumber
        $Ary_AddConfig += "  ipsec sa policy "+ $Add_TunnelNumber + " " + $Add_TunnelNumber + " esp 3des-cbc sha-hmac"
        $Ary_AddConfig += "  ipsec ike keepalive use " + $Add_TunnelNumber + " " + $KeepAlive
        $Ary_AddConfig += "  ipsec ike local address "+ $Add_TunnelNumber + " " + $LocalAddress
        $Ary_AddConfig += "  ipsec ike nat-traversal " + $Add_TunnelNumber + " on"
        $Ary_AddConfig += "  ipsec ike payload type " + $Add_TunnelNumber + " 3"
        $Ary_AddConfig += "  ipsec ike pre-shared-key " + $Add_TunnelNumber + " text " + $PSK
        $Ary_AddConfig += "  ipsec ike remote address " + $Add_TunnelNumber + " any"
        $Ary_AddConfig += "  ipsec ike remote name " +$Add_TunnelNumber + " " + $FQDN + "-2 key-id"
        $Ary_AddConfig += "  ipsec ike xauth request " + $Add_TunnelNumber +" on 1"
        $Ary_AddConfig += " ip tunnel tcp mss limit auto"
        $Ary_AddConfig += " tunnel enable " + $Add_TunnelNumber
        $Ary_AddConfig += ""

        $Add_Config = $Ary_AddConfig -join "`r`n"

        #Write-Output $Add_Config
        Set-Clipboard $Add_Config

        $CheckMessage = ""
        if ($KeepAlive -eq "【KeepAlive】"){
            $CheckMessage += "KeepAlive未取得`r`n"
        }
        if ($LocalAddress -eq "【LocalAddress】"){
            $CheckMessage += "LocalAddress未取得`r`n"
        }
        if ($PSK -eq  "【PSK】"){
            $CheckMessage += "PSK未取得`r`n"
        }
        if ($FQDN -eq "【FQDN】"){
            $CheckMessage += "FQDN未取得`r`n"
        }
        if ($CheckMessage -eq ""){
            [System.Windows.Forms.MessageBox]::Show("クリップボードに出力しました。", "処理終了")
            Exit
        }else{
            [System.Windows.Forms.MessageBox]::Show("クリップボードに出力しました。`r`n `r`n【注意!!】`r`n" + $CheckMessage, "処理終了")
            Exit
        }

    }
    else{
        #Tunnel未検出
        [System.Windows.Forms.MessageBox]::Show("コンフィグファイルをコピーしてから実行して下さい", "Tunnel未検出")
        exit
    }
    }
    else
    {
    #クリップボードが空なら終了
    [System.Windows.Forms.MessageBox]::Show("クリップボードが空です`r`n処理を終了します", "エラー")
    exit
    }

