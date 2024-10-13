#
#   ※TOSMEC
#   セキュリティオプション設定
#   セキュリティオプションの変更
#   [ローカルセキュリティポリシー］→　[セキュリティの設定]→
#   [ローカルポリシー]→[セキュリティオプション]内の
#   「アカウント：ローカルアカウント：空のパスワードの使用をコンソールログオンのみに制限する」を「無効」へ設定する。
#

write-output "--"
Write-Output "ローカルセキュリティポリシーを確認します。"

$RegPath = "HKLM:\System\CurrentControlSet\Control\Lsa"

if(test-path($RegPath)){
    $ChkReg = Get-ItemProperty -path $RegPath
    if($null -eq $ChkReg.LimitBlankPasswordUse){
        Write-Host "レジストリパラメータ(LimitBlankPasswordUse) が見つかりません。【エラー】`r`n手動で更新してください。" -ForegroundColor "Red"
    }else{
        if ( ($ChkReg.LimitBlankPasswordUse -eq 1)){
            Write-Output ("`t「空のパスワードの使用をコンソールログオンのみに制限する」が有効です。【Fix】")
            Set-ItemProperty -path $RegPath -name LimitBlankPasswordUse -value 0
        }else{
            Write-Output ("`t「空のパスワードの使用をコンソールログオンのみに制限する」は無効です。")
        }
    }
}else{
    Write-Host ("レジストリエントリ" + $RegPath + "がありません。【エラー】") -ForegroundColor "Red"
}
