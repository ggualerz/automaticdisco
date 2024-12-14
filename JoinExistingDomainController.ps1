#Get Domain name
$domainname = Read-Host "Write the domain name to join"

#Get Credential of an admin of the existing domain 
$Creds = (Get-Credential)

#SafeModePassword Generation, because the subject doesnt ask for this as a parameter
$length = 24  # Specify the length of the password
$chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%&*_-+=?"  # Set of characters to use
$password = -join ((1..$length) | ForEach-Object { $chars | Get-Random })

Install-ADDSDomainController -DomainName $domainName -Credential $Creds -InstallDNS -SafeModeAdministratorPassword (ConvertTo-SecureString -String $password -AsPlainText -Force)

Write-Host "Your safemode password $password `t Keep it safely in case of an emergency" -ForegroundColor Red