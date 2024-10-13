#
#   CMS2M3Sol.ps1
#
#   Gmailのフィルタ設定エクスポートファイルの修正
#
#   Copyright 2022 By T.Tanaka
#

#Set-ExecutionPolicy -Scope Process RemoteSigned

Add-Type -AssemblyName Microsoft.VisualBasic
Add-Type -AssemblyName System.Windows.Forms


#   xmlファイル選択(mailFilters.xml) 
$CMSFile = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
    InitialDirectory = [System.Environment]::GetFolderPath('userprofile') + "\Downloads"
    Filter = 'GMailFiter設定ファイル|mailFilters.xml'
    Title = '変換するファイルを選択してください'
}

if($CMSFile.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK){
    #[System.Windows.forms.MessageBox]::Show('選択したファイル：' + $FileBrowser.FileName)
}else{
    #[System.Windows.forms.MessageBox]::Show('ファイルは選択されませんでした！')
    Exit
}


#   ファイル読み込み

$CMSMailFilters = Get-Content -Encoding UTF8 $CMSFile.FileName


#   置換
$M3SolMailFilters = $CMSMailFilters.Replace("@cmsnet.ne.jp","@m3sol.co.jp")

#   書き出し
$M3SolFILE = [System.Environment]::GetFolderPath('userprofile') + "\Desktop\"
$M3SolFILE += ($CMSFile.SafeFileName -replace '(.+)(\.[^.]+$)','$1') + "_M3Sol.xml"

Set-Content $M3SolFILE $M3SolMailFilters -Encoding UTF8

[System.Windows.Forms.MessageBox]::Show("デスクトップに置換ファイルを作成しました。", "CMS2M3Sol")

exit
