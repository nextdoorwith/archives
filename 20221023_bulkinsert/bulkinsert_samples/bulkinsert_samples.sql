
truncate table m_employee;

-- ★★★★★ 基本的なクエリ

BULK INSERT m_employee
FROM 'C:\bulkinsert_samples\csv\t_employee.csv'
WITH ( FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',');

BULK INSERT m_employee
FROM 'C:\bulkinsert_samples\csv\t_employee.csv'
WITH ( FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',', KEEPIDENTITY);

BULK INSERT m_employee
FROM 'C:\bulkinsert_samples\csv\t_employee_data_utf8.csv'
WITH ( FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',',
  CODEPAGE  = '65001');
BULK INSERT m_employee
FROM 'C:\bulkinsert_samples\csv\t_employee_data_utf8bom.csv'
WITH ( FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',',
  CODEPAGE  = '65001');

BULK INSERT m_employee
FROM 'C:\bulkinsert_samples\csv\t_employee_data_utf8bom_lf.csv'
WITH ( FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',',
  CODEPAGE  = '65001', ROWTERMINATOR = '0x0a');

BULK INSERT m_employee
FROM 'C:\bulkinsert_samples\csv\t_employee.tsv'
WITH ( FIRSTROW = 2);


-- ★★★★★ その他サンプル

BULK INSERT m_employee
FROM 'C:\bulkinsert_samples\csv\t_employee_citing_all.csv'
WITH ( FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',');
BULK INSERT m_employee
FROM 'C:\bulkinsert_samples\csv\t_employee_citing_part.csv'
WITH ( FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',');

BULK INSERT m_employee
FROM 'C:\bulkinsert_samples\csv\t_employee_header_various.csv'
WITH ( FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',');

BULK INSERT m_employee
FROM 'C:\bulkinsert_samples\csv\t_employee_header_various.csv'
WITH ( FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',');

BULK INSERT m_employee
FROM 'C:\bulkinsert_samples\csv\t_employee_header_nothing.csv'
WITH ( FORMAT = 'CSV', FIELDTERMINATOR = ',');

-- NG: "リンク サーバー "(null)" の OLE DB プロバイダー "BULK" から必要なインターフェイス ("IID_IColumnsInfo") を取得できません。"
BULK INSERT m_employee
FROM 'C:\bulkinsert_samples\csv\t_employee_header_toofew.csv'
WITH ( FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',');
BULK INSERT m_employee
FROM 'C:\bulkinsert_samples\csv\t_employee_header_toomany.csv'
WITH ( FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',');
BULK INSERT m_employee
FROM 'C:\bulkinsert_samples\csv\t_employee_header_toomany.csv'
WITH ( FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',');
BULK INSERT m_employee
FROM 'C:\bulkinsert_samples\csv\t_employee_newline_lf.csv'
WITH ( FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',');
BULK INSERT m_employee
FROM 'C:\bulkinsert_samples\csv\t_employee_header_utf8bom.csv'
WITH ( FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',');
BULK INSERT m_employee
FROM 'C:\bulkinsert_samples\csv\t_employee_newline_lf.csv'
WITH ( FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',');

-- NG: "CSV データ ファイル filename.csv の列値が無効であるため、一括読み込みが失敗しました。"
BULK INSERT m_employee
FROM 'C:\bulkinsert_samples\csv\t_employee_data_toofew.csv'
WITH ( FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',');
BULK INSERT m_employee
FROM 'C:\bulkinsert_samples\csv\t_employee_data_toomany.csv'
WITH ( FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',');
BULK INSERT m_employee
FROM 'C:\bulkinsert_samples\csv\t_employee_newline_lf_2rows_noheader.csv'
WITH ( FORMAT = 'CSV', FIELDTERMINATOR = ',');

-- NG: "(column_name) の一括読み込みデータ変換エラー (型の不一致または指定されたコードページでは無効な文字)。"
BULK INSERT m_employee
FROM 'C:\bulkinsert_samples\csv\t_employee_value_invalid.csv'
WITH ( FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',');
