# outputs.tf
output "node_group_id" { value = aws_eks_node_group.main.id }
output "node_group_arn" { value = aws_eks_node_group.main.arn }
output "node_group_status" { value = aws_eks_node_group.main.status }
output "node_role_arn" { value = aws_iam_role.node.arn }
output "node_role_name" { value = aws_iam_role.node.name }
