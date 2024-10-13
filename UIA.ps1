# UI Automation ���ʃt�@���N�V����

# UI Automation ��g�ݍ���
Add-Type -AssemblyName UIAutomationClient
Add-Type -AssemblyName UIAutomationTypes
  
# Net Framework �\�[�X��g�ݍ���
#$source = (Get-Content .\UIAAutomation.vb) -join "`r`n"
#Add-Type -Language VisualBasic -TypeDefinition $source -ReferencedAssemblies ("UIAutomationClient", "UIAutomationTypes")
# �R�}���h���b�g��g�ݍ���
Import-Module .\MyUIAutomation20.dll
# �s����
[MyUIAutomation.UIAAutomation]::GetRoot() | Out-Null

# ������
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
    "�ҏW" {
      $p=$top.GetCurrentPattern([System.Windows.Automation.ValuePattern]::Pattern)
      $p.current.value
    }
    "�ꗗ" {
      $p=$top.GetCurrentPropertyValue([System.Windows.Automation.SelectionPatternIdentifiers]::SelectionProperty)
      $p.current.name
    }
    "�ꗗ����" {
      $p=$top.GetCurrentPropertyValue([System.Windows.Automation.SelectionItemPatternIdentifiers]::IsSelectedProperty)
      $p
    }
    "�c���[����" {
     $p=$top.GetCurrentPropertyValue([System.Windows.Automation.TogglePatternIdentifiers]::ToggleStateProperty)
      $p
    }
    "�I�v�V���� �{�^��"{
      $p=$top.GetCurrentPropertyValue([System.Windows.Automation.SelectionItemPatternIdentifiers]::IsSelectedProperty)
      $p
    }
    "�`�F�b�N �{�b�N�X"{
      $p=$top.GetCurrentPropertyValue([System.Windows.Automation.TogglePatternIdentifiers]::ToggleStateProperty)
      $p
    }
    "�X�s��"{
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
    "�_�C�A���O" {
      $pkey + "_" + $top.current.name
    }
    "�E�B���h�E" {
      $pkey + "_" + $top.current.name
    }
    "�^�u����" {
      $pkey + "_" + $top.current.name
    }
    "�{�^��" {
      $pkey + "_" + $top.current.name
    }
    "�ҏW" {
      $pkey + "_" + $top.current.name
    }
    "�ꗗ����" {
      $pkey + "_" + $top.current.name
    }
    "�c���[����" {
      $pkey + "_" + $top.current.name
    }
    "�I�v�V���� �{�^��"{
      $pkey + "_" + $top.current.name
    }
    "�`�F�b�N �{�b�N�X"{
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
  $key =�@UIA_GetKey $top $pkey
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
  if ($top.current.localizedcontroltype -match "�_�C�A���O") {
    $top
  }
  else {
    $p = [System.Windows.Automation.TreeWalker]::ControlViewWalker.GetParent($top)
    Write-Host $($p | UIA_OutPut | Out-String)
    if ($p -eq $re) {
      if ($top.current.localizedcontroltype -match "�E�B���h�E") {
        $top
      }
      else {
        $null
      }
    }
    else {
      if ($p.current.localizedcontroltype -match "�_�C�A���O") {
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
    �@  switch ($mode) {
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

# ���ʒ萔
# ���[�g�G�������g
$global:re = [System.Windows.Automation.AutomationElement]::RootElement
# �c���[�X�R�[�v
$global:subtree = [System.Windows.Automation.TreeScope]::Subtree
$global:children = [System.Windows.Automation.TreeScope]::Children
$global:parent = [System.Windows.Automation.TreeScope]::Parent

$global:condition_true = [System.Windows.Automation.Condition]::TrueCondition


#Add-Type -Path "C:\Program Files\Reference Assemblies\Microsoft\Framework\v3.0\UIAutomationClient.dll"
#Add-Type -Path "C:\Program Files\Reference Assemblies\Microsoft\Framework\v3.0\UIAutomationTypes.dll"

#Add-Type -AssemblyName System.Windows.Forms
#[System.Windows.Forms.Application]::VisualStyleState = [System.Windows.Forms.VisualStyles.VisualStyleState]::NoneEnabled

