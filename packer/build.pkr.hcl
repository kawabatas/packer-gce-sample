packer {
  required_plugins {
    googlecompute = {
      source  = "github.com/hashicorp/googlecompute"
      version = "~> 1.1.4"
    }
  }
}

source "googlecompute" "test-vm-image" {
  project_id          = local.project_id
  source_image        = local.base_image
  source_image_family = "ubuntu-2404-lts-amd64"
  zone                = local.zone
  disk_size           = 10
  image_name          = "kawabatas-test-imege-${local.timestamp}"
  image_description   = "Test VM image created with HashiCorp Packer"
  image_project_id    = local.image_project_id
  machine_type        = local.machine_type
  preemptible         = false
  scopes = [
    "https://www.googleapis.com/auth/cloud-platform"
  ]
  ssh_username = "root"
  tags = [
    "http-server",
    "https-server",
  ]
}

build {
  name    = "build-vm-image"
  sources = ["sources.googlecompute.test-vm-image"]

  provisioner "shell" {
    # root ユーザで作業
    inline = [
      "apt-get update",
      "apt-get upgrade -y",
      "timedatectl set-timezone Asia/Tokyo",
      "adduser --disabled-password --gecos '' bob", # ユーザ bob を追加
      "gpasswd -a bob sudo",                        # bob を sudo グループに追加
      "mkdir -p /opt/bob/bin",
    ]
  }
  provisioner "file" {
    destination = "/opt/bob/bin/hello.sh"
    source      = "./files/hello.sh"
  }
  provisioner "file" {
    destination = "/etc/systemd/system/hello.service"
    source      = "./files/hello.service"
  }
  provisioner "shell" {
    inline = [
      "chown bob:bob /opt/bob/bin/hello.sh",
      "chmod 0755 /opt/bob/bin/hello.sh",
      "systemctl daemon-reload",
      "systemctl enable hello.service",
      "systemctl start hello.service"
    ]
  }
  provisioner "shell" {
    inline = [
      "curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh",
      "apt-get update --allow-releaseinfo-change",
      "bash add-google-cloud-ops-agent-repo.sh --also-install",
    ]
  }
  provisioner "file" {
    destination = "/etc/google-cloud-ops-agent/config.yaml"
    source      = "./files/ops-agent-config.yaml"
  }
  provisioner "shell" {
    inline = [
      "sudo systemctl restart google-cloud-ops-agent",
    ]
  }
}
