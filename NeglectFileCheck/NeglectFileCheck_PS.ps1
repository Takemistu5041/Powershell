#
#   一定期間アクセスのないファイルを削除
#
#   Copyright 2024 By T.Tanaka
#
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

write-output "--"
Write-Output "ごみ箱を空にします。"

Clear-RecycleBin -Confirm:$False

write-output "--"
write-output "【処理開始】"


#
#	設定
#

#	チェックする日数
$NumberofDays = -7

#	対象フォルダ
$TargetFolder = 'C:\work\共有起点\文書管理'

# ログファイル
$NeglectLog = $TargetFolder + '\NeglectFile' + (get-date -format "yyyyMMddHHmm") + '.txt'
$DeleFolderLog = $TargetFolder + '\DeleteFolder' + (get-date -format "yyyyMMddHHmm") + '.txt'

# 作成日時
#$fobj.CreationTime

# 最終更新日時
#$fobj.LastWriteTime

# 最終アクセス日時
#$fobj.LastAccessTime



$NeglectMessage = [string][math]::abs($NumberofDays) + "日以上アクセスのないファイルを削除します。"
write-output "--"
write-output ($NeglectMessage)
Add-Content -path $NeglectLog -value "$NeglectMessage `r`n" -Encoding utf8BOM 

#	リストアップ

Get-ChildItem -Path $TargetFolder -Recurse -File | `
  select-object LastAccessTime,length,FullName | `
  Where-Object { $_.LastAccessTime -lt (Get-Date).AddDays($NumberofDays) } | out-file $NeglectLog -Append -Encoding utf8BOM

#	消す
#Get-ChildItem -Path $TargetFolder -Recurse -File | `
  Where-Object { $_.LastAccessTime -lt (Get-Date).AddDays($NumberofDays) } | Remove-Item -Force -WhatIf


write-output "--"
write-output "空のフォルダを削除します。"
Add-Content -path $DeleFolderLog -value "空のフォルダを削除します。 `r`n" -Encoding utf8BOM

  # 空フォルダを削除する
$items=Get-ChildItem -Recurse -Path $TargetFolder -Directory
foreach($item in $items){
  if((Get-ChildItem $item.fullname).Count -eq 0){
      $item | select-object CreationTime,length,FullName | out-file $DeleFolderLog -Append -Encoding utf8BOM
      $item | Remove-Item -force -Recurse -WhatIf
  }
}

write-output "--"
write-output "【処理終了】"








 
