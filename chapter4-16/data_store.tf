resource "aws_db_parameter_group" "example" {
  name   = "example"
  family = "mysql5.7"

  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }
}

resource "aws_db_option_group" "example" {
  name                 = "example"
  engine_name          = "mysql"
  major_engine_version = "5.7"

  option {
    option_name = "MARIADB_AUDIT_PLUGIN"
  }
}

resource "aws_db_subnet_group" "example" {
  name = "example"
  subnet_ids = [
    aws_subnet.private_0.id,
    aws_subnet.private_1.id,
  ]
}

resource "aws_db_instance" "example" {
  count                      = 0
  identifier                 = "example"
  engine                     = "mysql"
  engine_version             = "5.7.25"
  instance_class             = "db.t3.small"
  allocated_storage          = 20
  max_allocated_storage      = 100
  storage_type               = "gp2"
  storage_encrypted          = true
  kms_key_id                 = aws_kms_key.example.id
  username                   = "admin"
  password                   = "VeryStrongPassword"
  multi_az                   = true
  publicly_accessible        = false
  backup_window              = "09:10-09:40"
  backup_retention_period    = 30
  maintenance_window         = "mon:10:10-mon:10:40"
  auto_minor_version_upgrade = false
  deletion_protection        = false
  skip_final_snapshot        = false
  port                       = 3306
  apply_immediately          = true
  vpc_security_group_ids     = [module.mysql_sg.security_group_id]
  parameter_group_name       = aws_db_parameter_group.example.name
  option_group_name          = aws_db_option_group.example.name
  db_subnet_group_name       = aws_db_subnet_group.example.name

  lifecycle {
    ignore_changes = [password]
  }
}

module "mysql_sg" {
  source = "./security_group"

  cidr_blocks = [
    aws_vpc.example.cidr_block
  ]
  name   = "mysql-sg"
  port   = 3306
  vpc_id = aws_vpc.example.id
}

resource "aws_elasticache_parameter_group" "example" {
  family = "redis5.0"
  name   = "example"

  parameter {
    name  = "cluster-enabled"
    value = "no"
  }
}

resource "aws_elasticache_subnet_group" "example" {
  name = "example"
  subnet_ids = [
    aws_subnet.private_0.id,
    aws_subnet.private_1.id,
  ]
}

resource "aws_elasticache_replication_group" "example" {
  count                         = 0
  replication_group_description = "Cluster Disabled"
  replication_group_id          = "example"
  engine                        = "redis"
  engine_version                = "5.0.4"
  number_cache_clusters         = 3
  node_type                     = "cache.m3.medium"
  snapshot_window               = "09:10-10:10"
  snapshot_retention_limit      = 7
  maintenance_window            = "mon:10:40-mon:11:40"
  automatic_failover_enabled    = true
  port                          = 6379
  apply_immediately             = true
  security_group_ids = [
    module.redis_sg.security_group_id
  ]
  parameter_group_name = aws_elasticache_parameter_group.example.name
  subnet_group_name    = aws_elasticache_subnet_group.example.name
}

module "redis_sg" {
  source      = "./security_group"
  name        = "redis-sg"
  cidr_blocks = [aws_vpc.example.cidr_block]
  port        = "6379"
  vpc_id      = aws_vpc.example.id
}



