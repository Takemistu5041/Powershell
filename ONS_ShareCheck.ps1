#
#   ONS_ShareCheck.ps1
#   オン資端末共有チェック
#
#   Copyright 2022 By T.Tanaka
#

#   2024/5/8    NTFSアクセス権にDownloadフォルダ追加
#   2024/4/26   Downloadフォルダの共有追加(薬情PDF用）


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

#
#   ユーザアカウントチェック
#
#   Onsrenkeiが存在するか確認
#

write-output "--"
Write-Output "ユーザアカウントを確認します。"

$CheckAccount = 'OQSComApp','ONSRenkei'

foreach($Str_CA in $CheckAccount){

    if ((IsLocalUserAccunt $Str_CA) -eq $false){
        #   アカウント作成
        Write-host "$Str_CA が存在しません【エラー】" -ForegroundColor "Red"
        Write-host "ONSCheckを実行して再セットアップしてください。" -ForegroundColor "Red"

    }else{
        Write-Output "$Str_CA を確認します。"

        #   有効にする
        Write-Output "`tアカウントを有効化します。"
        Enable-LocalUser -name $Str_CA
    
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
#   共有フォルダチェック
#   
#   2021/12/29　「almex」フォルダ追加
#   2024/4/26   Downloadフォルダの共有追加(薬情PDF用）
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
#   終了
#

Read-Host 終了しました。画面を閉じるには何かキーを押してください…
exit
