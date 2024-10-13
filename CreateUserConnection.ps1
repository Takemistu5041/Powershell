#Set-ExecutionPolicy -Scope Process RemoteSigned

#
#　　関数(上に置いとかないといけないみたい)
#


$Password_Numeric = "1234567890"
$Password_UpperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
$Password_LowerCase = "abcdefghijklmnopqrstuvwxyz"
$Password_Symbol = "!$%&+*-@"

function CreateVNCTV(){

#[System.Windows.Forms.MessageBox]::Show(CreatePassword (16,True), "処理終了")

$VNC = CreatePassword 8 $True
$TV = CreatePassword 16 $True

[System.Windows.Forms.MessageBox]::Show("VNC : $VNC `r`n TV : $TV", "処理終了")

}

function CreatePassword($Length,$KIGOU){
  
  #
  #　パスワード生成
  #
  #　Length->文字数　KIGOU->記号を含むか　True:含む　False:含まない
  #
  #  Copyright 2020 By T.Tanaka
  #
  #　文字数が3文字以下だと要件を満たせませんが、エラーは出ません。
  #
  
  $PassWord = ''

  #とりあえず最低要件を満たす
    # 数字
  $PassWord += GenPassWord($Password_Numeric)
    #　英大文字
  $PassWord += GenPassWord($Password_UpperCase)
    #　英小文字
  $PassWord += GenPassWord($Password_LowerCase)
    #　記号
  if ($KIGOU -eq $True){
    $PassWord += GenPassWord($Password_Symbol)
  }
  
  #　パスワード生成
  
  for ($i = 3 + $KIGOU ; $i -lt $Length ; $i++){
    
    $Target = get-random -Minimum 0 -Maximum 17
    
    switch($Target){
      {($_ -ge 0) -and ($_ -le 4)} {
            #数字
        $PassWord += GenPassWord($Password_Numeric)
        ;break
        }
      {($_ -ge 5) -and ($_ -le 9)} {
            #英大文字
        $PassWord += GenPassWord($Password_UpperCase)
        ;break
        }
      {($_ -ge 10) -and ($_ -le 14)} {
            #英小文字
        $PassWord += GenPassWord($Password_LowerCase)
        ;break
        }
      {($_ -ge 15) -and ($_ -le 16)} {
            #記号
        if ($KIGOU -eq $True){
          $PassWord += GenPassWord($Password_Symbol)
          ;break
        }else{
        $i = $i - 1
        ;continue
        }
        }
      default{
        $Result = [System.Windows.Forms.MessageBox]::Show("17が出た", "想定外")
        exit
        ;break
        }
    }
  }

  #Write-Host $PassWord

  #//var Result = Browser.msgBox(PassWord);
  
  #ランダムに並び替える
  
  $SPassWord = ''
  $PassArray = @()
  
  for ($i = 0 ; $i -lt $Length ; $i++){
    $PassArray += 0 
  }
  
  for ($i = 0 ; $i -lt $Length; $i++){
    while ($True){
    
      $Target = get-random -Minimum 0 -Maximum $Length
    
      if ($PassArray[$Target] -eq 0){
        $PassArray[$Target]=1
        $SPassWord += $PassWord.Substring($Target,1)
        ;break

      }
     }
  }
    
  return $SPassWord
  
  
  }

  function GenPassWord($PassWordSource){
  #
  #　パスワード生成 (引数PassWordSouceからランダムな一文字を選んで返す)
  #
  
  $PassWord = ""


    $Target = get-random -Minimum 0 -Maximum $PassWordSource.length
  
      $PassWord = $PassWordSource.substring($Target,1)
      
      return $PassWord

}


#
#	ユーザ用ShrewVPN接続設定追加
#
#	Copyright 2020 By T.Tanaka
#


#Set-ExecutionPolicy -Scope Process RemoteSigned


#$Str_Target = Get-Clipboard -Format Text 
$Str_Target = Get-Clipboard

Add-Type -Assembly System.Windows.Forms

if ($Str_Target)
    {
    
    #処理開始
    $Ary_Config = $Str_Target -split "`r`n"
    $Target_Tunnel = $False
    $Add_TunnelNumber = 0 
    $Add_VPNNumver = 1
    $DDNS = ""
        
    foreach($Str_Source in $Ary_Config){
        #write-output $Str_Source
        Switch -Wildcard ($Str_Source){
            "*serial=S*"{
                $DM = $Str_Source.Trim()  -replace "  * ", " " -split " "
                $FWX_Serial = $DM[3]
                #write-output $FWX_Serial
                ;break
                }
            "*ip route 10.*"{
                $DM = $Str_Source.Trim() -replace "  * ", " " -split " "
                $Target_IP = $DM[2].split(".")
                ;break
                }
            "tunnel select none"{
                ;break
                }   
            "tunnel select 2"{
                $Target_Tunnel = $True
                $Add_TunnelNumber = 3
                ;break
                }
            "tunnel select *"{
                $DM = $Str_Source.Trim() -replace "  * ", " " -split " "
                $Target_Tunnel = $True
                $Add_TunnelNumber = [int]$DM[2] + 1
                ;break
                }
            "*ipsec ike keepalive use *"{
                $DM = $Str_Source.Trim() -replace "  * ", " " -split " "
                $KeepAlive = $DM[5] + " " + $DM[6]
                ;break
                }
            "*ipsec ike local address *"{
                $DM = $Str_Source.Trim() -replace "  * ", " " -split " "
                $LocalAddress = $DM[5]
                ;break
                }
            "*ipsec ike pre-shared-key *"{
                $DM = $Str_Source.Trim() -replace "  * ", " " -split " "
                $PSK = $DM[5]
                $DM2 = $PSK.split("-")
                $MED = $DM2[1]
                ;break
                }
            "*netvolante-dns hostname*"{
                $DM = $Str_Source.Trim() -replace "  * ", " " -split " "
                $DDNS = $DM[5]
                ;break
                }
            "*netvolante.jp*"{
                $DM = $Str_Source.Trim() -replace "  * ", " " -split " "
                if ($DM[0].indexof('.netvolante.jp') -gt 0 ){
                  $DDNS = $DM[0]
                  ;break
                  } 
                }
            "*tunnel name UserVPN*"{
                $DM = $Str_Source.Trim() -replace "  * "," " -split " "
                $DM2 = $DM[2].split("-")
                $Add_VPNNumver = [int]$dm2[1] + 1
                ;break
                }
            "*auth user*"{
                $DM = $Str_Source.Trim() -replace "  * "," " -split " "
                if (-not([int]::TryParse($DM[2],[ref]$null))){
                    #数字以外　(何もしない)
                }
                else{
                    $Add_UserNumber = [int]$DM[2] + 1
                    ;break
                }
                }
            "*auth user group*"{
                $DM = $Str_Source.Trim() -replace "  * "," " -split " "
                if (-not([int]::TryParse($DM[3],[ref]$null))){
                    #数字以外　(何もしない)
                }
                else{
                    $Add_UserGroup = [int]$DM[3] + 1
                    ;break
                }
                }
        }

    } 

    if ($Target_Tunnel){

        #Tunnel検出できた場合
        #[System.Windows.Forms.MessageBox]::Show("追加コンフィグを作成します", "Tunnel検出")

        #　アセンブリの読み込み
        [void][System.Reflection.Assembly]::Load("Microsoft.VisualBasic, Version=8.0.0.0, Culture=Neutral, PublicKeyToken=b03f5f7f11d50a3a")

        #　ファイル名入力
        $INPUT = [Microsoft.VisualBasic.Interaction]::InputBox("FWXの追加コンフィグと`r`nShrewVPN接続情報ファイルを作成します`r`nユーザ名(ファイル名)を入力して下さい", "追加コンフィグ作成")

        if ($INPUT -ne "" ){

            #   トンネル数入力
            $AddTunnelCount = [Microsoft.VisualBasic.Interaction]::InputBox("追加するトンネル数を入力してください`r`nそのままEnterだと1つ作成します", "追加コンフィグ作成")

            #   未入力　->　1にする
            if ($AddTunnelCount -eq ""){
                $AddTunnelCount = [int]1
            }
            else{
                #   数字が入力されているかチェック
                if (-not([int]::tryparse($AddTunnelCount,[ref]$null))){
                    #   数字じゃない　->　1にする
                    $AddTunnelCount = [int]1
                }
                #   数字なら値の大きさは特にチェックしない
            }

            for ($ConfigCount = 0; $ConfigCount -lt $AddTunnelCount; $ConfigCount++) {
                
                #追加コンフィグ作成
                $Ary_AddConfig = @()

                # リモート用トンネル追加対策
                $Target_IP[1] = [int]$Target_IP[1] + 1
                if ($Target_IP[1] -eq "2"){
                    $Target_IP[1] = "3"
                }

                #　実コンフィグ
                if ($Target_IP[3] -eq "2"){
                    $Target_IP[3] = "0/24"
                }

                # 設定ファイルの時
                if ($Target_IP[3] -eq "2/32"){
                    $Target_IP[3] = "0/24"
                }
                # 追加先グループが2だったら3にする
                if ($Add_UserGroup -eq "2"){
                    $Add_UserGroup = "3"
                }


                $Ary_AddConfig += "ip route " + ($Target_IP -join(".")) + " gateway tunnel " + $Add_TunnelNumber
                $Ary_AddConfig += ""
                $Ary_AddConfig += "tunnel select "+ $Add_TunnelNumber
                $Ary_AddConfig += " tunnel name UserVPN-" + $Add_VPNNumver
                $Ary_AddConfig += " description tunnel UserVPN-" + $Add_VPNNumver
                $Ary_AddConfig += " ipsec tunnel "+ $Add_TunnelNumber
                $Ary_AddConfig += "  ipsec sa policy "+ $Add_TunnelNumber + " " + $Add_TunnelNumber + " esp 3des-cbc sha-hmac"
                $Ary_AddConfig += "  ipsec ike keepalive use " + $Add_TunnelNumber + " " + $KeepAlive
                $Ary_AddConfig += "  ipsec ike local address "+ $Add_TunnelNumber + " " + $LocalAddress
                $Ary_AddConfig += "  ipsec ike nat-traversal " + $Add_TunnelNumber + " on"
                $Ary_AddConfig += "  ipsec ike payload type " + $Add_TunnelNumber + " 3"
                $NPSK = CreatePassword 24 $False
                $Ary_AddConfig += "  ipsec ike pre-shared-key " + $Add_TunnelNumber + " text " + $NPSK + "-" + $MED
                $Ary_AddConfig += "  ipsec ike remote address " + $Add_TunnelNumber + " any"
                $NFQDN = CreatePassword 8 $False
                $Ary_AddConfig += "  ipsec ike remote name " +$Add_TunnelNumber + " " + $NFQDN + "-" + $MED + " key-id"
                $Ary_AddConfig += "  ipsec ike xauth request " + $Add_TunnelNumber +" on " + $Add_UserGroup
                $Ary_AddConfig += " ip tunnel tcp mss limit auto"
                $Ary_AddConfig += " tunnel enable " + $Add_TunnelNumber
                $Ary_AddConfig += ""
                $UserID = CreatePassword 16 $True
                $UserPass = CreatePassword 16 $True
                $Ary_AddConfig += "auth user " + $Add_UserNumber + " " + $UserID + " " + $UserPass
                $Ary_AddConfig += "auth user attribute " + $Add_UserNumber + " xauth=on"
                $Ary_AddConfig += "auth user group " + $Add_UserGroup + " " + $Add_UserNumber
                $Ary_AddConfig += "auth user group attribute " + $Add_UserGroup + " xauth=on"
                $Ary_AddConfig += ""
        
                $Add_Config = $Ary_AddConfig -join "`r`n"

                #Write-Output $Add_Config
                Set-Clipboard $Add_Config

                #[System.Windows.Forms.MessageBox]::Show("クリップボードに出力しました。", "処理終了")

                # ShrewVPN用設定ファイル作成

                $Ary_ShrewConfig = @()

                $Ary_ShrewConfig += "n:version:2"
                $Ary_ShrewConfig += "n:network-ike-port:500"
                $Ary_ShrewConfig += "n:network-mtu-size:1380"
                $Ary_ShrewConfig += "n:client-addr-auto:0"
                $Ary_ShrewConfig += "n:network-natt-port:4500"
                $Ary_ShrewConfig += "n:network-natt-rate:15"
                $Ary_ShrewConfig += "n:network-frag-size:540"
                $Ary_ShrewConfig += "n:network-dpd-enable:1"
                $Ary_ShrewConfig += "n:client-banner-enable:0"
                $Ary_ShrewConfig += "n:network-notify-enable:1"
                $Ary_ShrewConfig += "n:client-wins-used:0"
                $Ary_ShrewConfig += "n:client-wins-auto:0"
                $Ary_ShrewConfig += "n:client-dns-used:0"
                $Ary_ShrewConfig += "n:client-dns-auto:0"
                $Ary_ShrewConfig += "n:client-splitdns-used:0"
                $Ary_ShrewConfig += "n:client-splitdns-auto:0"
                $Ary_ShrewConfig += "n:phase1-dhgroup:2"
                $Ary_ShrewConfig += "n:phase1-life-secs:86400"
                $Ary_ShrewConfig += "n:phase1-life-kbytes:0"
                $Ary_ShrewConfig += "n:vendor-chkpt-enable:0"
                $Ary_ShrewConfig += "n:phase2-life-secs:3600"
                $Ary_ShrewConfig += "n:phase2-life-kbytes:0"
                $Ary_ShrewConfig += "n:policy-nailed:0"
                $Ary_ShrewConfig += "n:policy-list-auto:0"
                $Ary_ShrewConfig += "s:network-host:" + $DDNS
                $Ary_ShrewConfig += "s:client-auto-mode:disabled"
                $Ary_ShrewConfig += "s:client-iface:virtual"

                $IPBuffer = $Target_IP[3] 
                $Target_IP[3] = 1
                $Ary_ShrewConfig += "s:client-ip-addr:" + ($Target_IP -join("."))
                $Target_IP[3]=$IPBuffer

                $Ary_ShrewConfig += "s:client-ip-mask:255.255.255.0"
                $Ary_ShrewConfig += "s:network-natt-mode:enable"
                $Ary_ShrewConfig += "s:network-frag-mode:enable"
                $Ary_ShrewConfig += "s:auth-method:mutual-psk-xauth"
                $Ary_ShrewConfig += "s:ident-client-type:ufqdn"
                $Ary_ShrewConfig += "s:ident-server-type:address"
                $Ary_ShrewConfig += "s:ident-client-data:" + $NFQDN + "-" + $MED
                $Ary_ShrewConfig += "s:ident-server-data:" + $LocalAddress
                $Ary_ShrewConfig += "b:auth-mutual-psk:" + $NPSK + "-" + $MED
                $Ary_ShrewConfig += "s:phase1-exchange:aggressive"
                $Ary_ShrewConfig += "s:phase1-cipher:3des"
                $Ary_ShrewConfig += "s:phase1-hash:sha1"
                $Ary_ShrewConfig += "s:phase2-transform:esp-3des"
                $Ary_ShrewConfig += "s:phase2-hmac:sha1"
                $Ary_ShrewConfig += "s:ipcomp-transform:disabled"
                $Ary_ShrewConfig += "n:phase2-pfsgroup:-1"
                $Ary_ShrewConfig += "s:policy-level:auto"
        
                $NWADR = $LocalAddress.split(".")
                $NWADR[3] = 0
                $Ary_ShrewConfig += "s:policy-list-include:" + ($NWADR -join(".")) + " / 255.255.255.0"

                #
                #  接続情報ファイル
                #
                $Ary_UserFile = @()

                $Ary_UserFile += "接続ＩＤ：" + $UserID
                $Ary_UserFile += "接続パスワード：" + $UserPass
                $Ary_UserFile += ""


                #追加コンフィグファイル
            
                $ConfigFile = $INPUT + "_AddConfig-" + ([int]$ConfigCount+1) + ".txt"

                $Add_Config | out-file $ConfigFile

                #ShrewVPN接続用ファイル

                $ShrewFile = $INPUT + "_ShrewVPN-" + ([int]$ConfigCount+1) + ".vpn"

                $Ary_ShrewConfig | out-file $ShrewFile -Encoding ascii

                #ユーザIDファイル
                $UserFile = $INPUT + "_接続情報-" + ([int]$ConfigCount+1) + ".txt"

                $Ary_UserFile | out-file $UserFile

                #   インクリメント
                $Add_TunnelNumber = [int]$Add_TunnelNumber + 1
                $Add_VPNNumver = [int]$Add_VPNNumver + 1 
                $Add_UserNumber = [int]$Add_UserNumber + 1
                $Add_UserGroup = [int]$Add_UserGroup + 1

            }

            if([string]::IsNullOrEmpty($DDNS)){
                [System.Windows.Forms.MessageBox]::Show("DDNS名が取得できませんでした、`r`nShrewVPN接続情報ファイル(.vpn）に手動で追加してください。`r`n(25行目、s:network-host:)", "【注意！！】")    
            }

            [System.Windows.Forms.MessageBox]::Show("FWXの追加コンフィグと`r`nShrewVPN接続情報ファイルを作成しました`r`n(コンフィグはクリップボードにも出力されています)", "処理終了")

            exit
            
        }
        else{

            [System.Windows.Forms.MessageBox]::Show("入力が空かキャンセルされました", "処理終了")

            exit
        }

        exit
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

