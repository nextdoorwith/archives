/****** Object:  Table [dbo].[m_dbtypes]    Script Date: 2022/10/24 21:58:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[m_dbtypes](
	[n1] [int] NOT NULL,
	[n2] [bit] NOT NULL,
	[n3] [tinyint] NOT NULL,
	[n4] [smallint] NOT NULL,
	[n5] [bigint] NOT NULL,
	[n6] [smallmoney] NOT NULL,
	[n7] [money] NOT NULL,
	[n8] [numeric](18, 0) NOT NULL,
	[n9] [decimal](18, 0) NOT NULL,
	[f1] [float] NOT NULL,
	[f2] [real] NOT NULL,
	[d1] [date] NOT NULL,
	[d2] [datetime] NOT NULL,
	[d3] [datetime2](7) NOT NULL,
	[d4] [datetimeoffset](7) NOT NULL,
	[d5] [smalldatetime] NOT NULL,
	[d6] [time](7) NOT NULL,
	[s1] [char](10) NOT NULL,
	[s2] [varchar](50) NOT NULL,
	[s3] [text] NOT NULL,
	[u1] [nchar](10) NOT NULL,
	[u2] [nvarchar](50) NOT NULL,
	[u3] [ntext] NOT NULL,
	[b1] [binary](50) NOT NULL,
	[b2] [varbinary](50) NOT NULL,
	[o4] [uniqueidentifier] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[m_dbtypes_other]    Script Date: 2022/10/24 21:58:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[m_dbtypes_other](
	[id] [int] NOT NULL,
	[o1] [image] NOT NULL,
	[o2] [geometry] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[m_employee]    Script Date: 2022/10/24 21:58:22 ******/
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
