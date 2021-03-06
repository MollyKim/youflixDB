USE [CMS]
GO
/****** Object:  StoredProcedure [dbo].[USP_CMS_INGEST_PLAY_LIST_VIDEO_INSERT]    Script Date: 2021-03-23 오전 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-------------------------------------------------------------------------------------------
-- 프로시져명 : USP_CMS_INGEST_PLAY_LIST_REGSTER_INSERT
-- 내      용 : 입수자동화 서버 플레이 리스트 비디오 동기화
-- 작  성  일 : 2021-02-09
-- 작  성  자 : 조 준 희
-- EXEC USP_CMS_INGEST_PLAY_LIST_VIDEO_INSERT '', '', ''
-------------------------------------------------------------------------------------------

CREATE  PROC [dbo].[USP_CMS_INGEST_PLAY_LIST_VIDEO_INSERT]
  @PLAY_LIST_ID CHAR(34)
 ,@VIDEO_ID VARCHAR(200)
AS

BEGIN
	INSERT INTO SUB_PLAY_LIST(  SUB_PLAY_LIST
						, VIDEO_ID
						)
   VALUES ( @PLAY_LIST_ID
		  , @VIDEO_ID
		 )
END
GO
