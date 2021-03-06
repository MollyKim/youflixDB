USE [CUST]
GO
/****** Object:  StoredProcedure [dbo].[USP_CUST_PASSWORD_CHANGE]    Script Date: 2021-03-23 오전 11:48:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-------------------------------------------------------------------------------------------
-- 프로시져명 : USP_CUST_PASSWORD_CHANGE
-- 내      용 : 고객 비밀번호 변경
-- 작  성  일 : 2021-03-21  
-- 작  성  자 : 김 명 희  
-- EXEC USP_CUST_PASSWORD_CHANGE  'test@test.com', 'password', @RESULT OUTPUT
-- 이       력 :
-------------------------------------------------------------------------------------------


CREATE PROC [dbo].[USP_CUST_PASSWORD_CHANGE] 
	@CUST_EMAIL VARCHAR(50),
	@PASSWORD CHAR(64),
	@RES CHAR(3) OUTPUT
AS
BEGIN
		UPDATE dbo.CUST SET [PASSWORD] = @PASSWORD WHERE CUST_EMAIL = @CUST_EMAIL
	 IF( @@ROWCOUNT = 1  )
         SET @RES = 200
      ELSE
         SET @RES = 400

	RETURN @RES
END


GO
