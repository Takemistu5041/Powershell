#
#   メモ帳の設定を「新しいウィンドウで開く」に
#    SetupNotepadOpenNewWindow.ps1
#
#   Copyright 2024 By T.Tanaka
#
#


# Windows PowerShellでアプリを自動操作するスクリプト

# UI オートメーションを使うための準備
Add-Type -AssemblyName UIAutomationClient
Add-Type -AssemblyName UIAutomationTypes
Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.Form].FullName
$AutomationElement = [System.Windows.Automation.AutomationElement]
$TreeScope = [System.Windows.Automation.TreeScope]
$Condition = [System.Windows.Automation.Condition]
$InvokePattern = [System.Windows.Automation.InvokePattern]
$Cursor = [System.Windows.Forms.Cursor]

# マウスの左クリック操作をおこなうための準備
$SendInputSource =@"
using System;
using System.Drawing;
using System.Runtime.InteropServices;
using System.Windows.Forms;

public class MouseClick {
    [StructLayout(LayoutKind.Sequential)]
    struct MOUSEINPUT {
        public int dx;
        public int dy;
        public int mouseData;
        public int dwFlags;
        public int time;
        public IntPtr dwExtraInfo;
    }
    
    [StructLayout(LayoutKind.Sequential)]
    struct INPUT
    {
        public int type;
        public MOUSEINPUT mi;
    }

    [System.Runtime.InteropServices.DllImport("user32.dll")]
    extern static uint SendInput(uint cInputs, INPUT[] pInputs, int cbSize);

    public static void Click() {
        INPUT[] input = new INPUT[2];
        input[0].mi.dwFlags = 0x0002;
        input[1].mi.dwFlags = 0x0004;
        SendInput(2, input, Marshal.SizeOf(input[0]));
    }
}
"@
Add-Type -TypeDefinition $SendInputSource -ReferencedAssemblies System.Windows.Forms, System.Drawing
$MouseClick = [MouseClick]

# 要素を取得する関数
function GetElements {
    Param($RootWindowName = $null)
    if ($RootWindowName -eq $null) {
        try {
            return $AutomationElement::RootElement.FindAll($TreeScope::Subtree, $Condition::TrueCondition)
        }
        catch {
            return $null
        }
    }
    else {
        $childrenElements = $AutomationElement::RootElement.FindAll($TreeScope::Children, $Condition::TrueCondition)
        foreach ($element in $childrenElements) {
            if ($element.GetCurrentPropertyValue($AutomationElement::NameProperty) -eq $RootWindowName) {
                return $element.FindAll($TreeScope::Subtree, $Condition::TrueCondition)
            }
        }
            Write-Host "指定された名前 '${RootWindowName}' のウィンドウが見つかりません。"
    }
    return $null
}

# 要素を検索する関数
function FindElement {
    Param($RootWindowName = $null, $PropertyType, $Identifier, $Timeout)
    $startTime = (Get-Date).Ticks
    do {
        foreach ($element in GetElements -RootWindowName $RootWindowName) {
            try {
                if ($element.GetCurrentPropertyValue($AutomationElement::$PropertyType) -eq $Identifier) {
                    return $element
                }
            }
            catch {
                continue
            }
        }
    }
    while (((Get-Date).Ticks - $startTime) -le ($Timeout * 10000))
    throw "指定された要素 '${Identifier}' が見つかりません。"
}

# クリック操作をおこなう関数
function ClickElement {
    Param($RootWindowName = $null, $PropertyType, $Identifier, $Timeout = 5000)
    $startTime = (Get-Date).Ticks
    do {
        $element = FindElement -RootWindowName $RootWindowName -PropertyType $PropertyType -Identifier $Identifier -Timeout $Timeout
        $isEnabled = $element.GetCurrentPropertyValue($AutomationElement::IsEnabledProperty)
        if ($isEnabled -eq "True") { break }
    }
    while (((Get-Date).Ticks - $startTime) -le ($Timeout * 10000))
    if ($isEnabled -ne "True") {
        throw "指定された要素 '${Identifier}' が有効状態になりません。"
    }

    if ($element.GetCurrentPropertyValue($AutomationElement::IsInvokePatternAvailableProperty) -eq "True") {
        $element.GetCurrentPattern($InvokePattern::Pattern).Invoke()
    }
    else {
        # IsInvokePatternAvailablePropertyがFalseの時はマウスカーソルを要素に移動して左クリックする
        $clickablePoint = $element.GetClickablePoint()
        $Cursor::Position = New-Object System.Drawing.Point($clickablePoint.X, $clickablePoint.Y)
        $MouseClick::Click()
    }
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
#   OS Check
#

$OS_Check = (get-wmiobject win32_operatingsystem).caption

if (-not ($OS_Check -match "Windows 11")){
   
    write-output $OS_Check
    Write-Output "Windows11用です。Windows11で実行して下さい。"
    Read-Host 終了します。画面を閉じるには何かキーを押してください…
    Exit

}

#
#   メモ帳起動
#

start-process notepad

#   設定を開く(ALT+S)

send-keys -KeyStroke "%(S)" -ProcessName "notepad.exe" -Wait 500

#   メモ帳の起動時を選択(TABx4、Enter)

send-keys -KeyStroke "{TAB}{TAB}{TAB}{TAB}{ENTER}" -ProcessName "notepad.exe.exe" -Wait 1000

#   「新しいウィンドウ」をクリック

$element = FindElement -RootWindowName "タイトルなし - メモ帳" -PropertyType "AutomationIdProperty" -Identifier "TurnOffButton"

$element.SetFocus()
$element.SetFocus()


#   前に戻る（BS）

send-keys -KeyStroke "{BS}" -ProcessName "notepad.exe" -Wait 1000

#   メモ帳を終了(ALT+F4)

send-keys -KeyStroke "%(F)X" -ProcessName "notepad.exe" -Wait 1000

