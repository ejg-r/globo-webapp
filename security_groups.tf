##################################################################################
# RESOURCES
##################################################################################

resource "aws_security_group" "webapp_sg" {
  name        = "${local.name_prefix}-Security-group-main"
  description = "Ingress and Egress are outside"
  vpc_id      = data.tfe_outputs.networking.nonsensitive_values.vpc_id
  tags        = local.common_tags
}

resource "aws_vpc_security_group_ingress_rule" "webapp_http_inbound" {
  security_group_id = aws_security_group.webapp_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80

  tags = local.common_tags
}

resource "aws_vpc_security_group_ingress_rule" "webapp_https_inbound" {
  security_group_id = aws_security_group.webapp_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443


  tags = local.common_tags
}

resource "aws_vpc_security_group_egress_rule" "webapp_outbound" {
  security_group_id = aws_security_group.webapp_sg.id

  from_port   = 0
  to_port     = 0
  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"

  tags = local.common_tags
}

resource "aws_vpc_security_group_ingress_rule" "ssh_rule" {
  security_group_id = aws_security_group.webapp_sg.id

  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
  cidr_ipv4   = "94.60.110.242/32"

  description = "Allow SSH from specific IP"
}

resource "aws_vpc_security_group_ingress_rule" "ssh_rule_2" {
  security_group_id = aws_security_group.webapp_sg.id

  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
  cidr_ipv4   = "18.206.107.24/29"

  description = "Allow SSH from specific IPs"
}