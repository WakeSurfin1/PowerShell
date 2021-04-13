## jcoleman 2021-03-16
## Use Powershell and Windows Oracle client SqlPlus utility to execute sql scripts on Oracle rds database
## Oracle client 10.2.0.1.0 (32 bit) 
## See tnsname.ora file for tns alias information
## usage: C:\>powershell .\scripts\execOracleSqlPlusScript.ps1 >> C:\temp\powershellLogfile.txt

$uid = "<putUserNameHere>"
$pwd = "<putPasswordHere>"
$tnsalias = "<putHostNameHere>"
$sqlPlusScript = "c:\script\sqlPlusScriptForPS.sql"
$outputfile = "c:\temp\sqlPlusOutPut.txt"

Echo 'Start' 
Get-Date -UFormat %Y-%m-%d-%R 

## call sqlplus utility
## login
## pass in sql script to be run on Oracle db
## pipe output to a file
sqlplus -silent $uid/$pwd@$tnsalias " $sqlPlusScript " | Out-File $outputfile

Get-Date -UFormat %Y-%m-%d-%R 
Echo 'End' 

exit