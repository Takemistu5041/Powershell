#Set-ExecutionPolicy -Scope Process RemoteSigned

#
#   ＦＷ設定更新  ONS_SetFW.ps1
#
#
#   Copyright 2021 By T.Tanaka
#

#   管理者権限
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators")) {
    #Start-Process powershell.exe "-WindowStyle Hidden -executionpolicy remotesigned -File `"$PSCommandPath`"" -Verb RunAs
    Start-Process powershell.exe " -executionpolicy remotesigned -File `"$PSCommandPath`"" -Verb RunAs

    exit
}


#
#   エラークリア
#
$error.Clear()


Write-Output "ＦＷ設定を確認します。"

$Target_FW_Name = "NetLogon","TeamViewer"

foreach ($FWName in $Target_FW_Name) {

    Write-Output $FWName + "の設定を確認"

    $FWRules = (Get-NetFirewallRule | where DisplayName -like ($FWName +"*") | select *)

    foreach($TargetRule in $FWRules){
    
        #   有効チェック
        if ($TargetRule.enabled -eq $false) {
            
            Write-Output "`t" + $TargetRule.DisplayName + "がオフです。【修正】"
    
            Set-NetFirewallRule -displayname $TargetRule.displayname -enabled True
    
        }
    
    }

}

#
#   終了
#
write-host "完了しました"
if($error -ne $null){
    write-host "エラーが発生しています。内容を確認してください。"
}
Read-Host "何かキーを押してください。"
