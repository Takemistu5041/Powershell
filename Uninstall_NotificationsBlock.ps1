#
#   Uninstall_NotificationsBlock
#   (通知ブロック設定削除)
#   
#   Copyright2021 By T.Tanaka
#

#   管理者権限チェック
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators")) {
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

#
#   選択肢コレクションの作成
#
$assembly= $yes.getType().AssemblyQualifiedName
$Choice = new-object "System.Collections.ObjectModel.Collection``1[[$assembly]]"
$Choice.add($yes)
$Choice.add($no)


#
#   通知ブロックのインストールを確認
#


Write-Output "【通知ブロック設定アンインストーラ】"
write-output "--"
Write-Output "通知ブロック設定を確認します。"


$RegKey = "HKLM:\SOFTWARE\Policies\Google\Chrome\NotificationsBlockedForUrls"

if(-not (test-path($RegKey))){

    Write-Output "`t通知ブロックは設定されていません。"

}else{
    Write-Output "`t【通知ブロックが設定されています。】"
    $Answer = $host.ui.PromptForChoice("<通知ブロック削除確認>","通知ブロック設定を削除しますか？",$Choice,1)

    if(-not $Answer){
        #
        #   レジストリ削除
        #
        Write-Output "`t--"
        Write-Output "・レジストリを削除します。"

        $RegKeyList = "HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy Objects\{924E1265-018B-44BC-9A05-87A2F254D6C1}Machine\Software\Policies\Google\Chrome" `
                        ,"HKLM:SOFTWARE\Policies\Google\Chrome" `
                        ,"HKLM:SOFTWARE\WOW6432Node\Policies\Google\Chrome" `

        $RegEntry = "ExtensionSettings"

        foreach($Regkey in $RegKeyList){
            if(test-path($RegKey)){
                Write-Output ("`tRegKey:" + $RegKey )
                if($null -ne (Get-ItemProperty -Path $RegKey -Name $RegEntry -ErrorAction SilentlyContinue)){
                    Remove-ItemProperty -path $RegKey -Name $RegEntry
                }else{
                    Write-Output ("`tRegKey:" + $RegKey + "\" + $RegEntry + " is Not already.")
                }
            }
        }
    
        $RegKeyList = "HKLM:SOFTWARE\Policies\Google\Chrome\NotificationsBlockedForUrls" `
                        ,"HKLM:SOFTWARE\WOW6432Node\Policies\Google\Chrome\NotificationsBlockedForUrls" `
                        ,"HKLM:SOFTWARE\Policies\Microsoft\Edge\NotificationsBlockedForUrls" `
                        ,"HKLM:SOFTWARE\WOW6432Node\Policies\Microsoft\Edge\NotificationsBlockedForUrls" `
                        ,"HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy Objects\{B8DC9E97-13BF-410D-91CC-55636E4342C0}Machine\Software\Policies\Microsoft\Edge\NotificationsBlockedForUrls"

        foreach ($Regkey in $RegKeyList) {
            if(test-path($RegKey)){
                Write-Output ("`tRegKey:" + $RegKey )
                Remove-Item $RegKey
            }else{
                Write-Output ("`tRegKey:" + $RegKey + " is Not already.")
            }
        }

        #
        #   スケジューラ削除
        #
        Write-Output "`t--"
        Write-Output "・スケジュールタスクを削除します。"

        #   タスクを取得
        $Tasks = (Get-ScheduledTask | Where-Object TaskName -like "UpdateBlockURL*" | Select-Object *)

        if($tasks.count -ne 0){
            foreach($TargetTask in $Tasks){

                Write-Output ("`t" + $Targettask.TaskName + "is Deleted." )
                #   タスク削除
                Unregister-ScheduledTask -TaskName $TargetTask.TaskName -Confirm:$false

            }
        }

        #
        #   フォルダ削除
        #
        Write-Output "`t--"
        Write-Output "・ファイルフォルダを削除します。"

        Write-Output ("`t 「C:\Cmstools」 is Deleted." )
        Remove-Item -path c:\cmstools -Recurse

        Write-Output "`t通知ブロック設定を削除しました。"
    }else{
        Write-Output "`t通知ブロック設定はそのままです。"
    }
}

write-output "--"
Write-Output "処理は終了しました。"
Read-Host 画面を閉じるには何かキーを押してください…

