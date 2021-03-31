module "eks_cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "3.0.0"

  cluster_version = "1.14"

  cluster_name = "prod-cluster"

  # your VPC ID
  vpc_id       = "vpc-542cab30"

  # The private AND public subnet ids
  subnets = [
    "subnet-07078232e07eb69f5",
    "subnet-0a9bf4fcbcd7a4351",
    "subnet-1192e667",
    "subnet-1392e665",
    "subnet-c80545ac",
    "subnet-db0545bf"
  ]

  # Modify these to control cluster access
  cluster_endpoint_private_access = "true"
  cluster_endpoint_public_access  = "false"

  # Makes configuring aws-iam-authenticator easy 
  write_kubeconfig      = true

  # Change to wherever you want the generated kubeconfig to go
  config_output_path    = "./"

  # Makes specifying IAM users or roles with cluster access easier
  manage_aws_auth       = true
  write_aws_auth_config = true

  # Specify IAM users that you want to be able to use your cluster
  map_users_count = 4
  map_users = [
    {
      user_arn = "arn:aws:iam::035385703479:user/vishal.ingale"
      username = "vishal.ingale"
      group    = "system:masters"
    },
    {
      user_arn = "arn:aws:iam::035385703479:user/harsha.shastri"
      username = "harsha.shastri"
      group    = "system:masters"
    },
  ]

  # If you use IAM roles to federate IAM access, specify the roles you want to be able to use your cluster
#  map_roles_count = 1
#  map_roles = [
#    {
#      role_arn = "arn:aws:iam::12345678912:role/role1"
#      username = "role1"
#      group    = "system:masters"
#    },
#  ]

  # This creates an autoscaling group for your workers
  worker_group_count = 1
  worker_groups = [
    {
      name                 = "workers"
      instance_type        = "m4.large"
      asg_min_size         = 1
      asg_desired_capacity = 2
      asg_max_size         = 3
      root_volume_size     = 50
      root_volume_type     = "gp2"

      # This evaluate to our encrypted AMI from before!
      ami_id               = "${aws_ami_copy.eks_worker.id}"

      # Specify the SSH key pair you wish to use 
      key_name          = "devops-aws-sg-1"

      # Optionally enable 1-minute CloudWatch metrics
      enable_monitoring = true

      # Specify your private subnets here as a comma-separated string
      subnets = "subnet-1392e665,subnet-db0545bf,subnet-07078232e07eb69f5"
    },
  ]

  # Add any other tags you wish to the resources created by this module
  tags = {
    Cluster = "prod-cluster"
  }
}

output "worker_role_arn" {
  value = "${module.eks_cluster.worker_iam_role_arn}"
}
