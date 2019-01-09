# NETWORKING #
resource "aws_vpc" "vpc" {
  cidr_block = "${var.network_address_space}"
  enable_dns_hostnames = true
  tags {
    Name        = "${var.environment_tag}-vpc"
    Environment = "${var.environment_tag}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags {
    Name        = "${var.environment_tag}-vpc"
    Environment = "${var.environment_tag}"
  }
}

resource "aws_subnet" "subnet" {
  count                   = "${var.subnet_count}"
  cidr_block              = "${cidrsubnet(var.network_address_space, 8, count.index + 1)}"
  vpc_id                  = "${aws_vpc.vpc.id}"
  map_public_ip_on_launch = "true"
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"

  tags {
    Name        = "${var.environment_tag}-subnet-${count.index + 1}"
    Environment = "${var.environment_tag}"
  }
}

# ROUTING #
resource "aws_route_table" "rtb" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags {
    Name        = "${var.environment_tag}-rtb"
    Environment = "${var.environment_tag}"
  }
}

resource "aws_route_table_association" "rta-subnet" {
  count          = "${var.subnet_count}"
  subnet_id      = "${element(aws_subnet.subnet.*.id,count.index)}"
  route_table_id = "${aws_route_table.rtb.id}"
}

# SECURITY GROUPS #
resource "aws_security_group" "http" {
  name        = "http"
  vpc_id      = "${aws_vpc.vpc.id}"

  #Allow HTTP from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# SSH security group
resource "aws_security_group" "ssh" {
  name        = "ssh"
  vpc_id      = "${aws_vpc.vpc.id}"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

## LOAD BALANCER #
#resource "aws_elb" "web" {
#  name = "nginx-elb"
#
#  subnets         = ["${aws_subnet.subnet.*.id}"]
#  security_groups = ["${aws_security_group.http.id}"]
#  instances       = ["${aws_instance.web.*.id}"]
#
#  listener {
#    instance_port     = 80
#    instance_protocol = "http"
#    lb_port           = 80
#    lb_protocol       = "http"
#  }
#
#  tags {
#    Name        = "${var.environment_tag}-elb"
#    Environment = "${var.environment_tag}"
#  }
#}

##################################################################################
# OUTPUT
##################################################################################

#output "aws_elb_public_dns" {
#    value = "${aws_elb.web.dns_name}"
#}
