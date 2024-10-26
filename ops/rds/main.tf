module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = var.identifier

  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3a.large"
  allocated_storage = 5

  db_name  = "db-lab"
  username = "db-lab-username"
  port     = "3306"

  iam_database_authentication_enabled = true

  vpc_security_group_ids = ["sg-db-lab"]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  monitoring_interval    = var.monitoring_interval
  monitoring_role_name   = var.monitoring_role_name
  create_monitoring_role = true

  tags = {
     tags = var.tags
  }

  # DB subnet group
  create_db_subnet_group = true
  subnet_ids             = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]

  # DB parameter group
  family = "mysql8.0"

  # DB option group
  major_engine_version = "8.0"

  # Database Deletion Protection
  deletion_protection = true

  parameters = [
    {
      name  = var.character_set_client      
    },
    {
      name  = var.character_set_server      
    }
  ]

  options = [
    {
      option_name = var.option_name

      option_settings = [
        {
          name  = var.server_plugin_events          
        },
        {
          name  = var.server_file_rotations          
        },
      ]
    },
  ]
}
