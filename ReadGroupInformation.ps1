#OK
#Get Group name to retrieve informations
$Name = Read-Host "Name of the group"

#Exit if name null
if([string]::IsNullOrEmpty($Name))
{
    Write-Error "Name is null or empty"
    Exit 1
}

#Get Attribute to print
$Attribute = Read-Host "Attribute to retrieve, default is all"
#If attributefilter is empty set to everything
if([string]::IsNullOrEmpty($Attribute)){$Attribute = "*"}
#Get User with all properties
$Group = Get-ADGroup -Identity $Name -Properties *
# Get only the properties of the user
$Group | Select-Object  -Property $Attribute