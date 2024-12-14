#Get CSV PAth
$CSVPath = Read-Host "CSV Output path and name C:\Users\contoso\export.csv (default is $(Get-Location)\export.csv)"
#Get Delimiter
$Delim = Read-Host "Choose the delimiter char (default is ',')"
#Get Properties to fetch
$Properties = Read-Host "Which properties to fetch, separate them with ',' (default is Name)"



#Apply default values if empty
if([string]::IsNullOrEmpty($CSVPath)){$CSVPath = "$(Get-Location)\export.csv"}
if([string]::IsNullOrEmpty($Delim)){$Delim = ","}
if([string]::IsNullOrEmpty($Properties)){$Properties = "Name"}


#Transform properties string into array of string
$PropertiesArr = $Properties -split ",\s*"

#Get all Users with the correct arguments
$Users = Get-ADUser -Filter * -Properties $PropertiesArr
#Add a boolean to know if its an user or group
$Users | Add-Member -MemberType NoteProperty -Name 'IsUser' -Value $true -Force

#Get all Groups with the correct arguments
$Groups = Get-ADGroup -Filter * -Properties $PropertiesArr
#Add a boolean to know if its an user or group
$Groups | Add-Member -MemberType NoteProperty -Name 'IsUser' -Value $false -Force
#Export All AD Users with arguments
$Users + $Groups | Export-Csv -Path $CSVPath -Delimiter $Delim