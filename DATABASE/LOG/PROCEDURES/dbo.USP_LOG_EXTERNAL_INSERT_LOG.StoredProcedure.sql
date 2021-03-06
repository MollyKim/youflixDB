USE [LOG]
GO
/****** Object:  StoredProcedure [dbo].[USP_LOG_EXTERNAL_INSERT_LOG]    Script Date: 2021-03-23 오전 11:49:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-------------------------------------------------------------------------------------------
-- 프로시져명 : USP_LOG_EXTERNAL_INSERT_LOG
-- 내      용 : 외부 API 로그 생성
-- 작  성  일 : 2021-02-05  
-- 작  성  자 : 김 명 희  
-- EXEC USP_LOG_EXTERNAL_INSERT_LOG  'USP_CMS_INGEST_GET_YOUTUBERS', 'GET YOUTUBERS', '유튜버 정보 가져오기','1','1223'
-- 이       력 : 
-------------------------------------------------------------------------------------------
CREATE PROC [dbo].[USP_LOG_EXTERNAL_INSERT_LOG]
	@API_NAME VARCHAR(20),
	@API_DESCRIPTION VARCHAR(50),
	@LOG_DESCRIPTION VARCHAR(400),
	@RESULT CHAR(1),
	@ELAPSED_TIME INT
AS

BEGIN
	INSERT INTO dbo.EXTERNAL_API_LOG (API_NAME, API_DESCRIPTION, LOG_DESCRIPTION, RESULT, ELAPSED_TIME, CREATED_AT)
	 VALUES( @API_NAME,@API_DESCRIPTION, @LOG_DESCRIPTION,@RESULT,@ELAPSED_TIME,GETDATE()) 
END
GO
