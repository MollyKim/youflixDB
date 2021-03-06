USE [CMS]
GO
/****** Object:  StoredProcedure [dbo].[USP_CMS_PLAY_VIDEO]    Script Date: 2021-03-23 오전 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-------------------------------------------------------------------------------------------
-- 프로시져명 : USP_CMS_PLAY_VIDEO
-- 내      용 : 동영상 재생
-- 작  성  일 : 2021-03-08
-- 작  성  자 : 김 명 희  
-- EXEC USP_CMS_PLAY_VIDEO  'test@test.com', '_wJOQwEPjlE','ACAF914F4D6608481B97269D8C6D32063DFE588DFD4BFD9FD000BF9A2DD06BDA'
-- 이       력 : 
-------------------------------------------------------------------------------------------
CREATE PROC [dbo].[USP_CMS_PLAY_VIDEO] 
	@CUST_EMAIL VARCHAR(50),	
	@VIDEO_ID CHAR(34),	
	@SESSION_ID VARCHAR(64)
AS
 DECLARE @JUMP_POINT INT = 0
BEGIN
	 SELECT TOP 1 @JUMP_POINT = JUMP_POINT
				FROM CUST.dbo.CUST_WATCHING
				WHERE CUST_EMAIL = @CUST_EMAIL
					AND VIDEO_ID = @VIDEO_ID
				ORDER BY CREATED_AT DESC 

		INSERT 
				INTO CUST.dbo.CUST_WATCHING 
				(     CUST_EMAIL
					, VIDEO_ID
					, JUMP_POINT
					, CREATED_AT
					, SESSION_ID
				)
				VALUES 
				(	  @CUST_EMAIL
					, @VIDEO_ID
					, @JUMP_POINT
					, GETDATE()
					, @SESSION_ID
				) 

	SELECT TOP 1 CW.JUMP_POINT
		 , V.VIDEO_URL
	FROM VIDEO V
	INNER JOIN CUST.dbo.CUST_WATCHING CW
	ON V.VIDEO_ID = CW.VIDEO_ID
	WHERE CUST_EMAIL = @CUST_EMAIL 
		  AND CW.VIDEO_ID = @VIDEO_ID
	ORDER BY CW.CREATED_AT DESC
END

GO
