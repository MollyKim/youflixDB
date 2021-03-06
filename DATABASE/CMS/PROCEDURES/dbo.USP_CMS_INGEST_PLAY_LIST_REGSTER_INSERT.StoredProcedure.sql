USE [CMS]
GO
/****** Object:  StoredProcedure [dbo].[USP_CMS_INGEST_PLAY_LIST_REGSTER_INSERT]    Script Date: 2021-03-23 오전 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-------------------------------------------------------------------------------------------
-- 프로시져명 : USP_CMS_INGEST_PLAY_LIST_REGSTER_INSERT
-- 내      용 : 입수자동화 서버 비디오 입수
-- 작  성  일 : 2021-02-09
-- 작  성  자 : 조 준 희
-- EXEC USP_CMS_INGEST_PLAY_LIST_REGSTER_INSERT '', '', ''
-------------------------------------------------------------------------------------------

CREATE  PROC [dbo].[USP_CMS_INGEST_PLAY_LIST_REGSTER_INSERT]
  @YOUTUBER_ID CHAR(24)
 ,@TITLE VARCHAR(200)
 ,@PLAY_LIST_ID VARCHAR(34)
AS

BEGIN
	INSERT INTO YOUTUBER_PLAY_LIST(  YOUTUBER_ID
						, PLAY_LIST_ID
						, USE_YN
						, CREATED_AT
						, PLAY_LIST_TITLE
						)
   VALUES ( @YOUTUBER_ID
		  , @PLAY_LIST_ID
		  , 'Y'
		  , GETDATE()
		  , @TITLE
		 )
END
GO
