# 
# CreateSqlInserts.ps1
#
# - DBのテーブル・カラム情報に基づいてインサート可能なSQL文を生成する。
# - 多様なDBでの使用を想定し、接続情報はODBCデータソースから取得する前提
# - ANSI/ISO準拠のカタログであるINFORMATION_SCHEMAからテーブル・カラム情報を取得
#
$ErrorActionPreference = "Stop"

# SQL文の出力先ファイル名
$filename = "dummy_insert.sql"

# 接続文字列
# - "ODBCデータソース"を開き、データソース(DSN)を追加している前提
$connStr = "DSN=sqlserver_local;"

# 処理対象外のテーブル名
$skipTables = @(
    "m_dbtypes_other", "skip_table1"
)
# カラム名に基づいて決定する値
$valueByColumn = @{
    "created_by" = "'system'"; "created_on" = "getdate()";
    "updated_by" = "'system'"; "updated_on" = "getdate()"
}
# カラム型に基づいて決定する値
# - 値から型を推測できるよう各型で固有の値を指定
# - SQL Server 2019を想定した型一覧
$valueByType = @{
    "int" = "1"; "bit" = "2"; "tinyint" = "3"; "smallint" = "4"; "bigint" = "5";
    "smallmoney" = "6"; "money" = "7";
     "numeric" = "8"; "decimal" = "9";
    "float" = "0.1"; "real" = "0.2";
    "date" = "'2001-01-01'"; "datetime" = "'2002-02-02'"; "datetime2" = "'2003-03-03'";
    "datetimeoffset" = "'2004-04-04'"; "smalldatetime" = "'2005-05-05'";
    "time"="'2006-06-06'";
    "char" = "'c'"; "varchar" = "'v'"; "text" = "'t'";
    "nchar" = "N'c'"; "nvarchar" = "N'v'"; "ntext" = "N't'";
    "binary" = "0xbb"; "varbinary" = "0xbbbb";
    "uniqueidentifier" = "newid()"; 
}

# ファイル出力関数の宣言
function Write-Result($msg)
{
    Write-Output $msg | Out-File $fullpath -Append -Encoding utf8 # UTF8(BOM)
}

# DB接続
$conn = New-Object System.Data.Odbc.OdbcConnection($connStr)
$conn.open()

# テーブル一覧の取得
# https://learn.microsoft.com/ja-jp/sql/relational-databases/system-information-schema-views/tables-transact-sql?view=sql-server-ver15
$tableListSql = "select TABLE_NAME from INFORMATION_SCHEMA.TABLES order by TABLE_NAME"
$tableListCmd = New-Object System.Data.Odbc.OdbcCommand
$tableListCmd.Connection = $conn
$tableListCmd.CommandText = $tableListSql
$tableListReader = $tableListCmd.ExecuteReader()
$tableList = @()
while($tableListReader.Read()) {
  $tableList += $tableListReader["TABLE_NAME"].ToString()
}
$tableListReader.Dispose()
if( $tableList.Count -le 0 ){
    Write-Host "no target tables"
    exit
}

# 出力先ファイルの初期化(空で上書き)
New-Item $filename -Force | Out-Null
$fullpath = Resolve-Path $filename

# truncate文の出力
$tableList | foreach { Write-Result("-- truncate table [$_];") }

# テーブル毎にカラム一覧を処理
Write-Host "output file  : $fullpath"
Write-Host "total tables : $($tableList.Length)"
Write-Result("")
$outputCount = 0
foreach($table in $tableList) {
    
    # 対象外はスキップ
    if( $skipTables.Contains($table) )
    {
        continue;
    }

    # カラム一覧の取得
    # https://learn.microsoft.com/ja-jp/sql/relational-databases/system-information-schema-views/columns-transact-sql?view=sql-server-ver15
    $colListSql =
        "select *, COLUMNPROPERTY(object_id(TABLE_SCHEMA+'.'+TABLE_NAME), COLUMN_NAME, 'IsIdentity') as _IS_IDENTITY " + `
        "from INFORMATION_SCHEMA.COLUMNS " + `
        "where TABLE_NAME = '$table' " + `
        "order by ORDINAL_POSITION"
    $colListCmd = New-Object System.Data.Odbc.OdbcCommand
    $colListCmd.Connection = $conn
    $colListCmd.CommandText = $colListSql
    $colListReader = $colListCmd.ExecuteReader()

    # カラム情報に基づいてダミー値を設定
    $cols = @(); $vals = @()
    while($colListReader.Read()) {
        $colName = $colListReader["COLUMN_NAME"].ToString()
        $colType = $colListReader["DATA_TYPE"].ToString()
        $isNullable = $colListReader["IS_NULLABLE"].ToString() -eq "YES"
        $isIdentity = $colListReader["_IS_IDENTITY"].ToString() -eq "1"
        $val = $null

        # 業務要件に合わせて出力値を編集してください！！！！！
        if( $isIdentity ){
            # Identity属性がある列は自動採番ためスキップ
            Write-Host "skip identity column: $table.$colName"
            continue;
        } elseif( $valueByColumn.Contains($colName) ){
            # 特定カラムは固定値を出力
            $val = $valueByColumn[$colName];
        } elseif( $isNullable ){
            # null許容型カラムの場合はnullを出力
            $val = "null"
        } else {
            # null非許容型カラムの場合は型に応じたダミー値を出力
            $val = $valueByType[$colType]
        }

        # 値が定まらなかった場合は警告出力
        if( $null -eq $val -or $val -eq "" ){
            Write-Warning "unknown type: $table.$colName($colType)"
            $val = "/* UNKNOWN: $colName($colType) */"
        }

        $cols += "[$colName]"; $vals += $val
    }
    $colListReader.Dispose();

    # INSERT文を組み立ててファイルに出力
    $colsStr = $cols -join ", "; $valsStr = $vals -join ", "
    $insert = `
        "insert into [$table] ($colsStr) VALUES `r`n" + `
        "    ($valsStr);"
    Write-Result($insert)
    $outputCount++
}
$conn.Dispose()

# 検証用selectの出力
#Write-Result("")
#$tableList | foreach { Write-Result("-- select count(1) from [$_];") }

Write-Host "generated sql: $outputCount"
