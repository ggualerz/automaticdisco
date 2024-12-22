#OK
#Get Domain name
$domainname = Read-Host "Write the domain name to join"

#Get Credential of an admin of the existing domain 
$Creds = (Get-Credential)

#SafeModePassword Set, because the subject doesnt ask for this as a parameter
$password = "Pass42!"

#Join the domain
Install-ADDSDomainController -DomainName $domainName -NoRebootOnCompletion -Credential $Creds -SafeModeAdministratorPassword (ConvertTo-SecureString -String $password -AsPlainText -Force) -Force

Write-Host "Your safemode password $password `nKeep it safely in case of an emergency" -ForegroundColor Red