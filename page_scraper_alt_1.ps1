# retrieves files of format "$($url)$($i)$($directory)$($fileExt)"
# stores as "$($SavePath)$($directory)\$($i)$($fileExt)"
# where $i is a counter with no leading zeros and $directory is an integer

param (
[Parameter(Mandatory=$true)]
[string]$SavePath
,[Parameter(Mandatory=$true)]
[string]$url
,[Parameter(Mandatory=$true)]
[int]$directoryStart,
,[Parameter(Mandatory=$true)]
[int]$directoryEnd
,[Parameter(Mandatory=$true)]
[int]$fileStart
,[Parameter(Mandatory=$true)]
[int]$fileEnd
,[Parameter(Mandatory=$true)]
[int]$fileEnd
,[Parameter(Mandatory=$true)]
[string]$fileExt
)

Import-Module -Name "[path]page scraper - functions.psm1"

for ($directory=$directoryStart; $directory -le $directoryEnd; $directory++)
{
    try {New-Item ($SavePath + $directory) -type Directory >$null}
    catch {$_.Exception.Message}

    $SleepCounter=0

    for ($i=$fileStart; $i -le $fileEnd; $i++){
        
        $link = "$($url)$($i)$($directory)$($fileExt)"
        $FullPath = "$($SavePath)$($directory)\$($i)$($fileExt)"

        try 
        {
        Get-Html $link $FullPath; 
        }
        catch
        {
        $_.Exception.Message + " for " + $link + "saving to " + $FullPath
        }

        sleepBetween ([ref]$SleepCounter) 5 20
    }

    if ($directory -lt $directoryEnd) {sleepBetween ([ref]$SleepCounter) 5 60 $true}
}
