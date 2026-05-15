locals {
  inventory_template = templatefile("${path.module}/templates/inventory.yml.tpl", {
    bastion_ip    = yandex_compute_instance.bastion.network_interface[0].nat_ip_address
    web_fqdns     = [for i in range(2) : "${yandex_compute_instance.web[i].hostname}.ru-central1.internal"]
    zabbix_fqdn   = "${yandex_compute_instance.zabbix.hostname}.ru-central1.internal"
    kibana_fqdn   = "${yandex_compute_instance.kibana.hostname}.ru-central1.internal"
    es_fqdn       = "${yandex_compute_instance.elasticsearch.hostname}.ru-central1.internal"
  })
}

resource "local_file" "ansible_inventory" {
  content  = local.inventory_template
  filename = "${path.module}/../ansible/inventory.yml"
}

output "alb_public_ip" {
  value = yandex_alb_load_balancer.web_alb.listener[0].endpoint[0].address[0].external_ipv4_address[0].address
}