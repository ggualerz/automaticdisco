#OK
#Get CSV PAth
$CSVPath = Read-Host "CSV input C:\Users\contoso\export.csv (default is $(Get-Location)\export.csv)"
#Get Delimiter
$Delim = Read-Host "Choose the delimiter char (default is ',')"



#Apply default values if empty
if([string]::IsNullOrEmpty($CSVPath)){$CSVPath = "$(Get-Location)\export.csv"}
if([string]::IsNullOrEmpty($Delim)){$Delim = ","}


#Import the CSV

$CSV = Import-Csv -Delimiter $Delim -Path $CSVPath

#Print Users
Read-Host "Type Enter to print users"
$CSV | Where-Object { $_.IsUser -eq "True" }

#Print Group
Read-Host "Type Enter to print groups"
$CSV | Where-Object { $_.IsUser -eq "False" }