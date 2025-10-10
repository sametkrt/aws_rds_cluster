resource "aws_security_group" "this" {
  name        = "${var.name}-aurora-sg"
  description = "Aurora SG for ${var.name}"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = length(var.cluster_allowed_ingress_cidrs) > 0 ? [1] : []
    content {
      from_port   = local.port
      to_port     = local.port
      protocol    = "tcp"
      cidr_blocks = var.cluster_allowed_ingress_cidrs
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(local.tags, { Name = "${var.name}-aurora-sg" })
}

resource "aws_security_group_rule" "this" {
  for_each                 = toset(var.security_groups)
  description              = "Allow DB traffic from ${each.key}"
  type                     = "ingress"
  from_port                = local.port
  to_port                  = local.port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.this.id
  source_security_group_id = each.key
}
