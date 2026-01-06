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
source "azure-arm" "windows" {

  # Azure CLIの認証情報を使用
  use_azure_cli_auth = true

  # ビルド環境
  subscription_id   = "xxx" # ★環境に合わせて修正★
  location          = "japaneast"
  temp_resource_group_name = "pkrtmp-win11"

  # 仮想マシンのベースイメージ
  os_type         = "Windows"
  image_publisher = "MicrosoftWindowsDesktop"
  image_offer     = "Windows-11"
  image_sku       = "win11-25h2-ent"
  image_version   = "latest"

  # ビルドで使用する仮想マシンの仕様
  # （実際の利用時は、その際にSKUなどの仕様を指定）
  vm_size   = "Standard_D2s_v3"
  managed_image_storage_account_type = "Standard_LRS"

  # ビルドで使用する仮想マシンの制御
  communicator   = "winrm"
  winrm_use_ssl  = true
  winrm_insecure = true
  winrm_timeout  = "20m"
  winrm_username = "packer"
  winrm_password = "P@ssw0rd1234!"
  # "Waiting for WinRM ..."が終わらない対策
  user_data_file = "./setup-winrm.ps1"

  # Azure Compute Galleryへの登録
  shared_image_gallery_destination {
    resource_group = "test-rg"
    gallery_name   = "test_gal"
    image_name     = "test-win11"
    image_version  = "0.0.1"
    # ACGでイメージを保持するストレージ
    storage_account_type = "Standard_LRS"
  }
}

build {
  sources = ["source.azure-arm.windows"]

  # 疎通確認用のダミー処理
  provisioner "powershell" {
    inline = [
      "Write-Host 'Build for ACG'",
      "Get-ComputerInfo | Select-Object OsName, OsVersion"
    ]
  }
}
