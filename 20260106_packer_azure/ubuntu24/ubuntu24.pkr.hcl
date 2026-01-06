# 共通
packer {
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = "~> 2.0"
    }
  }
}

# ビルド定義
source "azure-arm" "ubuntu24" {

  # Azure CLIの認証情報を使用
  use_azure_cli_auth = true

  # ビルド環境
  subscription_id   = "xxx" # ★環境に合わせて修正★
  location          = "japaneast"
  temp_resource_group_name = "pkrtmp-ubuntu24"

  # 仮想マシンのベースイメージ
  os_type         = "Linux"
  image_publisher = "Canonical"
  image_offer     = "ubuntu-24_04-lts"
  image_sku       = "server"
  image_version   = "latest"

  # ビルドで使用する仮想マシンの仕様
  # （実際の利用時は、その際にSKUなどの仕様を指定）
  vm_size   = "Standard_D2s_v3"
  managed_image_storage_account_type = "Standard_LRS"

  # ビルドで使用する仮想マシンの制御
  communicator   = "ssh"

  # Azure Compute Galleryへの登録
  shared_image_gallery_destination {
    resource_group = "test-rg"
    gallery_name   = "test_gal"
    image_name     = "test-ubuntu24"
    image_version  = "0.0.1"
    # ACGでイメージを保持するストレージ
    storage_account_type = "Standard_LRS"
  }
}

build {
  sources = ["source.azure-arm.ubuntu24"]

  # Azureイメージとして再利用可能にするための必須コマンド
  provisioner "shell" {
    inline = [
      "sudo /usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"
    ]
  }
}
