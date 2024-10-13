#
#   オン資用　初期パスワード生成ツール
#
#   Copyright 2022 By T.Tanaka
#
#A:オン資フォルダの「初期アカウント情報(PC名).txt」
#B:デスクトップの「医療情報閲覧(初期).txt」
#
#・どちらもない場合
#    A･B両方作成
#・Aだけ存在する場合
#    Aはそのまま(警告表示)
#    Aから医療情報閲覧用パスワードを取得してBを作成
#    (Aから読み込めない場合はエラー、新規でBを作成)※フォーマットチェックは行数のみ
#・Bだけ存在する場合
#    Aを作成
#    Bはそのまま(エラー)
#・どちらも存在する場合
#    Aはそのまま(エラー)
#    Bはそのまま(エラー)
#

#   引数
Param( [bool]$Child = $False)

#
#　　関数(上に置いとかないといけないみたい)
#

#   定数
$Password_Numeric = "1234567890"
$Password_UpperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
$Password_LowerCase = "abcdefghijklmnopqrstuvwxyz"
$Password_Symbol = "^$*.[]{}()?-!@#%&/,><':;|_~``"

function CreatePassword($Length,$KIGOU){
  
  #
  # パスワード生成
  #
  # Length->文字数　KIGOU->記号を含むか　True:含む　False:含まない
  #
  # Copyright 2020 By T.Tanaka
  #
  # 文字数が3文字以下だと要件を満たせませんが、エラーは出ません。
  #
  
  $PassWord = ''

  #とりあえず最低要件を満たす
    #   数字
  $PassWord += GenPassWord($Password_Numeric)
    #   英大文字
  $PassWord += GenPassWord($Password_UpperCase)
    #   英小文字
  $PassWord += GenPassWord($Password_LowerCase)
    #   記号
  if ($KIGOU -eq $True){
    $PassWord += GenPassWord($Password_Symbol)
  }
  
  # パスワード生成
  
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
# 「オン資」フォルダ確認
#

Write-Output "--"
Write-Output "【ランダムパスワード生成】"
write-output "「オン資」フォルダを確認します。"

$TargetFolder = [Environment]::GetFolderPath('MyDocuments') + "\オン資"

#   フォルダの存在チェック

if(test-path $TargetFolder){
    Write-Output ("`t" + $TargetFolder + "は存在します。")
}else{
    Write-Output ("`t" + $TargetFolder + "が存在しません、作成します。【Fix】")
    New-Item -path $TargetFolder -ItemType Directory
}

#
# ランダムパスワード生成
#

# 医療情報用は別で作成
$Iryou_Pass = (CreatePassword 16 $True)

$Ary_IryoData = @()
$Ary_IryoData += "【医療情報閲覧アカウント】Iryou01"
$Ary_IryoData += $Iryou_Pass
$Ary_IryoData += ""

$Iryo_DATA = $Ary_IryoData -join "`r`n"


#   出力データ作成
$Ary_OPDATA = @()

$Ary_OPDATA += "【マスタアカウント】"
$Ary_OPDATA += (CreatePassword 16 $True)
$Ary_OPDATA += ""

$Ary_OPDATA += "【管理アカウント】Kanri01"
$Ary_OPDATA += (CreatePassword 16 $True)
$Ary_OPDATA += ""

$Ary_OPDATA += "【一般利用者アカウント】Staff01"
$Ary_OPDATA += (CreatePassword 16 $True)
$Ary_OPDATA += ""

$Ary_OPDATA += "【医療情報閲覧アカウント】Iryou01"
$Ary_OPDATA += $Iryou_Pass
$Ary_OPDATA += ""

$OP_DATA = $Ary_OPDATA -join "`r`n"


#   ファイル書き出し

# 初期アカウント情報

$ONS_Password_FILE = [Environment]::GetFolderPath('MyDocuments') + "\オン資\"
$ONS_Password_FILE += "初期アカウント情報(" + $Env:COMPUTERNAME + ").txt"

if(-not (test-path($ONS_Password_FILE))){
  Set-Content $ONS_Password_FILE $OP_DATA -Encoding Default
  write-output ("`t" + $ONS_Password_FILE + "を出力しました。")
}else{
  Write-Host "`t $ONS_Password_FILE は既に存在します。【Warning】" -ForegroundColor "Yellow"

  # 既存ファイルの読み込み
  $RandomPasswordFile = Get-Content -Encoding Default $ONS_Password_FILE

  if ($RandomPasswordFile.count -ne 12){
    Write-Host "`t $ONS_Password_FILE のフォーマットが異なります。【Error】" -ForegroundColor "Red"
  }else{
    # ファイルからIryou01のパスワードを取得
    # 「医療情報閲覧(初期).txt"」用データ再生成

    $Ary_IryoData = @()
    $Ary_IryoData += "【医療情報閲覧アカウント】Iryou01"
    $Ary_IryoData += $RandomPasswordFile[10]
    $Ary_IryoData += ""
    
    $Iryo_DATA = $Ary_IryoData -join "`r`n"
    
  }

}

# 医療情報閲覧アカウント
$ONS_Iryouetsuran_FILE = [Environment]::GetFolderPath('Desktop') + "\"
$ONS_Iryouetsuran_FILE += "医療情報閲覧(初期).txt"

if(-not (test-path($ONS_Iryouetsuran_FILE))){
  Set-Content $ONS_Iryouetsuran_FILE $Iryo_DATA -Encoding Default
  write-output ("`t" + $ONS_Iryouetsuran_FILE + "を出力しました。")
}else{
  Write-Host "`t $ONS_Iryouetsuran_FILE は既に存在します。【Error】" -ForegroundColor "Red"
}


#   処理終了

if(-not $Child){
  write-output "--"
  Write-Output "処理は終了しました。"
  Read-Host 画面を閉じるには何かキーを押してください…
}

exit
