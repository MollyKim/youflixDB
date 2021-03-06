USE [CMS]
GO
/****** Object:  StoredProcedure [dbo].[USP_CMS_INGEST_PLAY_LIST_UPDATED_AT_UPDATE]    Script Date: 2021-03-23 오전 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-------------------------------------------------------------------------------------------
-- 프로시져명 : USP_CMS_INGEST_PLAY_LIST_UPDATED_AT_UPDATE
-- 내      용 : 입수자동화 서버 유튜버 플레이 리스트 동기화 시간 업데이트
-- 작  성  일 : 2021-02-10
-- 작  성  자 : 조 준 희
-- EXEC USP_CMS_INGEST_PLAY_LIST_UPDATED_AT_UPDATE '','2021-01-01 00:00:00'
-- 이       력 :
-------------------------------------------------------------------------------------------

CREATE PROC [dbo].[USP_CMS_INGEST_PLAY_LIST_UPDATED_AT_UPDATE]
 @YOUTUBER_ID VARCHAR(24)
 ,@PLAY_LIST_UPDATED_AT VARCHAR(19)
AS

BEGIN
	UPDATE YOUTUBER
	   SET PLAY_LIST_UPDATED_AT = @PLAY_LIST_UPDATED_AT
	 WHERE YOUTUBER_ID = @YOUTUBER_ID
END
GO
