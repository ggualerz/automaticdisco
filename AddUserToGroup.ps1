#OK

#Get Group Name
$Name = Read-Host "Name of the group"

if([string]::IsNullOrEmpty($Name))
{
    Write-Error "Name is null or empty"
    Exit 1
}

#Loop until the user is good

while ($true) {
    $UserName = Read-Host "Name of the user to add to the group"
    try {
        #If the User exist, leave the loop
        $UserToAdd = Get-ADUser -Identity $UserName
        break
    }
    catch {
        Write-Error "$UserName is not a valid account"
    }
}

#Add the user
Add-ADGroupMember -Identity $Name -Members $UserToAdd