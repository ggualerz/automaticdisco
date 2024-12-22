#OK

#Get Group Name
$Name = Read-Host "Name of the group"

if([string]::IsNullOrEmpty($Name))
{
    Write-Error "Name is null or empty"
    Exit 1
}

#Check if the group exist
    try {
        $Group = Get-ADGroup -Identity $Name
        Write-Host "Group $($Group.name) found"
    }
    catch {
        Write-Error "the group $Name doesnt exist"
        exit 1
    }

#Loop until the user is good

while ($true) {
    $UserName = Read-Host "Name of the user to remove to the group"
    try {
        #If the User exist, leave the loop
        $UserToRemove = Get-ADGroupMember -Identity $Name | Where-Object { $_.Name -eq $UserName }
        #Check if the user exist
        Get-ADUser -Identity $UserName
        break
    }
    catch {
        Write-Error "$UserName is not a valid account or is not in the group"
    }
}

#Add the user
Remove-ADGroupMember -Identity $Name -Members $UserToRemove -Confirm