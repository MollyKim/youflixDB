USE [CUST]
GO
/****** Object:  StoredProcedure [dbo].[USP_CUST_LOG_OUT]    Script Date: 2021-03-23 오전 11:48:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-------------------------------------------------------------------------------------------
-- 프로시져명 : USP_CUST_LOG_OUT
-- 내      용 : 고객 로그아웃
-- 작  성  일 : 2021-02-15 
-- 작  성  자 : 김 명 희  
-- EXEC USP_CUST_LOG_OUT  'ACAF914D4D6608481B97269D8C6D32063DFE588DFD4BFD9FD000BF9A2DD06BDA',@OUTPUT OUTPUT
-- 이       력 : 
-------------------------------------------------------------------------------------------


CREATE PROC [dbo].[USP_CUST_LOG_OUT]
	@SESSION_ID CHAR(64),
	@RES CHAR(3) OUTPUT
AS
BEGIN
		UPDATE dbo.SESSION_LOG SET SESSION_STATE = 0 WHERE SESSION_ID = @SESSION_ID
		IF(@@ROWCOUNT = 0  )
			SET @RES = 401
		ELSE 
			SET @RES = 200
	RETURN @RES
END
GO
