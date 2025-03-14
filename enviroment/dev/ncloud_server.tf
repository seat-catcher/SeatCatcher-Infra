resource "ncloud_login_key" "loginkey" {
  key_name = "test-key"
}

resource "local_file" "loginkey_file" {
  content         = ncloud_login_key.loginkey.private_key
  filename        = "${path.module}/test-key.pem"
  file_permission = "0400"
}

resource "ncloud_block_storage" "dev_block_storage" {
  size               = "10"
  server_instance_no = ncloud_server.dev_server.instance_no
  name               = "dev-block-storage"
  hypervisor_type    = "KVM"
  zone               = var.availability_zone[0]
  volume_type        = "CB1"
  depends_on         = [ncloud_server.dev_server]
}

resource "ncloud_public_ip" "dev_public_ip" {
  server_instance_no = ncloud_server.dev_server.id
}

data "ncloud_server_image_numbers" "server_images" {
  filter {
    name   = "name"
    values = ["ubuntu-22.04-base"]
  }
}

data "ncloud_server_specs" "spec" {
  filter {
    name   = "server_spec_code"
    values = ["s2-g3"]
  }
}

resource "ncloud_server" "dev_server" {
  subnet_no            = ncloud_subnet.dev_public_subnet.id
  name                 = "dev-server"
  server_image_number  = data.ncloud_server_image_numbers.server_images.image_number_list.0.server_image_number
  server_spec_code     = data.ncloud_server_specs.spec.server_spec_list.0.server_spec_code
  login_key_name       = ncloud_login_key.loginkey.key_name
  fee_system_type_code = "FXSUM"
  network_interface {
    network_interface_no = ncloud_network_interface.dev_server_nic.id
    order                = 0
  }
}

output "dev_server_ip" {
  value = ncloud_server.dev_server.public_ip
}
