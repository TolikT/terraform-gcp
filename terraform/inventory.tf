# https://stackoverflow.com/questions/45489534/best-way-currently-to-create-an-ansible-inventory-from-terraform

data "template_file" "inventory_template" {
  template = "${file("./templates/inventory.tpl")}"
  vars = {
    instance_public_ip = "${join("\n", google_compute_instance.website-instance.*.network_interface.0.access_config.0.nat_ip)}"
  }
}

resource "local_file" "inventory_file" {
  content  = data.template_file.inventory_template.rendered
  filename = "../ansible/hosts"
}