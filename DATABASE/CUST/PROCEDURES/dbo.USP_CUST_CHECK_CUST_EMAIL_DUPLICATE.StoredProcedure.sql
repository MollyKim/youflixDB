USE [CUST]
GO
/****** Object:  StoredProcedure [dbo].[USP_CUST_CHECK_CUST_EMAIL_DUPLICATE]    Script Date: 2021-03-23 오전 11:48:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-------------------------------------------------------------------------------------------
-- 프로시져명 : USP_CUST_CHECK_CUST_EMAIL_DUPLICATE
-- 내      용 : 고객 중복 이메일 확인
-- 작  성  일 : 2021-02-03  
-- 작  성  자 : 김 명 희  
-- EXEC USP_CUST_CHECK_CUST_EMAIL_DUPLICATE  'test@test.com', @RESULT OUTPUT
-- 이       력 :
-------------------------------------------------------------------------------------------

CREATE PROC [dbo].[USP_CUST_CHECK_CUST_EMAIL_DUPLICATE]
	@CUST_EMAIL VARCHAR(50), 
	 @RES CHAR(3) OUTPUT
	AS
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	IF EXISTS (SELECT CUST_EMAIL FROM dbo.CUST WHERE (@CUST_EMAIL = CUST_EMAIL) ) 
		SET @RES = 201
			
	ELSE 
		SET @RES = 200
RETURN @RES
GO
