USE [CUST]
GO
/****** Object:  StoredProcedure [dbo].[USP_CUST_SESSION_CHECK]    Script Date: 2021-03-23 오전 11:48:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-------------------------------------------------------------------------------------------
-- 프로시져명 : USP_CUST_SESSION_CHECK
-- 내      용 : 고객 로그인 여부 체크
-- 작  성  일 : 2021-02-05 
-- 작  성  자 : 김 명 희  
-- EXEC USP_CUST_SESSION_CHECK  'ACAF914D4D6608481B97269D8C6D32063DFE588DFD4BFD9FD000BF9A2DD06BDA',@OUTPUT OUTPUT
-- 이       력 :
-------------------------------------------------------------------------------------------

CREATE PROC [dbo].[USP_CUST_SESSION_CHECK]
	@SESSION_ID CHAR(64),
	@RES CHAR(3) OUTPUT
	AS
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	IF EXISTS (SELECT SESSION_ID FROM dbo.SESSION_LOG WHERE (@SESSION_ID = SESSION_ID) ) 
		SET @RES = 200
			
	ELSE 
		SET @RES = 401
RETURN @RES
GO
