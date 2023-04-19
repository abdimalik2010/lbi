
``
terraform init -backend-config variables/dev.conf
``
# example usage of environment variables in terraform plan command
``
terraform plan -var-file="variables/prod.tfvars"
``

## Create SA (Powershell)
$Name = ""
$Role = "Contributor"
$SubId = ""
$Rg = ""
$Scope1 = "/subscriptions/" + $SubId + "/resourceGroups/" + $Rg
az ad sp create-for-rbac --display-name $Name --role $Role --scopes $Scope1

