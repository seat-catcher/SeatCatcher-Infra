resource "ncloud_objectstorage_bucket" "dev_container_registry_bucket" {
  bucket_name = "dev-container-registry-bucket"
}

resource "ncloud_objectstorage_bucket" "dev_tfstate_backend_bucket" {
  bucket_name = "dev-tfstate-backend-bucket"
}