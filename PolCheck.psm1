#
#   PolCheck.ps1
#
#   パスワードポリシーチェック
#

function PolCheck(){


    $Pass = Read-Host 'パスワードを入力'

    $PassWordPolicyChcek = $false

    #$BSTR=[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecPass)
    #$Pass=[System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

    write-output "--"
    Write-Output "パスワードポリシーを確認します。"

    #   文字数(16文字以上)
    if ($Pass.Length -gt 15){
        Write-Output ("`t文字数：" + $pass.Length + "・・・OK")
        $PassWordPolicyChcek += 0x1
    }else {
        Write-Output ("`t文字数：" + $pass.Length + "・・・【NG】")
    }

    #   英大文字
    if($pass -cmatch "\p{Lu}+"){
        Write-Output ("`t英大文字：" + $Matches.Values + "・・・OK")
        $PassWordPolicyChcek += 0x2
    }else{
        Write-Output ("`t英大文字：なし・・・【NG】") 
    }
    #   英小文字
    if($pass -cmatch "\p{Ll}+"){
        Write-Output ("`t英小文字：" + $Matches.Values + "・・・OK")
        $PassWordPolicyChcek += 0x4
    }else{
        Write-Output ("`t英小文字：なし・・・【NG】") 
    }

    #   数字
    if($pass -cmatch "\p{Nd}+"){
        Write-Output ("`t数字：" + $Matches.Values + "・・・OK")
        $PassWordPolicyChcek += 0x8
    }else{
        Write-Output ("`t数字：なし・・・【NG】") 
    }

    #   記号
    if($pass -cmatch "\W+"){
        Write-Output ("`t記号：" + $Matches.Values + "・・・OK")
        $PassWordPolicyChcek += 0x10
    }else{
        Write-Output ("`t記号：なし・・・【NG】") 
    }

    #   全角文字
    if($Pass -cmatch "[^\x01-\x7E]"){
        Write-Output ("`t全角文字：" + $Matches.Values + "・・・【NG】") 
    }else{
        Write-Output ("`t全角文字：なし・・・OK")
        $PassWordPolicyChcek += 0x20
    }

    if ($PassWordPolicyChcek -ne 63) {
        Write-Output "パスワードがポリシーを満たしていません。"

        Exit
    }

}



