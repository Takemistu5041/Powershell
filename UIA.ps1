# UI Automation 共通ファンクション

# UI Automation を組み込む
Add-Type -AssemblyName UIAutomationClient
Add-Type -AssemblyName UIAutomationTypes
  
# Net Framework ソースを組み込む
#$source = (Get-Content .\UIAAutomation.vb) -join "`r`n"
#Add-Type -Language VisualBasic -TypeDefinition $source -ReferencedAssemblies ("UIAutomationClient", "UIAutomationTypes")
# コマンドレットを組み込む
Import-Module .\MyUIAutomation20.dll
# 不具合回避
[MyUIAutomation.UIAAutomation]::GetRoot() | Out-Null

# 初期化
Function UIA_Init()
{
  #
  #Get-UIAutomation
  New-Object MyUIAutomation.UIAAutomation
}

function global:UIA_GetNameToElements($top,$treescope,$name)
{
  $top.FindFirst(
    $treescope,
    $condition_true
  ) | ?{$_.name -match $name}
}

function global:UIA_GetElements($top,$treescope)
{
  $top.FindAll(
    $treescope,
    $condition_true
  )
}

function global:UIA_GetValue($top)
{
  #Write-Host $($top | UIA_OutPut | Out-String)
  #Write-Host $($top.GetSupportedPatterns() | Out-String)
  switch ($top.current.localizedcontroltype) {
    "編集" {
      $p=$top.GetCurrentPattern([System.Windows.Automation.ValuePattern]::Pattern)
      $p.current.value
    }
    "一覧" {
      $p=$top.GetCurrentPropertyValue([System.Windows.Automation.SelectionPatternIdentifiers]::SelectionProperty)
      $p.current.name
    }
    "一覧項目" {
      $p=$top.GetCurrentPropertyValue([System.Windows.Automation.SelectionItemPatternIdentifiers]::IsSelectedProperty)
      $p
    }
    "ツリー項目" {
     $p=$top.GetCurrentPropertyValue([System.Windows.Automation.TogglePatternIdentifiers]::ToggleStateProperty)
      $p
    }
    "オプション ボタン"{
      $p=$top.GetCurrentPropertyValue([System.Windows.Automation.SelectionItemPatternIdentifiers]::IsSelectedProperty)
      $p
    }
    "チェック ボックス"{
      $p=$top.GetCurrentPropertyValue([System.Windows.Automation.TogglePatternIdentifiers]::ToggleStateProperty)
      $p
    }
    "スピン"{
      $p=$top.GetCurrentPropertyValue([System.Windows.Automation.RangeValuePatternIdentifiers]::ValueProperty)
      $p
    }
    default {
    }
  }
}

function global:UIA_GetKey($top,$pkey)
{
  #Write-Host $($top | UIA_OutPut | Out-String)
  switch ($top.current.localizedcontroltype) {
    "ダイアログ" {
      $pkey + "_" + $top.current.name
    }
    "ウィンドウ" {
      $pkey + "_" + $top.current.name
    }
    "タブ項目" {
      $pkey + "_" + $top.current.name
    }
    "ボタン" {
      $pkey + "_" + $top.current.name
    }
    "編集" {
      $pkey + "_" + $top.current.name
    }
    "一覧項目" {
      $pkey + "_" + $top.current.name
    }
    "ツリー項目" {
      $pkey + "_" + $top.current.name
    }
    "オプション ボタン"{
      $pkey + "_" + $top.current.name
    }
    "チェック ボックス"{
      $pkey + "_" + $top.current.name
    }
    default {
      ""
    }
  }
}

function global:UIA_GetElementTreeWithNest($top,$nest = 0)
{
  Write-Host "UIA_GetElementTreeWithNest"
  $opt = @{Nest=$nest}
  [PSCustomObject]@{UIA=$top;OPT=$opt}
  $c = UIA_GetElements $top $children
  if ($c -eq $null) {
  }
  else {
    $c | %{UIA_GetElementTreeWithNest $_ ($nest + 1)}
  }
}

function global:UIA_GetElementTreeWithOpt($top,$nest = 0,$pkey="")
{
  Write-Host "UIA_GetElementTreeWithOpt $key" 

  $value = UIA_GetValue $top
  $action=""
  $trigger=""
  $key =　UIA_GetKey $top $pkey
  if ($key -ne "") {$pkey = $key}
  $opt = @{Nest=$nest;Value=$value;Action=$action;Trigger=$trigger;Key=$key}
  [PSCustomObject]@{UIA=$top;OPT=$opt}
  $c = UIA_GetElements $top $children
  if ($c -eq $null) {
  }
  else {
    $c | %{UIA_GetElementTreeWithOpt $_ ($nest + 1) $pkey}
  }
}

function global:UIA_GetParentElement($top)
{
  Write-Host "UIA_GetParentElement"
  if ($top.current.localizedcontroltype -match "ダイアログ") {
    $top
  }
  else {
    $p = [System.Windows.Automation.TreeWalker]::ControlViewWalker.GetParent($top)
    Write-Host $($p | UIA_OutPut | Out-String)
    if ($p -eq $re) {
      if ($top.current.localizedcontroltype -match "ウィンドウ") {
        $top
      }
      else {
        $null
      }
    }
    else {
      if ($p.current.localizedcontroltype -match "ダイアログ") {
        $p
      }
      else {
        UIA_GetParentElement $p
      }
    }
  }
}

Function global:UIA_OutPut()
{
    [CmdletBinding()]
    Param (
        #[Parameter(Mandatory=$True,ValueFromPipeline=$True)]
        [Parameter(ValueFromPipeline=$True)]
        [System.Object[]]$input,
        $element,
        $event,
        [ValidateSet("Element" , "ElementWithNest", "ElementWithOpt", "Event")]
        [String]$mode = "Element",
        [switch]$action = $false,
        [switch]$trigger = $false,
        [switch]$key = $false

    )

    Begin {
    }

    Process {
    　  switch ($mode) {
            ("Element") {     
                foreach ($in in $input) {
                    $in | %{$_.current} | select localizedcontroltype,classname,name
                }
            }
            ("ElementWithNest") {     
                foreach ($in in $input) {
                  $name = $in.UIA.current.name
                  $controltype =  ("  " * [int]$in.OPT.nest) + $in.UIA.current.localizedcontroltype
                  $classname = $in.UIA.current.classname
                  [PSCustomObject]@{
                    ControlType=$controltype;
                    ClassName=$classname;
                    Name=$name
                  }
                }
            }
            ("ElementWithOpt") {     
                foreach ($in in $input) {
                  $name = $in.UIA.current.name
                  $controltype =  ("  " * [int]$in.OPT.nest) + $in.UIA.current.localizedcontroltype
                  $classname = $in.UIA.current.classname
                  $value = $in.OPT.value
                  $ret=@{
                    ControlType=$controltype;
                    ClassName=$classname;
                    Value=$value;
                    Name=$name
                  }
                  if ($action) {$ret["action"] = $in.OPT.Action}
                  if ($trigger) {$ret["trigger"] = $in.OPT.Trigger}
                  if ($key) {$ret["key"] = $in.OPT.Key}
                  (([PSCustomObject]$ret) | select controltype,classname,value,action,trigger,name,key)
                  #[PSCustomObject]$ret
                }
            }
            ("Event") {
                #Export-Clixml -InputObject $input -Path d:\input.txt     
                $name = $element.current.name
                $controltype = $element.current.localizedcontroltype
                $classname = $element.current.classname
                $eventid = $event.EventId.ProgrammaticName
                $property = $event.property.ProgrammaticName
                [PSCustomObject]@{
                    ControlType=$controltype;
                    ClassName=$classname;
                    EventID=$eventid;
                    Property=$property;
                    Name=$name
                }
            }
        }
    }

    End {
    }
}

#UIA_Init

# 共通定数
# ルートエレメント
$global:re = [System.Windows.Automation.AutomationElement]::RootElement
# ツリースコープ
$global:subtree = [System.Windows.Automation.TreeScope]::Subtree
$global:children = [System.Windows.Automation.TreeScope]::Children
$global:parent = [System.Windows.Automation.TreeScope]::Parent

$global:condition_true = [System.Windows.Automation.Condition]::TrueCondition


#Add-Type -Path "C:\Program Files\Reference Assemblies\Microsoft\Framework\v3.0\UIAutomationClient.dll"
#Add-Type -Path "C:\Program Files\Reference Assemblies\Microsoft\Framework\v3.0\UIAutomationTypes.dll"

#Add-Type -AssemblyName System.Windows.Forms
#[System.Windows.Forms.Application]::VisualStyleState = [System.Windows.Forms.VisualStyles.VisualStyleState]::NoneEnabled

