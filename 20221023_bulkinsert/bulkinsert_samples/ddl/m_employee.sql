/****** Object:  Table [dbo].[m_employee]    Script Date: 2022/10/22 12:40:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[m_employee](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](256) NOT NULL,
	[address] [nvarchar](2048) NULL,
	[gender] [tinyint] NULL,
	[retired] [bit] NOT NULL,
	[birthday] [datetime2](7) NOT NULL,
	[internal_id] [uniqueidentifier] NULL,
	[created_by] [varchar](128) NOT NULL,
	[created_on] [datetime2](7) NOT NULL,
	[updated_by] [varchar](128) NOT NULL,
	[updated_on] [datetime2](7) NOT NULL,
	[version] [timestamp] NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[m_employee] ADD  DEFAULT ((0)) FOR [retired]
GO

