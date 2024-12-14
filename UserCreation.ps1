

#Get CSV PAth
$Name = Read-Host "Name of the user firstname.lastname in lowercase only (default is john.doe)"
#Get Delimiter
$OU = Read-Host "Organisation Unit Path to join (default is CN=Users,DC=domain,DC=tld)"
#Get Properties to fetch
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
    Write-Error "Name: $Name"
    Exit 1
}


#Get the domain name
$Domain = (Get-ADDomain).Forest
#Create the Mail
$Mail = "$($Name)@$($Domain)"


#Create the user
New-ADUser -Name $Name -ChangePasswordAtLogon $true -AccountPassword $secureString -UserPrincipalName $Mail -Enabled $true
if (!([string]::IsNullOrEmpty($OU)))
{
    Set-ADUser -Identity $Name -Path $OU
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


