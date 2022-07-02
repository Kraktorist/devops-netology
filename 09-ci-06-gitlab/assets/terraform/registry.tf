resource "yandex_container_registry" "default" {
  name      = "kraktorist"

  labels = {
    my-label = "kraktorist"
  }
}
