# 
# CreateSqlInserts.ps1
#
$ErrorActionPreference = "Stop"

# SQL���̏o�͐�t�@�C����
$filename = "dummy_insert.sql"

# �ڑ�������
# - "ODBC�f�[�^�\�[�X"���J���A�f�[�^�\�[�X(DSN)��ǉ����Ă���O��
$connStr = "DSN=sqlserver_local;"

# �����ΏۊO�̃e�[�u����
$skipTables = @(
    "m_dbtypes_other", "skip_table1"
)
# �J�������Ɋ�Â��Č��肷��l
$valueByColumn = @{
    "created_by" = "'system'"; "created_on" = "getdate()";
    "updated_by" = "'system'"; "updated_on" = "getdate()"
}
# �J�����^�Ɋ�Â��Č��肷��l
# - �l����^�𐄑��ł���悤�e�^�ŌŗL�̒l���w��
# - SQL Server 2019��z�肵���^�ꗗ
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

# �t�@�C���o�͊֐��̐錾
function Write-Result($msg)
{
    Write-Output $msg | Out-File $fullpath -Append -Encoding utf8 # UTF8(BOM)
}

# DB�ڑ�
$conn = New-Object System.Data.Odbc.OdbcConnection($connStr)
$conn.open()

# �e�[�u���ꗗ�̎擾
# https://learn.microsoft.com/ja-jp/sql/relational-databases/system-information-schema-views/tables-transact-sql?view=sql-server-ver15
$tableListSql = 
    "select TABLE_NAME from INFORMATION_SCHEMA.TABLES order by TABLE_NAME"
$tableListCmd = New-Object System.Data.Odbc.OdbcCommand
$tableListCmd.Connection = $conn
$tableListCmd.CommandText = $tableListSql
$tableListReader = $tableListCmd.ExecuteReader()
$tableList = @()
while($tableListReader.Read()){
    $tableName = $tableListReader["TABLE_NAME"].ToString()
    if( ! $skipTables.Contains($tableName) ){
        $tableList += $tableName
    }
}
$tableListReader.Dispose()
if( $tableList.Count -le 0 ){
    Write-Host "no target tables"
    exit
}

# �o�͐�t�@�C���̏�����(��ŏ㏑��)
New-Item $filename -Force | Out-Null
$fullpath = Resolve-Path $filename

# ���s�������R���\�[���ɏo��
Write-Host "output file   : $fullpath"
Write-Host "target tables : $($tableList.Length)"

# truncate���̏o��
$tableList | foreach { Write-Result("-- truncate table [$_];") }

# �e�[�u�����ɃJ�����ꗗ������
Write-Result("")
foreach($table in $tableList) {

    # �J�����ꗗ�̎擾
    # https://learn.microsoft.com/ja-jp/sql/relational-databases/system-information-schema-views/columns-transact-sql?view=sql-server-ver15
    $colListSql =
        "select *, " + `
            "COLUMNPROPERTY(object_id(TABLE_SCHEMA+'.'+TABLE_NAME), " + `
                "COLUMN_NAME, 'IsIdentity') as _IS_IDENTITY " + `
        "from INFORMATION_SCHEMA.COLUMNS " + `
        "where TABLE_NAME = '$table' " + `
        "order by ORDINAL_POSITION"
    $colListCmd = New-Object System.Data.Odbc.OdbcCommand
    $colListCmd.Connection = $conn
    $colListCmd.CommandText = $colListSql
    $colListReader = $colListCmd.ExecuteReader()

    # �J�������Ɋ�Â��ă_�~�[�l��ݒ�
    $cols = @(); $vals = @()
    while($colListReader.Read()) {
        $colName = $colListReader["COLUMN_NAME"].ToString()
        $colType = $colListReader["DATA_TYPE"].ToString()
        $isNullable = $colListReader["IS_NULLABLE"].ToString() -eq "YES"
        $isIdentity = $colListReader["_IS_IDENTITY"].ToString() -eq "1"
        $val = $null

        # �Ɩ��v���ɍ��킹�ďo�͒l��ҏW���Ă��������I�I�I�I�I
        if( $isIdentity ){
            # Identity�����������͎����̔Ԃ��߃X�L�b�v
            Write-Host "skip identity column: $table.$colName"
            continue;
        } elseif( $valueByColumn.Contains($colName) ){
            # ����J�����͌Œ�l���o��
            $val = $valueByColumn[$colName];
        } elseif( $isNullable ){
            # null���e�^�J�����̏ꍇ��null���o��
            $val = "null"
        } else {
            # null�񋖗e�^�J�����̏ꍇ�͌^�ɉ������_�~�[�l���o��
            $val = $valueByType[$colType]
        }

        # �l����܂�Ȃ������ꍇ�͌x���o��
        if( $null -eq $val -or $val -eq "" ){
            Write-Warning "unknown type: $table.$colName($colType)"
            $val = "/* UNKNOWN: $colName($colType) */"
        }

        $cols += "[$colName]"; $vals += $val
    }
    $colListReader.Dispose();

    # INSERT����g�ݗ��Ăăt�@�C���ɏo��
    $colsStr = $cols -join ", "; $valsStr = $vals -join ", "
    $insert = `
        "insert into [$table] ($colsStr) VALUES `r`n" + `
        "    ($valsStr);"
    Write-Result($insert)
}
$conn.Dispose()

# ���ؗpselect�̏o��
#Write-Result("")
#$tableList | foreach { Write-Result("-- select count(1) from [$_];") }

Write-Host "completed"
