USE [CMS]
GO
/****** Object:  Table [dbo].[YOUTUBER_PLAY_LIST]    Script Date: 2021-03-22 오후 6:16:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[YOUTUBER_PLAY_LIST](
	[YOUTUBER_ID] [char](24) NOT NULL,
	[PLAY_LIST_ID] [char](34) NOT NULL,
	[USE_YN] [char](1) NOT NULL,
	[CREATED_AT] [datetime] NOT NULL,
	[PLAY_LIST_TITLE] [varchar](200) NOT NULL,
 CONSTRAINT [PLAY_LIST_ID] PRIMARY KEY NONCLUSTERED 
(
	[PLAY_LIST_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[YOUTUBER_PLAY_LIST] ADD  CONSTRAINT [DF__YOUTUBER___USE_Y__5441852A]  DEFAULT ('Y') FOR [USE_YN]
GO
