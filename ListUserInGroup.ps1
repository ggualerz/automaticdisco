#OK
#Get Group name to list the users
$Name = Read-Host "Name of the Group"

#Exit if name null
if([string]::IsNullOrEmpty($Name))
{
    Write-Error "Name is null or empty"
    Exit 1
}
#Get users
Get-ADGroupMember -Identity $Name