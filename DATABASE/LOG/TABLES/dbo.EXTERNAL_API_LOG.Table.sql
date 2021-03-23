USE [LOG]
GO
/****** Object:  Table [dbo].[EXTERNAL_API_LOG]    Script Date: 2021-03-23 오전 11:49:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EXTERNAL_API_LOG](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[API_NAME] [varchar](20) NOT NULL,
	[API_DESCRIPTION] [varchar](50) NULL,
	[LOG_DESCRIPTION] [varchar](2000) NULL,
	[RESULT] [char](1) NOT NULL,
	[ELAPSED_TIME] [int] NULL,
	[CREATED_AT] [datetime] NULL,
 CONSTRAINT [PK__EXTERNAL__3214EC2728820458] PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
