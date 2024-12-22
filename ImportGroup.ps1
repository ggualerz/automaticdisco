#OK

#Get Group Names
$FromName = Read-Host "Name of the source group"
$DestName = Read-Host "Name of the destination group"

try {
    #Check if the groups exist
    $FromGroup = Get-ADGroup -Identity $FromName
    $DestGroup = Get-ADGroup -Identity $DestName    
}
catch {
    Write-Error "Unknown group $FromName or $DestName"
    Exit 1
}

#Get list of users in the source group
$Users = Get-ADGroupMember -Identity $FromName

#Add the users to the destination group
Add-ADGroupMember -Identity $DestName -Members $Users