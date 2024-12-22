#OK

#Get Group Name
$Name = Read-Host "Name of the group"
#Get OU Path
$OU = Read-Host "Organisation Unit Path to join (default is CN=Users,DC=domain,DC=tld)"
#Get Group Scope
$Scope = Read-Host "Group scope (DomainLocal, Global, Universal), default is DomainLocal"
#Get Group Description
$Desc = Read-Host "Group description"

#Apply default values if empty
if([string]::IsNullOrEmpty($Scope)){$Scope = "DomainLocal"}
if([string]::IsNullOrEmpty($Desc)){$Desc = "Default description by CreateGroup.ps1"}

New-ADGroup -Name $Name -GroupScope $Scope -Description $Desc -GroupCategory Security


#If an OU is set, move the group to this OU after creating
if (!([string]::IsNullOrEmpty($OU)))
{
    try {
        #Confirm the $OU Exist
        Get-ADOrganizationalUnit $OU
        #Move it
        Get-ADGroup -Identity $Name | Move-ADObject -TargetPath $OU
    }
    catch {
        #Failute info
        Write-Error "Cannot move the group $Name to the OU $OU, it gonna stay in the default OU"
    }
}


