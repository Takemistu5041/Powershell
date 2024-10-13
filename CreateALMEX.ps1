#
#   CreateALMEX（オン資端末 ALMEX用フォルダチェック）
#
#   Copyright 2022 By T.Tanaka
#
#
#   2022/06/09  新規作成
#

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


#   フォーム用宣言
Add-Type -Assembly System.Windows.Forms

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

#   処理確認
$Answer = $host.ui.PromptForChoice("<実行確認>","ALMEXフォルダの確認/設定を行いますか？",$Choice,1)


if(-not $Answer){

    #
    #   共有フォルダチェック
    #   
    #   2021/12/29　「almex」フォルダ追加
    #

    write-output "--"
    write-output "共有フォルダをチェックします"

    $Check_ShareName = 'OQS','FACE','REQ','RES','ALMEX'
    $Check_FolderName = 'C:\OQS','C:\OQS\Face','C:\OQS\Req','C:\OQS\Res','C:\OQS\Almex'
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


    for($i = 1 ; $i -lt 6 ; $i++){

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

    $Check_ShareV35 = Get-SmbShare

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

    $Check_Folder = 'C:\OQS', 'C:\ProgramData\OQS\OQSComApp\work\output'

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

}

#
#   終了
#
Read-Host 終了しました。画面を閉じるには何かキーを押してください…
exit

