resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  instance_tenancy = var.instance_tenancy
  enable_dns_hostnames= var.enable_dns_hostnames
 
  tags = merge( var.tags,{

      Name=local.name
  }
  )
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge( var.tags,var.gw_tags,{

      Name=local.name
  
}
  )
}

resource "aws_subnet" "public_subnet" {
  count = length(var.public_cidr_block)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_cidr_block[count.index]
  map_public_ip_on_launch= true
  availability_zone= local.availability_zone[count.index]

  tags = merge( var.tags,var.public_subnet_tags,{

      Name="${local.name}-public"
  
}
  )
}

resource "aws_subnet" "private_subnet" {
  count = length(var.private_cidr_block)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_cidr_block[count.index]
  map_public_ip_on_launch= true
  availability_zone= local.availability_zone[count.index]

  tags = merge( var.tags,var.private_subnet_tags,{

      Name="${local.name}-private"
  
}
  )
}


resource "aws_subnet" "database_subnet" {
  count = length(var.database_cidr_block)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.database_cidr_block[count.index]
  map_public_ip_on_launch= true
  availability_zone= local.availability_zone[count.index]

  tags = merge( var.tags,var.database_subnet_tags,{

      Name="${local.name}-database"
  
}
  )
}

resource "aws_eip" "lb" {
  domain   = "vpc"
}

resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.lb.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = merge( var.tags,var.nat_tags,{

      Name=local.name
  
}
  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  tags = merge( var.tags,var.public_rt_tags,{

      Name="${local.name}-public_rt"
  
}
  )
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  tags = merge( var.tags,var.private_rt_tags,{

      Name="${local.name}-private_rt"
}
  )
}

resource "aws_route_table" "database_rt" {
  vpc_id = aws_vpc.main.id

  tags = merge( var.tags,var.database_rt_tags,{

      Name="${local.name}-database_rt"
  
}
  )
}

resource "aws_route" "public_route" {
  route_table_id            = aws_route_table.public_rt.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id  = aws_internet_gateway.gw.id
}

resource "aws_route" "private_route" {
  route_table_id            = aws_route_table.private_rt.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id   = aws_nat_gateway.example.id
}

resource "aws_route" "database_route" {
  route_table_id            = aws_route_table.database_rt.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id   = aws_nat_gateway.example.id
}

resource "aws_route_table_association" "public" {
  count = length(var.public_cidr_block)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private" {
  count = length(var.private_cidr_block)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "database" {
  count = length(var.database_cidr_block)
  subnet_id      = aws_subnet.database_subnet[count.index].id
  route_table_id = aws_route_table.database_rt.id
}