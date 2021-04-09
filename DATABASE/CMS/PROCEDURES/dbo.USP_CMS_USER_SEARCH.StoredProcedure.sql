USE [CMS]
GO

/****** Object:  StoredProcedure [dbo].[USP_CMS_USER_SEARCH]    Script Date: 2021-04-09 오후 5:37:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-------------------------------------------------------------------------------------------
/*
 검색 조건들 : *생성시간, VIDEO_ID, TITLE, 유투버 이름, 태그, 페이징
 결과 : VIDEO_ID, TITLE, VIDEO_TYPE, 유튜버 이름, VIDEO_URL, KIDS_YN, PLAY_YN 을
 ORDER BY CREATED DESC 로
*/

-- 프로시저명 : USP_CMS_USER_SEARCH
-- 내      용 : 유저의 검색에따른 비디오 조회
-- 작  성  일 : 2021-04-07
-- 작  성  자 : 김 명 희 
-- EXEC USP_CMS_USER_SEARCH  '2021-01-05', '2021-04-26', '', '리트리버', '', '', '15','30'
-- 이       력 : PRINT(CONVERT(VARCHAR(10), GETDATE(), 120))
-------------------------------------------------------------------------------------------
CREATE PROC [dbo].[USP_CMS_USER_SEARCH]
	  @START VARCHAR(10)
	, @END VARCHAR(10)
	, @VIDEO_ID VARCHAR(11)
	, @VIDEO_TITLE VARCHAR(200)
	, @YOUTUBRT_NAME VARCHAR(50)
	, @TAGS VARCHAR(1000)
	, @PAGE_START VARCHAR(4)
	, @PAGE_END VARCHAR(4)
AS
DECLARE @SQL VARCHAR(4000)
		, @SQLT VARCHAR(4000)
 
BEGIN	
	SET @SQL = ' SELECT V.VIDEO_ID
					 , CASE ISNULL(SPL.SUB_PLAY_LIST,'''')  
						WHEN '''' THEN V.TITLE
						ELSE YPL.PLAY_LIST_TITLE
						END AS VIDEO_TITLE
					 , dbo.FN_GET_VIDEO_TYPE_NAME(200,V.VIDEO_TYPE) AS VIDEO_TYPE_NAME
					 , V.VIDEO_TYPE
					 , Y.YOUTUBER_NAME
					 , V.VIDEO_URL
					 , V.KIDS_YN
					 , V.PLAY_YN
					FROM VIDEO V
					INNER JOIN YOUTUBER Y 
					ON V.YOUTUBER_ID = Y.YOUTUBER_ID
					LEFT JOIN SUB_PLAY_LIST SPL
					ON V.VIDEO_ID = SPL.VIDEO_ID
					LEFT JOIN YOUTUBER_PLAY_LIST YPL
					ON SPL.SUB_PLAY_LIST = YPL.PLAY_LIST_ID '

	SET @SQL = @SQL + 'WHERE ''' + @START + ' 00:00:00.000'' <= V.CREATED_AT
						AND V.CREATED_AT <= ''' + @END + ' 23:59:59.999'' '

	IF ISNULL(@VIDEO_ID ,'') != ''
		SET @SQL = @SQL + 'AND V.VIDEO_ID = ''' + @VIDEO_ID + ''''

	IF ISNULL(@VIDEO_TITLE ,'') != ''
		SET @SQL = @SQL + 'AND TITLE LIKE ''%' + @VIDEO_TITLE + '%'''

	IF ISNULL(@YOUTUBRT_NAME ,'') != ''
		SET @SQL = @SQL + 'AND Y.YOUTUBER_NAME LIKE''%' + @YOUTUBRT_NAME + '%'''

	IF ISNULL(@TAGS ,'') != ''
		SET @SQL = @SQL + 'AND V.TAGS LIKE ''%' + @TAGS + '%'''

	 SET @SQLT = 'ORDER BY V.CREATED_AT DESC
					OFFSET '+ @PAGE_START + ' ROWS
					FETCH NEXT ' + @PAGE_END + ' ROWS ONLY'

PRINT(@SQL + @SQLT)
EXEC (@SQL + @SQLT)

END
GO

