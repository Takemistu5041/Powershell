function base64(){
    Param([switch]$encode=$true, [switch]$decode=$false, [Parameter(Mandatory=$true,ValueFromPipeline=$true)][string]$input)
    Begin{}
    Process{
        if($decode){
            $byte = [System.Convert]::FromBase64String($input)
            $txt = [System.Text.Encoding]::Default.GetString($byte)
            echo $txt
        }
        elseif($encode){
            $byte = ([System.Text.Encoding]::Default).GetBytes($input)
            $b64enc = [Convert]::ToBase64String($byte)
            echo $b64enc
        }
    }
    End{}
}

#--
# encodeオプションは省略可
#echo "text here" | base64 -encode
# -> "dGV4dCBoZXJl"
#echo "dGV4dCBoZXJl" | base64 -decode
# -> "text here"

# 複数の入力も可
#echo "text here", "sample text" | base64 -encode
# -> "dGV4dCBoZXJl"
# -> "c2FtcGxlIHRleHQ="
#echo "dGV4dCBoZXJl", "c2FtcGxlIHRleHQ=" | base64 -decode
# -> "text here"
# -> "sample text"

