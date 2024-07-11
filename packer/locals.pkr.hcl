locals {
  project_id       = "プロジェクトID"
  image_project_id = "プロジェクトID" # The project ID to push the build image into.
  zone             = "asia-northeast1-a"
  timestamp        = regex_replace(timestamp(), "[- TZ:]", "")
  base_image       = "ubuntu-2404-noble-amd64-v20240701a" # Google Cloud の更新で削除されている可能性があります。確認してください。https://cloud.google.com/compute/docs/images?hl=ja#os-compute-support
  machine_type     = "e2-micro"
}
