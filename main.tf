
module "vpc" {
  source = "./vpc"
}

module "ec2" {
  source = "./ec2"
  s1 = module.vpc.pub_s
  sg = module.vpc.sg
  pr_sub = module.vpc.pr_s
  private_key_content = file("") #enter for key path
}



resource "aws_internet_gateway" "igw" {
  vpc_id = module.vpc.vpc_id
}

resource "aws_route_table" "rt" {
  vpc_id = module.vpc.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta" {
  subnet_id = element(module.vpc.pub_s, count.index)
  route_table_id = aws_route_table.rt.id
  count = 2
}

resource "aws_eip" "eip" {
  count  =2
  instance = module.ec2.instance_ids[count.index]
}

resource "aws_nat_gateway" "natgw" {
  count          = length(module.ec2)
  subnet_id      = module.vpc.pub_s[count.index % length(module.vpc.pub_s)]
  allocation_id  = aws_eip.eip[count.index].id
  depends_on = [ aws_internet_gateway.igw ]
}


resource "aws_alb" "alb" {
  internal            = false
  load_balancer_type  = "application"
  security_groups     = module.vpc.sg
  subnets             = module.vpc.pub_s  
}


resource "aws_lb_target_group" "lbtg" {
  port = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id = module.vpc.vpc_id

  health_check {
    healthy_threshold = 3
    unhealthy_threshold = 10
    timeout = 5
    interval = 10
    path = "/"
    port = 80
  }
}

resource "aws_lb_target_group_attachment" "name" {
   count = 2
  target_group_arn = aws_lb_target_group.lbtg.arn
  target_id = module.ec2.instance_ids[count.index]
  port = 80
 
}

resource "aws_lb_listener" "name" {
  load_balancer_arn = aws_alb.alb.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type =  "forward"
    target_group_arn = aws_lb_target_group.lbtg.arn
  }
}