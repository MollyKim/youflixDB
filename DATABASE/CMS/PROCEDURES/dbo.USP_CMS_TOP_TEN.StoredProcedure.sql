USE [CMS]
GO
/****** Object:  StoredProcedure [dbo].[USP_CMS_TOP_TEN]    Script Date: 2021-03-23 오전 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-------------------------------------------------------------------------------------------
/*
1. 파티션 = SUB_PLAY_LIST /   SUB_PLAY_LIST != NUUL  /  카운트(SUB_PLAY_LIST)   => 비디오 정보 & SUB_LIST_TITLE GET
												UNION
2. 파티션 = SUB_PLAY_LIST /   SUB_PLAY_LIST == NUUL  /  카운트(VIDEO_ID)		=>  비디오 정보 GET

TITLE / CNT / ISSUB_YN  / [DESCRIPTION]  /  VIDEO_URL  /  VIDEO_TYPE  /  PICTURE_URL / TAGS  /  KIDS_YN

*/
-- 프로시저명 : USP_CMS_TOP_TEN
-- 내      용 : 전날 많이 시청된 동영상 TOP 10 가져오기
-- 작  성  일 : 2021-02-25  
-- 작  성  자 : 김 명 희  
-- EXEC USP_CMS_TOP_TEN
-- 이       력 : (03.04 오류 발견) CNT / ISSUB_YN 를 제외한 열이 NULL로 출력됨
-------------------------------------------------------------------------------------------
CREATE PROC [dbo].[USP_CMS_TOP_TEN]
AS 
DECLARE @YESTERDAY VARCHAR(10)

BEGIN
SET @YESTERDAY = CONVERT(VARCHAR(10), DATEADD(D,-1,GETDATE()), 120)

SELECT TOP 10 *
	FROM(
	SELECT YPL.PLAY_LIST_TITLE AS TITLE
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
					FROM ( -- 시청이력에서 어제날짜 동영상들중,
						   -- SUB_LIST가 있는 동영상 추출해서 같은 SUB_LIST 채널 동영상들의 재생 횟수 CNT
						SELECT TOP 10 V.SUB_PLAY_LIST, COUNT(V.SUB_PLAY_LIST) AS 'CNT', 'Y' AS 'IS_SUB_YN'
							FROM CUST.dbo.CUST_WATCHING W
							INNER JOIN VIDEO V ON W.VIDEO_ID = V.VIDEO_ID
								WHERE  @YESTERDAY + ' 00:00:00.000' <= W.CREATED_AT 
								AND  W.CREATED_AT <= @YESTERDAY + ' 23:59:59.999'
								AND ISNULL(V.SUB_PLAY_LIST,'') != ''
								GROUP BY V.SUB_PLAY_LIST	  
								ORDER BY CNT DESC

						 ) WV
					LEFT JOIN VIDEO V
					ON V.SUB_PLAY_LIST = WV.SUB_PLAY_LIST
					 ) a
				WHERE RK = 1
			)s
		LEFT JOIN YOUTUBER_PLAY_LIST YPL
		ON s.SUB_PLAY_LIST = YPL.PLAY_LIST_ID

UNION
	-- CNT 된 동영상들중 TOP10개 뽑아 비디오 상세정보 GET
	SELECT V.TITLE AS TITLE
		   , WV.CNT
		   , V.VIDEO_LENGTH
		   , WV.ISSUB_YN
		   , V.[DESCRIPTION]
		   , V.VIDEO_URL
		   , dbo.FN_GET_VIDEO_TYPE_NAME(200, V.VIDEO_TYPE) AS VIDEO_TYPE_NAME
		   , V.PICTURE_URL
		   , V.TAGS
		   , V.KIDS_YN
	  FROM( -- 시청이력에서 어제날짜 동영상들중,
			-- SUB_LIST가 없는 동영상 추출해서 같은 동영상 재생 횟수 CNT
			  SELECT TOP 10 W.VIDEO_ID, COUNT (W.VIDEO_ID) AS 'CNT' ,'N' AS 'ISSUB_YN'
				FROM CUST.dbo.CUST_WATCHING W  
				INNER JOIN VIDEO V
				 ON W.VIDEO_ID = V.VIDEO_ID
			  WHERE  @YESTERDAY + ' 00:00:00.000' <= W.CREATED_AT 
				AND  W.CREATED_AT <= @YESTERDAY + ' 23:59:59.999'
				AND ISNULL(SUB_PLAY_LIST,'') = ''
				GROUP BY W.VIDEO_ID
				ORDER BY CNT DESC

		  ) WV
	   LEFT JOIN VIDEO V
		 ON WV.VIDEO_ID = V.VIDEO_ID
	) a
ORDER BY CNT DESC


	
END
GO
