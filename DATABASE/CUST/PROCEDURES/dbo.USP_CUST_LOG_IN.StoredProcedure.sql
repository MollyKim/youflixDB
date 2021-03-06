USE [CUST]
GO
/****** Object:  StoredProcedure [dbo].[USP_CUST_LOG_IN]    Script Date: 2021-03-23 오전 11:48:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-------------------------------------------------------------------------------------------
-- 프로시져명 : USP_CUST_LOG_IN
-- 내      용 : 고객 로그인
-- 작  성  일 : 2021-02-03  
-- 작  성  자 : 김 명 희  
-- EXEC USP_CUST_LOG_IN  'test@test.com', 'hashedpassword'
-- 이       력 :  
-------------------------------------------------------------------------------------------

CREATE PROC [dbo].[USP_CUST_LOG_IN]
	@CUST_EMAIL VARCHAR(50),
	@PASSWORD CHAR(64)
AS
DECLARE @SESSION_ID CHAR(64)
DECLARE @SESSION_KEY CHAR(40)
DECLARE @SESSION_STATE CHAR(1)
BEGIN 
	IF EXISTS (SELECT CUST_EMAIL,PASSWORD FROM dbo.CUST WHERE (CUST_EMAIL = @CUST_EMAIL AND PASSWORD = @PASSWORD)) 
		BEGIN
			SET @SESSION_KEY = 'YOUF'+(SELECT CONVERT(VARCHAR,GETDATE(),121))+@CUST_EMAIL
			SET @SESSION_ID = TRY_CONVERT(VARCHAR(64),HASHBYTES('SHA2_256',@SESSION_KEY), 2)

			INSERT INTO dbo.SESSION_LOG (CUST_EMAIL,SESSION_ID,SESSION_STATE,CREATED_AT)
				VALUES (@CUST_EMAIL,@SESSION_ID,1,GETDATE())

			IF(@@ROWCOUNT = 1)
				SELECT @SESSION_ID AS SESSION_ID
			
			
			
		END
		
	ELSE
		SELECT '' AS SESSION_ID
END


GO
