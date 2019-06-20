$params = @{
    RootOrgUnit = Get-ADOrganizationalunit -Searchbase "OU=Services,OU=Enterprise Management,DC=usafricom,DC=mil" -filter * -searchscope Base
    RootPath = "C:\Users\SVCDE05CM01\Desktop\DSC-Gallery"
}
Get-DataStructure @params