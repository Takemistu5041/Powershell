#
#   Windowsスタティックルート制御
#   ControlStaticRoute.ps1
#
#   Copyright 2023 By T.Tanaka
#

#
#   ターゲットNW
#
$Target_NW = "192.168.1.0","192.168.10.0","192.168.100.0"
$Target_GW = "192.168.110.1"


#   管理者権限チェック(「Administrators」 or　「Network Configuration Operators」)
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators") -and !([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Network Configuration Operators")) {
    #Start-Process powershell.exe "-WindowStyle Hidden -executionpolicy remotesigned -File `"$PSCommandPath`"" -Verb RunAs
    Start-Process powershell.exe " -executionpolicy remotesigned -File `"$PSCommandPath`"" -Verb RunAs;

    exit
}


#
#   選択肢の作成
#
$typename = "System.Management.Automation.Host.ChoiceDescription"
$yes = new-object $typename("&Yes","はい")
$no  = new-object $typename("&No","いいえ")

$Add = New-Object $typename("&A:追加")
$Delete = New-Object $typename("&D:削除")
$Quit = New-Object $typename("&Q:終了")


#
#   選択肢コレクションの作成
#
$assembly= $yes.getType().AssemblyQualifiedName
$Choice = new-object "System.Collections.ObjectModel.Collection``1[[$assembly]]"
$Choice.add($yes)
$Choice.add($no)

$Choice2 = new-object "System.Collections.ObjectModel.Collection``1[[$assembly]]"
$Choice2.add($Add)
$Choice2.add($Delete)
$Choice2.add($Quit)

write-output "--"
write-output "【VPN用StaticRoute設定/削除】"

#
#   インターフェース番号取得
#
$Target_IF = (Get-NetIPAddress | where-object -filterscript { $_.InterFaceAlias -like "*VR-U300W*"}).interfaceindex
$Target_Alias = (Get-NetIPAddress | where-object -filterscript { $_.InterFaceAlias -like "*VR-U300W*"}).InterfaceAlias

if($Target_IF -eq $null){
    write-output "--"
    write-output "VR-U300WへのVPNが接続されていないようです。"
    write-output "VPN接続状態で実行して下さい。"
    Read-Host 終了しました。画面を閉じるには何かキーを押してください…
    exit
        
}

write-output "--"
write-output "【現在のVPN接続】"
write-output $Target_Alias
write-output "インターフェース番号： $Target_IF"


#
#   現在のルーティングを表示
#
write-output "--"
write-output "【現在の $Target_GW 向けスタティックルート】"
get-netroute -addressfamily IPv4 | Where-Object -FilterScript { $_.NextHop -eq $Target_GW }


#
#   設定候補を表示
#
write-output "--"
write-output "【このスクリプトで設定されるネットワーク情報】"

foreach ($NWName in $Target_NW) {

    Write-Output ($NWName)

}


#
#   処理選択
#

do{
    $STask = $host.ui.PromptForChoice("<処理選択>","処理を選んで下さい",$Choice2,2)

    switch($STask){

        0 {
            #   追加

            foreach ($NWName in $Target_NW) {

                $NWName += "/24"
            
                New-NetRoute -DestinationPrefix $NWName -InterfaceIndex $Target_IF -NextHop $Target_GW -PolicyStore ActiveStore

            }

            write-output "--"
            write-output "追加しました。"

        }

        1 {
            #   削除

            foreach ($NWName in $Target_NW) {

                $NWName += "/24"
            
                Remove-NetRoute -DestinationPrefix $NWName -Confirm:$false -PassThru                
            }

            write-output "--"
            write-output "削除しました。"

        }


        default{
            break;
        }
    
    }


}while ($STask -ne 2)

write-output "--"
write-output "【現在の $Target_GW 向けスタティックルート】"
get-netroute -addressfamily IPv4 | Where-Object -FilterScript { $_.NextHop -eq $Target_GW }


write-output "--"
write-output "終了しました。"
Read-Host 画面を閉じるには何かキーを押してください…
exit






