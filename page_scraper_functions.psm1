function Get-Html {

param (
      [string]$Link
    , [string]$SaveFile
    , [string]$UserAgent="Mozilla/5.0 (compatible)")

# force TLS 1.2 (default is TLS 1.0!)
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Invoke-WebRequest ($Link) -OutFile ($SaveFile) -UseBasicParsing `
                    -DisableKeepAlive -MaximumRedirection 1 -TimeoutSec 10 -UserAgent $UserAgent

}


function Get-Paths {
param(
[string]$FileConventionString
,[string]$FileConventionExt
,[string]$UriPath
,[string]$iConventionString
,[string]$iConventionStringModPath
,[bool]$PathBypass
,[string]$PathBypassDirectory
,[int]$j
)

[string]$FileName=$FileConventionString + $j.ToString($FileConventionNumber) + $FileConventionExt

if ($PathBypass -eq $false)
{
$Link=$UriPath + $iConventionString + "/" + $FileName
$SaveFile=$SavePath + $iConventionStringModPath + "\" + $FileName
} else
{
$Link=$UriPath + $FileName
$SaveFile=$SavePath + $PathBypassDirectory + "\" + $FileName
}

return $Link,$SaveFile
}


function Remove-EmptyDirectory {
# remove directory if it's empty
param([string]$SavePath, [string]$iConventionStringModPath, [string]$link)

try
    {
    if( -Not [system.io.directory]::GetFiles($SavePath + $iConventionStringModPath).Count){
    remove-item -Path ($SavePath + $iConventionStringModPath)
    }
    }
catch
    {
    $_.Exception.Message + " for " + $link
    }
}
