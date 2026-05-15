resource "yandex_vpc_security_group" "sg_bastion" {
  name        = "sg-bastion"
  network_id  = yandex_vpc_network.vpc.id

  ingress {
    description    = "SSH"
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 65535
    protocol  = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "sg_alb" {
  name        = "sg-alb"
  network_id  = yandex_vpc_network.vpc.id

  ingress {
    description    = "HTTP"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port      = 0
    to_port        = 65535
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "sg_web" {
  name        = "sg-web"
  network_id  = yandex_vpc_network.vpc.id

  ingress {
    description       = "HTTP from ALB"
    protocol          = "TCP"
    port              = 80
    security_group_id = yandex_vpc_security_group.sg_alb.id
  }

  ingress {
    description       = "SSH from bastion"
    protocol          = "TCP"
    port              = 22
    security_group_id = yandex_vpc_security_group.sg_bastion.id
  }

  ingress {
    description       = "SSH from zabbix"
    protocol          = "TCP"
    port              = 10051
    security_group_id = yandex_vpc_security_group.sg_zabbix.id
  }

  ingress {
    description       = "SSH from zabbix"
    protocol          = "TCP"
    port              = 10050
    security_group_id = yandex_vpc_security_group.sg_zabbix.id
  }

  egress {
    from_port      = 0
    to_port        = 65535
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "sg_zabbix" {
  name        = "sg-zabbix"
  network_id  = yandex_vpc_network.vpc.id

  ingress {
    description    = "Zabbix web"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "Zabbix agent (active checks)"
    protocol       = "TCP"
    port           = 10051
    v4_cidr_blocks = ["192.168.0.0/16"] # вся внутренняя сеть VPC
  }

  ingress {
    description       = "SSH from bastion"
    protocol          = "TCP"
    port              = 22
    security_group_id = yandex_vpc_security_group.sg_bastion.id
  }

  egress {
    from_port      = 0
    to_port        = 65535
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "sg_kibana" {
  name        = "sg-kibana"
  network_id  = yandex_vpc_network.vpc.id

  ingress {
    description    = "Kibana UI"
    protocol       = "TCP"
    port           = 5601
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description       = "SSH from bastion"
    protocol          = "TCP"
    port              = 22
    security_group_id = yandex_vpc_security_group.sg_bastion.id
  }

  egress {
    from_port      = 0
    to_port        = 65535
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "sg_elasticsearch" {
  name        = "sg-elasticsearch"
  network_id  = yandex_vpc_network.vpc.id

  ingress {
    description       = "Elasticsearch API"
    protocol          = "TCP"
    port              = 9200
    security_group_id = yandex_vpc_security_group.sg_kibana.id
  }

  ingress {
    description       = "Elasticsearch API from filebeat"
    protocol          = "TCP"
    port              = 9200
    security_group_id = yandex_vpc_security_group.sg_web.id
  }

  ingress {
    description       = "SSH from bastion"
    protocol          = "TCP"
    port              = 22
    security_group_id = yandex_vpc_security_group.sg_bastion.id
  }

  egress {
    from_port      = 0
    to_port        = 65535
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}