ui = true
listener "tcp" {
  address          = "0.0.0.0:8200"
  cluster_address  = "10.31.23.58:8201"
  tls_disable      = "true"
}

storage "mysql" {
  ha_enabled = "true"
  address = "vault-db.clsqkkbd9zef.ap-southeast-1.rds.amazonaws.com:3306"
  username = "admin"
  password = "Admin123"
  database = "vault"
}

seal "awskms" {
  kms_key_id = "2e95001a-0722-4645-9ab1-e47c8c3855a2",
  region = "ap-southeast-1"
}

api_addr = "http://10.31.23.58:8200"
cluster_addr = "http://10.31.23.58:8201"