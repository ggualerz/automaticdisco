#OK
#Get User name to edit attrubute
$Name = Read-Host "Name of the user"

#Exit if name null
if([string]::IsNullOrEmpty($Name))
{
    Write-Error "Name is null or empty"
    Exit 1
}

#Get Attribute
$Attribute = Read-Host "Name of attribute to change on $Name "
#Get new value of it
$Value = Read-Host "New value of attribute of $Attribute"

#Set it
Set-ADUser -Identity $Name -Replace @{$Attribute=$Value}