USE [CMS]
GO
/****** Object:  StoredProcedure [dbo].[USP_CMS_VIDEO_KEEP_WATCHING]    Script Date: 2021-03-23 오전 11:46:30 ******/
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
 
BEGIN
	IF EXISTS( SELECT CUST_EMAIL  
				FROM CUST.dbo.CUST_WATCHING 
				WHERE CUST_EMAIL = @CUST_EMAIL 
			 )
	BEGIN
	SELECT * 
	FROM (
		SELECT YPL.PLAY_LIST_TITLE AS TITLE -- 타이틀 별로 한번 더 파티션 나눠주기
			 , s.SUB_PLAY_LIST
			 , s.VIDEO_LENGTH
			 , s.JUMP_POINT
			 , s.[DESCRIPTION]
			 , s.VIDEO_URL
			 , s.VIDEO_TYPE_NAME
			 , s.PICTURE_URL
			 , s.TAGS
			 , s.KIDS_YN
			 , s.CREATED_AT
		FROM (
		SELECT V.TITLE
				 , V.VIDEO_LENGTH
				 , CW.JUMP_POINT
				 , V.[DESCRIPTION]
				 , V.VIDEO_URL
				 , CMS.dbo.FN_GET_VIDEO_TYPE_NAME(200, V.VIDEO_TYPE) AS VIDEO_TYPE_NAME
				 , V.PICTURE_URL
				 , V.TAGS
				 , V.KIDS_YN
				 , CW.CREATED_AT
				 , V.SUB_PLAY_LIST
				 , ROW_NUMBER() OVER (PARTITION BY V.SUB_PLAY_LIST ORDER BY CW.CREATED_AT DESC) AS 'RK'
		FROM CUST.dbo.CUST_WATCHING CW
			 INNER JOIN VIDEO V
			 ON CW.VIDEO_ID = V.VIDEO_ID
			WHERE CUST_EMAIL = @CUST_EMAIL
				  AND V.VIDEO_LENGTH != CW.JUMP_POINT
				  AND ISNULL(SUB_PLAY_LIST,'') != ''
			) s
		LEFT JOIN YOUTUBER_PLAY_LIST YPL
		ON s.SUB_PLAY_LIST = YPL.PLAY_LIST_ID
		WHERE RK = 1

UNION

		SELECT a.TITLE AS TITLE
				 , 'n' AS SUB_PLAY_LIST
				 , a.VIDEO_LENGTH
				 , a.JUMP_POINT
				 , a.[DESCRIPTION]
				 , a.VIDEO_URL
				 , a.VIDEO_TYPE_NAME
				 , a.PICTURE_URL
				 , a.TAGS
				 , a.KIDS_YN
				 , a.CREATED_AT
		FROM (
			SELECT V.TITLE
				 , V.VIDEO_LENGTH
				 , CW.JUMP_POINT
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
			WHERE CUST_EMAIL = @CUST_EMAIL	
				  AND V.VIDEO_LENGTH != CW.JUMP_POINT
				  AND ISNULL(SUB_PLAY_LIST,'') = ''
			) a
			WHERE RK = 1
	) u
	ORDER BY u.CREATED_AT DESC
	END
END

GO
