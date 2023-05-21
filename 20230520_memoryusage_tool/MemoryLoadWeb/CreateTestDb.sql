--
-- CreateTestDb.sql
--   動作確認用のデータベースとテーブルを作成します。
--

USE master;
GO

CREATE DATABASE Test COLLATE Japanese_CI_AS;  
GO  

USE Test;
GO

CREATE TABLE [dbo].[Employee](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
	[Department] [varchar](4) NOT NULL,
	[Address] [nvarchar](1024) NOT NULL,
	[BirthDay] [datetime2](7) NOT NULL,
    PRIMARY KEY CLUSTERED (	[Id] ASC)
) ON [PRIMARY]
GO

SELECT COUNT(*) FROM Employee;

