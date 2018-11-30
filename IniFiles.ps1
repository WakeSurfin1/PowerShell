##-----------------------------------------------------------------
##
## Script Name: IniFiles.ps1
##
## Description: contains functions for process reading ini files
##
## Owner:  WakeSurfin1  2018-11-27
##
## Module importation:
## 
## . "C:\scripts\IniFiles.ps1"
##
##-----------------------------------------------------------------

##-----------------------------------------------------------------
## ReadIni()
##
## Read ini file contents
##
## returns a value read from an INI file
##
## parameters:  File Path and name
##
## Returns:
## the [string] value for the specified key in the specified section
##
## Written by Ed Wilson
## http://blogs.technet.com/b/heyscriptingguy/archive/2011/08/20/use-powershell-to-work-with-any-ini-file.aspx
## 
## Usage example:
##
## Step 1: reference the Ini file
## $iniContent = ReadIni “D:\Scripts\ADP_ORADump_land.ini”
##
## Step 2: reference the section and key 
## $value = $iniContent[“LOG DIR”][“logdir”]
##
## Step 3: Reference the value
## $value
## 
##-----------------------------------------------------------------

function ReadIni ($FilePath)
{
    $ini = @{}
    switch -regex -file $FilePath
    {
        "^\[(.+)\]" # Section
        {
            $section = $matches[1]
            $ini[$section] = @{}
            $CommentCount = 0
        }
        "^(;.*)$" # Comment
        {
            $value = $matches[1]
            $CommentCount = $CommentCount + 1
            $name = "Comment" + $CommentCount
            $ini[$section][$name] = $value
        } 
        "(.+?)\s*=(.*)" # Key
        {
            $name,$value = $matches[1..2]
            $ini[$section][$name] = $value
        }
    }
    return $ini
}






