data "aws_ami" "eks_worker_base" {
  filter {
    name = "name"
    values = ["amazon-eks-node-1.14-*"]
  }

  most_recent = true

  # Owner ID of AWS EKS team
  owners = ["amazon"]
}

resource "aws_ami_copy" "eks_worker" {
  name  = "${data.aws_ami.eks_worker_base.name}-encrypted"
  description  = "Encrypted version of EKS worker AMI"
  source_ami_id  = "${data.aws_ami.eks_worker_base.id}"
  source_ami_region = "ap-southeast-1"
  encrypted = true

  tags = {
    Name = "${data.aws_ami.eks_worker_base.name}-encrypted"
  }
}
