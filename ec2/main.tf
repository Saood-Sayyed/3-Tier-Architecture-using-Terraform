resource "aws_instance" "ec2" {
  ami = "ami-00beae93a2d981137"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  key_name = "ec2-key"
  subnet_id = element(var.s1, count.index % length(var.s1))
  security_groups = var.sg
  count = 2
  tags ={
    Name = "example-instance-${count.index}"
  }

  user_data = <<-EOF
              #!/bin/bash
              echo "${var.private_key_content}" > /home/ec2-user/.ssh/id_rsa
              chmod 600 /home/ec2-user/.ssh/id_rsa
              EOF

}

resource "aws_instance" "pr_ec2" {
  ami = "ami-00beae93a2d981137"
  instance_type = "t2.micro"
  key_name = "ec2-key"
  subnet_id = var.pr_sub
}