resource "aws_eks_node_group" "example_node_group" {
  cluster_name    = aws_eks_cluster.example_cluster.name
  node_group_name = "example_node_group"
  node_role_arn   = aws_iam_role.example_node_group_role.arn
  subnet_ids      = aws_subnet.subnet2[*].id
  instance_types = [ "t2.nano" ]

  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.example-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.example-AmazonEC2ContainerRegistryReadOnly,
  ]
}

resource "aws_iam_role" "example_node_group_role" {
  name = "example_node_group_role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.example_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.example_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.example_node_group_role.name
}

# resource "aws_subnet" "subnet3" {
#   vpc_id     = aws_vpc.main.id
#   cidr_block = "10.0.0.64/27"
#   availability_zone = "us-east-1a"
# }