# studocu
Terraform assignment

## Pre-requisites
- Development instance
- AWS Account
- Install latest terraform on development instance
- Setup aws creds on development instance
- S3 bucket created to store Terraform state

## Defaults
- Deafult values for infrastructure are set inside variables.tf file. You can update this file.

**NOTE :** Use values as per your requirement

## Mandatory Update
- Update file config.s3.tfbackend with appropriate S3 values

## Steps :
- Clone the repo
```
git clone https://github.com/taherbohari/studocu.git
```

- cd into dir
```
cd studocu
```

- Terraform Init
```
terraform init -backend-config=config.s3.tfbackend
```

- Terraform plan
```
terraform plan -out my_plan
```

- Terraform apply
```
terraform apply "my_plan"
```
