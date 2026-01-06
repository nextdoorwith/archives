# winrmを有効化するためのパッチ
# (起動時に WinRM を強制的に有効化)

# WinRMを有効化し、基本認証を許可する
winrm quickconfig -q
winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'

# ファイアウォールでWinRMのポート(5985, 5986)を開放する
New-NetFirewallRule -DisplayName "WinRM HTTPS" -Direction Inbound -LocalPort 5986 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "WinRM HTTP" -Direction Inbound -LocalPort 5985 -Protocol TCP -Action Allow

# ネットワークプロファイルを「プライベート」に変更（パブリックだと接続を拒否されるため）
Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory Private
