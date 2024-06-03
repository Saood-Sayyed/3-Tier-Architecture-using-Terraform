/*output "pub_s" {
  value = aws_subnet.pub_s.id
}*/

output "pub_s" {
  value = aws_subnet.pub_s[*].id
}

output "pr_s" {
  value = aws_subnet.pr_s.id
}

output "sg" {
  value = aws_security_group.sg.*.id
}

output "vpc_id" {
  value = aws_vpc.vpc1.id
}