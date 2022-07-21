vault {
    address = "http://10.0.1.114:8200"
}
auto_auth {
    method "approle" {
        mount_path = "auth/approle"
        config     = {
            role_id_file_path                   = "/tmp/test-vault-role-id"
            secret_id_file_path                 = "/tmp/test-vault-secret-id"
            remove_secret_id_file_after_reading = "false"
            secrets = {
                "http://10.0.1.114:8200" = "secret/application/docker"
            }
        }
    }
    sink "file" {
        config = {
            path = "/tmp/token-sink"
        }
    }
}
