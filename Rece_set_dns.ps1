# Set-ExecutionPolicy -scope process remotesigned
#
#   IPSEC環境でのオンライン請求DNS切替
#
#   Copyright 2021 By T.Tanaka
#

#
#   パラメータ設定
#

$IF_IP_Address = "192.168.110.21"
$ORG_DNS = "192.168.110.1"

$Rece_DNS = "10.255.4.70","10.254.4.70"


# アセンブリのロード
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# フォームを作る
$Form = New-Object System.Windows.Forms.Form
$Form.Size = New-Object System.Drawing.Size(280,220)
$Form.Text = "NTT東西選択"
$Form.StartPosition = "CenterScreen"

# Gender(性別)グループを作る
$MyGroupBox = New-Object System.Windows.Forms.GroupBox
$MyGroupBox.Location = New-Object System.Drawing.Point(30,10)
$MyGroupBox.size = New-Object System.Drawing.Size(200,100)
$MyGroupBox.text = "NTT東西"

# Gender(性別)グループの中のラジオボタンを作る
$RadioButton1 = New-Object System.Windows.Forms.RadioButton
$RadioButton1.Location = New-Object System.Drawing.Point(20,20)
$RadioButton1.size = New-Object System.Drawing.Size(100,30)
$RadioButton1.Checked = $True
$RadioButton1.Text = "NTT東日本"

$RadioButton2 = New-Object System.Windows.Forms.RadioButton
$RadioButton2.Location = New-Object System.Drawing.Point(20,60)

$RadioButton2.size = New-Object System.Drawing.Size(100,30)
$RadioButton2.Text = "NTT西日本"

# OKボタンを作る
$OKButton = new-object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Point(55,120)
$OKButton.Size = New-Object System.Drawing.Size(80,40)
$OKButton.Text = "OK"
$OKButton.DialogResult = "OK"

# キャンセルボタンを作る
$CancelButton = new-object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Point(145,120)

$CancelButton.Size = New-Object System.Drawing.Size(80,40)
$CancelButton.Text = "Cancel"
$CancelButton.DialogResult = "Cancel"

# グループにラジオボタンを入れる
$MyGroupBox.Controls.AddRange(@($Radiobutton1,$RadioButton2))
#$MyGroupBox1.Controls.AddRange(@($Radiobutton3,$RadioButton4,$RadioButton5))

# フォームに各アイテムを入れる
#$Form.Controls.AddRange(@($MyGroupBox,$MyGroupBox1,$OKButton,$CancelButton))
$Form.Controls.AddRange(@($MyGroupBox,$OKButton,$CancelButton))

# Enterキー、Escキーと各ボタンの関連付け
$Form.AcceptButton = $OKButton
$Form.CancelButton = $CancelButton

# フォームをアクティブにする＝Topmost？
$Form.TopMost = $True

# フォームを表示させ、押されたボタンの結果を受け取る
$dialogResult = $Form.ShowDialog()

# ボタン押下による条件分岐
if ($dialogResult -eq "OK"){
    # 性別の判定
    if ($RadioButton1.Checked){
    $NTT_EW = "NTT東日本"
    $TargetName[1] = $ASSV_East
    }elseif ($RadioButton2.Checked){
    $NTT_EW = "NTT西日本"
    $TargetName[1] = $ASSV_West
    }
}else{
exit
}

#[System.Windows.Forms.MessageBox]::Show("NTT：$NTT_EW`n$TargetName[1]" , "結果")

foreach ($NSTarget in $TargetName) {

    write-host "Target:"$NSTarget
    $NSResult = nslookup $NSTarget

        $NameCheck = $false

        foreach ($NSResult2 in $NSResult) {
            switch -wildcard ($NSResult2){
                "Name:*"{
                    Write-Host $NSResult2
                    $NameCheck = $True
                }
                
                "Address:"{
                    if($NameCheck){
                        write-host $NSResult2
                    }                    
                }
                "Addresses:*"{
                    if($NameCheck){
                        write-host $NSResult2
                    }                    
                }

                "*:*:*:*"{
                    if($NameCheck){
                        write-host $NSResult2
                    }   
                }

                "*.*.*.*"{
                    if($NameCheck){
                        write-host $NSResult2
                    }
                }
                    
        }
    }
}

