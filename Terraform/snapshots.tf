resource "yandex_compute_snapshot_schedule" "daily_all" {
  name = "daily-all-disks"

  schedule_policy {
    expression = "0 0 * * *" # ежедневно в полночь
  }

  retention_period = "168h" # 7 дней

  disk_ids = concat(
    [yandex_compute_instance.bastion.boot_disk[0].disk_id],
    [for vm in yandex_compute_instance.web : vm.boot_disk[0].disk_id],
    [yandex_compute_instance.zabbix.boot_disk[0].disk_id],
    [yandex_compute_instance.kibana.boot_disk[0].disk_id],
    [yandex_compute_instance.elasticsearch.boot_disk[0].disk_id]
  )
}