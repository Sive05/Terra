# Declare Variables
variable vpc_cidr_range {}
variable subnet_cidr_range {}
variable availability_zone {}
variable env_prefix {}

# Create VPC
resource "aws_vpc" "my-vpc" {
	cidr_block = var.vpc_cidr_range
	
	tags = {
    Name = "${var.env_prefix}-vpc"
  }
}

# Create Subnet 1
resource "aws_subnet" "my-subnet1" {
	vpc_id = aws_vpc.my-vpc.id
	cidr_block = var.subnet_cidr_range
	availability_zone = var.availability_zone
	
	tags = {
    Name = "${var.env_prefix}-subnet1"
  }
}

# Create IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    Name = "${var.env_prefix}-IGW"
  }
}

/* #block to test the custom route table creation and associate the subnet to it
# Create Custom RouteTable
resource "aws_route_table" "rt1" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.env_prefix}-RT1"
  }
}

# Create Route Table association
resource "aws_route_table_association" "association" {
  subnet_id      = aws_subnet.my-subnet1.id
  route_table_id = aws_route_table.rt1.id
}
*/

/* #block to test the association to Main RT
# Associate Subnet RT1 to Main RT
resource "aws_route_table_association" "Main-association" {
  subnet_id      = aws_subnet.my-subnet1.id
  route_table_id = aws_vpc.my-vpc.default_route_table_id
}
*/

# Add a Route to the Deault main RT
resource "aws_default_route_table" "add-route-in-main-RT" {
  default_route_table_id = aws_vpc.my-vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.env_prefix}-RT1"
  }
}
