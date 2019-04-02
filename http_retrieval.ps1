# manual single page web request
# creates directory path specified in $SaveFile if it doesn't exist

param(
[string]$Link = "https://www.google.com",
[string]$SaveFile = "F:\test.txt", # full path
[string]$UserAgent="Mozilla/5.0 (compatible)"
)

[string]$SavePath = Split-Path $SaveFile

if (-Not (Test-Path ($SavePath)))
{
New-Item ($SavePath) -type Directory
}

# force TLS 1.2 for Invoke-WebRequest (default is TLS 1.0!)
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Invoke-WebRequest ($Link) -OutFile ($SaveFile) -UseBasicParsing `
                    -DisableKeepAlive -MaximumRedirection 1 -TimeoutSec 4 -UserAgent $UserAgent
