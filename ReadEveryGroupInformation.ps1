#OK

#Get Attribute
$Attribute = Read-Host "Attributes to retrieve for $NameFilter, default all"
#set default value
if([string]::IsNullOrEmpty($Attribute)){$Attribute = "*"}


#Get Groups according to the filter on the name with all properties
$Groups = Get-ADGroup -Filter * -Properties *
# Get only the desired properties of the groups
$Groups | Select-Object  -Property $Attribute