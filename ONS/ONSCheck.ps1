#
#   ONSCheck（オン資端末キッティングチェック）
#
#   Copyright 2021 By T.Tanaka
#
#
#   2024/10/01  IOT 21H2対応(C:\OQS、C:\ProgramData\OQS\OQSComApp\work\outputがEveryoneフルコントロールになっていたらEveryone削除)
#   2024/07/24  IOT 21H2対応(自動ログインレジストリチェック追加)
#   2024/05/08  環境切り替えツールを1.0.7に更新
#   2024/05/08  DownloadフォルダのNTFSアクセス権追加
#   2023/07/20  Downloadフォルダの共有追加(薬情PDF用）
#   2023/03/14   暗号化識別ファイル設定変更(電子処方箋がらみ「EPS…」は「n」にする)
#   2022/12/02  ・IP設定回り修正
#                   DHCP->手動設定に変更した時、以前の手動設定が残っていたら削除するように修正
#   2022/11/15  インターネットオプション設定追加
#   2022/11/11  FW有効/無効チェックを追加、NICの有効/無効チェック追加
#   2022/11/01  ONSRenkei　「パスワード上書きしない」を選んでも上書きしてました…
#   2022/09/29  デスクトップショートカットの移動を修正（移動先に既に存在していてもエラーにならないように）
#   2022/09/27  環境切り替えツールもバージョンアップする様に変更
#   2022/09/06  環境切り替えツールバージョンアップに伴うチェック修正  
#   2022/07/29  スクリーンセーバ設定回り修正(タイムアウト時間がREG_Dwordになってしまうので明示的にREG_SZ指定に変更)
#   2022/06/16  GoogleのDNSアドレスが間違ってたので修正（×4.4.4.4->〇8.8.4.4)
#   2022/04/21  電源設定確認追加
#   2022/03/02  outputが共有されていたら共有解除(A_LB-JB18/M Ver3.50 対応)
#   2022/03/01  アカウントを上書きした場合は一度再起動するように変更(資格情報消え対策)
#   2022/01/21  パスワードの全角文字チェック追加、TVチェック追加
#   2021/12/28  almexフォルダ追加
#   …

#   ログインユーザチェック

$User = whoami.exe

$Check_User = $User.split("\")

if((($Check_User[$Check_User.count -1]).ToUpper()) -ne "OQSCOMAPP"){
    Read-Host "OQSComAppアカウントでログインして下さい。`r`n何かキーを押してください。"
    exit
}


#   管理者権限チェック
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators")) {
    #Start-Process powershell.exe "-WindowStyle Hidden -executionpolicy remotesigned -File `"$PSCommandPath`"" -Verb RunAs
    Start-Process powershell.exe " -executionpolicy remotesigned -File `"$PSCommandPath`"" -Verb RunAs;

    exit
}


#
#   【関数】    Send-keys
#
function Send-Keys
{
    [CmdletBinding()]
    [Alias("sdky")]
    Param
    (
        # キーストローク
        # アプリケーションに送りたいキーストローク内容を指定します。
        # キーストロークの記述方法は下記のWebページを参照。
        # https://msdn.microsoft.com/ja-jp/library/cc364423.aspx
        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string]
        $KeyStroke,

        # プロセス名
        # キーストロークを送りたいアプリケーションのプロセス名を指定します。
        # 複数ある場合は、PIDが一番低いプロセスを対象とする。
        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true)]
        [string]
        $ProcessName,

        # 待機時間
        # コマンドを実行する前の待機時間をミリ秒単位で指定します。
        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true)]
        [int]
        $Wait = 0
    )

    Process
    {
        $Process = Get-Process | Where-Object {$_.Name -eq $ProcessName} | Sort-Object -Property CPU -Descending | Select-Object -First 1
        Write-Verbose $Process", KeyStroke = "$KeyStroke", Wait = "$Wait" ms."
        Start-Sleep -Milliseconds $Wait
        if ($null -ne $Process)
        {
            [Microsoft.VisualBasic.Interaction]::AppActivate($Process.ID)
        }
        [System.Windows.Forms.SendKeys]::SendWait($KeyStroke)
    }
}

#
#   【関数】ローカルユーザが存在するか
#
function IsLocalUserAccunt( $UserID ){
    $hostname = hostname
    [ADSI]$Computer = "WinNT://$hostname,computer"
    $Users = $Computer.psbase.children | Where-Object {$_.psBase.schemaClassName -eq "User"} | Select-Object -expand Name
    return ($Users -contains $UserID)
}
#
#   【関数】ローカルユーザがグループのメンバーになっているか
#
function IsMemberLocalAccunt( $UserID, $GroupName ){
    $hostname = hostname
    [ADSI]$Computer = "WinNT://$hostname,computer"
    $Group = $Computer.GetObject("group", $GroupName)
    $User = $Computer.GetObject("user", $UserID)
    return $Group.IsMember($User.ADsPath)
}

#   フォーム用宣言
Add-Type -Assembly System.Windows.Forms

#
#   選択肢の作成
#
$typename = "System.Management.Automation.Host.ChoiceDescription"
$yes = new-object $typename("&Yes","はい")
$no  = new-object $typename("&No","いいえ")
$ORCA = new-object $typename("&ORCA/その他","ORCAその他")
$FUJI = new-object $typename("&Fuji(Hi-SEED/Pharma-SEED)","富士製品")
$Encrypt = new-object $typename("&Encrypt(暗号化する)","暗号化する")
$NoEncrypt = new-object $typename("&NoEncrypt(暗号化しない)","暗号化しない")
$Skip = new-object $typename("&Skip(変更しない)","変更しない")

#
#   選択肢コレクションの作成
#
$assembly= $yes.getType().AssemblyQualifiedName
$Choice = new-object "System.Collections.ObjectModel.Collection``1[[$assembly]]"
$Choice.add($yes)
$Choice.add($no)

$Choice2 = new-object "System.Collections.ObjectModel.Collection``1[[$assembly]]"
$Choice2.add($ORCA)
$Choice2.add($FUJI)

$Choice3 = new-object "System.Collections.ObjectModel.Collection``1[[$assembly]]"
$Choice3.add($Encrypt)
$Choice3.add($NoEncrypt)
$Choice3.add($Skip)

#
#   ＰＣ名チェック
#
write-output "--"
Write-Output "PC名を確認します。"

$PCName = $Env:COMPUTERNAME

if($PCName.ToUpper() -cmatch "\wONS\d{2}$"){
    #   OK
    Write-Output ("PC名は" + $PCName + "です。")
}else{
    #   NG
    $Answer = $host.ui.PromptForChoice("<PC名が「○○○○ONS××」ではありません>","$PCName のPC名を変更しますか？",$Choice,1)
    if(-not $Answer){
        while($true){
            $NewPCName = read-host "PC名を入力"
            $Answer2 = $host.ui.PromptForChoice("<PC名確認>","$NewPCName でよろしいですか？",$Choice,1)
            if(-not $Answer2){
                break;
            }
        }

        Read-Host PCは再起動されます。何かキーを押してください…
        Rename-Computer -NewName $NewPCName.ToUpper() -Force -Restart

    }else{
        Write-Output ("PC名は" + $PCName + "です。")
    }

}

#
#   ＮＩＣチェック
#


#   処理確認
$Answer = $host.ui.PromptForChoice("<ネットワークアダプタ確認>","ネットワークアダプタ設定の確認を行いますか？",$Choice,1)

#   オン資用アダプタ名(I211)
$ONSAdapterName = "I211"
#   連携用アダプタ名(I219-LM)
$CoordinationAdapterName = "I219-LM"

if(-not $Answer){
    write-output "--"
    Write-Output "ネットワークアダプタを確認します。"

    #   ELECOM機かチェック("I219-LM"があるかで判断)

    if($null -ne (Get-NetAdapter|Where-Object InterfaceDescription -Match $CoordinationAdapterName)){
        #   ELECOM
        Write-Output "エレコム機(LB-JB18/M)です。"
        #
        #   オン資用アダプタ(I211)確認
        #
        Write-Output "オン資用(I211)設定を確認します。"

        #   無効だったら有効にする
        if((Get-NetAdapter| Where-Object InterfaceDescription -Match $ONSAdapterName).status -eq "Not Present"){
            Write-Output ("`t「オン資用」を有効にします。")
            Enable-NetAdapter -name (Get-NetAdapter | Where-Object InterfaceDescription -Match $ONSAdapterName).name -Confirm:$false
        }

        #   アダプタ名（オン資用）
        if((Get-NetAdapter| Where-Object InterfaceDescription -Match $ONSAdapterName).name -ne "オン資用"){
            #   未設定
            Write-Output ("`t名前が「オン資用」ではありません。【Fix】")
            Get-NetAdapter | Where-Object InterfaceDescription -Match $ONSAdapterName | Rename-NetAdapter -PassThru -ThrottleLimit 1 -ErrorAction SilentlyContinue　-newname "オン資用"
        }else{
            #   設定済み
            Write-Output ("`t名前は「オン資用」です。")
        }

        #   IPv4をDisable
        if(((Get-NetAdapter | Where-Object InterfaceDescription -Match $ONSAdapterName | Get-NetAdapterBinding | Where-Object DisplayName -match "(TCP/IPv4)").Enabled -ne $false)){
            Write-Output ("`t「オン資用」のIPv4が有効です。【Fix】")
            Get-NetAdapter | Where-Object InterfaceDescription -Match $ONSAdapterName | get-NetAdapterBinding | Where-Object DisplayName -match "(TCP/IPv4)" | set-netadapterbinding -enabled $false
        }else{
            Write-Output ("`t「オン資用」のIPv4は無効です。")
        }

        #   IPv6をEnable
        if(((Get-NetAdapter | Where-Object InterfaceDescription -Match $ONSAdapterName | Get-NetAdapterBinding | Where-Object DisplayName -match "(TCP/IPv6)").Enabled -eq $false)){
            Write-Output ("`t「オン資用」のIPv6が無効です。【Fix】")
            Get-NetAdapter | Where-Object InterfaceDescription -Match $ONSAdapterName | get-NetAdapterBinding | Where-Object DisplayName -match "(TCP/IPv6)" | set-netadapterbinding -enabled $true
        }else{
            Write-Output ("`t「オン資用」のIPv6は有効です。")
        }

        #   IPv6　アドレスは自動取得、メトリック：1

        #   自動メトリック  メトリック数を入れればDisableになるっぽい
        #if((Get-NetAdapter | ? InterfaceDescription -Match $ONSAdapterName | Get-NetIPInterface | ? AddressFamily -match "IPv6").automaticmetric[(Get-NetAdapter | ? InterfaceDescription -Match "I211" | Get-NetIPInterface | ? AddressFamily -match "IPv6").automaticmetric.count - 1] -eq "Disabled"){
        #    Write-Output ("`t「オン資用」の自動メトリックはオフです。")
        #}else{
        #    Write-Output ("`t「オン資用」の自動メトリックはオンです。【Fix】")
        #    Get-NetAdapter | ? InterfaceDescription -Match $ONSAdapterName | Get-NetIPInterface | ? AddressFamily -match "IPv6" | Set-NetIPInterface -AutomaticMetric Disabled
        #}

        #   メトリック数
        if((Get-NetAdapter | Where-Object InterfaceDescription -Match $ONSAdapterName | Get-NetIPInterface | Where-Object AddressFamily -match "IPv6").interfacemetric[(Get-NetAdapter | Where-Object InterfaceDescription -Match "I211" | Get-NetIPInterface | Where-Object AddressFamily -match "IPv6").interfacemetric.count - 1] -eq "1"){
            Write-Output ("`t「オン資用」のメトリックは「1」です。")
        }else{
            Write-Output ("`t「オン資用」のメトリックが「1」ではありません。【Fix】")
            Get-NetAdapter | Where-Object InterfaceDescription -Match $ONSAdapterName | Get-NetIPInterface | Where-Object AddressFamily -match "IPv6" | Set-NetIPInterface -InterfaceMetric 1
        }

        #   DHCP
        if((Get-NetAdapter | Where-Object InterfaceDescription -Match $ONSAdapterName | Get-NetIPInterface | Where-Object AddressFamily -match "IPv6").dhcp[(Get-NetAdapter | Where-Object InterfaceDescription -Match "I211" | Get-NetIPInterface | Where-Object AddressFamily -match "IPv6").dhcp.count - 1] -eq "Enabled"){
            Write-Output ("`t「オン資用」のDHCPは有効です。")
        }else{
            Write-Output ("`t「オン資用」のDHCPが無効です。【Fix】")
            Get-NetAdapter | Where-Object InterfaceDescription -Match $ONSAdapterName | Get-NetIPInterface | Where-Object AddressFamily -match "IPv6" | Set-NetIPInterface -dhcp Enabled
        }

        #   RouterDiscovery（IPv6自動構成）
        if((Get-NetAdapter | Where-Object InterfaceDescription -Match $ONSAdapterName | Get-NetIPInterface | Where-Object AddressFamily -match "IPv6").RouterDiscovery[(Get-NetAdapter | Where-Object InterfaceDescription -Match "I211" | Get-NetIPInterface | Where-Object AddressFamily -match "IPv6").RouterDiscovery.count - 1] -eq "Enabled"){
            Write-Output ("`t「オン資用」のIPv6自動構成は有効です。")
        }else{
            Write-Output ("`t「オン資用」のIPv6自動構成が無効です。【Fix】")
            Get-NetAdapter | Where-Object InterfaceDescription -Match $ONSAdapterName | Get-NetIPInterface | Where-Object AddressFamily -match "IPv6" | Set-NetIPInterface -RouterDiscovery Enabled
        }


        #
        #   連携用アダプタ(I219-LM)確認
        #
        Write-Output "連携用(I219-LM)設定を確認します。"

        #   無効だったら有効にする
        if((Get-NetAdapter| Where-Object InterfaceDescription -Match $CoordinationAdapterName).status -eq "Disabled"){
            Write-Output ("`t「連携用」を有効にします。")
            Enable-NetAdapter -name (Get-NetAdapter | Where-Object InterfaceDescription -Match $CoordinationAdapterName).name -Confirm:$false
        }

        #   アダプタ名（連携用）
        if((Get-NetAdapter | Where-Object InterfaceDescription -Match $CoordinationAdapterName).name -ne "連携用"){
            #   未設定
            Write-Output ("`t名前が「連携用」ではありません。【Fix】")
            Get-NetAdapter | Where-Object InterfaceDescription -Match $CoordinationAdapterName | Rename-NetAdapter -PassThru -ThrottleLimit 1 -ErrorAction SilentlyContinue　-newname "連携用"
        }else{
            #   設定済み
            Write-Output ("`t名前は「連携用」です。")
        }

        #   IPv6をDisable
        if(((Get-NetAdapter | Where-Object InterfaceDescription -Match $CoordinationAdapterName | Get-NetAdapterBinding | Where-Object DisplayName -match "(TCP/IPv6)").Enabled -ne $false)){
            Write-Output ("`t「連携用」のIPv6が有効です。【Fix】")
            Get-NetAdapter | Where-Object InterfaceDescription -Match $CoordinationAdapterName | get-NetAdapterBinding | Where-Object DisplayName -match "(TCP/IPv6)" | set-netadapterbinding -enabled $false
        }else{
            Write-Output ("`t「連携用」のIPv6は無効です。")
        }
        
        #   IPv4　アドレス手動設定  192.168.220.11/24　DNS：8.8.8.8/8.8.4.4　メトリック：10
        #   自動メトリック	メトリック数を入れればDisableになるっぽい
        #if((Get-NetAdapter | ? InterfaceDescription -Match $CoordinationAdapterName | Get-NetIPInterface | ? AddressFamily -match "IPv4").automaticmetric[(Get-NetAdapter | ? InterfaceDescription -Match $CoordinationAdapterName | Get-NetIPInterface | ? AddressFamily -match "IPv4").automaticmetric.count - 1] -eq "Disabled"){
        #    Write-Output ("`t「連携用」の自動メトリックはオフです。")
        #}else{
        #    Write-Output ("`t「連携用」の自動メトリックはオンです。【Fix】")
        #    Get-NetAdapter | ? InterfaceDescription -Match $CoordinationAdapterName | Get-NetIPInterface | ? AddressFamily -match "IPv4" | Set-NetIPInterface -AutomaticMetric Disabled
        #}

        #   メトリック数
        if((Get-NetAdapter | Where-Object InterfaceDescription -Match $CoordinationAdapterName | Get-NetIPInterface | Where-Object AddressFamily -match "IPv4").interfacemetric[(Get-NetAdapter | Where-Object InterfaceDescription -Match $CoordinationAdapterName | Get-NetIPInterface | Where-Object AddressFamily -match "IPv4").interfacemetric.count - 1] -eq "10"){
            Write-Output ("`t「連携用」のメトリックは「10」です。")
        }else{
            Write-Output ("`t「連携用」のメトリックが「10」ではありません。【Fix】")
            Get-NetAdapter | Where-Object InterfaceDescription -Match $CoordinationAdapterName | Get-NetIPInterface | Where-Object AddressFamily -match "IPv4" | Where-Object CompartmentId -ne $null | Set-NetIPInterface -InterfaceMetric 10
        }

        if((Get-NetAdapter | Where-Object InterfaceDescription -Match $CoordinationAdapterName | Get-NetIPInterface | Where-Object AddressFamily -match "IPv4").dhcp[(Get-NetAdapter | Where-Object InterfaceDescription -Match $CoordinationAdapterName | Get-NetIPInterface | Where-Object AddressFamily -match "IPv4").dhcp.count - 1] -eq "Enabled"){
            Write-Output ("`t「連携用」のDHCPが有効です。【Fix】")
            $Answer = $host.ui.PromptForChoice("「連携用」のIPv4アドレスは自動取得になっています。","初期値(192.168.220.11/24) に修正しますか？",$Choice,1)
			if(-not $Answer){
                #   DHCPをオフ
				Get-NetAdapter | Where-Object InterfaceDescription -Match $CoordinationAdapterName | Get-NetIPInterface | Where-Object AddressFamily -match "IPv4" | Where-Object CompartmentId -ne $null | Set-NetIPInterface -dhcp Disabled
                if ((Get-NetAdapter | Where-Object InterfaceDescription -Match $CoordinationAdapterName | Get-NetIPInterface | Where-Object AddressFamily -match "IPv4" | Where-Object CompartmentId -ne $null | Get-NetIPConfiguration).ipv4address.ipaddress){
                    #   一度IPアドレスを消去
                    Get-NetAdapter | Where-Object InterfaceDescription -Match $CoordinationAdapterName | Get-NetIPInterface | Where-Object AddressFamily -match "IPv4" | Where-Object CompartmentId -ne $null | Remove-NetIPAddress -confirm:$false
                }
                if ((Get-NetAdapter | Where-Object InterfaceDescription -Match $CoordinationAdapterName | Get-NetIPInterface | Where-Object AddressFamily -match "IPv4" | Where-Object CompartmentId -ne $null | Get-NetIPConfiguration).Ipv4DefaultGateway){
                    #   一度DGWを消去
				    Get-NetAdapter | Where-Object InterfaceDescription -Match $CoordinationAdapterName | Get-NetIPInterface | Where-Object AddressFamily -match "IPv4" | Where-Object CompartmentId -ne $null | Remove-NetRoute -DestinationPrefix 0.0.0.0/0 -confirm:$false
                }
				#   IPアドレス設定
                Get-NetAdapter | Where-Object InterfaceDescription -Match $CoordinationAdapterName | Get-NetIPInterface | Where-Object AddressFamily -match "IPv4" | Where-Object CompartmentId -ne $null | New-NetIPAddress -AddressFamily IPv4 -IPAddress 192.168.220.11 -PrefixLength 24 -DefaultGateway 192.168.220.1
                #   DNS設定
                Get-NetAdapter | Where-Object InterfaceDescription -Match $CoordinationAdapterName | Get-NetIPInterface | Where-Object AddressFamily -match "IPv4" | Where-Object CompartmentId -ne $null | Set-DnsClientServerAddress -ServerAddresses 8.8.8.8,8.8.4.4
                Write-Output ("`t「連携用」のIP設定を修正しました【Fix】")
            }
        }else{
            Write-Output ("`t「連携用」のDHCPは無効です。")
        }

        $CheckIPAddress = Get-NetAdapter | Where-Object InterfaceDescription -Match $CoordinationAdapterName | Get-NetIPInterface | Where-Object AddressFamily -match "IPv4" | Where-Object CompartmentId -ne $null | Get-NetIPAddress
        $CheckDGW = Get-NetAdapter | Where-Object InterfaceDescription -Match $CoordinationAdapterName | Get-NetIPInterface | Where-Object AddressFamily -match "IPv4" | Where-Object CompartmentId -ne $null | Get-NetIPConfiguration | ForEach-Object IPv4DefaultGateway
        $CheckDNS = Get-NetAdapter | Where-Object InterfaceDescription -Match $CoordinationAdapterName | Get-NetIPInterface | Where-Object AddressFamily -match "IPv4" | Where-Object CompartmentId -ne $null | Get-DnsClientServerAddress | Where-Object AddressFamily -eq 2 # 2:IPv4 23:IPv6
        
        Write-Output ("`t「連携用」の現在の設定")
        Write-Output ("`t`tIPアドレス/マスク：" + $CheckIPAddress.IPAddress + "/" + $CheckIPAddress.PrefixLength)
        Write-Output ("`t`tデフォルトゲートウェイ：" + $CheckDGW.NextHop)
        Write-Output ("`t`tDNS：" + $CheckDNS.ServerAddresses)

        if($CheckIPAddress.IPAddress -ne "192.168.220.11"){
            $Answer = $host.ui.PromptForChoice("「連携用」のIPv4アドレスが初期値と異なります。","初期値(192.168.220.11/24) に修正しますか？",$Choice,1)
            if(-not $Answer){
                #   再設定
                #   DHCPをオフ
				Get-NetAdapter | Where-Object InterfaceDescription -Match $CoordinationAdapterName | Get-NetIPInterface | Where-Object AddressFamily -match "IPv4" | Where-Object CompartmentId -ne $null | Set-NetIPInterface -dhcp Disabled
                #   一度IPアドレスを消去
				Get-NetAdapter | Where-Object InterfaceDescription -Match $CoordinationAdapterName | Get-NetIPInterface | Where-Object AddressFamily -match "IPv4" | Where-Object CompartmentId -ne $null | Remove-NetIPAddress -confirm:$false
                #   一度DGWを消去
				Get-NetAdapter | Where-Object InterfaceDescription -Match $CoordinationAdapterName | Get-NetIPInterface | Where-Object AddressFamily -match "IPv4" | Where-Object CompartmentId -ne $null | Remove-NetRoute -DestinationPrefix 0.0.0.0/0 -confirm:$false
				#   IPアドレス設定
                Get-NetAdapter | Where-Object InterfaceDescription -Match $CoordinationAdapterName | Get-NetIPInterface | Where-Object AddressFamily -match "IPv4" | Where-Object CompartmentId -ne $null | New-NetIPAddress -AddressFamily IPv4 -IPAddress 192.168.220.11 -PrefixLength 24 -DefaultGateway 192.168.220.1
                #   DNS設定
                Get-NetAdapter | Where-Object InterfaceDescription -Match $CoordinationAdapterName | Get-NetIPInterface | Where-Object AddressFamily -match "IPv4" | Where-Object CompartmentId -ne $null | Set-DnsClientServerAddress -ServerAddresses 8.8.8.8,8.8.4.4
                Write-Output ("`t「連携用」のIP設定を再設定しました【Fix】")

                $CheckIPAddress = Get-NetAdapter | Where-Object InterfaceDescription -Match $CoordinationAdapterName | Get-NetIPInterface | Where-Object AddressFamily -match "IPv4" | Where-Object CompartmentId -ne $null | Get-NetIPAddress
                $CheckDGW = Get-NetAdapter | Where-Object InterfaceDescription -Match $CoordinationAdapterName | Get-NetIPInterface | Where-Object AddressFamily -match "IPv4" | Where-Object CompartmentId -ne $null | Get-NetIPConfiguration | ForEach-Object IPv4DefaultGateway
                $CheckDNS = Get-NetAdapter | Where-Object InterfaceDescription -Match $CoordinationAdapterName | Get-NetIPInterface | Where-Object AddressFamily -match "IPv4" | Where-Object CompartmentId -ne $null | Get-DnsClientServerAddress | Where-Object AddressFamily -eq 2 # 2:IPv4 23:IPv6
                
                Write-Output ("`t「連携用」の現在の設定")
                Write-Output ("`t`tIPアドレス/マスク：" + $CheckIPAddress.IPAddress + "/" + $CheckIPAddress.PrefixLength)
                Write-Output ("`t`tデフォルトゲートウェイ：" + $CheckDGW.NextHop)
                Write-Output ("`t`tDNS：" + $CheckDNS.ServerAddresses)
        
            }
        }

    }else {
        #   Not ELECOM
        Write-Output "エレコム機(LB-JB18/M)ではありません、ネットワークアダプタの確認は行いません。"
    }
}else{
    Write-Output "ネットワークアダプタの確認をスキップします。"
}



#
#   パスワード入力/チェック
#
write-output "--"
Write-Output "ログインパスワードを確認します。"

do {
    $SecPass = Read-Host "OQSComApp/ONSRenkei のパスワード" -AsSecureString
    $SecPass2 = Read-Host "パスワード確認入力" -AsSecureString
    if ([System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecPass)) -ne [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecPass2))) {
        Write-Output "パスワードが異なります"        
    }
} while ([System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecPass)) -ne [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecPass2)))

#
#   パスワードポリシーチェック
#

$PassWordPolicyChcek = $false

$BSTR=[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecPass)
$Pass=[System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

write-output "--"
Write-Output "パスワードポリシーを確認します。"

#   文字数(16文字以上)
if ($Pass.Length -gt 15){
    Write-Output ("`t文字数：" + $pass.Length + "・・・OK")
    $PassWordPolicyChcek += 0x1
}else {
    Write-Output ("`t文字数：" + $pass.Length + "・・・【NG】")
}

#   英大文字
if($pass -cmatch "\p{Lu}+"){
    Write-Output ("`t英大文字：" + $Matches.Values + "・・・OK")
    $PassWordPolicyChcek += 0x2
}else{
    Write-Output ("`t英大文字：なし・・・【NG】") 
}
#   英小文字
if($pass -cmatch "\p{Ll}+"){
    Write-Output ("`t英小文字：" + $Matches.Values + "・・・OK")
    $PassWordPolicyChcek += 0x4
}else{
    Write-Output ("`t英小文字：なし・・・【NG】") 
}

#   数字
if($pass -cmatch "\p{Nd}+"){
    Write-Output ("`t数字：" + $Matches.Values + "・・・OK")
    $PassWordPolicyChcek += 0x8
}else{
    Write-Output ("`t数字：なし・・・【NG】") 
}

#   記号
if($pass -cmatch "\W+"){
    Write-Output ("`t記号：" + $Matches.Values + "・・・OK")
    $PassWordPolicyChcek += 0x10
}else{
    Write-Output ("`t記号：なし・・・【NG】") 
}

#   全角文字
if($Pass -cmatch "[^\x01-\x7E]"){
    Write-Output ("`t全角文字：" + $Matches.Values + "・・・【NG】") 
}else{
    Write-Output ("`t全角文字：なし・・・OK")
    $PassWordPolicyChcek += 0x20
}

if ($PassWordPolicyChcek -ne 63) {
    Write-Output "パスワードがポリシーを満たしていません。"
    Read-Host 終了します。画面を閉じるには何かキーを押してください…
    Exit
}


#
#   ユーザアカウントチェック
#

write-output "--"
Write-Output "ユーザアカウントを確認します。"

$IsPasswordChange = $false
$CheckAccount = 'OQSComApp','ONSRenkei'

foreach($Str_CA in $CheckAccount){

    if ((IsLocalUserAccunt $Str_CA) -eq $false){
        #   アカウント作成
        Write-output "$Str_CA が存在しません、作成します。【Fix】"
     
        if($Str_CA -eq 'OQSComApp'){
            #   OqsComApp
            #   パスワードを無期限にする
            #New-LocalUser -Name $Str_CA -Password (ConvertTo-SecureString $SecPass -AsPlainText -Force) -PasswordNeverExpires
            New-LocalUser -Name $Str_CA -Password $SecPass -PasswordNeverExpires
            $IsPasswordChange = $true
        }else{
            #   ONSRenkei
            #   パスワードを無期限にする
            #   ユーザはパスワードを変更できない
            #New-LocalUser -Name $Str_CA -Password (ConvertTo-SecureString $SecPass -AsPlainText -Force) -PasswordNeverExpires　-UserMayNotChangePassword   
            New-LocalUser -Name $Str_CA -Password $SecPass -PasswordNeverExpires　-UserMayNotChangePassword   
        }

    }else{
        Write-Output "$Str_CA を確認します。"

        #   有効にする
        Write-Output "`tアカウントを有効化します。"
        Enable-LocalUser -name $Str_CA
    


        #   パスワードを無期限にする
        #   ユーザはパスワードを変更できない(Onsrenkei)
        #   面倒なので再設定

        $Answer = $host.ui.PromptForChoice("<パスワード上書き確認>","$Str_CA のパスワードを上書きしますか？",$Choice,1)

        
        if($Str_CA -eq 'OQSComApp'){
            #   OQSComApp
            #   パスワードを無期限にする
            Write-Output "`tパスワードを無期限にします。"
            if($Answer){
                #   上書きしない
                write-output "`tパスワードを上書きしません。"
                Set-LocalUser -Name $Str_CA -PasswordNeverExpires $true
            }else{                
                #   上書き
                write-output "`tパスワードを上書きします。"
                Set-LocalUser -Name $Str_CA -Password $SecPass -PasswordNeverExpires $true
                $IsPasswordChange = $true
            }

        }else{
            #   ONSRenkei
            #   パスワードを無期限にする
            #   ユーザはパスワードを変更できない
            Write-Output "`tパスワードを無期限にします。"
            if($Answer){
                #   上書きしない
                write-output "`tパスワードを上書きしません。"
                Set-LocalUser -Name $Str_CA -PasswordNeverExpires $true
            }else{
                #   上書き
                write-output "`tパスワードを上書きします。"
                Set-LocalUser -Name $Str_CA -Password $SecPass -PasswordNeverExpires $true
            }
            Write-Output "`t「ユーザはパスワードを変更できない」をオンにします"
            Set-LocalUser -Name $Str_CA -UserMayChangePassword $false

        }

    }

    #   グループチェック

    #   administrators
    $TargetGroup = 'administrators'
    if (IsMemberLocalAccunt $Str_CA $TargetGroup){
        write-output "`t$TargetGroup に所属しています。"
    }else{
        write-output "`t$TargetGroup に所属していません。追加します。【Fix】"
        Add-LocalGroupMember -group $TargetGroup -Member $Str_CA
    }

    #   users
    $TargetGroup = 'users'
    if (IsMemberLocalAccunt $Str_CA $TargetGroup){
        write-output "`t$TargetGroup に所属しています。削除します。【Fix】"
        Remove-LocalGroupMember -group $TargetGroup -Member $Str_CA
    }else{
        write-output "`t$TargetGroup に所属していません。"
    }

}

#
#   自動ログイン再設定（Netplwiz）
#
if($IsPasswordChange){
 
    #
    #   21H2対応
    #
    write-output "--"
    Write-Output "自動ログイン設定のレジストリを確認します。"

    $RegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\PasswordLess\Device"

    if(test-path($RegPath)){
        $ChkReg = Get-ItemProperty -path $RegPath
        if($null -eq $ChkReg.DevicePasswordLessBuildVersion){
            Write-Host "レジストリエントリ(DevicePasswordLessBuildVersion) が見つかりません。【エラー】`r`n手動で更新してください。" -ForegroundColor "Red"
        }else{
            if ( ($ChkReg.DevicePasswordLessBuildVersion -eq 2)){
                Write-Output ("`t「ユーザーがこのコンピュータを使うには、ユーザー名とパスワードの入力が必要」」が無効です。有効にします。【Fix】")
                Set-ItemProperty -path $RegPath -name DevicePasswordLessBuildVersion -value 0
            }else{
                Write-Output ("`t「ユーザーがこのコンピュータを使うには、ユーザー名とパスワードの入力が必要」は有効です。")
            }
        }
    }else{
        Write-Host ("レジストリエントリ" + $RegPath + "がありません、`r`n処理をスキップします。【Skip】") -ForegroundColor "Yellow"
    }

    write-output "--"
    Write-Output "自動ログインを再設定します。"

    #	NetplWizを起動
    Start-Process -FilePath "netplwiz"

    #	チェックを一度付ける
    send-keys -KeyStroke "%(E)" -ProcessName "netplwiz.exe" -Wait 500

    #   適用
    send-keys -KeyStroke "%(A)" -ProcessName "netplwiz.exe" -Wait 500

    #	チェックを外す
    send-keys -KeyStroke "%(E)" -ProcessName "netplwiz.exe" -Wait 500

    #	適用
    send-keys -KeyStroke "%(A)" -ProcessName "netplwiz.exe" -Wait 500

    #	ユーザ名
    send-keys -KeyStroke "%(U)" -ProcessName "netplwiz.exe" -Wait 500
    send-keys -KeyStroke "OQSComApp" -ProcessName "netplwiz.exe" -Wait 500

    #   パスワード
    send-keys -KeyStroke "{TAB}" -ProcessName "netplwiz.exe" -Wait 500
    send-keys -KeyStroke $Pass -ProcessName "netplwiz.exe" -Wait 500
    #   パスワード確認入力
    send-keys -KeyStroke "{TAB}" -ProcessName "netplwiz.exe" -Wait 500
    send-keys -KeyStroke $Pass -ProcessName "netplwiz.exe" -Wait 500
    #   OK
    send-keys -KeyStroke "{ENTER}" -ProcessName "netplwiz.exe" -Wait 500
    #   OK
    send-keys -KeyStroke "{ENTER}" -ProcessName "netplwiz.exe" -Wait 500

}


if(-not $IsPasswordChange){
    $Answer = $host.ui.PromptForChoice("<タスクスケジューラ更新確認>","タスクスケジューラの更新を行いますか？",$Choice,1)
} 

if((-not $Answer) -or $IsPasswordChange){

    #
    #   タスクスケジューラ確認
    #

    write-output "--"
    write-output "連携AP、配信APタスクの設定を更新します。"

    #
    #   エラークリア
    #
    $error.Clear()

    $DelFile_Fix = $false

    # 
    #   ユーザ名
    #

    #   最初に設定済み
    #$User = whoami.exe
    #   パスワードは上の方(36行目)で入力済み
    #$SecPass = Read-Host "$User のパスワード" -AsSecureString

    #   パスワードを平文にしておく(Register-Scheduledが平文でないとダメっぽい)
    #$BSTR=[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecPass);
    #$Pass=[System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

    #   タスク取得(OQS*)

    $Tasks = (Get-ScheduledTask | Where-Object TaskName -like "OQS*" | Select-Object *)

    if($tasks.count -ne 0){
        foreach($TargetTask in $Tasks){

            #
            #   初期化
            #
            $Action = $null
            $Trigger = $null
            $Setting = $null
            $Schedule = $null

            #   Actions取得
            #$Action = (Get-ScheduledTask | where TaskName -eq $TargetTask.TaskName).Actions
            $Action = (Get-ScheduledTask -TaskName $TargetTask.TaskName).Actions
    
            #   Trigger取得
            #$Trigger = (Get-ScheduledTask | where TaskName -eq $TargetTask.TaskName).Triggers
            $Trigger = (Get-ScheduledTask -TaskName $TargetTask.TaskName).Triggers
            $NTrigger = $null
    
            #   Settings取得
            #$Setting = (Get-ScheduledTask | where TaskName -eq $TargetTask.TaskName).Settings
            $Setting = (Get-ScheduledTask -TaskName $TargetTask.TaskName).Settings
    
            #   Principal(SecurityOption)取得
            #$TaskPrincipal = (Get-ScheduledTask | where TaskName -eq $TargetTask.TaskName).Principal
    
            switch($TargetTask.TaskName){
                "OQS_exec_distroappstart"
                {
                    if ($Trigger.delay -ne "PT1M"){
                        #write-output $Trigger
                        #$NTrigger = New-ScheduledTaskTrigger -AtStartup -RepetitionInterval (New-TimeSpan -Hours 1) -RepetitionDuration ([System.TimeSpan]::MaxValue)
                        $NTrigger = New-ScheduledTaskTrigger -AtStartup 
                        #$NTrigger = (Get-ScheduledTask -TaskName $TargetTask.TaskName).Triggers
                        $NTrigger.Delay = "PT1M"
                        $DelFile_Fix = $true
                        Write-output "`t「OQS_exec_distroappstart」の開始遅延設定(1分)がされていません。【Fix】"
                    }else{
                        Write-output "`t「OQS_exec_distroappstart」は1分の開始遅延設定がされています。"
                        $NTrigger = (Get-ScheduledTask -TaskName $TargetTask.TaskName).Triggers
                    }
                    ;break
                }
    
                "OQS_exec_comappdelfile_running"
                {
                    if ($Trigger.delay -ne "PT30S"){
                        #write-output $Trigger
                        $NTrigger = New-ScheduledTaskTrigger -AtStartup
                        #$NTrigger = (Get-ScheduledTask -TaskName $TargetTask.TaskName).Triggers
                        $NTrigger.Delay = "PT30S"
                        Write-Output "`t「OQS_exec_comappdelfile_running」の開始遅延設定(30秒)がされていません。【Fix】"
                    }else{
                        Write-Output "`t「OQS_exec_comappdelfile_running」は30秒の開始遅延設定がされています。"
                        $NTrigger = (Get-ScheduledTask -TaskName $TargetTask.TaskName).Triggers
                    }
                    ;break   
                }
                default
                {
                    $NTrigger = (Get-ScheduledTask -TaskName $TargetTask.TaskName).Triggers
                    ;break
                }
            }
        
            #   タスク更新
            Register-ScheduledTask -TaskPath \ -TaskName $TargetTask.TaskName -Action $Action -Trigger $NTrigger -Settings $Setting -User $User -Password $Pass -Force
            Write-Output ("`t「" + $TargetTask.TaskName + "」を更新しました。")

            #   OQS_exec_distroappstart　のタスクを修正した場合、繰り返し時間の設定
            if (($TargetTask.TaskName -eq "OQS_exec_distroappstart") -and ($DelFile_Fix -eq $true) ){
                $Schedule = (Get-ScheduledTask -TaskName $TargetTask.TaskName).Triggers
                $Schedule.Repetition.Interval = "PT1H"
                #$Schedule.Repetition.Duration = ([System.TimeSpan]::MaxValue)
                Set-ScheduledTask -Taskname $TargetTask.TaskName -Trigger $Schedule -User $User -Password $Pass
                Write-Output "`t「OQS_exec_distroappstart」の繰り返し間隔を1時間に設定しました。"
            }
    
        }
    
    }else{
        write-output "対象となるタスクが見つかりません。【エラー】"
    }
    write-output "連携AP、配信APタスクの設定を更新しました。"

    #   タスク取得(定刻に再起動)

    write-output "「定刻に再起動」 タスクを更新します。"

    $Tasks = (Get-ScheduledTask | Where-Object TaskName -eq "定刻に再起動" | Select-Object *)

    if($tasks.count -ne 0){
        foreach($TargetTask in $Tasks){
    
            #   Action取得
            $Action =(Get-ScheduledTask | Where-Object TaskName -eq $TargetTask.TaskName).Actions
    
            #   Triger取得
            $Trigger =(Get-ScheduledTask | Where-Object TaskName -eq $TargetTask.TaskName).Triggers
    
            #   Settings取得
            $Setting =(Get-ScheduledTask | Where-Object TaskName -eq $TargetTask.TaskName).Settings
    
            #   Principal取得
            #$TascPrincipal = (Get-ScheduledTask | where TaskName -eq $TargetTask.TaskName).Principal
            #   -passwordで書き込めばセキュリティオプションは「ユーザがログオンしているかどうかにかかわらず…」になるっぽい
    
            #   タスク更新
            Register-ScheduledTask -TaskPath \ -TaskName $TargetTask.TaskName -Action $Action -Trigger $Trigger -Settings $Setting -User $User -Password $Pass -Force
    
            Write-Output "`t「定刻に再起動」タスクを更新しました。"

        }
    }else{
        write-output "「定刻に再起動」タスクが見つかりません。【エラー】"
    }

    #   エラー確認

    if($error -ne $null){
        Write-Output "【タスク設定でエラーが発生しています。内容を確認してください。】"
    }

}    

#
#   アカウントを操作した場合は一度再起動
#

if($IsPasswordChange){

    write-output "--"
    Write-Output "アカウントが操作されたため、PCを再起動します。"
    Write-Output "再度スクリプトを実行してください。"
    Read-Host 何かキーを押してください…
    Restart-Computer -Force 

}



#
#   共有フォルダチェック
#   
#   2021/12/29　「almex」フォルダ追加
#   2023/07/20  「Downloads」フォルダ追加
#

write-output "--"
write-output "共有フォルダをチェックします"

$Check_ShareName = 'OQS','FACE','REQ','RES','ALMEX','Downloads'
$Check_FolderName = 'C:\OQS','C:\OQS\Face','C:\OQS\Req','C:\OQS\Res','C:\OQS\Almex',"$env:userprofile\downloads"
$Chk_SN = 0
$Check_Share = Get-SmbShare

foreach($Check_SN in $check_share){

    foreach($CheckSN in $Check_ShareName){

        if((($Check_SN.name).toupper()) -eq $CheckSN){

            $Chk_SN = $Chk_SN + [math]::Pow(2,([array]::indexof($Check_ShareName,$CheckSN))+1)
                
            #write-output $Chk_SN

            break;
        }
    }
}


#
#   共有されていないフォルダをチェック
#


for($i = 1 ; $i -le $Check_ShareName.Count ; $i++){

    $Mes = $Check_ShareName[$i-1]
    $TargetFolder = $Check_FolderName[$i-1]

    if(($Chk_SN -band [math]::Pow(2,$i)) -eq 0){
        write-output "$Mes が共有されていません。"

        #   ローカルフォルダ存在チェック

        if((test-path $TargetFolder) -eq $false){

            Write-Output "`t$TargetFolder が存在しません、作成します。【Fix】"
            New-Item -path $TargetFolder -ItemType Directory

        }

        #　 フォルダ共有
        New-SmbShare -name $Mes -path $TargetFolder -FullAccess administrators,ONSRenkei
        write-output "`t$Mes を共有しました。【Fix】"


    }else{
        write-output "`t$Mes は共有されています。"
    }

}

#
#   共有フォルダのアクセス権をチェック
#

write-output "--"
write-output "共有フォルダのアクセス権を確認します。"

foreach($Chk_SN in $Check_Sharename){

    $Check_ShareAccess = Get-SmbShareAccess -name $Chk_SN
    $Check_Administrators = $false
    $Check_ONSRenkei = $false

    write-output ("ShareName:" + $Chk_SN)
    
    foreach ($Check_Account in $Check_ShareAccess) {
        switch -Wildcard ($Check_Account.accountname) {
            "*\Administrators" {
                $Check_Administrators = $true
                write-output ("`t" + $_ + ":" +  $Check_Account.AccessControlType + ":" + $Check_Account.AccessRight)
                if(($Check_Account.AccessControlType -eq "Allow") -and ($Check_Account.AccessRight -eq "Full")){
                    Write-output ("`t" + $Chk_SN + "の" + $_ + "のアクセス権はフルコントロールです。")
                }else{
                    Write-output ("`t" + $Chk_SN + "への" + $_ + "のアクセス権がフルコントロールではありません。修正します。【Fix】")
                    Grant-SmbShareAccess -Name $Chk_SN -AccountName $_ -AccessRight Full -Force
                }
              }
            "*\ONSRenkei"{
                $Check_ONSRenkei = $true
                write-output ("`t" + $_ + ":" +  $Check_Account.AccessControlType + ":" + $Check_Account.AccessRight)
                if(($Check_Account.AccessControlType -eq "Allow") -and ($Check_Account.AccessRight -eq "Full")){
                    Write-output ("`t" + $Chk_SN + "への" + $_ + "のアクセス権はフルコントロールです。")
                }else{
                    Write-output ("`t" + $Chk_SN + "への" + $_ + "のアクセス権がフルコントロールではありません。修正します。【Fix】")
                    Grant-SmbShareAccess -Name $Chk_SN -AccountName $_ -AccessRight Full -Force
                }
            }
            Default {
                write-output ("`t" + $_ + ":" +  $Check_Account.AccessControlType + ":" + $Check_Account.AccessRight)
                Write-output ("`t" + $Chk_SN + "への" + $_ + "のアクセス権(" + $Check_Account.AccessRight  + ")があります。削除します。【Fix】")
                Revoke-SmbShareAccess -Name $Chk_SN -AccountName $_ -Force
            }
        }
          
    }

    #   Administratorsアクセス権がない    
    if ($Check_Administrators -eq $false){
        Write-output ("`t" + $Chk_SN + "への、「Administrators」のアクセス権がありません。作成します。【Fix】")
        Grant-SmbShareAccess -Name $Chk_SN -AccountName administrators -AccessRight Full -Force
    }

    #   ONSRenkeiアクセス権がない
    if ($Check_ONSRenkei -eq $false){
        Write-output ("`t" + $Chk_SN + "への、「ONSRenkei」のアクセス権がありません。作成します。【Fix】")
        Grant-SmbShareAccess -Name $Chk_SN -AccountName ONSRenkei -AccessRight Full -Force
    }
}

#
#   Ver 3.5対応
#
write-output "--"
write-output "output(C:\ProgramData\OQS\OQSComApp\work\output)が共有されていないか確認します。"

foreach($Check_SNV35 in $check_share){
    if(($Check_SNV35.name).toupper() -eq "OUTPUT"){
        write-output ($Check_SNV35.name + "(" + $Check_SNV35.Path + ")が共有されています。共有解除します。【Fix】")
        Remove-SmbShare -name $Check_SNV35.name -Force
        break
    }
}

#
#   NTFSアクセス権チェック
#

write-output "--"
Write-Output "NTFSアクセス権を確認します。"

#   c:\oqs をチェック
#   Authenticated Users にフルコントロール
#   C:\ProgramData\OQS\OQSComApp\work\output をチェック
#   ONSRenkei にフルコントロール

$Check_Folder = 'C:\OQS', 'C:\ProgramData\OQS\OQSComApp\work\output',"$env:userprofile\downloads"

foreach ($TargetFolder in $Check_Folder) {

    write-output "$TargetFolder のアクセス権を確認します。"

    #   チェックするアカウントを設定
    switch ($TargetFolder) {
        "C:\OQS" {
            $Target_Account = "Authenticated Users"
        }
        "C:\ProgramData\OQS\OQSComApp\work\output"{
            $Target_Account = "ONSRenkei"
        }
        "$env:userprofile\downloads"{
            $Target_Account = "Authenticated Users"
        }
        Default {
            #   あり得ない
            write-output "内部エラーです(フォルダアクセス権設定)"
        }
    }
    if(test-path $TargetFolder){
        $Check_ACL = (get-acl $TargetFolder).access | Where-Object IdentityReference -like ("*" + $Target_Account) | Where-Object IsInherited -eq $false
    
        $Check_AuthenticatedUsers = $false
    
        if ($Check_ACL.Count -ne 0){
            if($Check_ACL.FileSystemRights -eq "FullControl"){
                $Check_AuthenticatedUsers = $true
                #   設定あり
                Write-Output "`t $TargetFolder に「$Target_Account」「フルコントロール」のアクセス権があります。"
            }
        }
    
    
        if($Check_AuthenticatedUsers -eq $false){
            #   設定なし
            Write-Output "`t $TargetFolder に「$Target_Account」「フルコントロール」のアクセス権がありません。修正します。【Fix】"
    
            $Target_ACL = get-acl $TargetFolder
    
            #アクセス制御
            $Permission = ($Target_Account,”FullControl”,”ContainerInherit, ObjectInherit”,”None”,”Allow”)
            $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule $Permission
            #ACL変更
            $Target_ACL.SetAccessRule($accessRule) 
            #変更したACLの適用
            $Target_ACL | Set-Acl $TargetFolder 
        }
    
    }else{
        write-output "`t $TargetFolder が存在しません。【エラー】"
    }
    
}

#
#   21H2対応
#   Everyoneフルコントロールになっていたら解除
#
#

$Check_Folder = 'C:\OQS', 'C:\ProgramData\OQS\OQSComApp\work\output'

foreach ($TargetFolder in $Check_Folder) {

    write-output "$TargetFolder のアクセス権を確認します。"

    #   チェックするアカウントを設定
    $Target_Account = "Everyone"
    

    if(test-path $TargetFolder){
        $Check_ACL = (get-acl $TargetFolder).access | Where-Object IdentityReference -like ("*" + $Target_Account) | where-object FileSystemRights -eq "FullControl" | Where-Object IsInherited -eq $false
        
        if ($Check_ACL.Count -ne 0){
            Write-Output "`t $TargetFolder に「$Target_Account」「フルコントロール」のアクセス権があります。削除します。【Fix】"

            #   ACL取得
            $ACL = get-acl $TargetFolder
            #   該当ACLを削除
            $ACL.RemoveAccessRule($Check_ACL)
            #   ACL適用
            $ACL | Set-Acl $TargetFolder

        }
    
    }else{
        write-output "`t $TargetFolder が存在しません。【エラー】"
    }
    
}



#
#   セキュリティオプション設定
#   セキュリティオプションの変更
#   [ローカルセキュリティポリシー］→　[セキュリティの設定]→
#   [ローカルポリシー]→[セキュリティオプション]内の
#   「アカウント：ローカルアカウント：空のパスワードの使用をコンソールログオンのみに制限する」を「無効」へ設定する。
#
#   TOSMEC等で無効にされていた場合、有効に戻す
#

write-output "--"
Write-Output "ローカルセキュリティポリシーを確認します。"

$RegPath = "HKLM:\System\CurrentControlSet\Control\Lsa"

if(test-path($RegPath)){
    $ChkReg = Get-ItemProperty -path $RegPath
    if($null -eq $ChkReg.LimitBlankPasswordUse){
        Write-Host "レジストリエントリ(LimitBlankPasswordUse) が見つかりません。【エラー】`r`n手動で更新してください。" -ForegroundColor "Red"
    }else{
        if ( ($ChkReg.LimitBlankPasswordUse -eq 0)){
            Write-Output ("`t「空のパスワードの使用をコンソールログオンのみに制限する」が無効です。有効にします。【Fix】")
            Set-ItemProperty -path $RegPath -name LimitBlankPasswordUse -value 1
        }else{
            Write-Output ("`t「空のパスワードの使用をコンソールログオンのみに制限する」は有効です。")
        }
    }
}else{
    Write-Host ("レジストリエントリ" + $RegPath + "がありません。【エラー】") -ForegroundColor "Red"
}


#
#   ＦＷ設定確認
#

write-output "--"
Write-Output ("ＦＷ設定を確認します。")

#
#   エラークリア
#
$error.Clear()

#   FWが無効なら有効化
$Target_FW_Location = "Public","Private"

foreach ($FWLocation in $Target_FW_Location) {

    Write-Output ("「" + $FWLocation + "」のFW設定を確認")

    if (-not ((Get-NetFirewallProfile -Profile $FWLocation).Enabled)){
        Write-Output ("`t「" + $FWLocation + "」のFWが無効です。")
        Set-NetFirewallProfile -Profile $FWLocation -Enabled True
        Write-Output ("`t「" + $FWLocation + "」のFWを有効にしました。【Fix】")
    }else{
        Write-Output ("`t「" + $FWLocation + "」のFWは有効です。") 
    }
}

write-output "--"

$Target_FW_Name = "NetLogon","Teamviewer","ファイルとプリンターの共有"

foreach ($FWName in $Target_FW_Name) {

    Write-Output ("「" + $FWName + "」のFW設定を確認")

    $FWRules = (Get-NetFirewallRule | Where-Object DisplayName -like ($FWName + "*") | Select-Object *)

    foreach($TargetRule in $FWRules){
    
        #   有効チェック
        if ((($TargetRule.enabled -eq "False") -and ($TargetRule.Profile -ne "Domain"))) {
            
            Write-Output ("`t" + $TargetRule.DisplayName + "(" + $TargetRule.Profile + ")がオフです。【Fix】")
    
            Set-NetFirewallRule -displayname $TargetRule.displayname -enabled True
    
        }
    
        #   Private/Publicチェック
        #   TeamViewerで、PrivateやPublicだったら、Public,Privateに変更してしまう
        if (($FWName -eq "TeamViewer") -and (($TargetRule.Profile -eq "Private") -or ($TargetRule.Profile -eq "Public"))){
            
            Write-Output ("`t" + $TargetRule.DisplayName + "(" + $TargetRule.Profile + ")を「Private, Public」に修正します。【Fix】")
            
            Set-NetFirewallRule -displayname $TargetRule.displayname -profile Private, Public
        
        }
    }

}

if($error -ne $null){
    Write-Output "ＦＷ設定でエラーが発生しています。内容を確認してください。"
}

#
#	マイドキュメント内に「オン資」フォルダ作成、デスクトップにショートカット作成
#

write-output "--"
Write-Output "オン資フォルダ、デスクトップショートカットを確認します。"

#   エラークリア
$error.Clear()

write-output "「オン資」フォルダを確認します。"

$TargetFolder = [Environment]::GetFolderPath('MyDocuments') + "\オン資"

#   フォルダの存在チェック

if(test-path $TargetFolder){

    Write-Output ("`t" + $TargetFolder + "は存在します。")

}else{

    Write-Output ("`t" + $TargetFolder + "が存在しません、作成します。【Fix】")

    New-Item -path $TargetFolder -ItemType Directory
}


#   ショートカットの作成(Desktop)

write-output "「オン資」デスクトップのショートカットを確認します。"

$WsShell = New-Object -ComObject WScript.Shell
$SCName = [Environment]::GetFolderPath('Desktop') + "\オン資 - ショートカット.lnk"

if (Test-Path($SCName)){

    Write-Output ("`t" + $SCName + "は存在します。")

}else{

    Write-Output ("`t" + $SCName + "が存在しません。作成します。【Fix】")

    $Shortcut = $WsShell.CreateShortcut($SCName)
    $Shortcut.TargetPath = $TargetFolder
    #$Shortcut.IconLocation = ".ico"
    $Shortcut.WindowStyle = 4 #3 =Maximized 7=Minimized 4=Normal
    #$Shortcut.WorkingDirectory = "C:\CMS\"
    $Shortcut.Save()

}

#   「医療情報閲覧」ショートカットの作成(デスクトップ)

write-output "「医療情報閲覧」のショートカットを確認します。"

$TargetFolder = [Environment]::GetFolderPath('Desktop') 
$LinkName = "\医療情報閲覧.url"

$WsShell = New-Object -ComObject WScript.Shell
$SCName = $TargetFolder + $LinkName

if (Test-Path($SCName)){

    Write-Output ("`t" + $SCName + "は存在します。")

}else{

    Write-Output ("`t" + $SCName + "が存在しません。作成します。【Fix】")

    $Shortcut = $WsShell.CreateShortcut($SCName)
    $Shortcut.TargetPath = "https://hweb.oqs.onshikaku.org/web/?mode=etsuran"
    #$Shortcut.IconLocation = ".ico"
    #$Shortcut.WindowStyle = 4 #3 =Maximized 7=Minimized 4=Normal
    #$Shortcut.WorkingDirectory = "C:\CMS\"
    $Shortcut.Save()

}

#   検証環境のショートカットはオン資フォルダへ移動
$CheckFile = [Environment]::GetFolderPath('Desktop') + "\資格確認（接続検証環境）.url"
$DistFolder = [Environment]::GetFolderPath('MyDocuments') + "\オン資"

if(test-path($CheckFile)){
    Write-Output ("`t" + $CheckFile + "は" + $DistFolder +"へ移動します。【Fix】")
    #   既存チェック
    if(Test-Path($DistFolder + "\" + (Split-Path $CheckFile -leaf))){
        Remove-Item($DistFolder + "\" + (Split-Path $CheckFile -leaf))
    }
    Move-Item $CheckFile $DistFolder
}

#
#	連携AP類のバージョン確認(表示するだけ)
#

write-output "--"
Write-Output "連携AP、配信AP、顔認証DLLのバージョンを表示します。"

$TargetFolder = "C:\Program Files\OQS\OQSComApp","C:\Program Files\OQS\OQSDistroApp","C:\Program Files\OQS-Auth"

foreach ($TFName in $TargetFolder) {
	if(test-path $TFName){
		$TFName += "\Version.info"
		get-content $TFName
	}else{
        Write-Output ($TFName + "が存在しません")
    }

}

#
#	環境切替ツール確認
#
$ChangeEnvironmentLatestVersion = "v1.0.7"
$ChangeEnvironmentInstallFile = "ChangeEnvironment_v1.0.7.zip"
$ChangeEnvironmentErr = $false
write-output "--"
Write-Output "環境切り替えツールを確認します。"

$ChangeEnvironmentFolder = "C:\ChangeEnvironment"
$ChangeEnvironmentFile = $ChangeEnvironmentFolder + "\※必ずお読みください.txt"

if(-not(test-path $ChangeEnvironmentFile)){
    if(test-path $ChangeEnvironmentFolder){
        #   バージョンファイル(※必ずお読みください.txt)がない
        Write-Output "環境切り替えツールが最新版ではありません。【Alert】"
        $ChangeEnvironmentErr = $true
    }else{
        #   環境切り替えツールがない
        Write-Output "環境切り替えツールがインストールされていません。【Alert】"
        $ChangeEnvironmentErr = $true
    }   
}else{
    $Chk_ChangeEnvironmentVersion = get-content -Encoding UTF8 $ChangeEnvironmentFile -tail 1
    Write-Output $Chk_ChangeEnvironmentVersion

    if(-not $Chk_ChangeEnvironmentVersion.Contains($ChangeEnvironmentLatestVersion)){

        #   環境切り替えツールが最新版でない
        Write-Output "環境切り替えツールが最新版ではありません。【Alert】"   
        $ChangeEnvironmentErr = $true
    }
}

if($ChangeEnvironmentErr){
    if(Test-Path ($PSScriptRoot + "\" + $ChangeEnvironmentInstallFile)){
        #   更新ファイルあり
        Write-Output "更新ファイルが見つかりました。環境切り替えツールを更新します。【Fix】"
        Expand-Archive -Path ($PSScriptRoot + "\" + $ChangeEnvironmentInstallFile) -DestinationPath c:\ -Force
        #   ファイル名文字化け対策
        if(Test-Path($ChangeEnvironmentFolder + "\���K�����ǂ݂�������.txt")){
            #   古いファイルを削除
            if(Test-Path($ChangeEnvironmentFolder + "\※必ずお読みください.txt")){
                Remove-Item ($ChangeEnvironmentFolder + "\※必ずお読みください.txt") 
            }
            #   リネーム
            rename-item ($ChangeEnvironmentFolder + "\���K�����ǂ݂�������.txt") "※必ずお読みください.txt" 
        }
        $ChangeEnvironmentErr = $false
    }else{
        Write-Output "更新ファイル($ChangeEnvironmentInstallFile)が見つかりません"
    }
    
    $Chk_ChangeEnvironmentVersion = get-content -Encoding UTF8 $ChangeEnvironmentFile -tail 1
    Write-Output $Chk_ChangeEnvironmentVersion
    
}


if($ChangeEnvironmentErr){
    Write-Host "環境切り替えツールを更新できませんでした。【エラー】`r`n手動で更新してください。" -ForegroundColor "Red"  
}

if(test-path $ChangeEnvironmentFolder){
    Write-Output "環境切り替えツールを起動します。【本番環境】を確認して終了してください。"
    Start-Process -filepath ($ChangeEnvironmentFolder + "\ChangeEnvironment.bat") -Wait  
}  

#
#	資格情報確認
#

write-output "--"
Write-Output "資格情報を確認します。"


#   レセコン選択

$ReceModel = $host.ui.PromptForChoice("<レセコン機種選択>","レセコンを選んで下さい",$Choice2,0)
if($ReceModel -eq $false){
    #   ORCA、それ以外
    Write-Output "「ORCA、それ以外」を選択しました。"
    $CryptPass = "ONSacrosmcM3"
}else{
    #   富士製品(Hi-SEED、Pharma-SEED)
    Write-Output "「富士製品(Hi-SEED、Pharma-SEED)」を選択しました。"
    $CryptPass = "ons17220010"
}

#   OQS_CRYPT_PASS
$Result = cmdkey /list:oqs_crypt_pass
if(($Result -contains '* NONE *') -or ($Result -contains '* なし *')){
    #   資格情報なし、追加
    write-host "「OQS_CRYPT_PASS」が存在しません、作成します【Fix】"
    cmdkey /generic:OQS_CRYPT_PASS /user:OQS_Admin /pass:$CryptPass
}else{
    $Answer = $host.ui.PromptForChoice("「OQS_CRYPT_PASS」は存在します。","上書きしますか？",$Choice,1)
    if(-not $Answer){
        write-host "「OQS_CRYPT_PASS」を上書きします。"
        cmdkey /generic:OQS_CRYPT_PASS /user:OQS_Admin /pass:$CryptPass
    }else{
        write-host "「OQS_CRYPT_PASS」はそのままです。"
    }
}

#   OQS_LOGIN_KEY
$Result = cmdkey /list:oqs_login_key
if(($Result -contains '* NONE *') -or ($Result -contains '* なし *')){
    #   資格情報なし、追加
    write-host "「OQS_LOGIN_KEY」が存在しません、作成します【Fix】"
    cmdkey /generic:OQS_LOGIN_KEY /user:R0
}
else{
    write-host "「OQS_LOGIN_KEY」 は存在します。"
}

#   OQS_MEDICAL_INSTITUTION_CODE
$Result = cmdkey /list:oqs_medical_institution_code
if(($Result -contains '* NONE *') -or ($Result -contains '* なし *')){
    #   資格情報なし、追加
    write-host "「OQS_MEDICAL_INSTITUTION_CODE」が存在しません、作成します【Fix】"   
    cmdkey /generic:OQS_MEDICAL_INSTITUTION_CODE /user:OQS_Admin
}
else{
    write-host "「OQS_MEDICAL_INSTITUTION_CODE」は存在します。"
}

#   OQS_NAS_LOGIN_KEY
$Result = cmdkey /list:oqs_nas_login_key
if(($Result -contains '* NONE *') -or ($Result -contains '* なし *')){
    #   資格情報なし、追加
    write-host "「OQS_NAS_LOGIN_KEY」が存在しません、作成します【Fix】"
    cmdkey /generic:OQS_NAS_LOGIN_KEY /user:ONSRenkei /pass:$Pass
}else{
    $Answer = $host.ui.PromptForChoice("「OQS_NAS_LOGIN_KEY」は存在します。","上書きしますか？",$Choice,1)
    if(-not $Answer){
        write-host "「OQS_NAS_LOGIN_KEY」を上書きします。"
        cmdkey /generic:OQS_NAS_LOGIN_KEY /user:ONSRenkei /pass:$Pass
    }else{
        write-host "「OQS_NAS_LOGIN_KEY」はそのままです。"
    }
}

#
#   暗号化識別ファイルの設定
#

$TargetFilePath = "C:\ProgramData\OQS\OQSComApp\config"
$TargetFileName = "encrypt.conf","encrypt_face.conf"
$TargetSettingName = "連携AP","顔認証DLL"
$EncryptMode = $false,$false

write-output "--"
Write-Output "暗号化識別ファイルの設定を確認します。"

foreach($CheckTSN in $TargetSettingName){

    Write-Output ($CheckTSN + "の暗号化識別ファイルを確認します。")

        #   ファイルチェック
    if ((Test-Path ($TargetFilePath + '\' + $TargetFileName[[array]::indexof($TargetSettingName,$CheckTSN)])) -eq $false){

        write-output ($TargetFileName[[array]::indexof($TargetSettingName,$CheckTSN)] + "が存在しません。【エラー】")

    }else{

        #   設定を確認
        $UserDefinitionProperty = Get-Content -Encoding Default ($TargetFilePath + '\' + $TargetFileName[[array]::indexof($TargetSettingName,$CheckTSN)])

        if($UserDefinitionProperty.Count -ne 1){
            $CheckEncrypt = $UserDefinitionProperty[0] -split("=")
        }else{
            $CheckEncrypt = $UserDefinitionProperty -split("=")
        }
        if(($CheckEncrypt[1] -eq "e") -or ($CheckEncrypt[1] -eq "E")) {
            #   暗号化
            $EncryptMode[[array]::indexof($TargetSettingName,$CheckTSN)] = "暗号化設定"
        }else{
            #   非暗号化
            $EncryptMode[[array]::indexof($TargetSettingName,$CheckTSN)] = "暗号化設定されていません"
        }
        Write-Output ($CheckTSN + "：" + $EncryptMode[[array]::indexof($TargetSettingName,$CheckTSN)])
    }
}

$Answer = $host.ui.PromptForChoice("<暗号化設定確認>","暗号化を設定しますか？",$Choice3,2)

switch($Answer){
    0 {
        #   暗号化する
        Write-Output "暗号化識別ファイルを設定します（暗号化オン）"
        $SetChr = "e"
    }
    1 {
        #   暗号化しない
        Write-Output "暗号化識別ファイルを設定します（暗号化オフ）"
        $SetChr = "n"
    }
    default{
        #   スキップ（変更しない）
        Write-Output "暗号化識別ファイルを変更しません（スキップ）"
        $SetChr = $null
    }
}

if($null -ne $SetChr){
    foreach($CheckTSN in $TargetSettingName){

        #   ファイルチェック
        if ((Test-Path ($TargetFilePath + '\' + $TargetFileName[[array]::indexof($TargetSettingName,$CheckTSN)])) -eq $false){
            write-output ($TargetFileName[[array]::indexof($TargetSettingName,$CheckTSN)] + "が存在しません。【エラー】")
        }else{
            #   ファイル読み込み
            $UserDefinitionProperty = Get-Content -Encoding Default ($TargetFilePath + '\' + $TargetFileName[[array]::indexof($TargetSettingName,$CheckTSN)])
    
            foreach($Str_Target in $UserDefinitionProperty){
                $Chk_Encrypt = $Str_Target -split("=")
                if ($Chk_Encrypt.count -eq 2){
                    #   「EPS」で始まる行は「n」にする　(電子処方箋)
                    if($Chk_Encrypt[0].Startswith("EPS")){
                        $Chk_Encrypt[1] = "n"
                    }
                    else{
                        $Chk_Encrypt[1] = $SetChr
                    }
                    if($UserDefinitionProperty.Count -ne 1){
                        $UserDefinitionProperty[[array]::indexof($UserDefinitionProperty,$Str_Target)]=$Chk_Encrypt -join ("=")
                    }else{
                        $UserDefinitionProperty = $Chk_Encrypt -join ("=")
                    }     
                }else{
                    write-output ($TargetFileName[[array]::indexof($TargetSettingName,$CheckTSN)] + "の読み込み異常です。【エラー】")
                }
            }
            #   ファイル書き出し
            Set-Content ($TargetFilePath + '\' + $TargetFileName[[array]::indexof($TargetSettingName,$CheckTSN)]) $UserDefinitionProperty -Encoding Default
    
            if(-not $Answer){
                #   暗号化する
                Write-Output ($TargetFilePath + '\' + $TargetFileName[[array]::indexof($TargetSettingName,$CheckTSN)] + "を暗号化オンに設定しました。")
            }else{
                #   暗号化しない
                Write-Output ($TargetFilePath + '\' + $TargetFileName[[array]::indexof($TargetSettingName,$CheckTSN)] + "を暗号化オフに設定しました。")
            }
            
        }    
    }

    write-output "--"
    Write-Output "連携アプリケーションを再起動します。"

    $OQSComAppToolFolder = "C:\Program Files\OQS\OQSComApp\tools"
    $OQSComAppToolFile = $OQSComAppToolFolder + "\OQSComAppRestart.bat"

    if(test-path $OQSComAppToolFolder){
    
        Start-Process -filepath ($OQSComAppToolFile) -Wait

        Write-Output "連携アプリケーションを再起動しました。"

    }else{

        write-output "連携アプリケーション(OQSComApp)がインストールされていません。【エラー】"

    }

}

#
#   プロキシ確認
#

#   IEの設定をインポート
netsh winhttp import proxy source=ie
$Proxy_Result = netsh winhttp show proxy
if(($Proxy_Result -match '直接アクセス') -or ($Proxy_Result -match 'Direct access')){
    #   プロキシなし、追加
    write-host "プロキシが設定されていません。設定します【Fix】"
    write-host "プロキシのオン・オフはブラウザの設定から行って下さい。"
    netsh winhttp set proxy proxy-server="proxy.base.oqs-pdl.org:8080" bypass-list="*.onshikaku.org;*.flets-east.jp;*.flets-west.jp;*.lineauth.mnw;*.obn.managedpki.ne.jp;*.cybertrust.ne.jp;*.secomtrust.net;*.rece;pweb.base.oqs-pdl.org;192.168.220.1"
}else{
	write-host "プロキシ設定"
	write-host $Proxy_Result
}

#
#   プロキシ設定(レジストリ側)
#

write-output "--"
Write-Output "プロキシ設定(インターネットオプション)を設定します。"

$RegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"

#   ProxyServer     proxy.base.oqs-pdl.org:8080
#   ProxyOverride   *.onshikaku.org;*.flets-east.jp;*.flets-west.jp;*.lineauth.mnw;*.obn.managedpki.ne.jp;*.cybertrust.ne.jp;*.secomtrust.net;*.rece;pweb.base.oqs-pdl.org


if(test-path($RegPath)){
    $ChkReg = Get-ItemProperty -path $RegPath
    
    #   プロキシ設定
    Set-ItemProperty -path $RegPath -name ProxyServer -value 'proxy.base.oqs-pdl.org:8080'
    Set-ItemProperty -path $RegPath -name ProxyOverride -value '*.onshikaku.org;*.flets-east.jp;*.flets-west.jp;*.lineauth.mnw;*.obn.managedpki.ne.jp;*.cybertrust.ne.jp;*.secomtrust.net;*.rece;pweb.base.oqs-pdl.org;192.168.220.1'

}else{
    Write-Host ("レジストリエントリ" + $RegPath + "がありません。【エラー】") -ForegroundColor "Red"
}

#
#   DNS設定確認
#

write-output "--"
Write-Output "DNS設定を確認します。"

$SetDnsPath = $PSScriptRoot + "\ons_set_dns.ps1"

#   ファイルチェック
if ((Test-Path ($SetDnsPath)) -eq $false){
    write-output ($SetDnsPath + "が存在しません。【エラー】")
}else{
    Start-Process powershell.exe -ArgumentList $SetDnsPath -NoNewWindow -Wait
}

#
#   その他処理
#


#
#   デスクトップアイコン設定
#
write-output "--"
Write-Output "デスクトップアイコンの設定を確認します。"

$RegKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons"
if (-not (test-path($RegKey))){
    Write-Output ($RegKey + "がありません、作成します。【Fix】")
    New-Item -Path $RegKey
}

$RegKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"
if (-not (test-path($RegKey))){
    Write-Output ($RegKey + "がありません、作成します。【Fix】")
    New-Item -Path $RegKey
}

$RegValueID = "{20D04FE0-3AEA-1069-A2D8-08002B30309D}","{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}","{59031a47-3f72-44a7-89c5-5595fe6b30ee}","{645FF040-5081-101B-9F08-00AA002F954E}","{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}"
$RegValueName = "マイ コンピュータ","コントロールパネル","ユーザーのファイル","ごみ箱","ネットワーク"

$ChkReg = Get-ItemProperty -path $RegKey

foreach ($Chk_Reg in $RegValueID){
    if($null -ne $ChkReg.$Chk_Reg){
        if(((Get-ItemProperty -path $RegKey -name $Chk_Reg)."$Chk_Reg") -eq 1){
		    Write-Output ($RegValueName[[array]::indexof($RegValueID,$Chk_Reg)] + "は非表示です。【Fix】")
		    Set-ItemProperty -Path $RegKey -Name $Chk_Reg -value 0
	    }else{
		    Write-Output ($RegValueName[[array]::indexof($RegValueID,$Chk_Reg)] + "は表示設定です。")
	    }
    }else{
        Write-Output ($RegValueName[[array]::indexof($RegValueID,$Chk_Reg)] + "は非表示です。【Fix】")
        Set-ItemProperty -Path $RegKey -Name $Chk_Reg -value 0
}
}

#
#   エクスプローラ設定確認（隠しファイル表示）
#
write-output "--"
Write-Output "エクスプローラの設定を確認します。"

$RegKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"


if(((Get-ItemProperty -path $RegKey -name "Hidden")."Hidden") -ne 1){
		Write-Output ("隠しファイルは非表示です。【Fix】")
		Set-ItemProperty -Path $RegKey -Name "Hidden" -value 1
}else{
		Write-Output ("隠しファイルは表示設定です。")
}

#
#	Defender設定確認(PUA、サンプル自動送信）
#

write-output "--"
Write-Output "Defender設定(PUA)を確認します。"
$MPP = Get-MpPreference
if ($MPP.puaprotection -ne $true){
	set-mppreference -puaprotection enabled
	Write-Output "PUAが無効です。修正しました。【Fix】"
}else{
	Write-Output "PUAは有効です。"
}

write-output "--"
Write-Output "サンプルの自動送信を確認します。"
if ($MPP.SubmitSamplesConsent -eq 1){
	set-mppreference -SubmitSamplesConsent 0
	Write-Output "サンプルの自動送信がオンです。修正しました。【Fix】"
}else{
	Write-Output "サンプルの自動送信はオフです。"
}

#
#   メンテナンス時刻の確認   
#
write-output "--"
Write-Output "メンテナンス時刻を確認します。"

$RegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance"

if(test-path($RegPath)){
    $ChkReg = Get-ItemProperty -path $RegPath
    if($null -eq $ChkReg.'Activation Boundary'){
        Write-Output ("`t自動メンテナンス時刻は、デフォルト値です。")
    }else{
        Write-Output ("`t自動メンテナンス時刻は、" + (get-date($ChkReg.'Activation Boundary') -Format "HH:mm") + "です。")
    }
    if (($null -eq $ChkReg.WakeUp) -or ($ChkReg.WakeUp -eq 0)){
        Write-Output ("`t「スケジュールされたメンテナンスによるコンピュータのスリープを解除する」がオフです。【Fix】")
        Set-ItemProperty -path $RegPath -name WakeUp -value 1
    }else{
        Write-Output ("`t「スケジュールされたメンテナンスによるコンピュータのスリープを解除する」はオンです。")
    }
}else{
    Write-Output ("レジストリエントリ" + $RegPath + "がありません。【エラー】")
}

#
#	スクリーンセーバ設定
#
#   https://paddling-blog.com/%E3%80%90windows10%E3%80%91%E3%82%B9%E3%82%AF%E3%83%AA%E3%83%BC%E3%83%B3%E3%82%BB%E3%83%BC%E3%83%90%E3%83%BC%E3%82%92%E3%82%B3%E3%83%9E%E3%83%B3%E3%83%89%E3%81%A7%E8%A8%AD%E5%AE%9A%E3%81%99%E3%82%8B
#
write-output "--"
Write-Output "スクリーンセーバ設定を確認します。"

#Start-Process "cmd" "/c desk.cpl,1" -Wait

$SCRText = "3D テキスト","バブル","ブランク","ライン アート","リボン","写真"
$SCRExe="ssText3d.scr","Bubbles.scr","scrnsave.scr","Mystify.scr","Ribbons.scr","PhotoScreensaver.scr"

$ScrRegPath = "HKCU:\Control Panel\Desktop"

if(test-path($ScrRegPath)){
    $ScrChkReg = Get-ItemProperty -path $ScrRegPath
    if($null -eq $ScrChkReg.'SCRNSAVE.EXE'){
        #   未設定
        $Answer = $host.ui.PromptForChoice("<スクリーンセーバが未設定です。>","スクリーンセーバを設定しますか？",$Choice,1)
        if(-not $Answer){
            #   スクリーンセーバ設定
            Set-ItemProperty -path $ScrRegPath -name SCRNSAVE.EXE -value "C:\WINDOWS\system32\ssText3d.scr"
            Set-ItemProperty -path $ScrRegPath -name ScreenSaveActive -value 1 -type string 
            Set-ItemProperty -path $ScrRegPath -name ScreenSaveTimeOut -value 900 -type string
            Set-ItemProperty -path $ScrRegPath -name ScreenSaverIsSecure -value 1 -type string 

        }else{
            #   スクリーンセーバ未設定
            Write-Output ("`tスクリーンセーバは未設定です。")

        }
    }else{

        #   スクリーンセーバ設定確認
        foreach ($Chk_SCRExe in $SCRExe) {
            if($ScrChkReg.'SCRNSAVE.EXE' -eq ("C:\WINDOWS\system32\" + $Chk_SCRExe)){
                Write-Output ("`tスクリーンセーバは、「" + $SCRText[[array]::IndexOf($SCRExe,$Chk_SCRExe)] + "」です。")
                break;
            }
        }

        Write-Output ("`t待ち時間は、" + $ScrChkReg.ScreenSaveTimeOut + "秒です。")

        if($ScrChkReg.ScreenSaveTimeOut -ne 900){
            Write-Output ("`t待ち時間を「15分（900秒）」に変更します。【Fix】")
            Set-ItemProperty -path $ScrRegPath -name ScreenSaveTimeOut -value 900 -type string 
        }

        if($ScrChkReg.ScreenSaverIsSecure -eq 1){
            Write-Output ("`t「再開時にログオン画面に戻る」はオンです。")
        }else{
            Write-Output ("`t「再開時にログオン画面に戻る」がオフです。【Fix】")
            Set-ItemProperty -path $ScrRegPath -name ScreenSaverIsSecure -value 1 -type string
        }
    }
}else{
    Write-Output ("レジストリエントリ" + $ScrRegPath + "がありません。【エラー】")
}

#
#   電源オプションの確認
#   2022/04/21 追加
#

Write-Output "電源オプションの設定を確認します。(キッティング項目) "

#   現在のスキームを確認
$ActiveScheme = powercfg /getactivescheme
Write-Output "--"
Write-Output $ActiveScheme

#   スリープ時間を取得
#   スキームのGUIDを取得
$EnableGUID = ($ActiveScheme -split " ")[2]

$SleepIdle = powercfg /q $EnableGUID sub_sleep standbyidle 
Write-Output "--"
Write-Output $SleepIdle

foreach ($Chk_Pow in $SleepIdle){
    if($Chk_Pow -match "AC 電源設定のインデックス"){
        $PowPara = $Chk_Pow -split ":"
        write-output $PowPara[0]
        if([system.int32]$PowPara[1] -eq 0){
            write-output "スリープタイマーは「0」です。"
        }else{
            write-output "スリープタイマーが「0」ではありません。【Fix】"
            powercfg /change standby-timeout-ac 0
        }
    }
}


Write-Output "--"
Write-Output "シャットダウン設定を確認します。"
#   「高速スタートアップを有効にする(推奨)」をオフにする。
$PowRegPath = "HKLM:\SYSTEM\ControlSet001\Control\Session Manager\Power"

if(test-path($PowRegPath)){
    $ChkReg = Get-ItemProperty -path $PowRegPath
    if ($ChkReg.HiberbootEnabled -eq 1){
        Write-Output ("`t「高速スタートアップを有効にする(推奨)」がオンです。【Fix】")
        Set-ItemProperty -path $PowRegPath -name HiberbootEnabled -value 0
    }else{
        Write-Output ("`t「高速スタートアップを有効にする(推奨)」はオフです。")
    }
}else{
    Write-Output ("レジストリエントリ" + $PowRegPath + "がありません。【エラー】")
}




$Answer = $host.ui.PromptForChoice("デスクトップアイコンの整列確認","整列処理を行いますか？",$Choice,1)

#
#   レジストリを反映させる-1(Regedit、F5)
#

#   レジストリエディタ起動
start-process "regedit.exe"

#   F5(最新の情報に更新)
send-keys -KeyStroke "{F5}" -ProcessName "regedit.exe" -Wait 500

#   レジストリエディタ終了
send-keys -KeyStroke "(%{F4})" -ProcessName "regedit.exe" -Wait 500

#
#   レジストリ変更を反映させる-2(Gpupdate /force)
#

Start-Process "gpupdate" "/force" -Wait

#
#   レジストリ変更を反映させる-3(Win+D、F5)
#

write-output "--"
Write-Output "エクスプローラを最新の情報に更新します。"

#   デスクトップを表示
start-process "cmd" "/c start shell:::{3080F90D-D7AD-11D9-BD98-0000947B0257}"

#   アイコンの選択を解除
send-keys -KeyStroke "^ " -ProcessName "explorer.exe" -Wait 500

#   F5(最新の情報に更新)
send-keys -KeyStroke "{F5}" -ProcessName "explorer.exe" -Wait 500

if (-not $Answer){
    #   デスクトップの並べ替え(項目の種類) 
    send-keys -KeyStroke "(+{F10})" -ProcessName "explorer.exe" -Wait 500
    send-keys -KeyStroke "o" -ProcessName "explorer.exe" -Wait 500
    send-keys -KeyStroke "{Down 2}" -ProcessName "explorer.exe" -Wait 500
    send-keys -KeyStroke "{Enter}" -ProcessName "explorer.exe" -Wait 500

    #   デスクトップの並べ替え(名前) 
    send-keys -KeyStroke "(+{F10})" -ProcessName "explorer.exe" -Wait 500
    send-keys -KeyStroke "o" -ProcessName "explorer.exe" -Wait 500
    send-keys -KeyStroke "{Enter}" -ProcessName "explorer.exe" -Wait 500
}

#   PowerShellをアクティブに
$signature = @"
[DllImport("user32.dll")]
public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
"@

$showWindowAsync = Add-Type -memberDefinition $signature -name "Win32ShowWindowAsync" -namespace Win32Functions -passThru

$p = Get-Process | Where-Object {$_.MainWindowTitle -match "管理者: Windows PowerShell"}

# Restore it
$showWindowAsync::ShowWindowAsync($p.MainWindowHandle, 1)

add-type -AssemblyName microsoft.VisualBasic
[Microsoft.VisualBasic.Interaction]::AppActivate($p.id);


#
#   TeamViewerチェック
#

Write-Output ("--")
Write-Output ("【TeamViewerの設定を確認します。】")

$CheckTVPath = $PSScriptRoot + "\Check_TeamViewer.ps1"

#   ファイルチェック
if ((Test-Path ($CheckTVPath)) -eq $false){
    write-output ($CheckTVPath + "が存在しません。TeamViewerのチェックは行いません。")
}else{
    Start-Process powershell.exe -ArgumentList $CheckTVPath , "-Child 1" -NoNewWindow -Wait
}

#
#   ランダムパスワード生成
#

Write-Output ("--")
Write-Output ("【各アカウント用のランダムパスワードを生成します。】")

$CheckTVPath = $PSScriptRoot + "\ONS_CreatePasswords.ps1"

#   ファイルチェック
if ((Test-Path ($CheckTVPath)) -eq $false){
    write-output ($CheckTVPath + "が存在しません。パスワードファイル生成は行いません。")
}else{
    Start-Process powershell.exe -ArgumentList $CheckTVPath , "-Child 1" -NoNewWindow -Wait
}


#
#   途中終了用
#
Read-Host 終了しました。画面を閉じるには何かキーを押してください…
exit



#
#	cleanmgrでクリーンアップ
#

write-output "--"
Write-Output "ディスクのクリーンアップを行います。"

$Answer = $host.ui.PromptForChoice("<Cleanmgr実行確認>","ディスククリーンアップを実行しますか？",$Choice,1)
if($Answer -eq $false){
    write-output "--"
    Write-Output "「ディスククリーンアップ」を起動します。"
    cleanmgr /lowdisk /d c
    #cleanmgr /verylowdisk
}



#
#	インターネットオプション	履歴の削除
#

write-output "--"
Write-Output "インターネットオプション、履歴を削除します。"

RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 255


#   以下作成中



#
#	インターネットオプション    証明書が空な事を確認
#

write-output "--"
Write-Output "インターネットオプションを開きます。"
Write-Output "「コンテンツ」タブの個人証明書が空な事を確認してください。"

Start-Process "inetcpl.cpl" -Wait

#
#	ユーザアカウント制御
#
write-output "--"
Write-Output "UAC設定を確認してください。"

Start-Process "control" "/name Microsoft.UserAccounts" -Wait

#
#	アクションセンター（メンテナンス時刻の確認）
#
write-output "--"
Write-Output "メンテナンス時刻設定を確認してください。"

Start-Process "control" "/name Microsoft.ActionCenter" -Wait

#
#	エクスプローラ履歴の削除
#
write-output "--"
Write-Output "フォルダオプションを開きます。"
Write-Output "エクスプローラ履歴を削除してください。"

Start-Process "control" "/name microsoft.folderoptions" -Wait

#
#	PSの履歴を削除
#
write-output "--"
Write-Output "PowerShellのコマンド履歴を削除します。"

Remove-Item $env:userprofile\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt


#
#	Chkfileでファイルチェック
#


