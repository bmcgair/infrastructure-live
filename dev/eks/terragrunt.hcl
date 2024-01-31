terraform {
  source = "git@github.com:bmcgair/infrastructure-modules.git//eks?ref=eks-v0.0.1"
}

include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path           = find_in_parent_folders("env.hcl")
  expose         = true
  merge_strategy = "no_merge"
}

inputs = {
  eks_version = "1.29"
  env         = include.env.locals.env
  eks_name    = "billm"
  subnet_ids  = dependency.vpc.outputs.private_subnet_ids

  node_groups = {
    general = {
      capacity_type  = "ON_DEMAND"
      instance_types = ["t3a.medium"]
      scaling_config = {
        desired_size = 3
        max_size     = 6
        min_size     = 2
      }
    }
  }
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    private_subnet_ids = ["subnet-1234", "subnet-5678"]
  }
}
