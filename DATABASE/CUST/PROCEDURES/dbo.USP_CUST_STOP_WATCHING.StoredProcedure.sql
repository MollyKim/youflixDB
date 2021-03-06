USE [CUST]
GO
/****** Object:  StoredProcedure [dbo].[USP_CUST_STOP_WATCHING]    Script Date: 2021-03-23 오전 11:48:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-------------------------------------------------------------------------------------------
-- 프로시져명 : USP_CUST_STOP_WATCHING
-- 내      용 : 고객 시청 종료시
-- 작  성  일 : 2021-02-08  
-- 작  성  자 : 김 명 희  
-- EXEC USP_CUST_STOP_WATCHING 'test@test.com', 1250
-- 이       력 :
-------------------------------------------------------------------------------------------

CREATE PROC [dbo].[USP_CUST_STOP_WATCHING]
	@SESSION_ID CHAR(64),
	@VIDEO_ID CHAR(11),
	@JUMP_POIINT INT
AS
BEGIN
	UPDATE CUST_WATCHING SET JUMP_POINT = @JUMP_POIINT WHERE VIDEO_ID = @VIDEO_ID AND SESSION_ID = @SESSION_ID 
END
GO
