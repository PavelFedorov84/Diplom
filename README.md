# Домашнее задание к занятию "`Diplom`" - `Федоров Павел`




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


![Название скриншота 2](ссылка на скриншот 2)`














1. `Заполните здесь этапы выполнения, если требуется ....`
2. `Заполните здесь этапы выполнения, если требуется ....`
3. `Заполните здесь этапы выполнения, если требуется ....`
4. `Заполните здесь этапы выполнения, если требуется ....`
5. `Заполните здесь этапы выполнения, если требуется ....`
6. 

```
Поле для вставки кода...
....
....
....
....
```

`При необходимости прикрепитe сюда скриншоты
![Название скриншота 1](ссылка на скриншот 1)`




---

### Развертывание.

`Экспортируем токен`

export YC_TOKEN=`yc iam create-token`

export YC_CLOUD_ID=$(yc config get cloud-id)

export YC_FOLDER_ID=$(yc config get folder-id)

`Запускаем развертывание terraform`

cd Diplom/terraform

terraform init

terraform plan

terraform apply -auto-approve

`Установка Ansible на Bastion`

Плейбук:
- устанавливает Ansible на Bastion;
  
- копирует папку проекта на Bastion;
  
- копирует ssh ключи на Bastion.

cd Diplom/ansible-bastion

ansible-playbook -i inventory.ini ansible_bastion.yml


`Настройка проекта через Ansible`

Подключение к Bastion ssh ubuntu@111.88.253.100

cd ansible

ansible-playbook playbook.yml

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




