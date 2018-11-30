##====================================================================================================
##
## Name: API_Get_ColoradoGov.ps1
##
## Author: WakeSurfin1
##
## Purpose: Pull job data from GitHubJobs
##
## create date: 2018-11-26
##
## Base end point: http://data.colorado.gov/resource/4ykn-tg5h.json
## Data description: below is a list of data feilds.
## not all fields are a populated and 
## the fields are not consistently ordered
##       
## Data Fields:
## 
## entityid, 
## entityname, 
## principaladdress1, 
## principaladdress2, 
## principalcity, 
## principalstate, 
## principalzipcode, 
## principalcountry, 
## mailingaddress1, 
## mailingaddress2, 
## mailingcity, 
## mailingstate, 
## mailingzipcode, 
## mailingcountry, 
## entitystatus, 
## jurisdictonofformation, 
## entitytypeverbatim, 
## entitytype, 
## agentfirstname, 
## agentmiddlename, 
## agentlastname, 
## agentsuffix, 
## agentorganizationname, 
## agentprincipaladdress1, 
## agentprincipaladdress2, 
## agentprincipalcity, 
## agentprincipalstate, 
## agentprincipalzipcode, 
## agentprincipalcountry, 
## agentmailingaddress1, 
## agentmailingaddress2, 
## agentmailingcity, 
## agentmailingstate, 
## agentmailingzipcode, 
## agentmailingcountry, 
## entityformdate, 
## location 
##
## 
## Required files must be in same directory as script: 
##
##          API_Get_ColoradoGov.ps1
##       	API_Get_ColoradoGov.ini
##          IniFiles.ps1
##          logger.ps1
##
##  Usage example 1: C:\Scripts>powershell .\API_Get_ColoradoGov.ps1
## 
##  Usage example 2: PS C:\Scripts> .\API_Get_ColoradoGov.ps1            
##		
##=====================================================================================================

## Step 0: Dynamically create logfile var and Import PowerShell code modules ==========================

## create log file: current path + "\logs\" + ScriptBaseName + "_logs.txt"
$ParentDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$LogFile = $ParentDir + "\Logs\" + $MyInvocation.MyCommand.Name.split(".")[0] + "_log.txt"

## import logger.ps1 module: Note this file must be in the current directory
try {. $ParentDir\logger.ps1 -ErrorAction Stop}

catch { 
	    $ErrorMessage = $_.Exception.Message; $FailedItem = $_.Exception.ItemName
	    "ERROR importing logger module " + $ErrorMessage + " " + $FailedItem | out-file $LogFile -append
	    exit
	    }

# Begin logging to logfile
$strLogLine = "Begin " + $MyInvocation.MyCommand.Name; writelog $strLogLine $LogFile
$strLogLine = "	Machine and user:  " + [Environment]::MachineName + '  ' + [Environment]::UserDomainName + '\' + [Environment]::UserName
writeLog $strLogLine $LogFile

## import IniFiles.ps1 module: Note this file must be in the current directory
try {. $ParentDir\IniFiles.ps1 -ErrorAction Stop}

catch { 
	    $ErrorMessage = $_.Exception.Message; $FailedItem = $_.Exception.ItemName
	    $strLogLine = "ERROR importing ini module " + $ErrorMessage + " " + $FailedItem ; writelog $strLogLine $LogFile 
	    exit
	    }

## Step 1: ==========  Assign ini file values and input parms to global variables =======================
$IniFile = $ParentDir + "\" + $MyInvocation.MyCommand.Name.split(".")[0] + ".ini"
$strLogLine = "Step 1: Get ini file input values from " + $IniFile; writelog  $strLogLine $LogFile

## call ini module and read ini file 
try{ $iniContent = ReadIni $IniFile -ErrorAction Stop }

catch {  $strLogLine = "Error reading ini file: " + $IniFile; writelog $strLogLine $LogFile
         exit
         }
    
$strEndPoint = $iniContent["API”][“strEndPoint"]
$strOutFile = $iniContent["LocalHost”][“strOutFile"] 

## Step 2: =======================  Connect to API End Point  ==================================
$strLogLine = "Step 2: Connect to API End Point " + $strEndPoint; writeLog $strLogLine $LogFile

## Call REST API end point url and get response 
## Note this method works with http but not with https
try {$response = Invoke-RestMethod -Uri $strEndPoint -Method Get}

catch{
    writeLog "ERROR: API call failed " $LogFile
    writeLog "StatusCode:" $_.Exception.Response.StatusCode.value__ $LogFile
    writeLog "StatusDescription:" $_.Exception.Response.StatusDescription $LogFile
}

## Step 3: ============== validate and format API output ======================================
$strLogLine = "Step 3: Validate and format API output "; writeLog $strLogLine $LogFile

## count the number of records in the response
if ($response.count -lt 1) 
    {$strLogLine = "Error: API Get did NOT return data. count = " + $response.count; writeLog $strLogLine $LogFile
     exit
     }
Else { $strLogLine = "API Get record return count = " + $response.count; writeLog $strLogLine $LogFile}      

## Out put API response in sorted, key: value columns format to local output file
if (Test-Path $strOutFile) {Remove-Item $strOutFile}
$response.GetEnumerator() | Sort-Object Value -descending >> $strOutFile

## below example calls API and download contents in JSON format to local output file
## Invoke-RestMethod -Uri $strEndPoint -OutFile $strOutFile

##================== Exit API_Get_ColoradoGov.ps1 process ======================================
$strLogLine = "Exit " + $MyInvocation.MyCommand.Name; writelog $strLogLine $LogFile

exit