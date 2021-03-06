USE [CMS]
GO
/****** Object:  StoredProcedure [dbo].[USP_CMS_INGEST_VIDEO_REGSTER_INSERT]    Script Date: 2021-03-23 오전 11:46:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-------------------------------------------------------------------------------------------
-- 프로시져명 : USP_CMS_INGEST_VIDEO_REGSTER_INSERT
-- 내      용 : 입수자동화 서버 비디오 입수
-- 작  성  일 : 2021-02-09
-- 작  성  자 : 조 준 희
-- EXEC USP_CMS_INGEST_VIDEO_REGSTER_INSERT
-- 이       력 : 2020-03-04 조 준 희 - 비디오 길이 추가
-------------------------------------------------------------------------------------------

CREATE PROC [dbo].[USP_CMS_INGEST_VIDEO_REGSTER_INSERT]
  @VIDEO_ID CHAR(11)
 ,@TITLE VARCHAR(200)
 ,@VIDEO_TYPE CHAR(2)
 ,@YOUTUBER_ID CHAR(24)
 ,@DESCRIPTION VARCHAR(1000)
 ,@VIDEO_URL VARCHAR(41)
 ,@PUBLISHED_AT VARCHAR(19)
 ,@PICTURE_URL VARCHAR(48)
 ,@PLAY_YN CHAR(1)
 ,@TAGS VARCHAR(1000)
 ,@KIDS_YN CHAR(1)
 ,@MAIN_PLAY_LIST VARCHAR(34)
 ,@VIDEO_LENGTH INT
AS

BEGIN
	INSERT INTO VIDEO  (  VIDEO_ID
						, TITLE
						, VIDEO_TYPE
						, YOUTUBER_ID
						, [DESCRIPTION]
						, VIDEO_URL
						, PUBLISHED_AT
						, PICTURE_URL
						, CREATED_AT
						, TAGS
						, KIDS_YN
						, PLAY_YN
						, MAIN_PLAY_LIST
						, SUB_PLAY_LIST
                        , VIDEO_LENGTH)
   VALUES ( @VIDEO_ID
		  , @TITLE
		  , @VIDEO_TYPE
		  , @YOUTUBER_ID
		  , @DESCRIPTION
		  , @VIDEO_URL
		  , @PUBLISHED_AT
		  , @PICTURE_URL
		  , GETDATE()
		  , @TAGS
		  , @KIDS_YN
		  , @PLAY_YN
		  , @MAIN_PLAY_LIST
		  , NULL
          , @VIDEO_LENGTH)
END
GO
