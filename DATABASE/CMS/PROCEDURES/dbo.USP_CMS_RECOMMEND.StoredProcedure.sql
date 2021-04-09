USE [CMS]
GO

/****** Object:  StoredProcedure [dbo].[USP_CMS_RECOMMEND]    Script Date: 2021-04-06 오후 6:10:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-------------------------------------------------------------------------------------------
-- 프로시져명 : USP_CMS_RECOMMEND
-- 내      용 : Youflix 메인 추천 비디오 박스
-- 작  성  일 : 2021-03-31
-- 작  성  자 : 조 준 희
-- EXEC USP_CMS_RECOMMEND
-- 이       력 :
-------------------------------------------------------------------------------------------

CREATE  PROC [dbo].[USP_CMS_RECOMMEND]
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

SELECT TOP 1 
        CASE ISNULL(SPL.SUB_PLAY_LIST,'')  
             WHEN '' THEN   V.TITLE
             ELSE YPL.PLAY_LIST_TITLE
         END AS TITLE
         , V.VIDEO_ID
         ,V.VIDEO_LENGTH
         ,CASE ISNULL(SPL.SUB_PLAY_LIST,'')  
             WHEN '' THEN   'N'
             ELSE 'Y'
         END AS ISSUB_YN
         , V.[DESCRIPTION]
         , V.VIDEO_URL
         , VIDEO_TYPE
         , V.PICTURE_URL
         , V.TAGS
         , V.KIDS_YN
  FROM VIDEO V
  LEFT JOIN SUB_PLAY_LIST SPL
   ON V.VIDEO_ID = SPL.VIDEO_ID
  LEFT JOIN YOUTUBER_PLAY_LIST YPL
   ON SPL.SUB_PLAY_LIST = YPL.PLAY_LIST_ID
  ORDER BY V.CREATED_AT DESC
GO

