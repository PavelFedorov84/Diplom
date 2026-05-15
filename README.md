# Домашнее задание к занятию "Diplom" - Федоров Павел



---

### Подготовка.

`Установка YC CLI, Terraform и Ansible на локальном хосте`

YC CLI

sudo apt  install curl

curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash


Terraform

sudo apt install snapd

sudo snap install terraform --classic

Ansible

sudo apt install -y ansible



Генерация SSH ключа 

ssh-keygen -t rsa -b 4096 -C "pavelfedorov84@gmail.com"


Инициализация YC CLI (авторизация через Web интерфейс)

![Название скриншота](https://github.com/PavelFedorov84/Diplom/blob/main/img/1-1.png))`



---

### Развертывание.

`Экспортируем токен`

export YC_TOKEN=`yc iam create-token`

export YC_CLOUD_ID=$(yc config get cloud-id)

export YC_FOLDER_ID=$(yc config get folder-id)

`Запускаем развертывание terraform`
https://github.com/PavelFedorov84/Diplom/tree/main/Terraform

cd Diplom/terraform

terraform init

terraform plan

terraform apply -auto-approve


![Название скриншота](https://github.com/PavelFedorov84/Diplom/blob/main/img/1-10.png)

ВМ
![Название скриншота](https://github.com/PavelFedorov84/Diplom/blob/main/img/1-9.png)

ГРУППЫ
![Название скриншота](https://github.com/PavelFedorov84/Diplom/blob/main/img/1-11.png)



`Установка Ansible на Bastion`

Плейбук: https://github.com/PavelFedorov84/Diplom/tree/main/Ansible-bastion

- устанавливает Ansible на Bastion;
  
- копирует папку проекта на Bastion;
  
- копирует ssh ключи на Bastion.

cd Diplom/ansible-bastion

ansible-playbook -i inventory.ini ansible_bastion.yml





`Настройка проекта через Ansible` https://github.com/PavelFedorov84/Diplom/tree/main/Ansible


Основной плейбук playbook.yml, поочередно запускает остальные плейбуке.
Такой подход позваоляет сделать настройку боллее гибкой для внесения правок и тестирования.

Последовательность запуска (playbook.yml):

Web servers config (nginx, zabbix_agent, filebeat)

Zabbix server config

Elasticsearch config

Kibana config

Add hosts to Zabbix


Подключение к Bastion ssh ubuntu@89.169.132.153

cd ansible

ansible-playbook playbook.yml

![Название скриншота](https://github.com/PavelFedorov84/Diplom/blob/main/img/1-8.png)
---

### Проверка.

`После развертывания проверяем корректность настройки`


В Kibana видно что индексы с логами поступают в Elasticsearch.
![Название скриншота](https://github.com/PavelFedorov84/Diplom/blob/main/img/1-2.png)`

![Название скриншота](https://github.com/PavelFedorov84/Diplom/blob/main/img/1-3.png)`

В Zabbix добавлены необходимые хосты, хосты привязаны к шаблонам.
![Название скриншота](https://github.com/PavelFedorov84/Diplom/blob/main/img/1-4.png)`





### Тестирование.


Произведем нагрузочное тестирование.
wrk -t4 -c100 -d60s http://.....
![Название скриншота](https://github.com/PavelFedorov84/Diplom/blob/main/img/1-5.png)`


На графиках Zabbix видно равномерное повышение нагрузки и исходящего трафика на web-серверах.
![Название скриншота](https://github.com/PavelFedorov84/Diplom/blob/main/img/1-6.png)`

На Kibana также происходит повышение нагрузки и увеличивается кол-во логов. 
![Название скриншота](https://github.com/PavelFedorov84/Diplom/blob/main/img/1-7.png)`




