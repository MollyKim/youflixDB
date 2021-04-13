USE [CMS]
GO

/****** Object:  StoredProcedure [dbo].[USP_CMS_TOP_TEN]    Script Date: 2021-04-13 오후 4:27:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-------------------------------------------------------------------------------------------
/*						
TITLE / CNT / VIDEO_LENGTH / ISSUB_YN  / [DESCRIPTION]  /  VIDEO_URL  /  VIDEO_TYPE  /  PICTURE_URL / TAGS  /  KIDS_YN
*/
-- 프로시저명 : USP_CMS_TOP_TEN
-- 내      용 : 전날 많이 시청된 동영상 TOP 10 가져오기
-- 작  성  일 : 2021-04-01 
-- 작  성  자 : 김 명 희  
-- EXEC USP_CMS_TOP_TEN
-- 이       력 : 
-------------------------------------------------------------------------------------------
CREATE PROC [dbo].[USP_CMS_TOP_TEN]
AS  
SET NOCOUNT ON;  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;   
DECLARE @YESTERDAY VARCHAR(10)

BEGIN
SET @YESTERDAY = CONVERT(VARCHAR(10), DATEADD(D,-1,GETDATE()), 120)

	SELECT CASE ISNULL(SPL.SUB_PLAY_LIST,'')  
             WHEN '' THEN   V.TITLE
             ELSE YPL.PLAY_LIST_TITLE
         END AS TITLE
		 , CW.CNT
         , V.VIDEO_ID
         , V.VIDEO_LENGTH
         , CASE ISNULL(SPL.SUB_PLAY_LIST,'')  
             WHEN '' THEN   'N'
             ELSE 'Y'
             END AS ISSUB_YN
         , V.[DESCRIPTION]
         , V.VIDEO_URL
         , dbo.FN_GET_VIDEO_TYPE_NAME(200, V.VIDEO_TYPE) AS VIDEO_TYPE_NAME
         , V.PICTURE_URL
         , V.TAGS
         , V.KIDS_YN
	FROM (
		SELECT TOP 10  W.VIDEO_ID
					, COUNT (W.VIDEO_ID) AS 'CNT'
		FROM CUST.dbo.CUST_WATCHING W  
		INNER JOIN VIDEO V
		ON V.VIDEO_ID = W.VIDEO_ID
		WHERE  @YESTERDAY + ' 00:00:00.000' <= W.CREATED_AT 
			AND  W.CREATED_AT <= @YESTERDAY + ' 23:59:59.999'
		GROUP BY W.VIDEO_ID
		ORDER BY CNT DESC
	) CW
	INNER JOIN VIDEO V
	ON V.VIDEO_ID = CW.VIDEO_ID
	LEFT JOIN SUB_PLAY_LIST SPL
    ON V.VIDEO_ID = SPL.VIDEO_ID
    LEFT JOIN YOUTUBER_PLAY_LIST YPL
    ON SPL.SUB_PLAY_LIST = YPL.PLAY_LIST_ID

END
GO

