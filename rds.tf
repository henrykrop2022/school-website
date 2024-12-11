resource "aws_db_instance" "utc_dev_database" {
  identifier         = "utc-dev-database"
  engine             = "mysql"
  instance_class     = "db.t3.micro"
  allocated_storage  = 20
  storage_type       = "gp2"
  #name               = "utcdb"
  username           = "utcuser"
  password           = "utcdev12345"
  db_subnet_group_name = aws_db_subnet_group.utc_db_subnet_group1.id
  vpc_security_group_ids = [aws_security_group.database_sg.id]
  skip_final_snapshot   = true
  publicly_accessible   = false

  tags = {
    Name = "utc-dev-database"
    env  = "dev"
    team = "config management"
  }
}

resource "aws_db_subnet_group" "utc_db_subnet_group1" {
  name       = "utc-db-subnet-grp"
  subnet_ids = module.vpc.private_subnets

  tags = {
    Name = "utc-db-subnet-grp"
    env  = "dev"
    team = "config management"
  }
}
