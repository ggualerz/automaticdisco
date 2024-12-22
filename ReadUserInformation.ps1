#OK
#Get User name to retrieve informations
$Name = Read-Host "Name of the user"

#Exit if name null
if([string]::IsNullOrEmpty($Name))
{
    Write-Error "Name is null or empty"
    Exit 1
}

#Get Attribute Filter
$Attribute = Read-Host "Attribute to retrieve for $Name"

#Get User with all properties
$User = Get-ADUser -Identity $Name -Properties *
# Get only the properties of the user
$User | Select-Object  -Property $Attribute