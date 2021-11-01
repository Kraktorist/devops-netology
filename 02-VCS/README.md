File ```.gitignore``` will do the following:

```
# excluding .terraform directories
**/.terraform/*

# excluding files with .tfstate extension
*.tfstate

# excluding files which have .tfstate. as a part of the name
*.tfstate.*

# excluding files named crash.log
crash.log

# excluding files with .tfvars extension
*.tfvars

# excluding override.tf file
override.tf
# excluding override.tf.json file
override.tf.json
# excluding files with _override.tf and _override.tf.json endings
*_override.tf
*_override.tf.json

# Excluding files named .terraformrc and terraform.rc 
.terraformrc
terraform.rc
```