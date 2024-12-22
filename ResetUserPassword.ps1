#OK
#Get User name to reset
$Name = Read-Host "Name of the user"

#Exit if name null
if([string]::IsNullOrEmpty($Name))
{
    Write-Error "Name is null or empty"
    Exit 1
}

#Creation of default password
#Password secure
$base64String = 'VG90YWx5TjB0U2VjdXJl' #Not clear text
#Base64 to ByteArray
$byteArray = [System.Convert]::FromBase64String($base64String)
#ByteArray to text
$plainText = [System.Text.Encoding]::UTF8.GetString($byteArray)
#Text to securestring
$secureString = ConvertTo-SecureString -String $plainText -AsPlainText -Force

#Change password with the default value
Set-ADAccountPassword -Identity $Name -NewPassword $secureString -Reset

#Change passwrd at logon
Set-ADUser -Identity $Name -ChangePasswordAtLogon $true