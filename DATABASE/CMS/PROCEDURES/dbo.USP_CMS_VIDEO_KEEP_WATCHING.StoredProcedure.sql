USE [CMS]
GO

/****** Object:  StoredProcedure [dbo].[USP_CMS_VIDEO_KEEP_WATCHING]    Script Date: 2021-04-13 오후 4:27:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-------------------------------------------------------------------------------------------
-- 프로시져명 : USP_CMS_VIDEO_KEEP_WATCHING
-- 내      용 : 시청중인 콘텐츠
-- 작  성  일 : 2021-03-03 
-- 작  성  자 : 김 명 희  
-- EXEC USP_CMS_VIDEO_KEEP_WATCHING  'test@test.com'
-- 이       력 : 시리즈물인경우 123화 보면 123화 전부 각각 시청중인 기록에 남는지 여부
-------------------------------------------------------------------------------------------

CREATE PROC [dbo].[USP_CMS_VIDEO_KEEP_WATCHING]
	@CUST_EMAIL VARCHAR(50)
AS  
SET NOCOUNT ON;  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;  
 
BEGIN
	IF EXISTS( SELECT CUST_EMAIL  
				FROM CUST.dbo.CUST_WATCHING 
				WHERE CUST_EMAIL = @CUST_EMAIL 
			 )
	BEGIN
	

		SELECT TITLE
				, a.VIDEO_LENGTH
				, a.JUMP_POINT
				, a.ISSUB_YN
				, a.[DESCRIPTION]
				, a.VIDEO_URL
				, a.VIDEO_TYPE_NAME
				, a.PICTURE_URL
				, a.TAGS
				, a.KIDS_YN
				, a.CREATED_AT
		FROM (
			SELECT CASE ISNULL(SPL.SUB_PLAY_LIST,'')
					WHEN '' THEN V.TITLE
					ELSE YPL.PLAY_LIST_TITLE
					END AS 'TITLE'
				 , V.VIDEO_LENGTH
				 , CW.JUMP_POINT
				 , CASE ISNULL(SPL.SUB_PLAY_LIST,'')  
					 WHEN '' THEN   'N'
					 ELSE 'Y'
					 END AS ISSUB_YN
				 , V.[DESCRIPTION]
				 , V.VIDEO_URL
				 , CMS.dbo.FN_GET_VIDEO_TYPE_NAME(200, V.VIDEO_TYPE) AS VIDEO_TYPE_NAME
				 , V.PICTURE_URL
				 , V.TAGS
				 , V.KIDS_YN
				 , CW.CREATED_AT
				 , ROW_NUMBER() OVER (PARTITION BY V.VIDEO_ID ORDER BY CW.CREATED_AT DESC) AS 'RK'
			FROM CUST.dbo.CUST_WATCHING CW
			 INNER JOIN VIDEO V
			 ON CW.VIDEO_ID = V.VIDEO_ID
			 LEFT JOIN SUB_PLAY_LIST SPL
			 ON SPL.VIDEO_ID = V.VIDEO_ID
			 LEFT JOIN YOUTUBER_PLAY_LIST YPL
			 ON YPL.PLAY_LIST_ID = SPL.SUB_PLAY_LIST
			WHERE CUST_EMAIL = @CUST_EMAIL	
				  AND V.VIDEO_LENGTH != CW.JUMP_POINT
			) a
			WHERE RK = 1
			ORDER BY a.CREATED_AT DESC
	END
END

GO

