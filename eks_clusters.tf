resource "aws_eks_cluster" "example_cluster1" {
  name     = "example_cluster1"
  role_arn = aws_iam_role.eks_iam_role.arn

  vpc_config {
    subnet_ids = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.example-AmazonEKSVPCResourceController,
  ]
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/27"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "subnet2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.32/27"
  availability_zone = "us-east-1b"
}

resource "aws_iam_role" "eks_iam_role" {
  name = "eks-cluster-example"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_iam_role.name
}

# Optionally, enable Security Groups for Pods
# Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
resource "aws_iam_role_policy_attachment" "example-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_iam_role.name
}


output "endpoint1" {
  value = aws_eks_cluster.example_cluster1.endpoint
}

output "kubeconfig-certificate-authority-data1" {
  value = aws_eks_cluster.example_cluster1.certificate_authority[0].data
}



//=======================================================================================


resource "aws_eks_cluster" "example_cluster2" {
  name     = "example_cluster2"
  role_arn = aws_iam_role.eks_iam_role.arn

  vpc_config {
    subnet_ids = [aws_subnet.subnet3.id, aws_subnet.subnet4.id]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.example-AmazonEKSVPCResourceController,
  ]
}

# resource "aws_vpc" "main" {
#   cidr_block = "10.0.0.0/16"
# }

resource "aws_subnet" "subnet3" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.64/27"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "subnet4" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.128/27"
  availability_zone = "us-east-1b"
}

# resource "aws_iam_role" "eks_iam_role" {
#   name = "eks-cluster-example"

#   assume_role_policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "eks.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# POLICY
# }

# resource "aws_iam_role_policy_attachment" "example-AmazonEKSClusterPolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
#   role       = aws_iam_role.eks_iam_role.name
# }

# # Optionally, enable Security Groups for Pods
# # Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
# resource "aws_iam_role_policy_attachment" "example-AmazonEKSVPCResourceController" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
#   role       = aws_iam_role.eks_iam_role.name
# }


output "endpoint2" {
  value = aws_eks_cluster.example_cluster2.endpoint
}

output "kubeconfig-certificate-authority-data2" {
  value = aws_eks_cluster.example_cluster2.certificate_authority[0].data
}

