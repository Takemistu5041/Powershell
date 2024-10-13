#Set-ExecutionPolicy -Scope Process RemoteSigned

#
#　　関数(上に置いとかないといけないみたい)
#


$Password_Numeric = "1234567890"
$Password_UpperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
$Password_LowerCase = "abcdefghijklmnopqrstuvwxyz"
$Password_Symbol = "!$%&+*-@"
$Password_Buffalo = "_"


function CreatePassword($Length,$KIGOU){
  
  #
  #　パスワード生成
  #
  #　Length->文字数　KIGOU->記号を含むか　True:含む　False:含まない
  #
  #  Copyright 2020 By T.Tanaka
  #
  #　文字数が3文字以下だと要件を満たせませんが、エラーは出ません。
  #
  
  $PassWord = ''

  #とりあえず最低要件を満たす
    # 数字
  $PassWord += GenPassWord($Password_Numeric)
    #　英大文字
  $PassWord += GenPassWord($Password_UpperCase)
    #　英小文字
  $PassWord += GenPassWord($Password_LowerCase)
    #　記号
  if ($KIGOU -eq $True){
    $PassWord += GenPassWord($Password_Symbol)
  }
  
  #　パスワード生成
  
  for ($i = 3 + $KIGOU ; $i -lt $Length ; $i++){
    
    $Target = get-random -Minimum 0 -Maximum 17
    
    switch($Target){
      {($_ -ge 0) -and ($_ -le 4)} {
            #数字
        $PassWord += GenPassWord($Password_Numeric)
        ;break
        }
      {($_ -ge 5) -and ($_ -le 9)} {
            #英大文字
        $PassWord += GenPassWord($Password_UpperCase)
        ;break
        }
      {($_ -ge 10) -and ($_ -le 14)} {
            #英小文字
        $PassWord += GenPassWord($Password_LowerCase)
        ;break
        }
      {($_ -ge 15) -and ($_ -le 16)} {
            #記号
        if ($KIGOU -eq $True){
          $PassWord += GenPassWord($Password_Symbol)
          ;break
        }else{
        $i = $i - 1
        ;continue
        }
        }
      default{
        $Result = [System.Windows.Forms.MessageBox]::Show("17が出た", "想定外")
        exit
        ;break
        }
    }
  }

  #Write-Host $PassWord

  #//var Result = Browser.msgBox(PassWord);
  
  #ランダムに並び替える
  
  $SPassWord = ''
  $PassArray = @()
  
  for ($i = 0 ; $i -lt $Length ; $i++){
    $PassArray += 0 
  }
  
  for ($i = 0 ; $i -lt $Length; $i++){
    while ($True){
    
      $Target = get-random -Minimum 0 -Maximum $Length
    
      if ($PassArray[$Target] -eq 0){
        $PassArray[$Target]=1
        $SPassWord += $PassWord.Substring($Target,1)
        ;break

      }
     }
  }
    
  return $SPassWord
  
  
  }

  function CreatePassword2($Length,$KIGOU){
  
    #
    #　パスワード生成2(Buffalo用)※記号は「_」のみ
    #
    #　Length->文字数　KIGOU->記号を含むか　True:含む　False:含まない
    #
    #  Copyright 2020 By T.Tanaka
    #
    #　文字数が3文字以下だと要件を満たせませんが、エラーは出ません。
    #
    
    $PassWord = ''
  
    #とりあえず最低要件を満たす
      # 数字
    $PassWord += GenPassWord($Password_Numeric)
      #　英大文字
    $PassWord += GenPassWord($Password_UpperCase)
      #　英小文字
    $PassWord += GenPassWord($Password_LowerCase)
      #　記号
    if ($KIGOU -eq $True){
      $PassWord += GenPassWord($Password_Buffalo)
    }
    
    #　パスワード生成
    
    for ($i = 3 + $KIGOU ; $i -lt $Length ; $i++){
      
      $Target = get-random -Minimum 0 -Maximum 17
      
      switch($Target){
        {($_ -ge 0) -and ($_ -le 4)} {
              #数字
          $PassWord += GenPassWord($Password_Numeric)
          ;break
          }
        {($_ -ge 5) -and ($_ -le 9)} {
              #英大文字
          $PassWord += GenPassWord($Password_UpperCase)
          ;break
          }
        {($_ -ge 10) -and ($_ -le 14)} {
              #英小文字
          $PassWord += GenPassWord($Password_LowerCase)
          ;break
          }
        {($_ -ge 15) -and ($_ -le 16)} {
              #記号
          if ($KIGOU -eq $True){
            $PassWord += GenPassWord($Password_Buffalo)
            ;break
          }else{
          $i = $i - 1
          ;continue
          }
          }
        default{
          $Result = [System.Windows.Forms.MessageBox]::Show("17が出た", "想定外")
          exit
          ;break
          }
      }
    }
  
    #Write-Host $PassWord
  
    #//var Result = Browser.msgBox(PassWord);
    
    #ランダムに並び替える
    
    $SPassWord = ''
    $PassArray = @()
    
    for ($i = 0 ; $i -lt $Length ; $i++){
      $PassArray += 0 
    }
    
    for ($i = 0 ; $i -lt $Length; $i++){
      while ($True){
      
        $Target = get-random -Minimum 0 -Maximum $Length
      
        if ($PassArray[$Target] -eq 0){
          $PassArray[$Target]=1
          $SPassWord += $PassWord.Substring($Target,1)
          ;break
  
        }
       }
    }
      
    return $SPassWord
    
    
    }
  

  function GenPassWord($PassWordSource){
  #
  #　パスワード生成 (引数PassWordSouceからランダムな一文字を選んで返す)
  #
  
  $PassWord = ""


    $Target = get-random -Minimum 0 -Maximum $PassWordSource.length
  
      $PassWord = $PassWordSource.substring($Target,1)
      
      return $PassWord

}

#
#   Send-Keys関連
#

Add-Type -AssemblyName Microsoft.VisualBasic
Add-Type -AssemblyName System.Windows.Forms

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
        $Process = ps | ? {$_.Name -eq $ProcessName} | sort -Property CPU -Descending | select -First 1
        Write-Verbose $Process", KeyStroke = "$KeyStroke", Wait = "$Wait" ms."
        sleep -Milliseconds $Wait
        if ($Process -ne $null)
        {
            [Microsoft.VisualBasic.Interaction]::AppActivate($Process.ID)
        }
        [System.Windows.Forms.SendKeys]::SendWait($KeyStroke)
    }
}

#
#   ShrewImport.ps1
#
#	Copyright 2020 By T.Tanaka
#
# 2022/7/28 TVとかのパスワードの生成を追加
# 2024/8/6  Buffalo用のパスワード生成を追加
#

#   .vpnファイル選択
$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
    InitialDirectory = [System.Environment]::GetFolderPath('userprofile') + "\Downloads"
    Filter = 'ShrewVPNファイル(*.vpn)|*.vpn'
    Title = 'ShrewVPNにインポートするファイルを選択してください'
}
 
if($FileBrowser.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK){
    #[System.Windows.forms.MessageBox]::Show('選択したファイル：' + $FileBrowser.FileName)
}else{
    #[System.Windows.forms.MessageBox]::Show('ファイルは選択されませんでした！')
    Exit
}


#   .txtファイル選択
$FileBrowser2 = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
    InitialDirectory =[System.Environment]::GetFolderPath('userprofile') + "\Downloads"
    Filter = 'ルータ設定用ファイル(*.txt)|*.txt'
    Title = 'ルータ設定用のテキストファイルを選択してください'
}
 
if($FileBrowser2.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK){
    #[System.Windows.forms.MessageBox]::Show('選択したファイル：' + $FileBrowser2.FileName)
}else{
    #[System.Windows.forms.MessageBox]::Show('ファイルは選択されませんでした！')
    Exit
}

#   ShrewVPN VPN AccessManagerを起動
Start-Process -FilePath "C:\Program Files\ShrewSoft\VPN Client\ipseca.exe"

#
#   Sendkeyで送れない記号を変換する
#

$FileBrowser.FileName = $FileBrowser.FileName.Replace("(","{(}")
$FileBrowser.FileName = $FileBrowser.FileName.Replace(")","{)}")
$FileBrowser.FileName = $FileBrowser.FileName.Replace("+","{+}")
$FileBrowser.FileName = $FileBrowser.FileName.Replace("^","{^}")
$FileBrowser.FileName = $FileBrowser.FileName.Replace("~","{~}")
$FileBrowser.FileName = $FileBrowser.FileName.Replace("%","{%}")


#   選択したファイルをインポートして閉じる
send-keys -KeyStroke "%" -ProcessName "ipsecd.exe" -Wait 500
send-keys -KeyStroke "f" -ProcessName "ipsecd.exe" -Wait 500
send-keys -KeyStroke "i" -ProcessName "ipsecd.exe" -Wait 500
Send-Keys -KeyStroke $FileBrowser.FileName -ProcessName "ipsecd.exe" -Wait 500
send-keys -KeyStroke "{enter}" -ProcessName "ipsecd.exe" -Wait 500
send-keys -KeyStroke "{enter}" -ProcessName "ipsecd.exe" -Wait 500
send-keys -KeyStroke "%" -ProcessName "ipsecd.exe" -Wait 500
send-keys -KeyStroke "f" -ProcessName "ipsecd.exe" -Wait 500
send-keys -KeyStroke "ee" -ProcessName "ipsecd.exe" -Wait 500
send-keys -KeyStroke "{enter}" -ProcessName "ipsecd.exe" -Wait 500

#
#   変換した文字を元に戻す
#

$FileBrowser.FileName = $FileBrowser.FileName.Replace("{(}","(")
$FileBrowser.FileName = $FileBrowser.FileName.Replace("{)}",")")
$FileBrowser.FileName = $FileBrowser.FileName.Replace("{+}","+")
$FileBrowser.FileName = $FileBrowser.FileName.Replace("{^}","^")
$FileBrowser.FileName = $FileBrowser.FileName.Replace("{~}","~")
$FileBrowser.FileName = $FileBrowser.FileName.Replace("{%}","%")

#
#   設定ファイルを開いてSFコピペ用に表示
#
#   "%userprofile%\AppData\Local\Shrew Soft VPN\sites" Soft VPN\sites

$ShrewPath = $env:USERPROFILE
$ShrewPath  += "\AppData\Local\Shrew Soft VPN\sites"
$ShrewFile = $ShrewPath + "\" + $FileBrowser.SafeFileName
$FwxFile = $FileBrowser2.FileName

#   ShrewVPN設定読み込み
$ShrewConfig = Get-Content -Encoding Default $ShrewFile

foreach($Str_Source in $ShrewConfig){
    switch -Wildcard ($Str_Source){
        "*b:auth-mutual-psk:*"{
            $DM = $Str_Source.split(":")
            $SF_PSK = $DM[2]
            break;
        }
        "*s:ident-client-data:*"{
            $DM = $Str_Source.split(":")
            $SF_UFQN = $DM[2]
            break;
        }
        "*s:policy-list-include:*"{
            $DM = $Str_Source.split(":")
            $SF_RemoteNW = $DM[2]
            break;
        }
        "*s:ident-server-data:*"{
            $DM = $Str_Source.split(":")
            $SF_Address = $DM[2]
            $SF_RIPAddr = $SF_Address + "/24"
            break;
        }
        "*s:network-host:*"{
            $DM = $Str_Source.split(":")
            $SF_DDNS = $DM[2]
            break;
        }
    }

}

#   FWX設定読み込み

$FWXConfig = Get-Content -Encoding Default $FwxFile

foreach($Str_Source2 in $FWXConfig){
    switch -Wildcard ($Str_Source2){
        "*☆管理者パスワード*"{
            $DM = $Str_Source2.split("：")
            $SF_RPass = $DM[1]
            break;
        }
        "*x-auth user/pwその１*"{
            $DM = $Str_Source2.split("：")
            $DM2 = $DM[1].split(" ")
            $SF_ID1 = $DM2[0]
            $SF_PASS1 = $DM2[1]
            break;
        }
        "*x-auth user/pwその２*"{
            $DM = $Str_Source2.split("：")
            $DM2 = $DM[1].split(" ")
            $SF_ID2 = $DM2[0]
            $SF_PASS2 = $DM2[1]
            break;
        }
    }
}

#
#   TVとかのパスワード生成
#
$VNC = CreatePassword 8 $True
$TV = CreatePassword 16 $True
$ORCARenkei = CreatePassword 16 $True
$CMSSupport = CreatePassword 16 $True
$BuffaloPass = CreatePassword2 8 $true

#   出力データ作成
$Ary_SFDATA = @()

$Ary_SFDATA += "←ルーターPASS"
$Ary_SFDATA += $SF_RPass
$Ary_SFDATA += ""

$Ary_SFDATA += "ルーターIPアドレス→"
$Ary_SFDATA += $SF_RIPAddr
$Ary_SFDATA += ""

$Ary_SFDATA += "無線ルーターPASS→"
$Ary_SFDATA += $BuffaloPass
$Ary_SFDATA += ""

$Ary_SFDATA += "←リモートDNS"
$Ary_SFDATA += $SF_DDNS
$Ary_SFDATA += ""

$Ary_SFDATA += "←UFQN String"
$Ary_SFDATA += $SF_UFQN
$Ary_SFDATA += ""

$Ary_SFDATA += "Address String→"
$Ary_SFDATA += $SF_Address
$Ary_SFDATA += ""

$Ary_SFDATA += "←Pre Shared Key"
$Ary_SFDATA += $SF_PSK
$Ary_SFDATA += ""

$Ary_SFDATA += "Remote Network Resource→"
$Ary_SFDATA += $SF_RemoteNW
$Ary_SFDATA += ""

$Ary_SFDATA += "←IPSEC/ID(1)"
$Ary_SFDATA += $SF_ID1
$Ary_SFDATA += ""

$Ary_SFDATA += "IPSEC/PW(1)→"
$Ary_SFDATA += $SF_PASS1
$Ary_SFDATA += ""

$Ary_SFDATA += "←IPSEC/ID(2)"
$Ary_SFDATA += $SF_ID2
$Ary_SFDATA += ""

$Ary_SFDATA += "IPSEC/PW(2)→"
$Ary_SFDATA += $SF_PASS2
$Ary_SFDATA += ""

$Ary_SFDATA += "【VNC Password】"
$Ary_SFDATA += $VNC
$Ary_SFDATA += ""

$Ary_SFDATA += "【TV Password】"
$Ary_SFDATA += $TV
$Ary_SFDATA += ""

$Ary_SFDATA += "【ORCARenkei Password】"
$Ary_SFDATA += $ORCARenkei
$Ary_SFDATA += ""

$Ary_SFDATA += "【cmssupport Password】"
$Ary_SFDATA += $CMSSupport
$Ary_SFDATA += ""

$Ary_SFDATA += "【IPSEC接続元制限&ファーム更新スケジュールあり】"
$Ary_SFDATA += ""

$SF_DATA = $Ary_SFDATA -join "`r`n"


#   ファイル書き出し

$SFFILE = [System.Environment]::GetFolderPath('userprofile') + "\Desktop\"
$DM = $FileBrowser.SafeFileName.split(".")
$SFFILE += $DM[0] + "(SF貼付用).txt"

Set-Content $SFFILE $SF_DATA -Encoding Default

[System.Windows.Forms.MessageBox]::Show("デスクトップにSF貼付け用のテキストファイルを出力しました。", "処理終了")

exit
