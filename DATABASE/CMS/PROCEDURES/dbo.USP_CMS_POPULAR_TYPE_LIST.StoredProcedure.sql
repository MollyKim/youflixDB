USE [CMS]
GO
/****** Object:  StoredProcedure [dbo].[USP_CMS_POPULAR_TYPE_LIST]    Script Date: 2021-03-23 오전 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-------------------------------------------------------------------------------------------
-- 프로시저명 : USP_CMS_POPULAR_TYPE_LIST
-- 내      용 : 유저별 인기있는 비디오 타입 리스트
-- 작  성  일 : 2021-03-08
-- 작  성  자 : 김 명 희  
-- EXEC USP_CMS_POPULAR_TYPE_LIST  'watch@test.com'
-- 이       력 : 
-------------------------------------------------------------------------------------------
CREATE PROC [dbo].[USP_CMS_POPULAR_TYPE_LIST]
@CUST_EMAIL VARCHAR(50)
AS
 
BEGIN
	SELECT dbo.FN_GET_VIDEO_TYPE_NAME(200, V.VIDEO_TYPE) AS VIDEO_TYPE_NAME
		  , V.VIDEO_TYPE
		  , COUNT(V.VIDEO_TYPE) AS VIDEO_TYPE_COUNT
		  FROM CUST.dbo.CUST_WATCHING CW
		  INNER JOIN VIDEO V
		  ON CW.VIDEO_ID = V.VIDEO_ID
		  WHERE CW.CUST_EMAIL = @CUST_EMAIL
		  GROUP BY V.VIDEO_TYPE
		  ORDER BY VIDEO_TYPE_COUNT DESC
END
GO
