USE [CUST]
GO
/****** Object:  StoredProcedure [dbo].[USP_CUST_SIGN_UP]    Script Date: 2021-03-23 오전 11:48:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-------------------------------------------------------------------------------------------
-- 프로시져명 : USP_CUST_SIGN_UP
-- 내      용 : 고객 회원가입
-- 작  성  일 : 2021-02-03  
-- 작  성  자 : 김 명 희  
-- EXEC USP_CUST_SIGN_UP  'test@test.com', 'password', @RESULT OUTPUT
-- 이       력 :
-------------------------------------------------------------------------------------------

CREATE PROC [dbo].[USP_CUST_SIGN_UP]
	@CUST_EMAIL VARCHAR(50),
	@PASSWORD CHAR(64),
	@RES CHAR(3) OUTPUT
AS
BEGIN
		INSERT INTO dbo.CUST(CUST_EMAIL,PASSWORD,CREATED_AT,UPDATED_AT) VALUES(@CUST_EMAIL,@PASSWORD,GETDATE(),NULL)
		
	 IF( @@ROWCOUNT = 1  )
         SET @RES = 200
      ELSE
         SET @RES = 400

	RETURN @RES
END
GO
