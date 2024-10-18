module "sg_for_bastion_host" {
  source = "terraform-aws-modules/security-group/aws"

  name        = format(module.naming.result, "bastion-host-sg")
  description = "sg for bastion host"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "-1"
      description = "allow all traffic"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  egress_rules = ["all-all"]
}

module "security_group_for_backend" {
  source = "terraform-aws-modules/security-group/aws"

  name        = format(module.naming.result, "backend-sg")
  description = "sg for private backend instance"
  vpc_id      = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port                = 22
      to_port                  = 22
      protocol                 = "tcp"
      description              = "allow ssh traffic from bastion host"
      source_security_group_id = module.sg_for_bastion_host.security_group_id
    },
    {
      from_port                = 3000
      to_port                  = 3000
      protocol                 = "tcp"
      description              = "allow 3000 port traffic from alb"
      source_security_group_id = module.security_group_for_alb.security_group_id
    }
  ]

  egress_rules = ["all-all"]
}

module "security_group_for_alb" {
  source = "terraform-aws-modules/security-group/aws"

  name        = format(module.naming.result, "alb-sg")
  description = "sg for alb"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "allow HTTP traffic from anywhere"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "allow HTTPS traffic from anywhere"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_rules = ["all-all"]
}
