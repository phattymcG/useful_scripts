<# file scraper
downloads sequentially numbered files in specified directories over HTTP
#> 

# input assumptions:
# - all values in $designated array are between
#   $LowerBound and $UpperBound, inclusive

param (
    [string]$SavePath = "F:\temp\" # format: C:\[path\]
    ,[string]$UriPath="https://www.google.com/" # format: https://domain.tld/[path/]
    ,[string[]]$FileConventionStrings=@("log","log_") # options for leading text of filenames; MUST be one, CAN be a second
    ,[string]$FileConventionExt=".txt"    # file extension
    ,[string]$FileConventionNumber="00"   # number of digits in numerical part the file name
    ,[string]$PathConventionNumber="00000" # number of digits in directory number (if present; ignored if $PathBypass=$true)
    ,[string]$iConventionString=""        # string representation of directory number (if present; 
                                          #  ignored if $PathBypass=$true)
    ,[int]$StartFile=0                    # number in sequence of files; note that this can be represented by "00" 
                                          #  or more digits depending on $FileConventionNumber
    ,[int]$LowerBound=1                   # beginning numbered directory, or beginning of range for $designated
    ,[int]$UpperBound=100                 # ending numbered directory, or end of range for $designated
    ,[int[]]$designatedInteger=@()        # manual input of directory numbers, e.g. @(1250,1283,1317); mutually 
                                          #  exclusive with $loaddesignated=$true
    ,[bool]$loaddesignated=$false         # set to $true to load from file
    ,[bool]$PathBypass=$false             # set to $true if there is no iterating directory number in link path
    ,[string]$PathBypassDirectory=""      # fill in characters for directory path; this is appended to $UriPath
)

# Internal variables

[int]$i=0
[int]$j=0
[int]$filesretrieved=0
[int]$designatedLength=0
[string]$FileConventionString, # set by determining which convention is used on highest res files
[int]$FileConventionStringsLength
[int]$FileConventionStringsCounter=0 # tracks which convention is currently in use
[bool]$morefiles=$true # tracks progression of retrieved files
[string]$SaveFile
[string[]]$SaveFiles=@("","") # array to hold two diff potential $SaveFile values
[string[]]$designated=@()    #NOTE: can't use a cmdlet in params definition, so need to load below using external file
[int]$SleepCounter=0
[int]$SleepCounter2=0
[int]$ArrayCounter=0
[string]$iConventionStringRegEx
[string]$iConventionStringModPath
[System.IO.FileSystemInfo]$iConventionStringDir

Set-StrictMode -Version Latest

Import-Module -NoClobber -Name "F:\page_scraper_functions.psm1"

# control iteration of 'while' loop based on number of alternate file convention strings
$FileConventionStringsLength = $FileConventionStrings.Length

<# 
Process text-based input file

Input file must be a \n separated list of integers with correct 
    digits (i.e., include leading zeros)
#>
if ($loaddesignated)
{
$designated=(Get-Content C:\Users\user\Desktop\input.txt)
$designatedInteger= foreach($line in $designated) { [convert]::ToInt32($line,10) }
}
$designatedLength=$designatedInteger.Length

# main loop to iterate specified directory paths
For ($i=$LowerBound; $i -le $UpperBound; $i++)
{

<# Use designated (potentially non-sequential) array values for $i, if they exist
Otherwise, skip and iterate $i sequentially #>
if ($designatedLength -gt 0)
    {
    if ($ArrayCounter -le ($designatedLength - 1))
    {
    $i=$designatedInteger[$ArrayCounter]
    $ArrayCounter++
    }
    else
    {
    exit
    <# note: this exit occurs after iterating through an array 
    of designated directory numbers #>
    }
    }

<# reset vars for inner 'while' loop (file iteration within one directory) 
before starting on a new directory #>
$morefiles=$true
$SaveFiles=@("","")
$FileConventionStringChecked = $false
$FileConventionString = $FileConventionStrings[0]
$FileConventionStringsCounter=1
$j=$StartFile
$filesretrieved=0

<# convert outer loop counter to correct string format, whether there's
a read-in array of designated directories (which are strings initially)
or an incremental directory number is being used #>
if ($PathBypass -eq $false)
    {
    if ($designatedLength -gt 0){
    # if integers are manually supplied to the parameter, $designated will be empty
    if($designated.Length -gt 0)
    {
    $iConventionString = $designated[$ArrayCounter-1] # for designated numberical directories
    } else
    {
    $iConventionString = [convert]::ToString($designatedInteger[$ArrayCounter-1])
    }
    } else
    {
    $iConventionString = $i.ToString($PathConventionNumber) # for incremental
    }
    }

<# allows for subsequent manual changes to $SavePath, such as notes describing the files
if a modified path exists, set $iConventionString equal to it (instead of just the number) #>
$iConventionStringModPath = $null
$iConventionStringRegEx = "^" + $iConventionString + ".*"
$iConventionStringDir = Get-ChildItem -Path $SavePath | Where-Object { $_.Name -match $iConventionStringRegEx}
if ($iConventionStringDir) {$iConventionStringModPath = $iConventionStringDir.Name}


#create directory on local machine if it doesn't exist
if (-Not $iConventionStringModPath){
    if (-Not (Test-Path ($SavePath + $iConventionString)))
    {
    New-Item ($SavePath + $iConventionString) -type Directory
    }
    $iConventionStringModPath = $iConventionString
}

if ($PathBypass -eq $true)
{
if (-Not (Test-Path ($SavePath + $PathBypassDirectory)))
{
New-Item ($SavePath + $PathBypassDirectory) -type Directory
}
}


#inner loop: retrieve the files from the directory
#TODO: make number of iterations specifiable

while ($morefiles -eq $true)
{
# build link and local save paths

$Link,$SaveFile = Get-Paths $FileConventionString `
                            $FileConventionExt `
                            $UriPath `
                            $iConventionString `
                            $iConventionStringModPath `
                            $PathBypass `
                            $PathBypassDirectory `
                            $j

#don't retrieve file if it's already been retrieved
if (-Not (Test-Path ($SaveFile)))
{
try
    {
        Get-Html $Link $SaveFile
        
        $filesretrieved++

        $j++

        # slight random sleep delay between images to foil scraper detection
        If (($SleepCounter2 % 5) -lt 5)
        {Start-Sleep -s (Get-Random -minimum 5 -maximum 10)} 
        else
        {Start-Sleep -s (Get-Random -minimum 10 -maximum 20)}
        $SleepCounter2++
        }

catch
    {
    $_.Exception.Message + " for " + $link

    # repeat loop with same start file number if there are additional file conventions
    # if previous files have been found ($j -ne $startfile), this exception occurs because the last
    #   file was found, so terminate the loop
    if ($j -eq $StartFile)
    {
    if ($FileConventionStringsCounter -lt $FileConventionStringsLength)
    {
    $FileConventionStringsCounter++
    $FileConventionString = $FileConventionStrings[$FileConventionStringsCounter - 1]
    }
    else
    {
    "No files of any naming convention found."
    $morefiles=$false
    Remove-EmptyDirectory $SavePath $iConventionStringModPath $link
    }
    }
    else
    {$morefiles=$false}
    }        
}
else
{$j++}
} # end of inner 'while' loop

"Files retrieved: " + $filesretrieved 

# sleep cycle between resource retrievals, with longer wait every 5th directory
# to combat scraper detection
if ($i -lt $UpperBound)  # don't sleep after final round
{
If (($SleepCounter % 5) -lt 5)
{
$SleepTime=Get-Random -minimum 5 -maximum 25
"Sleeping for " + $SleepTime + " seconds"
Start-Sleep -s ($SleepTime)
} else
{
$SleepTime=Get-Random -minimum 25 -maximum 60
"Sleeping for " + $SleepTime + " seconds"
Start-Sleep -s ($SleepTime)
}
$SleepCounter++
}
}
