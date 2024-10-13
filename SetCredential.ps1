#Set-ExecutionPolicy -Scope Process RemoteSigned

#
#   資格情報確認  SetCredential.ps1　
#
#   Copyright 2021 By T.Tanaka
#

#   管理者権限
#if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators")) {
    #Start-Process powershell.exe "-WindowStyle Hidden -executionpolicy remotesigned -File `"$PSCommandPath`"" -Verb RunAs
#    Start-Process powershell.exe " -executionpolicy remotesigned -File `"$PSCommandPath`"" -Verb RunAs

#    exit
#}

#   パスワード
$SecPass = Read-Host "OQSComapp/ONSRenkei のパスワード" -AsSecureString

$BSTR=[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecPass);
$Pass=[System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

#   OQS_CRYPT_PASS
#   無条件上書き
write-host "OQS_CRYPT_PASS"
cmdkey /generic:OQS_CRYPT_PASS /user:OQS_Admin /pass:$Pass

#   OQS_LOGIN_KEY
$Result = cmdkey /list:oqs_login_key
if(($Result -contains '* NONE *') -or ($Result -contains '* なし *')){
    #   資格情報なし、追加
    write-host "OQS_LOGIN_KEY is Not Exist."
    cmdkey /generic:OQS_LOGIN_KEY /user:R0
}
else{
write-host "OQS_LOGIN_KEY is Exist."
}

#   OQS_MEDICAL_INSTITUTION_CODE
$Result = cmdkey /list:oqs_medical_institution_code
if(($Result -contains '* NONE *') -or ($Result -contains '* なし *')){
    #   資格情報なし、追加
    write-host "OQS_MEDICAL_INSTITUTION_CODE is Not Exits."   
    cmdkey /generic:OQS_MEDICAL_INSTITUTION_CODE /user:OQS_Admin
}
else{
    write-host "OQS_MEDICAL_INSTITUTION_CODE is Exist."
}

#   OQS_NAS_LOGIN_KEY
#   無条件上書き
write-host "OQS_NAS_LOGIN_KEY"
cmdkey /generic:OQS_NAS_LOGIN_KEY /user:ONSRenkei /pass:$Pass

