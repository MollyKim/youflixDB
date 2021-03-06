USE [CMS]
GO
/****** Object:  StoredProcedure [dbo].[USP_CMS_INGEST_GET_YOUTUBERS]    Script Date: 2021-03-23 오전 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-------------------------------------------------------------------------------------------
-- 프로시져명 : USP_CMS_INGEST_GET_YOUTUBERS
-- 내      용 : 입수자동화 서버 유튜버 리스트 리턴 프로시저
-- 작  성  일 : 2021-02-08
-- 작  성  자 : 조 준 희
-- EXEC USP_CMS_INGEST_GET_YOUTUBERS
-- 이       력 :
-------------------------------------------------------------------------------------------

CREATE PROC [dbo].[USP_CMS_INGEST_GET_YOUTUBERS]
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

BEGIN
	SELECT YOUTUBER_ID 
		   ,UPLOAD_ID
		   ,VIDEO_UPDATED_AT
		   ,PLAY_LIST_UPDATED_AT
	FROM YOUTUBER
END
GO
