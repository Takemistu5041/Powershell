#
#   VR-U300W用VPN接続作成
#
#   Copyright 2023 By T.Tanaka
#


#   管理者権限チェック
#if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators")) {
#    #Start-Process powershell.exe "-WindowStyle Hidden -executionpolicy remotesigned -File `"$PSCommandPath`"" -Verb RunAs
#    Start-Process powershell.exe " -executionpolicy remotesigned -File `"$PSCommandPath`"" -Verb RunAs;
#
#    exit
#}


#
#   選択肢の作成
#
$typename = "System.Management.Automation.Host.ChoiceDescription"
$yes = new-object $typename("&Yes","はい")
$no  = new-object $typename("&No","いいえ")

$NAGANO = new-object $typename("&1:長野","長野営業所")
$SHIZUOKA = new-object $typename("&2:静岡","静岡営業所")
$HAMAMATSU = new-object $typename("&3:浜松","浜松営業所")
$MIE = new-object $typename("&4:三重","三重営業所")
$OSAKA = new-object $typename("&5:大阪","大阪営業所")
$HIROSHIMA = new-object $typename("&6:広島","広島営業所")
$FUKUOKA = new-object $typename("&7:福岡","福岡営業所")
$SAPPORO = new-object $typename("&8:札幌","札幌営業所")
$SAITAMA = new-object $typename("&9:埼玉","首都圏第二営業所")
$KANAGAWA = new-object $typename("&A:神奈川","神奈川営業所")
$KOBE = New-Object $typename("&B:神戸","神戸営業所")
$QUIT = new-object $typename("&Q:終了","終了")


#
#   選択肢コレクションの作成
#
$assembly= $yes.getType().AssemblyQualifiedName
$Choice = new-object "System.Collections.ObjectModel.Collection``1[[$assembly]]"
$Choice.add($yes)
$Choice.add($no)

$Choice2 = new-object "System.Collections.ObjectModel.Collection``1[[$assembly]]"
$Choice2.add($NAGANO)
$Choice2.add($SHIZUOKA)
$Choice2.add($HAMAMATSU)
$Choice2.add($MIE)
$Choice2.add($OSAKA)
$Choice2.add($HIROSHIMA)
$Choice2.add($FUKUOKA)
$Choice2.add($SAPPORO)
$Choice2.add($SAITAMA)
$Choice2.add($KANAGAWA)
$Choice2.add($KOBE)
$Choice2.add($QUIT)


$VpnName = '長野(VR-U300W)','静岡(VR-U300W)','浜松(VR-U300W)','三重(VR-U300W)','大阪(VR-U300W)','広島(VR-U300W)','福岡(VR-U300W)','札幌(VR-U300W)','埼玉(VR-U300W)','神奈川(VR-U300W)','神戸(VR-U300W)'
$VpnUrl = '172.20.32.252','172.20.48.252','172.20.64.252','172.20.80.252','172.20.96.252','172.20.112.252','172.20.128.252','172.20.144.252','172.20.160.252','172.20.176.252','172.20.192.252'
#$VpnUrl = '172.20.64.252','172.20.64.252','172.20.64.252','172.20.64.252','172.20.64.252','172.20.64.252','172.20.64.252','172.20.64.252','172.20.64.252','172.20.64.252'
$VpnPSK = 'b^}%9g#zpE*)xWDa@_Vv','/EwPErIo2$V{gsX>m5zy','{yD2WuT(hA9B5Bv}Rp}M',']8tLvf,AP^KE:o]YN0&.','6RHhK#Grmj_T(0Hqv$gv','Pz}s$XHb&MgS@VF0k)2#','O?7fGQ@P#v,NFeNzqcF5','UYRRK>Y-ZA0kv*KU0h_N','2usBy[1&o8%<dOPm0+Lx','76Q9{?:B#B*lE)OF,S,1','g+*,kZ@Ro~?iAKSwyn2c'
$VpnUser = 'Ezl0kYvXOp5BPkr0','7AFosFf2kiTPqbLr','vGDNOymNLlAJFV15','7wMRZkVMyVtivnEB','z8V7TTBJlRetDYcH','ee6fsZoBqpOCQJyy','OZAdjlakh1MT2LWt','CPnZcYbyzBuN9dcs','MloKPRu1t1vmiF3p','m0La8ezQLjgdPfkh','BkJcNTTgF5fIrTqs'
$VpnPass = 'R%,kIee>LangYcbgsnUj','7fHiP%;LSx8Xysg)L%gr','f9lRNcqFUj2SjTq9snQ]','uI4!Jpo/%7uE7%VutBP+','Ki*0iYwrEmbmsfcZPS-j','Lj*%OQF85bbOA0EZptga','1_hAJ4+?.kGPi41W;zf3','zuNZsuGVL>f/u:9nbU.L','>/atnEKR:4Nc#IPt%,xO','RtxLKMbt150BOY;>eU@B','fJ:GFgvhrqBd/Yb:|11%'
$RasExec = "C:\windows\system32\rasdial.exe"


write-output "--"
write-output "【VR-U300W用VPN作成】"


do{
    $Location = $host.ui.PromptForChoice("<営業所選択>","営業所を選んで下さい",$Choice2,11)

    if ($Location -eq 11) {
        break;
    }

    $Kyoten = $VpnName[$Location]

    write-output "$Kyoten を作成します。"


    write-output "`t$Kyoten を削除します。"

    #Remove Vpn Adaptor
    Remove-VpnConnection -Name $VpnName[$Location] -Force -PassThru

    write-output "`t$Kyoten を作成します。"
    #Create VPN Adaptor
    Add-VpnConnection -Name $VpnName[$Location] `
                    -ServerAddress $VpnUrl[$Location] `
                    -RememberCredential -L2tpPsk $VpnPSK[$Location] `
                    -AuthenticationMethod MSChapv2 `
                    -EncryptionLevel Required `
                    -TunnelType L2tp `
                    -SplitTunneling $false `
                    -Force




    #   一度繋いでID/PASSを保存させる
    write-output "`t$Kyoten にVPN接続します。"
    $ConnectUser = $VpnUser[$Location]
    $ConnectPass = $VpnPass[$Location]
    
    cmd.exe /c $RasExec $VpnName[$Location] $ConnectUser $ConnectPass


    #   切断
    write-output "`tVPNを切断します。"
    cmd.exe /c $RasExec /Disconnect


}while ($Location -ne 10)

write-output "--"
write-output "終了します。"















                  

