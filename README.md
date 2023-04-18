
``
terraform init -backend-config variables/dev.conf
``
# example usage of environment variables in terraform plan command
``
terraform plan -var-file="variables/prod.tfvars"
``