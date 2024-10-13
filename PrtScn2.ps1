#Set-ExecutionPolicy -Scope Process RemoteSigned


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
#   PrtScn2.ps1
#
#	KBがない環境でPrtscnキーを押す
#
#	Copyright 2020 By T.Tanaka
#

#	PrtScnのみ
send-keys -KeyStroke "{PRTSC}" -Wait 200

#	ALT+PrtScn
#send-keys -KeyStroke "%{PRTSC}" -Wait 200

