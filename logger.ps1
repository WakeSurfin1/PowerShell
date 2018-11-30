##-----------------------------------------------------------------
##
## Script Name: logger.ps1
##
## Description: contains functions for process execution logging
##
## Author:  WakeSurfin1
##
## Date: 2018-11-26
##
## Module importation example:
## 
## . "C:\scripts\logger.ps1"
##
##-----------------------------------------------------------------

##-----------------------------------------------------------------
## writeLog()
##
## write a string text message to a log file
##
## Param1: the message <string>
##
## Param2: the path\filename <string>
##
## usage: writeLog "Testing" "C:\jcoleman\scripts\logFile.txt"
##
##-----------------------------------------------------------------

function writeLog

{param ($message, $logFile)

$strNow = Get-Date -format G

$strNow + " - " + $message >> $logFile

}


##-----------------------------------------------------------------
## writeEventLog()
##
## write a message to the Windows Event Log
##
## Param1: event id <integer range 1 to 65535>
##
## Param2: source <string>
##
## Param3: description <string>
##
## usage: writeEventLog 12345 Hello.ps1 "this is a test"
##
##-----------------------------------------------------------------

function writeEventLog

{Param($Param1,$Param2,$Param3)

$evt=new-object System.Diagnostics.EventLog("Application")
$evt.Source=$param2
$infoevent=[System.Diagnostics.EventLogEntryType]::Information
$evt.WriteEntry($param3,$infoevent,$param1)

}