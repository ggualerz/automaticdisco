#OK
#Get CSV PAth
$CSVPath = Read-Host "CSV input C:\Users\contoso\export.csv (default is $(Get-Location)\export.csv)"
#Get Delimiter
$Delim = Read-Host "Choose the delimiter char (default is ',')"



#Apply default values if empty
if([string]::IsNullOrEmpty($CSVPath)){$CSVPath = "$(Get-Location)\export.csv"}
if([string]::IsNullOrEmpty($Delim)){$Delim = ","}


#Import the CSV

$CSV = Import-Csv -Delimiter $Delim -Path $CSVPath

#Print Users
Read-Host "Type Enter to load users"
$Users = $CSV | Where-Object { $_.IsUser -eq "True" }

# Itterate users
foreach ($User in $Users) {
    $SamAccountName = $User.SamAccountName
    $UPN = $User.UserPrincipalName
    $GivenName = $User.GivenName

    # Check mandatoy fields
    if (-not [string]::IsNullOrEmpty($SamAccountName) -and -not [string]::IsNullOrEmpty($UPN) -and -not [string]::IsNullOrEmpty($GivenName)) {

        # Check if user already exist
        $ExistingUser = Get-ADUser -Filter {SamAccountName -eq $SamAccountName} -ErrorAction SilentlyContinue

        if (-not $ExistingUser) {
            Write-Host "User creation : $SamAccountName $GivenName"

            # Create new user
            New-ADUser `
                -SamAccountName $SamAccountName `
                -UserPrincipalName $UPN `
                -Name $User.GivenName `
                -GivenName $User.GivenName `
                -Surname $User.Surname `
                -Enabled $true `
                -AccountPassword (ConvertTo-SecureString "Pass42!" -AsPlainText -Force) `
                -ChangePasswordAtLogon $true

        } else {
            Write-Host "User $SamAccountName already exist"
        }
    } else {
        Write-Host "User with missing fields (login/name/...), ignored $($User.SamAccountName)"
    }
}
#Print Group
Read-Host "Type Enter to load groups"
$Groups = $CSV | Where-Object { $_.IsUser -eq "False" }

# Iterate Groups
foreach ($Group in $Groups) {
    if ($Group.Name) { # Check mandatory fields
        $GroupName = $Group.Name

        # Check if group already exist
        if (-not (Get-ADGroup -Filter { Name -eq $GroupName } -ErrorAction SilentlyContinue)) {
            try {
                # Créer le groupe
                New-ADGroup -Name $GroupName -GroupScope Global -GroupCategory Security -Description "Group created with LoadDatabase.ps1"
                Write-Output "Group '$GroupName' created."
            } catch {
                Write-Error "Error while creating '$GroupName': $_"
            }
        } else {
            Write-Output " '$GroupName' already exist."
        }
    } else {
        Write-Host "Missing field name in a group, cannot create the group"
    }
}