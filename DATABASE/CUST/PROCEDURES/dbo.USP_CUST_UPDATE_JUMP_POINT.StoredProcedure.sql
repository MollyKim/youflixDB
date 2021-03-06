USE [CUST]
GO
/****** Object:  StoredProcedure [dbo].[USP_CUST_UPDATE_JUMP_POINT]    Script Date: 2021-03-23 오전 11:48:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-------------------------------------------------------------------------------------------
-- 프로시져명 : USP_CUST_UPDATE_JUMP_POINT
-- 내      용 : 점프 포인트 갱신
-- 작  성  일 : 2021-03-03 
-- 작  성  자 : 김 명 희  
-- EXEC USP_CUST_UPDATE_JUMP_POINT  'test@test.com','ACAF914F4D6608481B97269D8C6D32063DFE588DFD4BFD9FD000BF9A2DD06BDA','_wJOQwEPjlE',222
-- 이       력 : created_at 의 가장 최신 
-------------------------------------------------------------------------------------------
CREATE PROC [dbo].[USP_CUST_UPDATE_JUMP_POINT]
	@CUST_EMAIL VARCHAR(50),
	@SESSION_ID VARCHAR(64),
	@VIDEO_ID CHAR(34),
	@JUMP_POINT INT
AS
DECLARE @LATEST INT

BEGIN
	SET @LATEST = ( SELECT TOP 1 ID FROM CUST_WATCHING
		WHERE CUST_EMAIL = @CUST_EMAIL 
			AND SESSION_ID = @SESSION_ID
			AND VIDEO_ID = @VIDEO_ID
		ORDER BY CREATED_AT DESC 
		)

	UPDATE CUST_WATCHING 
		SET JUMP_POINT = @JUMP_POINT
		WHERE ID = @LATEST
			
END


GO
