USE [CMS]
GO
/****** Object:  StoredProcedure [dbo].[USP_CMS_INGEST_GET_YOUTUBER_PLAY_LIST]    Script Date: 2021-03-23 오전 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-------------------------------------------------------------------------------------------
-- 프로시져명 : USP_CMS_INGEST_GET_YOUTUBERS
-- 내      용 : 입수자동화 서버 유튜버 플레이 리스트 
-- 작  성  일 : 2021-03-15
-- 작  성  자 : 조 준 희
-- EXEC USP_CMS_INGEST_GET_YOUTUBER_PLAY_LIST
-- 이       력 :
-------------------------------------------------------------------------------------------

CREATE PROC [dbo].[USP_CMS_INGEST_GET_YOUTUBER_PLAY_LIST]
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

BEGIN
	SELECT PLAY_LIST_ID
	FROM YOUTUBER_PLAY_LIST
END
GO
