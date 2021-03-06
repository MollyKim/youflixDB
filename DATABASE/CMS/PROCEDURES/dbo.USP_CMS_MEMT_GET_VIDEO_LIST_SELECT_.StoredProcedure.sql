USE [CMS]
GO

/****** Object:  StoredProcedure [dbo].[USP_CMS_MGMT_GET_VIDEO_LIST_SELECT]    Script Date: 2021-04-09 오후 5:39:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*
 검색 조건들 : *생성시간, VIDEO_ID, TITLE, 유투버 이름, 태그, 페이징
 결과 : VIDEO_ID, TITLE, VIDEO_TYPE, 유튜버 이름, VIDEO_URL, KIDS_YN, PLAY_YN 을
 ORDER BY CREATED DESC 로
*/

-- 프로시저명 : USP_CMS_MGMT_GET_VIDEO_LIST_SELECT
-- 내      용 : 운영관리 비디오 조회 프로시저
-- 작  성  일 : 2021-04-06
-- 작  성  자 : 조 준 희
-- EXEC USP_CMS_MGMT_GET_VIDEO_LIST_SELECT  '2021-01-01', '2021-04-30', 1, 15, '', '', '',''
-- 이       력 : 
-------------------------------------------------------------------------------------------
CREATE PROC [dbo].[USP_CMS_MGMT_GET_VIDEO_LIST_SELECT]
	  @START_DT VARCHAR(10)
	, @END_DT VARCHAR(10)
	, @START_NUM INT
	, @END_NUM INT
	, @VIDEO_ID VARCHAR(11)
	, @VIDEO_TITLE VARCHAR(200)
	, @YOUTUBRT_NAME VARCHAR(50)
	, @TAGS VARCHAR(100)
AS

SELECT NUM
	   , VIDEO_ID
	   , TITLE
	   , VIDEO_TYPE
	   , YOUTUBER_NAME
	   , VIDEO_URL
	   , KIDS_YN
	   , PLAY_YN
  FROM(
		SELECT ROW_NUMBER( ) OVER ( ORDER BY V.CREATED_AT DESC ) AS NUM
		      , V.VIDEO_ID
			  , CASE ISNULL(SPL.SUB_PLAY_LIST,'''')  
					WHEN '''' THEN V.TITLE
					ELSE YPL.PLAY_LIST_TITLE
				 END AS TITLE
			  , dbo.FN_GET_VIDEO_TYPE_NAME(200,V.VIDEO_TYPE) AS VIDEO_TYPE
			  , Y.YOUTUBER_NAME
			  , V.VIDEO_URL
			  , V.KIDS_YN
			  , V.PLAY_YN
		  FROM VIDEO V
		  LEFT JOIN YOUTUBER Y 
			ON V.YOUTUBER_ID = Y.YOUTUBER_ID
		  LEFT JOIN SUB_PLAY_LIST SPL
		    ON V.VIDEO_ID = SPL.VIDEO_ID
		  LEFT JOIN YOUTUBER_PLAY_LIST YPL
		    ON SPL.SUB_PLAY_LIST = YPL.PLAY_LIST_ID 
		 WHERE @START_DT + ' 00:00:00' <= V.CREATED_AT AND V.CREATED_AT <= @END_DT+ ' 23:59:59'
		       AND ( @VIDEO_ID = '' OR V.VIDEO_ID = @VIDEO_ID)
			   AND ( @VIDEO_TITLE = '' OR  TITLE LIKE '%'+ @VIDEO_TITLE + '%')
			   AND ( @YOUTUBRT_NAME = '' OR Y.YOUTUBER_NAME LIKE '%'+ @YOUTUBRT_NAME + '%')
			   AND ( @TAGS = '' OR	V.TAGS LIKE '%'+ @TAGS + '%')
		)a
 WHERE NUM BETWEEN @START_NUM AND @END_NUM
GO

