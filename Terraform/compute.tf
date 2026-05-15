
data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"   # семейство Ubuntu 22.04 LTS
}


locals {
  image_id = data.yandex_compute_image.ubuntu.id
  web_count = 2
  web_zones = ["ru-central1-a", "ru-central1-b"]
  web_subnets = [yandex_vpc_subnet.private_subnet_a.id, yandex_vpc_subnet.private_subnet_b.id]
}

resource "yandex_compute_instance" "bastion" {
  name        = "bastion"
  hostname    = "bastion"
  platform_id = "standard-v2"
  zone        = "ru-central1-a"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = local.image_id
      size     = 10
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public_subnet_a.id
    nat                = true
    #nat_ip_address     = "111.88.247.104"
    security_group_ids = [yandex_vpc_security_group.sg_bastion.id]
  }

  metadata = {
    ssh-keys = "${var.username}:${file(var.ssh_public_key_path)}"
  }

  scheduling_policy {
    preemptible = true
  }
}

resource "yandex_compute_instance" "web" {
  count       = local.web_count
  name        = "web-server-${count.index + 1}"
  hostname    = "web-server-${count.index + 1}"
  platform_id = "standard-v2"
  zone        = local.web_zones[count.index]

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = local.image_id
      size     = 10
    }
  }

  network_interface {
    subnet_id          = local.web_subnets[count.index]
    nat                = false
    security_group_ids = [yandex_vpc_security_group.sg_web.id]
  }

  metadata = {
    ssh-keys = "${var.username}:${file(var.ssh_public_key_path)}"
  }

  scheduling_policy {
    preemptible = true
  }
}

resource "yandex_compute_instance" "zabbix" {
  name        = "zabbix-server"
  hostname    = "zabbix-server"
  platform_id = "standard-v2"
  zone        = "ru-central1-a"

  resources {
    cores         = 2
    memory        = 4
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = local.image_id
      size     = 10
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public_subnet_a.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.sg_zabbix.id]
  }

  metadata = {
    ssh-keys = "${var.username}:${file(var.ssh_public_key_path)}"
  }

  scheduling_policy {
    preemptible = true
  }
}

resource "yandex_compute_instance" "kibana" {
  name        = "kibana-server"
  hostname    = "kibana-server"
  platform_id = "standard-v2"
  zone        = "ru-central1-a"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = local.image_id
      size     = 10
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public_subnet_a.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.sg_kibana.id]
  }

  
  metadata = {
    ssh-keys = "${var.username}:${file(var.ssh_public_key_path)}"
  }
  scheduling_policy {
    preemptible = true
  }
}

resource "yandex_compute_instance" "elasticsearch" {
  name        = "elasticsearch-server"
  hostname    = "elasticsearch-server"
  platform_id = "standard-v2"
  zone        = "ru-central1-a"

  resources {
    cores         = 2
    memory        = 4
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = local.image_id
      size     = 10
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private_subnet_a.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.sg_elasticsearch.id]
  }

    metadata = {
    ssh-keys = "${var.username}:${file(var.ssh_public_key_path)}"
  }

  scheduling_policy {
    preemptible = true
  }
}