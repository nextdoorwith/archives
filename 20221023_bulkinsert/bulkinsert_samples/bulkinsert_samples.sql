
truncate table m_employee;

-- ���������� ��{�I�ȃN�G��

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


-- ���������� ���̑��T���v��

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

-- NG: "�����N �T�[�o�[ "(null)" �� OLE DB �v���o�C�_�[ "BULK" ����K�v�ȃC���^�[�t�F�C�X ("IID_IColumnsInfo") ���擾�ł��܂���B"
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

-- NG: "CSV �f�[�^ �t�@�C�� filename.csv �̗�l�������ł��邽�߁A�ꊇ�ǂݍ��݂����s���܂����B"
BULK INSERT m_employee
FROM 'C:\bulkinsert_samples\csv\t_employee_data_toofew.csv'
WITH ( FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',');
BULK INSERT m_employee
FROM 'C:\bulkinsert_samples\csv\t_employee_data_toomany.csv'
WITH ( FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',');
BULK INSERT m_employee
FROM 'C:\bulkinsert_samples\csv\t_employee_newline_lf_2rows_noheader.csv'
WITH ( FORMAT = 'CSV', FIELDTERMINATOR = ',');

-- NG: "(column_name) �̈ꊇ�ǂݍ��݃f�[�^�ϊ��G���[ (�^�̕s��v�܂��͎w�肳�ꂽ�R�[�h�y�[�W�ł͖����ȕ���)�B"
BULK INSERT m_employee
FROM 'C:\bulkinsert_samples\csv\t_employee_value_invalid.csv'
WITH ( FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',');
