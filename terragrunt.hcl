remote_state {
  backend = "s3"
  generate = {
    path = "state.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
   profile = "tf-user" 
   role_arn = "arn:aws:iam::654654146895:role/terraform"
   bucket = "billm-tf-state"
   
   key = "${path_relative_to_include()}/terraform.tfstate"
   region = "us-west-2"
   encrypt = true
   dynamodb_table = "tf-lock-table"
  }
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  region = "us-west-2"
  profile = "tf-user"
   assume_role {
    role_arn = "arn:aws:iam::654654146895:role/terraform"
   } 
}
EOF
}
