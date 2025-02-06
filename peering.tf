resource "aws_vpc_peering_connection" "main" {
  count = var.is_peering ? 1 : 0
  peer_vpc_id   = data.aws_vpc.default.id 
  vpc_id        = aws_vpc.main.id
  auto_accept   = true

  tags = merge( var.tags,var.peering_tags,{

      Name="${local.name}-default"
  
}
  )
}

resource "aws_route" "public_route_peering" {
  route_table_id            = aws_route_table.public_rt.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id  = aws_vpc_peering_connection.main[0].id
}

resource "aws_route" "private_route_peering" {
  route_table_id            = aws_route_table.private_rt.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id  = aws_vpc_peering_connection.main[0].id
}

resource "aws_route" "database_route_peering" {
  route_table_id            = aws_route_table.database_rt.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id  = aws_vpc_peering_connection.main[0].id
}

resource "aws_route" "default_route_peering" {
  route_table_id            = data.aws_vpc.default.main_route_table_id
  destination_cidr_block    = aws_vpc.main.cidr_block
  vpc_peering_connection_id  = aws_vpc_peering_connection.main[0].id
}
