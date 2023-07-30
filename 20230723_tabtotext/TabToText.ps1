#
# TabToText.ps1
#     
Param(
    [parameter(mandatory = $false)][String]$InFile,
    [parameter(mandatory = $false)][String]$OutFile
)

# 定数定義
$DELI = "`t"            # 列区切り(CSV: ",", TSV: "`t")
$EL_LEN = 2             # 省略時の記号の長さ("...")

$SJIS_ENC = [System.Text.Encoding]::GetEncoding("shift_jis")

# 整形方法の選択
. ${PSScriptRoot}\TabToText_simple.ps1 # 単純な整形
#. ${PSScriptRoot}\TabToText_table.ps1 # 表形式の整形

# メイン処理
Function ProcMain([String]$InFile, [String]$OutFile) {

    # データの読み取り
    if ([string]::IsNullOrEmpty($InFile)) {
        $InFile = "${PSScriptRoot}\input.tsv"
    }
    $content = Get-Content $InFile -Encoding UTF8

    # 一旦データを読み取って各列幅を決定
    $widths = @() # 列幅配列(各列の幅を保持)
    $row = 0
    $content | ForEach-Object {
        $vals = $_ -split $DELI
        for ($col = 0; $col -lt $vals.Length; $col++) {
            # 列の値に基づいて列幅を算出（上限あり）
            $valw = GetValWidth -Value $vals[$col]
            $colw = CalcColWidth -Row $row -Col $col -ValueWidth $valw
            # 既存より列が増えた場合、列幅配列を追加
            if ( $widths.Length -lt ($col + 1) ) { $widths += 0 }
            # 既存より列幅が大きい場合は、列幅配列の値を更新
            if ( $widths[$col] -lt $colw ) { $widths[$col] = $colw }
        }
        $row++
    }

    # 列幅配列に基づいて各行・列のデータを出力
    # ※ProcXXX関数(ハンドラ関数)は、冒頭の「整形方式の選択」(外部のps1)で定義される前提
    $row = 0; $lines = @()
    $lines += ProcHeader -Widths $widths
    $content | ForEach-Object {
        $vals = $_ -split $DELI
        $outvals = @()
        for ($col = 0; $col -lt $vals.Length; $col++) {
            # 値が列幅以内であれば空白を埋める(超過時は切り捨て)
            $val = $vals[$col]; $wid = $widths[$col]
            $valw = GetValWidth -Value $val
            if ( $valw -le $wid ) {
                $padw = $wid - $valw
                $outvals += $val + " " * $padw
            }
            else {
                $outvals += Truncate -Value $val -Max $wid
            }
        }
        $lines += ProcRowBefore -Row $row -Column $col -Widths $widths -Values $outvals
        $lines += ProcRow       -Row $row -Column $col -Widths $widths -Values $outvals
        $lines += ProcRowAfter  -Row $row -Column $col -Widths $widths -Values $outvals
        $row++
    }
    $lines += ProcFooter -Widths $widths

    # 実行結果をファイルに出力(ファイル指定がない場合は標準出力へ)
    $result = ($lines | Where-Object { $null -ne $_ }) # ハンドラ関数で未出力の行を除外
    if ([string]::IsNullOrEmpty($OutFile)) {
        Write-Output $result # パイプライン後段処理のために配列のまま出力
    }
    else {
        $result -join "`r`n" | Out-File $OutFile
    }
}

# 文字列の超過部分を切り捨てる。
# ※全角文字のを中途半端に切り捨てて文字化けしないよう位置を調整
Function Truncate([string]$Value, [int]$Max) {
    # 省略記号を埋める前提で、値を残す最大幅を決定
    # (最大幅が小さすぎる場合は省略記号なし)
    $vmax = $Max
    if ( $EL_LEN -lt $Max ) { $vmax = $Max - $EL_LEN }
    # 値を残す最大幅までの文字列を生成
    # ※最大幅を超えないよう1文字(1or2バイト)づつ文字連結を試行
    $result = ""; $count = 0
    foreach ($ch in $Value.ToCharArray()) {
        $size = $SJIS_ENC.GetByteCount($ch)
        if ( $vmax -lt ($count + $size) ) { break }
        $result += $ch; $count += $size
    }
    # 最大幅まで省略記号を埋める
    $padlen = $max - $count
    if ( 0 -lt $padlen ) { $result += "." * $padlen }
    return $result
}

# 画面上での文字列幅を取得
# ※画面上の文字数とバイト数が一致するSJISを使用
#   (UTF-8/16等では画面上の文字数とバイト数が一致しない)
Function GetValWidth($Value) {
    return $SJIS_ENC.GetByteCount($Value)
}


# メイン処理の実行
ProcMain -InFile $InFile -OutFile $OutFile
