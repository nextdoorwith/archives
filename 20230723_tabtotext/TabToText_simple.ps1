# シンプルなハンドラの例
# - SQL実行結果を整形することを想定
# - 1行目はヘッダ行、2行目以降はデータ行のイメージ
# - 2行名以降のデータ行の値の幅で列幅を決定
#   (ヘッダ行のカラムを含めて幅を決定すると必要以上に長い幅になるため。)

$MAX_WIDTH = 32         # 最大列幅
$IGNORE_HEADER = $false # 先頭行の列幅を無視

# 各列の最大幅を定義  ※戻り値が各列の最大幅になります！
Function CalcColWidth([int]$Row, [int]$Col, [int]$ValueWidth) {
    # ヘッダ行の幅は無視
    if ( $IGNORE_HEADER -and $Row -eq 0 ) { return 1 }
    # 列幅は最大列幅以下に調整
    $actual = $ValueWidth
    if ( $actual -lt $MAX_WIDTH) {
        return $actual
    }
    else {
        return $MAX_WIDTH
    }
}

# 処理前に出力する内容を定義
Function ProcHeader([int[]]$Widths) { return $null }

# 行出力の直前に出力する内容を定義
Function ProcRowBefore([int]$Row, [int]$Col, [int[]]$Widths, [string[]]$Values) { 
    return $null 
}

# 行出力する内容を定義
Function ProcRow([int]$Row, [int]$Col, [int[]]$Widths, [string[]]$Values) { 
    return $Values -join " " 
}

# 行出力の直後に出力する内容を定義
Function ProcRowAfter([int]$Row, [int]$Col, [int[]]$Widths, [string[]]$Values) {
    # １行目の下に列ヘッダを出力
    if ( $Row -gt 0 ) { return $null }
    $line = ""
    foreach ($w in $Widths) {
        $line += "-" * $w + " "
    }
    return $line
}

# 処理後に出力する内容を定義
Function ProcFooter([int[]]$Widths) { return $null }
