#OK

#Get User Name
$Name = Read-Host "Name of the user firstname.lastname in lowercase only (default is john.doe)"
#Get OU Path
$OU = Read-Host "Organisation Unit Path to join (default is CN=Users,DC=domain,DC=tld)"
#Get Group targeted
$Group = Read-Host "Group to join (Default is none)"

#Apply default values if empty
if([string]::IsNullOrEmpty($Name)){$Name = "john.doe"}


#Password secure
$base64String = 'VG90YWx5TjB0U2VjdXJl' #Not clear text
#Base64 to ByteArray
$byteArray = [System.Convert]::FromBase64String($base64String)
#ByteArray to text
$plainText = [System.Text.Encoding]::UTF8.GetString($byteArray)
#Text to securestring
$secureString = ConvertTo-SecureString -String $plainText -AsPlainText -Force



#Check the pattern of the name
$pattern = "^[a-z]+\.[a-z]+$"
if (!($Name -match $pattern))
{
    Write-Error "Name: $Name is not valid, should be firstname.lastname"
    Exit 1
}


#Get the domain name
$Domain = (Get-ADDomain).Forest
#Create the Mail
$Mail = "$($Name)@$($Domain)"


#Create the user
New-ADUser -Name $Name -ChangePasswordAtLogon $true -AccountPassword $secureString -UserPrincipalName $Mail -Enabled $true

#If an OU is set, move the user to this OU after creatin
if (!([string]::IsNullOrEmpty($OU)))
{
    try {
        #Confirm the $OU Exist
        Get-ADOrganizationalUnit $OU
        #Move it
        Get-ADUser -Identity $Name | Move-ADObject -TargetPath $OU
    }
    catch {
        #Failute info
        Write-Error "Cannot move the user $Name to the OU $OU, it gonna stay in the default OU"
    }
}
#Add more properties to the uer
#Name processing and mail
#Split the name in two
$NameParts = $Name -split '\.'
#Set the user with new properties
Set-ADUser -Identity $Name -GivenName $NameParts[0] -Surname $NameParts[1] -EmailAddress $Mail
if(!([string]::IsNullOrEmpty($Group)))
{
    Add-ADGroupMember -Members $Name -Identity $Group
}


