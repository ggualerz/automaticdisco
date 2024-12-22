#OK
#Get Users name filter to retrieve informations
$NameFilter = Read-Host "Name filter of the users to retrieve, example *"

#Exit if name null
if([string]::IsNullOrEmpty($NameFilter))
{
    Write-Error "Name filter is null or empty"
    Exit 1
}

#Get Attribute
$Attribute = Read-Host "Attributes to retrieve for $NameFilter"

#Get Users according to the filter on the name with all properties
$Users = Get-ADUser -Filter "Name -like `"$($NameFilter)`"" -Properties *
# Get only the desired properties of the user
$Users | Select-Object  -Property $Attribute