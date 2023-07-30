# 表形式のハンドラの例

$MAX_WIDTH = 32     # 最大列幅

$SEP = "-"          # セパレータ(ヘッダ・データの仕切り)
$SEP_LEFT = "+"     # セパレータ行: 左側
$SEP_DIV = "+"      # セパレータ行: 列区切り
$SEP_RIGHT = "+"    # セパレータ行: 右側
$ROW_LEFT = "|"     # データ行: 左側
$ROW_DIV = "|"      # データ行: 列区切り
$ROW_RIGHT = "|"    # データ行: 右側

Function CalcColWidth([int]$Row, [int]$Col, [int]$ValueWidth) {
    # 列幅は最大列幅以下に調整
    $actual = $ValueWidth
    if ( $actual -lt $MAX_WIDTH) {
        return $actual
    }
    else {
        return $MAX_WIDTH
    }
}

Function ProcHeader([int[]]$Widths) { return $null }

Function ProcRowBefore([int]$Row, [int]$Col, [int[]]$Widths, [string[]]$Values) { return $null }

Function ProcRow([int]$Row, [int]$Col, [int[]]$Widths, [string[]]$Values) {
    return $ROW_LEFT + ($Values -join $ROW_DIV) + $ROW_RIGHT
}

Function ProcRowAfter([int]$Row, [int]$Col, [int[]]$Widths, [string[]]$Values) {
    if ( $Row -gt 0 ) { return $null }
    $sepvals = @()
    foreach ($w in $Widths) {
        $sepvals += $SEP * $w
    }
    return $SEP_LEFT + ($sepvals -join $SEP_DIV) + $SEP_RIGHT
}

Function ProcFooter([int[]]$Widths) { return $null }
