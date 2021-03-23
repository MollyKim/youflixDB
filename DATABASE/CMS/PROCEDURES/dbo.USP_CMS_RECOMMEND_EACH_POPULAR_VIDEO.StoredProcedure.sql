USE [CMS]
GO
/****** Object:  StoredProcedure [dbo].[USP_CMS_RECOMMEND_EACH_POPULAR_VIDEO]    Script Date: 2021-03-23 오전 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-------------------------------------------------------------------------------------------
-- 프로시저명 : USP_CMS_RECOMMEND_EACH_POPULAR_VIDEO
-- 내      용 : 유저의 타입별 인기있는 비디오 추천
-- 작  성  일 : 2021-03-08
-- 작  성  자 : 김 명 희  
-- EXEC USP_CMS_RECOMMEND_EACH_POPULAR_VIDEO  '22', '1'
-- 이       력 : 
-------------------------------------------------------------------------------------------
CREATE PROC [dbo].[USP_CMS_RECOMMEND_EACH_POPULAR_VIDEO]
	@VIDEO_TYPE CHAR(2),
	@START INT
AS
 
BEGIN
	SELECT * 
	FROM (
	SELECT ROW_NUMBER() OVER(ORDER BY CNT DESC) AS ROWNUM
		   , * 
	FROM ( SELECT YPL.PLAY_LIST_TITLE AS TITLE
				, s.CNT
				, s.VIDEO_LENGTH
				, s.IS_SUB_YN
				, s.[DESCRIPTION]
				, s.VIDEO_URL
				, dbo.FN_GET_VIDEO_TYPE_NAME(200, s.VIDEO_TYPE) AS VIDEO_TYPE_NAME
				, s.PICTURE_URL
				, s.TAGS
				, s.KIDS_YN
			FROM (  
			SELECT * FROM (
				SELECT  V.TITLE
						, V.SUB_PLAY_LIST
						, V.VIDEO_TYPE
						, WV.CNT
						, V.VIDEO_LENGTH
						, WV.IS_SUB_YN
						, V.[DESCRIPTION]
						, V.VIDEO_URL
						, V.PICTURE_URL
						, V.TAGS
						, V.KIDS_YN
						, ROW_NUMBER() OVER ( PARTITION BY V.SUB_PLAY_LIST ORDER BY V.CREATED_AT DESC ) AS 'RK'
					FROM ( SELECT V.SUB_PLAY_LIST
							 , COUNT(V.SUB_PLAY_LIST) AS 'CNT'
							 , 'Y' AS 'IS_SUB_YN'
							FROM CUST.dbo.CUST_WATCHING W
							INNER JOIN VIDEO V ON W.VIDEO_ID = V.VIDEO_ID
								WHERE V.VIDEO_TYPE = @VIDEO_TYPE
										AND ISNULL(V.SUB_PLAY_LIST,'') != ''
								GROUP BY V.SUB_PLAY_LIST
								--ORDER BY CNT DESC
						 ) WV
					LEFT JOIN VIDEO V
					ON V.SUB_PLAY_LIST = WV.SUB_PLAY_LIST
					 ) a
				WHERE RK = 1
			)s
		LEFT JOIN YOUTUBER_PLAY_LIST YPL
		ON s.SUB_PLAY_LIST = YPL.PLAY_LIST_ID

	UNION

		SELECT  V.TITLE AS TITLE
			   , WV.CNT
			   , V.VIDEO_LENGTH
			   , WV.ISSUB_YN
			   , V.[DESCRIPTION]
			   , V.VIDEO_URL
			   , dbo.FN_GET_VIDEO_TYPE_NAME(200, V.VIDEO_TYPE) AS VIDEO_TYPE_NAME
			   , V.PICTURE_URL
			   , V.TAGS
			   , V.KIDS_YN
		  FROM( 
			SELECT  W.VIDEO_ID
					, V.VIDEO_TYPE
					, COUNT (W.VIDEO_ID) AS 'CNT' 
					,'N' AS 'ISSUB_YN'
			FROM CUST.dbo.CUST_WATCHING W  
				INNER JOIN VIDEO V
				ON W.VIDEO_ID = V.VIDEO_ID
			WHERE V.VIDEO_TYPE = @VIDEO_TYPE
				AND ISNULL(V.SUB_PLAY_LIST,'') = ''
			GROUP BY W.VIDEO_ID,  V.VIDEO_TYPE
			) WV
			LEFT JOIN VIDEO V
			 ON WV.VIDEO_ID = V.VIDEO_ID

	)u
	)K
	WHERE ROWNUM BETWEEN ((@START-1)*7)+1 AND (@START*7)

	



	
END
GO
