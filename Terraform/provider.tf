terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  # Аутентификация через переменные окружения:
  # export YC_TOKEN=<iam-токен>
  # export YC_CLOUD_ID=<cloud_id>
  # export YC_FOLDER_ID=<folder_id>
}