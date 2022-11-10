
CREATE TABLE [dbo].[m_employee](
	[employee_no] [varchar](10) NOT NULL PRIMARY KEY,
	[name] [nvarchar](256) NOT NULL,
	[address] [nvarchar](1024) NULL,
	[age] [tinyint] NULL,
	[start_day] [datetime2](7) NOT NULL,
	[remark] [nvarchar](1024) NULL
) ON [PRIMARY]
GO
