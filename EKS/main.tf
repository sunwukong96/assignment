provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_vpc" "internal-0-vpc" {
  cidr_block           = "172.17.0.0/24"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "internal-0-vpc"
    Zone = "internal"
  }
}

resource "aws_subnet" "eks_subnet_1" {
  vpc_id            = aws_vpc.internal-0-vpc.id
  cidr_block        = "172.17.0.0/26"
  availability_zone = "ap-southeast-1a"
  tags = {
    Name = "eks-subnet-1"
    Zone = "internal"
    VPC  = "internal-0-vpc"
  }
}

resource "aws_subnet" "eks_subnet_2" {
  vpc_id            = aws_vpc.internal-0-vpc.id
  cidr_block        = "172.17.0.64/26"
  availability_zone = "ap-southeast-1b"
  tags = {
    Name = "eks-subnet-2"
    Zone = "internal"
    VPC  = "internal-0-vpc" 
  }
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "eks-internal-0"
  cluster_version = "1.27"
  vpc_id          = aws_vpc.internal-0-vpc.id
  subnet_ids      = [aws_subnet.eks_subnet_1.id, aws_subnet.eks_subnet_2.id]

  eks_managed_node_groups = {
    internal  = {
      name          = "eks-node-group-internal-0"
      instance_type = "t3.medium"
      min_size      = 1
      desired_size  = 2
      max_size      = 3
    }
  }
}
