## Usage

```hcl
module "primary" {
  source = "git@github.com:sametkrt/aws_rds_cluster.git"

  name                        = "samet"
  env                         = "test"
  vpc_id                      = "vpc-0d0294db679832bd2"
  subnet_ids                  = ["subnet-000cde7313b15b40b", "subnet-01c2283f800d44524"]
  security_groups             = ["sg-0edc7139d23435ee4"]
  engine                      = "aurora-postgresql"
  cluster_engine_version      = "15.4"
  instance_class              = "db.r6g.large"
  reader_count                = 1
  cluster_master_username     = "samet"
  cluster_skip_final_snapshot = true
  cluster_deletion_protection = false

  # DMS configuration (Optional)
  enable_dms_source                   = true
  dms_max_replication_slots           = 8
  dms_max_wal_senders                 = 10
  dms_max_logical_replication_workers = 4
  dms_allowed_security_group_ids      = [aws_security_group.dms.id]
  
  extra_tags = {
    Project = "poc"
    Owner   = "samet"
  }
}
```