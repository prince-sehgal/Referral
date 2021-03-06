USE [master]
GO
/****** Object:  Database [okn_dbadroit]    Script Date: 2/09/2018 9:07:12 PM ******/
CREATE DATABASE [okn_dbadroit]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'dbConsuntency', FILENAME = N'c:\Program Files (x86)\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\okn_dbadroit_data.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'dbConsuntency_log', FILENAME = N'c:\Program Files (x86)\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\okn_dbadroit_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [okn_dbadroit] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [okn_dbadroit].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [okn_dbadroit] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [okn_dbadroit] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [okn_dbadroit] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [okn_dbadroit] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [okn_dbadroit] SET ARITHABORT OFF 
GO
ALTER DATABASE [okn_dbadroit] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [okn_dbadroit] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [okn_dbadroit] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [okn_dbadroit] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [okn_dbadroit] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [okn_dbadroit] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [okn_dbadroit] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [okn_dbadroit] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [okn_dbadroit] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [okn_dbadroit] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [okn_dbadroit] SET  DISABLE_BROKER 
GO
ALTER DATABASE [okn_dbadroit] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [okn_dbadroit] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [okn_dbadroit] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [okn_dbadroit] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [okn_dbadroit] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [okn_dbadroit] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [okn_dbadroit] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [okn_dbadroit] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [okn_dbadroit] SET  MULTI_USER 
GO
ALTER DATABASE [okn_dbadroit] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [okn_dbadroit] SET DB_CHAINING OFF 
GO
ALTER DATABASE [okn_dbadroit] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [okn_dbadroit] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [okn_dbadroit]
GO
/****** Object:  User [useradroit]    Script Date: 2/09/2018 9:07:13 PM ******/
CREATE USER [useradroit] FOR LOGIN [useradroit] WITH DEFAULT_SCHEMA=[useradroit]
GO
ALTER ROLE [db_owner] ADD MEMBER [useradroit]
GO
/****** Object:  Schema [useradroit]    Script Date: 2/09/2018 9:07:13 PM ******/
CREATE SCHEMA [useradroit]
GO
/****** Object:  StoredProcedure [dbo].[p_AuthenticateUser]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_AuthenticateUser]
@userName nvarchar(50)=null,@password nvarchar(50)=null
AS
BEGIN

select userId,firstName from tblManageUser where emailId=@userName and password=@password
END

GO
/****** Object:  StoredProcedure [dbo].[p_Candidate_delete]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_Candidate_delete]
@cId int=0
AS
BEGIN
	delete from tblCandidate where cId=@cId
	delete from tblEducationDetails where cId=@cId
	delete from tblExperienceDetails where cId=@cId
END

GO
/****** Object:  StoredProcedure [dbo].[p_checkExistsEmailId_MobileNo]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[p_checkExistsEmailId_MobileNo]
@emailId nvarchar(50)='',@userId int=0,@mobileNo nvarchar(10)='',@firstName nvarchar(50)=null
AS
BEGIN
declare @emailIdStatus int=0,@mobileNoStatus int=0,@firstNameStatus int=0
if exists(select userId from tblManageUser where userId<>@userId and firstName=@firstName)
begin
set @firstNameStatus=1
end

if exists(select userId from tblManageUser where userId<>@userId and emailId=@emailId)
begin
set @emailIdStatus=1
end

if exists(select userId from tblManageUser where userId<>@userId and mobileNo=@mobileNo)
begin
set @mobileNoStatus=1
end
select @emailIdStatus as emailIdStatus ,@mobileNoStatus as mobileNoStatus,@firstNameStatus as firstNameStatus
END



GO
/****** Object:  StoredProcedure [dbo].[p_getRecruiter_byRecruitmetLeadId]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_getRecruiter_byRecruitmetLeadId]
@recruitmetLeadId int=0
AS
BEGIN
if(@recruitmetLeadId!=0)
begin
	select userId,firstName from tblManageUser where recruitmetLeadId=@recruitmetLeadId
	end
END

GO
/****** Object:  StoredProcedure [dbo].[p_tblAssociateJob_To_Candidate_get]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_tblAssociateJob_To_Candidate_get]
@candidateId int=0
AS
BEGIN
SELECT associateJCId
      ,ac.joiId
      ,ac.candidateId
      ,ac.comments
      ,ac.crtUserId
      ,ac.modUserId
      ,ac.crtDT
      ,ac.modDT
      ,ac.csSubCatId,
      j.positionTile,
     (select firstName from tblManageUser where tblManageUser.userId=j.recruitmetLeadId) as recruitmetLeadName
     ,(select firstName from tblManageUser where tblManageUser.userId=j.recruiterId) as recruiterName
     ,(select csSubCat from tblCandidateStatusSubCat where tblCandidateStatusSubCat.csSubCatId=ac.csSubCatId) as csSubCat
     ,(select clientName from tblClient where clientId=j.clientId) as clientName
     ,c.currentJobTitle
     
  FROM [dbo].[tblAssociateJob_To_Candidate] ac
   inner join tblJobOpeningInformation j on j.joiId=ac.joiId
   inner join tblCandidate c on c.cId=ac.candidateId
   where ac.candidateId=@candidateId




END

GO
/****** Object:  StoredProcedure [dbo].[p_tblAssociateJob_To_Candidate_get_byCandidateId]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_tblAssociateJob_To_Candidate_get_byCandidateId]
@candidateId int=0
AS
BEGIN
SELECT associateJCId
      ,ac.joiId
      ,ac.candidateId
      ,ac.comments
      ,ac.crtUserId
      ,ac.modUserId
      ,ac.crtDT
      ,ac.modDT
      ,ac.csSubCatId,
      j.positionTile,
     (select firstName from tblManageUser where tblManageUser.userId=j.recruitmetLeadId) as recruitmetLeadName
     ,(select firstName from tblManageUser where tblManageUser.userId=j.recruiterId) as recruiterName
     ,(select csSubCat from tblCandidateStatusSubCat where tblCandidateStatusSubCat.csSubCatId=ac.csSubCatId) as csSubCat
     ,(select clientName from tblClient where clientId=j.clientId) as clientName
     ,c.currentJobTitle
     
  FROM [dbo].[tblAssociateJob_To_Candidate] ac
   inner join tblJobOpeningInformation j on j.joiId=ac.joiId
   inner join tblCandidate c on c.cId=ac.candidateId
   where ac.candidateId=@candidateId




END

GO
/****** Object:  StoredProcedure [dbo].[p_tblAssociateJob_To_Candidate_save]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_tblAssociateJob_To_Candidate_save]
@associateJCId int=0,
@joiId int=0,@candidateId int=0,@comments nvarchar(200)=null,@crtUserId int=0,@csSubCatId int=0

AS
BEGIN
if(@associateJCId=0)
 begin	
INSERT INTO [dbo].[tblAssociateJob_To_Candidate]
           ([joiId]
           ,[candidateId]
           ,[comments]
           ,[crtUserId]
           ,[crtDT],csSubCatId
          )
     VALUES
           (@joiId ,@candidateId ,@comments ,@crtUserId,GETDATE(),@csSubCatId)
           update tblCandidate set csSubCatId=@csSubCatId,comments=@comments where cId=@candidateId
           end
         else
         begin
         update tblAssociateJob_To_Candidate set csSubCatId=@csSubCatId,modUserId=@crtUserId,comments=@comments,modDT=GETDATE() where associateJCId=@associateJCId
         update tblCandidate set csSubCatId=@csSubCatId,comments=@comments where cId=@candidateId
         end
END

GO
/****** Object:  StoredProcedure [dbo].[p_tblCandidate_checkExistsEmailId_MobileNo]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_tblCandidate_checkExistsEmailId_MobileNo]
@email varchar(50)='',@cId int=0,@mobile varchar(10)=''
AS
BEGIN
declare @emailStatus int=0,@mobileStatus int=0
if exists(select email from tblCandidate where cId<>@cId and email=@email)
begin
set @emailStatus=1
end

if exists(select email from tblCandidate where cId<>@cId and mobile=@mobile)
begin
set @mobileStatus=1
end
select @emailStatus as emailStatus ,@mobileStatus as mobileStatus 
END

GO
/****** Object:  StoredProcedure [dbo].[p_tblCandidate_get]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_tblCandidate_get]

AS
BEGIN
--SELECT [cId]
--      ,[email]
--      ,c.[firstName]
--      ,c.[middleName]
--      ,c.[lastName]
--      ,[phone]
--      ,[mobile]
--      ,[secondaryEmail]
--      ,[street]
--      ,[postalCode]
--      ,c.city
--      ,c.state
--      ,c.country
--      ,[experienceInYear]
--      ,ISNULL( [quaId],0) as quaId
--      ,[currentJobTitle]
--      ,[currentEmployer]
--      ,ISNULL( [expectedSalary],0) as expectedSalary
--      ,ISNULL( [currentSalary],0) as currentSalary
--      ,[skillSet]
--      ,ISNULL( c.csSubCatId,0) as csSubCatId
--      ,ISNULL( s.[sourceId],0) as sourceId
--      ,ISNULL( c.recruiterId,0) as recruiterId
--      ,[resume]
--      ,[others] ,sc.csSubCat
--      ,mu.firstName as recruiterName
--      ,s.source,jo.positionTile
      
--  FROM [dbo].[tblCandidate] c inner join 
--  tblCandidateStatusSubCat sc on c.csSubCatId=sc.csSubCatId
--   inner join tblManageUser mu on mu.userId=c.recruiterId 
--   inner join tblSource s on s.sourceId=c.sourceId 
--   left join tblJobOpeningInformation jo on jo.joiId=c.joiId
--    order by cId desc


SELECT [cId]
      ,[email]
      ,c.[firstName]
      ,c.[middleName]
      ,c.[lastName]
      ,[phone]
      ,[mobile]
      ,[secondaryEmail]
      ,[street]
      ,[postalCode]
      ,c.city
      ,c.state
      ,c.country
      ,[experienceInYear]
      ,ISNULL( [quaId],0) as quaId
      ,[currentJobTitle]
      ,[currentEmployer]
      ,ISNULL( [expectedSalary],0) as expectedSalary
      ,ISNULL( [currentSalary],0) as currentSalary
      ,[skillSet]
      --,ISNULL( c.csSubCatId,0) as csSubCatId
      ,ISNULL( s.[sourceId],0) as sourceId
      --,ISNULL( c.recruiterId,0) as recruiterId
      ,[resume]
      ,[others] 
      --,sc.csSubCat
      --,mu.firstName as recruiterName
      ,s.source,
      --jo.positionTile,
      
      (case when exists(select candidateId from tblAssociateJob_To_Candidate where candidateId=c.cId) then 
     (select top 1 ajc.csSubCatId  from tblAssociateJob_To_Candidate ajc where candidateId=c.cId order by associateJCId desc) 
             else 
               ISNULL( c.csSubCatId,0) 
              end) as csSubCatId,
              
              
             (select csSubCat FROM tblCandidateStatusSubCat where csSubCatId= (case when exists(select candidateId from tblAssociateJob_To_Candidate where candidateId=c.cId) then 
     (select top 1 ajc.csSubCatId  from tblAssociateJob_To_Candidate ajc where candidateId=c.cId order by associateJCId desc) 
             else 
               ISNULL( c.csSubCatId,0) 
              end) ) as csSubCat
              ,
             (select positionTile from  tblJobOpeningInformation joi where joi.joiId=(case when exists(select candidateId from tblAssociateJob_To_Candidate where candidateId=c.cId) then 
     (select top 1 ajc.joiId  from tblAssociateJob_To_Candidate ajc where candidateId=c.cId order by associateJCId desc) 
             else 
            0
              end) ) as positionTile
      ,
      (case when exists(select candidateId from tblAssociateJob_To_Candidate where candidateId=c.cId) then 
     (select top 1 ajc.comments  from tblAssociateJob_To_Candidate ajc where candidateId=c.cId order by associateJCId desc) 
             else 
               c.comments
              end) as comments
              ,(select  COUNT(*) from tblAssociateJob_To_Candidate ajc where ajc.candidateId=c.cId) as noOfAppliedJobs
                   

      
  FROM [dbo].[tblCandidate] c 
	   --inner join tblManageUser mu on mu.userId=c.recruiterId 
	   left join tblSource s on s.sourceId=c.sourceId 
    order by cId desc
END

GO
/****** Object:  StoredProcedure [dbo].[p_tblCandidate_get_byCandidateId]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_tblCandidate_get_byCandidateId]
@cId int=0
AS
BEGIN
SELECT [cId]
      ,[email]
      ,c.[firstName]
      ,c.[middleName]
      ,c.[lastName]
      ,[phone]
      ,[mobile]
      ,[secondaryEmail]
      ,[street]
      ,[postalCode]
      ,c.city
      ,c.state
      ,c.country
      ,[experienceInYear]
      ,ISNULL( [quaId],0) as quaId
      ,[currentJobTitle]
      ,[currentEmployer]
      ,ISNULL( [expectedSalary],0) as expectedSalary
      ,ISNULL( [currentSalary],0) as currentSalary
      ,[skillSet]
      --,ISNULL( c.csSubCatId,0) as csSubCatId
      ,ISNULL( s.[sourceId],0) as sourceId
      --,ISNULL( c.recruiterId,0) as recruiterId
      ,[resume]
      ,[others] 
      --,sc.csSubCat
      --,mu.firstName as recruiterName
      ,s.source,
      --jo.positionTile,
      
      (case when exists(select candidateId from tblAssociateJob_To_Candidate where candidateId=c.cId) then 
     (select top 1 ajc.csSubCatId  from tblAssociateJob_To_Candidate ajc where candidateId=c.cId order by associateJCId desc) 
             else 
               ISNULL( c.csSubCatId,0) 
              end) as csSubCatId,
              
              
             (select csSubCat FROM tblCandidateStatusSubCat where csSubCatId= (case when exists(select candidateId from tblAssociateJob_To_Candidate where candidateId=c.cId) then 
     (select top 1 ajc.csSubCatId  from tblAssociateJob_To_Candidate ajc where candidateId=c.cId order by associateJCId desc) 
             else 
               ISNULL( c.csSubCatId,0) 
              end) ) as csSubCat
              ,
             (select positionTile from  tblJobOpeningInformation joi where joi.joiId=(case when exists(select candidateId from tblAssociateJob_To_Candidate where candidateId=c.cId) then 
     (select top 1 ajc.joiId  from tblAssociateJob_To_Candidate ajc where candidateId=c.cId order by associateJCId desc) 
             else 
            0
              end) ) as positionTile
                   ,
      (case when exists(select candidateId from tblAssociateJob_To_Candidate where candidateId=c.cId) then 
     (select top 1 ajc.comments  from tblAssociateJob_To_Candidate ajc where candidateId=c.cId order by associateJCId desc) 
             else 
               c.comments
              end) as comments
      
      
  FROM [dbo].[tblCandidate] c 
	   --inner join tblManageUser mu on mu.userId=c.recruiterId 
	   left join tblSource s on s.sourceId=c.sourceId 

   where c.cId=@cId
    order by cId desc
END

GO
/****** Object:  StoredProcedure [dbo].[p_tblCandidate_get_Not_AlreadyTag_OnSamePosition]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_tblCandidate_get_Not_AlreadyTag_OnSamePosition]
@joiId nvarchar(max)=null
AS
BEGIN

SELECT [cId]
      ,[email]
      ,c.[firstName]
      ,c.[middleName]
      ,c.[lastName]
      ,[phone]
      ,[mobile]
      ,[secondaryEmail]
      ,[street]
      ,[postalCode]
      ,c.city
      ,c.state
      ,c.country
      ,[experienceInYear]
      ,ISNULL( [quaId],0) as quaId
      ,[currentJobTitle]
      ,[currentEmployer]
      ,ISNULL( [expectedSalary],0) as expectedSalary
      ,ISNULL( [currentSalary],0) as currentSalary
      ,[skillSet]
      --,ISNULL( c.csSubCatId,0) as csSubCatId
      ,ISNULL( s.[sourceId],0) as sourceId
      --,ISNULL( c.recruiterId,0) as recruiterId
      ,[resume]
      ,[others] 
      --,sc.csSubCat
      --,mu.firstName as recruiterName
      ,s.source,
      --jo.positionTile,
      
      (case when exists(select candidateId from tblAssociateJob_To_Candidate where candidateId=c.cId) then 
     (select top 1 ajc.csSubCatId  from tblAssociateJob_To_Candidate ajc where candidateId=c.cId order by associateJCId desc) 
             else 
               ISNULL( c.csSubCatId,0) 
              end) as csSubCatId,
              
              
             (select csSubCat FROM tblCandidateStatusSubCat where csSubCatId= (case when exists(select candidateId from tblAssociateJob_To_Candidate where candidateId=c.cId) then 
     (select top 1 ajc.csSubCatId  from tblAssociateJob_To_Candidate ajc where candidateId=c.cId order by associateJCId desc) 
             else 
               ISNULL( c.csSubCatId,0) 
              end) ) as csSubCat
              ,
             (select positionTile from  tblJobOpeningInformation joi where joi.joiId=(case when exists(select candidateId from tblAssociateJob_To_Candidate where candidateId=c.cId) then 
     (select top 1 ajc.joiId  from tblAssociateJob_To_Candidate ajc where candidateId=c.cId order by associateJCId desc) 
             else 
            0
              end) ) as positionTile
      ,
      (case when exists(select candidateId from tblAssociateJob_To_Candidate where candidateId=c.cId) then 
     (select top 1 ajc.comments  from tblAssociateJob_To_Candidate ajc where candidateId=c.cId order by associateJCId desc) 
             else 
               c.comments
              end) as comments
              ,(select  COUNT(*) from tblAssociateJob_To_Candidate ajc where ajc.candidateId=c.cId) as noOfAppliedJobs
                   

      
  FROM [dbo].[tblCandidate] c 
	   left join tblSource s on s.sourceId=c.sourceId 
	   where cId not in(select candidateId from tblAssociateJob_To_Candidate where joiId in(@joiId))
    order by cId desc
END

GO
/****** Object:  StoredProcedure [dbo].[p_tblCandidate_save]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[p_tblCandidate_save]

@cId int=0,	@email nvarchar(50)=null,@firstName nvarchar(50)=null,@middleName nvarchar(50)=null,@lastName nvarchar(50)=null,@phone nvarchar(20)=null,@mobile nvarchar(10)=null,@secondaryEmail nvarchar(50)=null,@street nvarchar(100)=null,@postalCode nvarchar(50)=null,@city nvarchar(50)=null,@state nvarchar(50)=null,@country nvarchar(50)=null,@experienceInYear nvarchar(10)=null,@quaId int=0,@currentJobTitle nvarchar(50)=null,@currentEmployer nvarchar(50)=null,@expectedSalary numeric(12,2)=0,@currentSalary numeric(12,2)=0,@skillSet nvarchar(100)=null,@csSubCatId int=0,@sourceId int=0,@resume nvarchar(100)=null,@others nvarchar(100)=null,@crtUserId int=0,@comments nvarchar(200)=null
AS
BEGIN
if(@cId=0)
begin
declare @candidateNo nvarchar(5)=null,@last_candidateNo nvarchar(5)=null
select top 1 @last_candidateNo=candidateNo from tblCandidate  order by cId desc
set @candidateNo=dbo.f_GenerateNo(@last_candidateNo) 
	INSERT INTO [dbo].[tblCandidate]
           ([email]
           ,[firstName]
           ,[middleName]
           ,[lastName]
           ,[phone]
           ,[mobile]
           ,[secondaryEmail]
           ,[street]
           ,[postalCode]
           ,[city]
           ,[state]
           ,[country]
           ,[experienceInYear]
           ,[quaId]
           ,[currentJobTitle]
           ,[currentEmployer]
           ,[expectedSalary]
           ,[currentSalary]
           ,[skillSet]
           ,[csSubCatId]
           ,[sourceId]
           ,[crtDT],[crtUserId],comments,candidateNo
           )
     VALUES(@email ,@firstName ,@middleName ,@lastName ,@phone ,@mobile ,@secondaryEmail ,@street ,@postalCode ,@city ,@state ,@country ,@experienceInYear ,@quaId ,@currentJobTitle ,@currentEmployer ,@expectedSalary ,@currentSalary ,@skillSet ,@csSubCatId ,@sourceId  ,GETDATE(),@crtUserId,@comments,@candidateNo)
     set @cId=SCOPE_IDENTITY()
     select @cId
     end
     else
     begin
     update tblCandidate set 
     email=@email,firstName=@firstName,middleName=@middleName,lastName=@lastName,phone=@phone,mobile=@mobile,secondaryEmail=@secondaryEmail,street=@street,postalCode=@postalCode,city=@city,state=@state,country=@country,experienceInYear=@experienceInYear,quaId=@quaId,currentJobTitle=@currentJobTitle,currentEmployer=@currentEmployer,expectedSalary=@expectedSalary,currentSalary=@currentSalary,skillSet=@skillSet,csSubCatId=@csSubCatId,sourceId=@sourceId,modDT=GETDATE() ,modUserId=@crtUserId,comments=@comments
     where cId=@cId
     select @cId
     
     update tblAssociateJob_To_Candidate set csSubCatId=@csSubCatId,comments=@comments,modDT=GETDATE(),modUserId=@crtUserId where associateJCId=(select top 1 associateJCId from tblAssociateJob_To_Candidate where candidateId=@cId order by associateJCId desc )
     end
     

END


GO
/****** Object:  StoredProcedure [dbo].[p_tblCandidateStatusSubCat_getCat_SubCat]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_tblCandidateStatusSubCat_getCat_SubCat]

AS
BEGIN
SELECT sc.csSubCatId,c.csCat,sc.csSubCat
     
  FROM [dbo].[tblCandidateStatusSubCat] sc inner join tblCandidateStatusCat c on c.csCatId=sc.csCatId

END

GO
/****** Object:  StoredProcedure [dbo].[p_tblClient_AccountManager_delete]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_tblClient_AccountManager_delete]
@c_amId int=0,@clientId int=0
AS
BEGIN
delete from tblClient_AccountManager where c_amId=@c_amId and clientId=@clientId
END



GO
/****** Object:  StoredProcedure [dbo].[p_tblClient_AccountManager_get]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_tblClient_AccountManager_get]	
@clientId int=0
AS
BEGIN
if(@clientId=0)
		begin
SELECT [c_amId]
      ,[clientId]
      ,[accountManager]
      ,[crtDT]
      ,[modDT]
      ,[contactNo],emailId
  FROM [dbo].[tblClient_AccountManager]
  end
  else if(@clientId>0)
  begin
  SELECT [c_amId]
      ,[clientId]
      ,[accountManager]
      ,[crtDT]
      ,[modDT]
      ,[contactNo],emailId
  FROM [dbo].[tblClient_AccountManager] where clientId=@clientId
  end
END

GO
/****** Object:  StoredProcedure [dbo].[p_tblClient_AccountManager_save]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_tblClient_AccountManager_save]
@c_amId int=0,@clientId int=0,@accountManager nvarchar(50)=null,@contactNo nvarchar(15)=null,@emailId nvarchar(50)=null
AS
BEGIN
if(@c_amId=0)
begin
INSERT INTO [dbo].[tblClient_AccountManager]
           ([clientId]
           ,[accountManager]
           ,[crtDT],contactNo,emailId
           )
     VALUES
           (@clientId ,@accountManager,GETDATE(),@contactNo,@emailId)
           end
           
           else
           begin
           update [dbo].[tblClient_AccountManager] set accountManager=@accountManager,modDT=GETDATE(),contactNo=@contactNo
           ,emailId=@emailId
            where c_amId=@c_amId and clientId=@clientId 
           end
END

GO
/****** Object:  StoredProcedure [dbo].[p_tblClient_delete]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_tblClient_delete]
@clientId int=0
AS
BEGIN
	--delete from tblClient where clientId in(SELECT Value FROM fn_Split(@clientIds, ','))
	delete from tblClient where clientId=@clientId
END

GO
/****** Object:  StoredProcedure [dbo].[p_tblClient_get]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_tblClient_get]
AS
BEGIN
	--SELECT [clientId]
 --     ,[clientName]
 --     ,[contactNo]
 --     ,[website]
 --     ,tblClient.recruitmetLeadId , tblManageUser.firstName as recruitmetLeadName 
      
 --       FROM [dbo].[tblClient] inner join tblManageUser on  tblClient.recruitmetLeadId=tblManageUser.userId order by clientId desc
 
 
 SELECT [clientId]
      ,[clientName]
      ,[website],aboutCompany
      ,isnull( recruitmetLeadId,0) as recruitmetLeadId ,(select firstName from tblManageUser where userId=tblClient.recruitmetLeadId) as recruitmetLeadName, 
      ISNULL( recruiterId,0) as recruiterId,(select firstName from tblManageUser where userId=tblClient.recruiterId) as recruiterName
      
      
        FROM [dbo].[tblClient]  order by clientId desc
END

GO
/****** Object:  StoredProcedure [dbo].[p_tblClient_save]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_tblClient_save]
@clientId int=0,
@clientName nvarchar(50)=null,@contactNo nvarchar(15)=null,@website nvarchar(50)=null,@recruitmetLeadId int=0,@crtUserId int=0
,@recruiterId int=0, @aboutCompany nvarchar(1000)=null
AS
BEGIN
if(@clientId=0)
	begin
		INSERT INTO [dbo].[tblClient]
				   ([clientName]
				   ,[website]
				  ,[recruitmetLeadId]
				   ,[crtUserId]
				   ,[crtDT],[recruiterId],[aboutCompany]
				   )
			 VALUES(@clientName ,@website,@recruitmetLeadId ,@crtUserId ,getdate(),@recruiterId, @aboutCompany)
			set @clientId=SCOPE_IDENTITY()
			select @clientId
	end
		else
			begin
				update tblClient set clientName=@clientName,website=@website,
				recruitmetLeadId=@recruitmetLeadId,modUserId=@crtUserId,
				modDT=GETDATE(),recruiterId=@recruiterId,aboutCompany=@aboutCompany where clientId=@clientId
				select @clientId
			end		 
END

GO
/****** Object:  StoredProcedure [dbo].[p_tblContact_delete]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_tblContact_delete]
@contactId int=0
AS
BEGIN
	delete from tblContact where contactId=@contactId
END

GO
/****** Object:  StoredProcedure [dbo].[p_tblContact_get]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_tblContact_get]
@clientId int=0
AS
BEGIN
if(@clientId=0)
 begin
SELECT [contactId]
      ,[preName]
      ,[firstName]
      ,[lastName]
      ,co.clientId
      ,[email]
      ,[workPhone]
      ,[mobile]
      ,co.crtDT
      ,co.modDT,
     cl.clientName
  FROM [dbo].[tblContact] co inner join tblClient cl on co.clientId=cl.clientId order by contactId desc
  end
  else if(@clientId>0)
  begin
SELECT [contactId]
      ,[preName]
      ,[firstName]
      ,[lastName]
      ,co.clientId
      ,[email]
      ,[workPhone]
      ,[mobile]
      ,co.crtDT
      ,co.modDT
      ,cl.clientName
  FROM [dbo].[tblContact]
  co inner join tblClient cl on co.clientId=cl.clientId 
   where co.clientId=@clientId order by contactId desc
  
  end
  
END

GO
/****** Object:  StoredProcedure [dbo].[p_tblContact_save]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_tblContact_save]
@contactId int=0,
@preName nvarchar(10)=null,@firstName nvarchar(50)=null,@lastName nvarchar(50)=null,@clientId int=0,@email nvarchar(50)=null,@workPhone nvarchar(20)=null,@mobile nvarchar(15)=null,@crtUserId int=0
AS
BEGIN
if(@contactId=0)
	begin
INSERT INTO [dbo].[tblContact]
           ([preName]
           ,[firstName]
           ,[lastName]
           ,[clientId]
           ,[email]
           ,[workPhone]
           ,[mobile]
           ,[crtUserId]
           ,[crtDT]
          )
     VALUES(@preName ,@firstName ,@lastName ,@clientId ,@email ,@workPhone ,@mobile ,@crtUserId ,GETDATE())
     set @contactId=SCOPE_IDENTITY()
     select @contactId
end
	else
	begin
	update tblContact set preName=@preName,firstName=@firstName,lastName=@lastName,clientId=@clientId,email=@email,workPhone=@workPhone,mobile=@mobile,modUserId=@crtUserId,modDT=GETDATE() where contactId=@contactId
select @contactId	
	
	end
END

GO
/****** Object:  StoredProcedure [dbo].[p_tblEducationDetails_delete]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_tblEducationDetails_delete]
@eduId int=0
AS
BEGIN
delete from tblEducationDetails where eduId=@eduId
END

GO
/****** Object:  StoredProcedure [dbo].[p_tblEducationDetails_get_byCId]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_tblEducationDetails_get_byCId]
@cId int=0
AS
BEGIN
	SELECT [eduId]
      ,[institute]
      ,[departmant]
      ,[degree]
      ,[currentlyPursuing]
      ,[fromMonth]
      ,ISNULL( [fromYear],0) as fromYear
      ,[toMonth]
      ,ISNULL( [toYear],0) as toYear
  FROM [dbo].[tblEducationDetails] where cId=@cId

END

GO
/****** Object:  StoredProcedure [dbo].[p_tblEducationDetails_save]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_tblEducationDetails_save]
@eduId int=0,
@cId int=0,@institute nvarchar(100)=null,@departmant nvarchar(100)=null,@degree nvarchar(100)=null,@currentlyPursuing bit=null,@fromMonth nvarchar(10)=null,@fromYear int=0,@toMonth nvarchar(10)=null,@toYear int=0
AS
BEGIN
if(@eduId=0)
begin
INSERT INTO [dbo].[tblEducationDetails]
           ([cId]
           ,[institute]
           ,[departmant]
           ,[degree]
           ,[currentlyPursuing]
           ,[fromMonth]
           ,[fromYear]
           ,[toMonth]
           ,[toYear]
           ,[crtDT]
           )
     VALUES(@cId ,@institute ,@departmant ,@degree ,@currentlyPursuing ,@fromMonth ,@fromYear ,@toMonth ,@toYear,GETDATE())
end
else
begin
update tblEducationDetails set institute=@institute,departmant=@departmant,degree=@degree,currentlyPursuing=@currentlyPursuing,fromMonth=@fromMonth,fromYear=@fromYear,toMonth=@toMonth,toYear=@toYear,modDT=getdate() where eduId=@eduId and cId=@cId
end
END

GO
/****** Object:  StoredProcedure [dbo].[p_tblEmailTemplate_delete]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_tblEmailTemplate_delete]
@etIds nvarchar(max)=null
AS
BEGIN
	delete from tblEmailTemplate where etId in(SELECT Value FROM fn_Split(@etIds, ','))
END

GO
/****** Object:  StoredProcedure [dbo].[p_tblEmailTemplate_get]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_tblEmailTemplate_get]

AS
BEGIN
SELECT [etId]
      ,[title]
      ,[description]
      ,[crtUserId]
      ,[modUserId]
      ,[crtDT]
      ,[modDT],subject
  FROM [dbo].[tblEmailTemplate] order by etId desc
END

GO
/****** Object:  StoredProcedure [dbo].[p_tblEmailTemplate_save]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_tblEmailTemplate_save]
@etId int=0,@title nvarchar(50)=null,@description nvarchar(500)=null,@crtUserId int=0,@subject nvarchar(100)=null
AS
BEGIN
if(@etId=0)
	begin
INSERT INTO [dbo].[tblEmailTemplate]
           ([title]
           ,[description]
           ,[crtUserId]
           ,[crtDT],subject
           )
     VALUES
           (
           @title ,@description ,@crtUserId ,GETDATE() ,@subject
           )
end

else
begin
update tblEmailTemplate set title=@title ,description=@description ,modDT=GETDATE(),subject=@subject where etId=@etId
end

END

GO
/****** Object:  StoredProcedure [dbo].[p_tblExperienceDetails_delete]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_tblExperienceDetails_delete]
@expId int=0
AS
BEGIN
delete from tblExperienceDetails where expId=@expId
END

GO
/****** Object:  StoredProcedure [dbo].[p_tblExperienceDetails_get_byCId]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_tblExperienceDetails_get_byCId]
@cId int=0
AS
BEGIN
SELECT [expId]
      ,[occupation]
      ,[company]
      ,[summery]
      ,[currentlyWork]
      ,[fromMonth]
      ,ISNULL( [fromYear],0) as fromYear
      ,[toMonth]
      ,ISNULL( [toYear],0) as toYear

  FROM [dbo].[tblExperienceDetails] where cId=@cId
END

GO
/****** Object:  StoredProcedure [dbo].[p_tblExperienceDetails_save]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_tblExperienceDetails_save]
@expId int=0,	@cId int=0,@occupation nvarchar(100)=null,@company nvarchar(100)=null,@summery nvarchar(100)=null,@currentlyWork bit=null,@fromMonth nvarchar(10)=null,@fromYear int=0,@toMonth nvarchar(10)=null,@toYear int=0
AS
BEGIN
if(@expId=0)
begin
	INSERT INTO [dbo].[tblExperienceDetails]
           ([cId]
           ,[occupation]
           ,[company]
           ,[summery]
           ,[currentlyWork]
           ,[fromMonth]
           ,[fromYear]
           ,[toMonth]
           ,[toYear]
           ,[crtDT]
           )
     VALUES(@cId ,@occupation ,@company ,@summery ,@currentlyWork ,@fromMonth ,@fromYear ,@toMonth ,@toYear,getdate())
end
else
begin
update tblExperienceDetails set 
occupation=@occupation,company=@company,summery=@summery,currentlyWork=@currentlyWork,fromMonth=@fromMonth,fromYear=@fromYear,toMonth=@toMonth,toYear=@toYear,modDT=GETDATE() where expId=@expId and cId=@cId
end
END

GO
/****** Object:  StoredProcedure [dbo].[p_tblInterviewNameMaster_get]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_tblInterviewNameMaster_get]

AS
BEGIN
SELECT [imId]
      ,[interviewName]
  FROM [dbo].[tblInterviewNameMaster]

END

GO
/****** Object:  StoredProcedure [dbo].[p_tblInterviews_delete]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_tblInterviews_delete]
@interviewIds nvarchar(max)=null
AS
BEGIN
delete from tblInterviews where interviewId   in(SELECT Value FROM fn_Split(@interviewIds, ','))
END

GO
/****** Object:  StoredProcedure [dbo].[p_tblInterviews_get]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_tblInterviews_get]
@candidateId int=0
AS
BEGIN
if(@candidateId=0)
begin
SELECT [interviewId]
      ,i.imId
      ,[candidateId]
      ,i.clientId
      ,i.joiId
      ,i.c_amId
      ,[toDate]
      ,[toTime]
      ,[interviewStatus]
      ,[location]
      ,[scheduleComments]
      ,[others_Photo_Doc]
      ,i.crtUserId
      ,i.modUserId
      ,i.crtDT
      ,i.modDT,c.clientName,ca.firstName,am.accountManager,j.positionTile as positionTitle,im.interviewName
  FROM [dbo].[tblInterviews] i
  left join tblInterviewNameMaster im on im.imId=i.imId
  left join tblClient c on c.clientId=i.clientId
  left join tblCandidate ca on ca.cId=i.candidateId
  left join tblClient_AccountManager am on am.c_amId=i.c_amId
  left join tblJobOpeningInformation j on j.joiId=i.joiId
  end
  
  else if(@candidateId>0)
  begin
  
SELECT [interviewId]
      ,i.imId
      ,[candidateId]
      ,i.clientId
      ,i.joiId
      ,i.c_amId
      ,[toDate]
      ,[toTime]
      ,[interviewStatus]
      ,[location]
      ,[scheduleComments]
      ,[others_Photo_Doc]
      ,i.crtUserId
      ,i.modUserId
      ,i.crtDT
      ,i.modDT,c.clientName,ca.firstName,am.accountManager,j.positionTile as  positionTitle,im.interviewName
  FROM [dbo].[tblInterviews] i
  left join tblInterviewNameMaster im on im.imId=i.imId
  left join tblClient c on c.clientId=i.clientId
  left join tblCandidate ca on ca.cId=i.candidateId
  left join tblClient_AccountManager am on am.c_amId=i.c_amId
  left join tblJobOpeningInformation j on j.joiId=i.joiId
  where i.candidateId=@candidateId
  end
  
END

GO
/****** Object:  StoredProcedure [dbo].[p_tblInterviews_save]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_tblInterviews_save]
@interviewId int=0,
@imId int=0,@candidateId int=0,@clientId int=0,@joiId int=0,@c_amId int=0,@toDate date=null,@toTime nvarchar(20)=null,@interviewStatus nvarchar(20)=null,@location nvarchar(100)=null,@scheduleComments nvarchar(500)=null,@crtUserId int=0
AS
BEGIN
if(@interviewId=0)
	begin
INSERT INTO [dbo].[tblInterviews]
           ([imId]
           ,[candidateId]
           ,[clientId]
           ,[joiId]
           ,[c_amId]
           ,[toDate]
           ,[toTime]
           ,[interviewStatus]
           ,[location]
           ,[scheduleComments]
           ,[crtUserId]
           ,[crtDT])
           
     VALUES
           (@imId ,@candidateId ,@clientId ,@joiId ,@c_amId ,@toDate ,@toTime ,@interviewStatus ,@location ,@scheduleComments ,@crtUserId ,GETDATE())
           set @interviewId= SCOPE_IDENTITY()
           select @interviewId
           
           end
            else
             begin
             update tblInterviews set imId=@imId,candidateId=@candidateId,clientId=@clientId,joiId=@joiId,c_amId=@c_amId,toDate=@toDate,toTime=@toTime,interviewStatus=@interviewStatus,location=@location,scheduleComments=@scheduleComments,modUserId=@crtUserId,modDT=GETDATE() where interviewId=@interviewId
             select @interviewId
             end
END

GO
/****** Object:  StoredProcedure [dbo].[p_tblJobOpeningInformation_delete]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_tblJobOpeningInformation_delete]
@joiId int=0
AS
BEGIN
delete from tblJobOpeningInformation where joiId=@joiId
END

GO
/****** Object:  StoredProcedure [dbo].[p_tblJobOpeningInformation_get]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_tblJobOpeningInformation_get]
@clientId int=0
AS
BEGIN
if(@clientId=0) 
 begin
SELECT [joiId]
      ,[positionTile]
      
      ,ISNULL(jo.contactId,0) as contactId
      ,ISNULL(jo.recruitmetLeadId,0) as recruitmetLeadId
      ,(select firstName from tblManageUser where userId=isnull( jo.recruitmetLeadId,0)) as recruitmetLeadName,
      ISNULL(jo.recruiterId,0) as recruiterId,(select firstName from tblManageUser where userId=ISNULL(jo.recruiterId,0)) as recruiterName
      ,[targetDT]
      ,[jobOpeningStatus]
      ,isnull(jo.clientId,0) as clientId
      ,jo.c_amId
      ,[openedDT]
      ,[jobType]
      ,[city]
      ,[state]
      ,[minWorkExperience]
      ,[maxWorkExperience]
      ,[noOfPositions]
      ,ISNULL( [minCTC],0) as minCTC
      ,ISNULL( [maxCTC],0) as maxCTC
      ,[jobDesc]
      ,[jobSummery],cl.clientName,co.firstName as contactName,
    isnull ((select COUNT(*)  from tblAssociateJob_To_Candidate where joiId=jo.joiId),0) as noOfCV,
         am.accountManager
      
  FROM [dbo].[tblJobOpeningInformation] jo
   inner join tblClient cl on jo.clientId=cl.clientId  
   inner join tblContact co on jo.contactId=co.contactId 
   left join tblClient_AccountManager am on jo.c_amId=am.c_amId
   order by joiId desc
   end
   else if(@clientId>0)
   begin
   
SELECT [joiId]
      ,[positionTile]
      
      ,ISNULL(jo.contactId,0) as contactId
      ,ISNULL(jo.recruitmetLeadId,0) as recruitmetLeadId
      ,(select firstName from tblManageUser where userId=isnull( jo.recruitmetLeadId,0)) as recruitmetLeadName,
      ISNULL(jo.recruiterId,0) as recruiterId,(select firstName from tblManageUser where userId=ISNULL(jo.recruiterId,0)) as recruiterName
      ,[targetDT]
      ,[jobOpeningStatus]
      ,isnull(jo.clientId,0) as clientId
      ,jo.c_amId
      ,[openedDT]
      ,[jobType]
      ,[city]
      ,[state]
      ,[minWorkExperience]
      ,[maxWorkExperience]
      ,[noOfPositions]
      ,ISNULL( [minCTC],0) as minCTC
      ,ISNULL( [maxCTC],0) as maxCTC
      ,[jobDesc]
      ,[jobSummery],cl.clientName,co.firstName as contactName,
    isnull ((select COUNT(*)  from tblAssociateJob_To_Candidate where joiId=jo.joiId),0) as noOfCV
    ,     am.accountManager
      
  FROM [dbo].[tblJobOpeningInformation] jo
   inner join tblClient cl on jo.clientId=cl.clientId  
   inner join tblContact co on jo.contactId=co.contactId 
   left join tblClient_AccountManager am on jo.c_amId=am.c_amId where jo.clientId=@clientId
   order by joiId desc
   
   end

END

GO
/****** Object:  StoredProcedure [dbo].[p_tblJobOpeningInformation_get_byJoiId]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_tblJobOpeningInformation_get_byJoiId]
@joiId int=0
AS
BEGIN
	SELECT [joiId]
      ,[positionTile]
      
      ,ISNULL(jo.contactId,0) as contactId
      ,ISNULL(jo.recruitmetLeadId,0) as recruitmetLeadId
      ,(select firstName from tblManageUser where userId=isnull( jo.recruitmetLeadId,0)) as recruitmetLeadName,
      ISNULL(jo.recruiterId,0) as recruiterId,(select firstName from tblManageUser where userId=ISNULL(jo.recruiterId,0)) as recruiterName
      ,[targetDT]
      ,[jobOpeningStatus]
      ,isnull(jo.clientId,0) as clientId
      ,jo.c_amId
      ,[openedDT]
      ,[jobType]
      ,[city]
      ,[state]
      ,[minWorkExperience]
      ,[maxWorkExperience]
      ,[noOfPositions]
      ,ISNULL( [minCTC],0) as minCTC
      ,ISNULL( [maxCTC],0) as maxCTC
      ,[jobDesc]
      ,[jobSummery],cl.clientName,co.firstName as contactName,
      am.accountManager
      
  FROM [dbo].[tblJobOpeningInformation] jo
   inner join tblClient cl on jo.clientId=cl.clientId  
   inner join tblContact co on jo.contactId=co.contactId 
   left join tblClient_AccountManager am on jo.c_amId=am.c_amId
   where joiId=@joiId
   order by joiId desc

END

GO
/****** Object:  StoredProcedure [dbo].[p_tblJobOpeningInformation_get_Not_AlreadyTag_OnSameCandidate]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[p_tblJobOpeningInformation_get_Not_AlreadyTag_OnSameCandidate]
@clientId int=0,@candidateIds nvarchar(max)=null
AS
BEGIN

   
SELECT [joiId]
      ,[positionTile]
      
      ,ISNULL(jo.contactId,0) as contactId
      ,ISNULL(jo.recruitmetLeadId,0) as recruitmetLeadId
      ,(select firstName from tblManageUser where userId=isnull( jo.recruitmetLeadId,0)) as recruitmetLeadName,
      ISNULL(jo.recruiterId,0) as recruiterId,(select firstName from tblManageUser where userId=ISNULL(jo.recruiterId,0)) as recruiterName
      ,[targetDT]
      ,[jobOpeningStatus]
      ,isnull(jo.clientId,0) as clientId
      ,jo.c_amId
      ,[openedDT]
      ,[jobType]
      ,[city]
      ,[state]
      ,[minWorkExperience]
      ,[maxWorkExperience]
      ,[noOfPositions]
      ,ISNULL( [minCTC],0) as minCTC
      ,ISNULL( [maxCTC],0) as maxCTC
      ,[jobDesc]
      ,[jobSummery],cl.clientName,co.firstName as contactName,
    isnull ((select COUNT(*)  from tblAssociateJob_To_Candidate where joiId=jo.joiId),0) as noOfCV
    ,     am.accountManager
      
  FROM [dbo].[tblJobOpeningInformation] jo
   inner join tblClient cl on jo.clientId=cl.clientId  
   inner join tblContact co on jo.contactId=co.contactId 
   inner join tblClient_AccountManager am on jo.c_amId=am.c_amId 
   
   where joiId not in(select joiId from tblAssociateJob_To_Candidate where candidateId in(@candidateIds)) and jo.clientId=@clientId
   order by joiId desc
   


END

GO
/****** Object:  StoredProcedure [dbo].[p_tblJobOpeningInformation_save]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_tblJobOpeningInformation_save]
@joiId int=0,
@positionTile varchar(50)=null,@contactId int=0,@recruitmetLeadId int=0,@recruiterId int=0,@targetDT date=null,@jobOpeningStatus varchar(50)=null,@clientId varchar(50)=null,@c_amId int=0,@openedDT date=null,@jobType varchar(50)=null,@city varchar(50)=null,@state varchar(50)=null,@minWorkExperience varchar(50)=null,@maxWorkExperience varchar(50)=null,@noOfPositions varchar(10)=null,@minCTC numeric(18,2)=0,@maxCTC numeric(18,2)=0,@jobDesc nvarchar(MAX)=null,@crtUserId int=0
AS
BEGIN
if(@joiId=0)
begin
declare @jobOpeningNo nvarchar(5)=null,@last_jobOpeningNo nvarchar(5)=null
select top 1 @last_jobOpeningNo=jobOpeningNo from tblJobOpeningInformation  order by joiId desc
set @jobOpeningNo=dbo.f_GenerateNo(@last_jobOpeningNo) 

INSERT INTO [dbo].[tblJobOpeningInformation]
           ([positionTile]
           ,[contactId]
           ,[recruitmetLeadId]
           ,[recruiterId]
           ,[targetDT]
           ,[jobOpeningStatus]
           ,[clientId]
           ,[c_amId]
           ,[openedDT]
           ,[jobType]
           ,[city]
           ,[state]
           ,[minWorkExperience]
           ,[maxWorkExperience]
           ,[noOfPositions]
           ,[minCTC]
           ,[maxCTC]
           ,[jobDesc]
           ,[crtDT],[crtUserId],jobOpeningNo)
     VALUES
    (@positionTile ,@contactId ,@recruitmetLeadId ,@recruiterId ,@targetDT ,@jobOpeningStatus ,@clientId ,@c_amId ,@openedDT ,@jobType ,@city ,@state ,@minWorkExperience ,@maxWorkExperience ,@noOfPositions ,@minCTC ,@maxCTC ,@jobDesc ,GETDATE(),@crtUserId,@jobOpeningNo)
    set @joiId=SCOPE_IDENTITY()
    select @joiId

end
else
begin
update tblJobOpeningInformation set positionTile=@positionTile,contactId=@contactId,recruitmetLeadId=@recruitmetLeadId,recruiterId=@recruiterId,targetDT=@targetDT,jobOpeningStatus=@jobOpeningStatus,clientId=@clientId,c_amId=@c_amId,openedDT=@openedDT,jobType=@jobType,city=@city,state=@state,minWorkExperience=@minWorkExperience,maxWorkExperience=@maxWorkExperience,noOfPositions=@noOfPositions,minCTC=@minCTC,maxCTC=@maxCTC,jobDesc=@jobDesc,modDT=GETDATE(),modUserId=@crtUserId
 where joiId=@joiId
select @joiId
end
END

GO
/****** Object:  StoredProcedure [dbo].[p_tblManageUser_delete]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_tblManageUser_delete]
@userId int=0
AS
BEGIN
	delete from tblManageUser where userId=@userId
END

GO
/****** Object:  StoredProcedure [dbo].[p_tblManageUser_get]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_tblManageUser_get]
AS
BEGIN
SELECT [userId]
      ,[firstName]
      ,[lastName]
      ,[emailId]
      ,[password]
      ,[confirmPassword]
      ,[mobileNo]
      ,[role]
      ,[portNo]
      ,[smtpServer]
      ,[status]
      ,isnull([recruitmetLeadId],0) as recruitmetLeadId,
     (select firstName from tblManageUser where userId=ISNULL(m.recruitmetLeadId,0)) as recruitmetLeadName ,
      managerName,emailPassword
      
      
  FROM [dbo].[tblManageUser] m where role<>'Admin' order by userId desc
END

GO
/****** Object:  StoredProcedure [dbo].[p_tblManageUser_getRecruiter]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_tblManageUser_getRecruiter]
AS
BEGIN
select userId,firstName from tblManageUser where role='Recruiter'
END

GO
/****** Object:  StoredProcedure [dbo].[p_tblManageUser_getRecruitmetLead]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_tblManageUser_getRecruitmetLead]

AS
BEGIN
select userId,firstName from tblManageUser where role='Recruitmet Lead'
END

GO
/****** Object:  StoredProcedure [dbo].[p_tblManageUser_save]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_tblManageUser_save]
@userId int=0,@firstName nvarchar(50)=null,@lastName nvarchar(50)=null,@emailId nvarchar(50)=null,@password nvarchar(50)=null,@confirmPassword nvarchar(50)=null,@mobileNo nvarchar(10)=null,@role nvarchar(50)=null,@portNo nvarchar(50)=null,@smtpServer nvarchar(50)=null,@status nvarchar(10)=null,@recruitmetLeadId int=0,@managerName nvarchar(50)=null,@emailPassword nvarchar(50)=null
AS
BEGIN
if(@userId=0)
begin
INSERT INTO [dbo].[tblManageUser]
           ([firstName]
           ,[lastName]
           ,[emailId]
           ,[password]
           ,[confirmPassword]
           ,[mobileNo]
           ,[role]
           ,[portNo]
           ,[smtpServer],[status],[recruitmetLeadId]
           ,[crtDT],managerName,emailPassword)
     VALUES(@firstName ,@lastName ,@emailId ,@password ,@confirmPassword ,@mobileNo ,@role ,@portNo ,@smtpServer ,@status,@recruitmetLeadId,GETDATE(),@managerName,@emailPassword)
end
	else
		begin
		update tblManageUser set firstName=@firstName,lastName=@lastName,emailId=@emailId,password=@password,confirmPassword=@confirmPassword,mobileNo=@mobileNo,role=@role,portNo=@portNo,smtpServer=@smtpServer,status=@status,recruitmetLeadId=@recruitmetLeadId,modDT=GETDATE() ,managerName=@managerName
	,emailPassword=	@emailPassword
		where userId=@userId
		end


END

GO
/****** Object:  StoredProcedure [dbo].[p_tblQualificationMaster_get]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_tblQualificationMaster_get]

AS
BEGIN
	SELECT [qualId]
      ,[qualification]
  FROM [dbo].[tblQualificationMaster]
END

GO
/****** Object:  StoredProcedure [dbo].[p_tblSource_get]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[p_tblSource_get]
AS
BEGIN
SELECT [sourceId]
      ,[source]
  FROM [dbo].[tblSource]
END

GO
/****** Object:  StoredProcedure [dbo].[updateCandidateStatus]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[updateCandidateStatus] 
	@cId int=0,@comments nvarchar(200),@csSubCatId int=0,@crtUserId int=0
AS
BEGIN
	update tblCandidate set 
     csSubCatId=@csSubCatId,modDT=GETDATE() ,modUserId=@crtUserId,comments=@comments
     where cId=@cId
  update tblAssociateJob_To_Candidate
   set
    csSubCatId=@csSubCatId,comments=@comments ,modDT=GETDATE(),modUserId=@crtUserId
  where associateJCId=(select top 1 associateJCId from tblAssociateJob_To_Candidate where candidateId=@cId order by associateJCId desc )
    
END

GO
/****** Object:  UserDefinedFunction [dbo].[f_GenerateNo]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[f_GenerateNo]
(

@no nvarchar(5)=null
)
RETURNS  nvarchar(5)
AS
BEGIN

	DECLARE @returnNo nvarchar(5)

	
  if(@no is null or @no='')
      set @returnNo='00001'
   else
      set @returnNo= RIGHT('00000'+ convert(varchar(5),@no+1) ,5)

	-- Return the result of the function
	RETURN @returnNo

END

GO
/****** Object:  UserDefinedFunction [dbo].[fn_Split]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_Split](@text varchar(8000), @delimiter varchar(20) = ' ')
RETURNS @Strings TABLE
(   
  position int IDENTITY PRIMARY KEY,
  value varchar(8000)  
)
AS
BEGIN

DECLARE @index int
SET @index = -1

WHILE (LEN(@text) > 0)
  BEGIN 
    SET @index = CHARINDEX(@delimiter , @text) 
    IF (@index = 0) AND (LEN(@text) > 0) 
      BEGIN  
        INSERT INTO @Strings VALUES (@text)
          BREAK 
      END 
    IF (@index > 1) 
      BEGIN  
        INSERT INTO @Strings VALUES (LEFT(@text, @index - 1))  
        SET @text = RIGHT(@text, (LEN(@text) - @index)) 
      END 
    ELSE
      SET @text = RIGHT(@text, (LEN(@text) - @index))
    END
  RETURN
END

GO
/****** Object:  Table [dbo].[tblAssociateJob_To_Candidate]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblAssociateJob_To_Candidate](
	[associateJCId] [int] IDENTITY(1,1) NOT NULL,
	[joiId] [int] NULL,
	[candidateId] [int] NULL,
	[comments] [nvarchar](200) NULL,
	[crtUserId] [int] NULL,
	[modUserId] [int] NULL,
	[crtDT] [datetime] NULL,
	[modDT] [datetime] NULL,
	[csSubCatId] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tblCandidate]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCandidate](
	[cId] [int] IDENTITY(1,1) NOT NULL,
	[email] [nvarchar](50) NULL,
	[firstName] [nvarchar](50) NULL,
	[middleName] [nvarchar](50) NULL,
	[lastName] [nvarchar](50) NULL,
	[phone] [nvarchar](20) NULL,
	[mobile] [nvarchar](10) NULL,
	[secondaryEmail] [nvarchar](50) NULL,
	[street] [nvarchar](100) NULL,
	[postalCode] [nvarchar](50) NULL,
	[city] [nvarchar](50) NULL,
	[state] [nvarchar](50) NULL,
	[country] [nvarchar](50) NULL,
	[experienceInYear] [nvarchar](10) NULL,
	[quaId] [int] NULL,
	[currentJobTitle] [nvarchar](50) NULL,
	[currentEmployer] [nvarchar](50) NULL,
	[expectedSalary] [numeric](12, 2) NULL,
	[currentSalary] [numeric](12, 2) NULL,
	[skillSet] [nvarchar](100) NULL,
	[csSubCatId] [int] NULL,
	[sourceId] [int] NULL,
	[resume] [nvarchar](100) NULL,
	[others] [nvarchar](100) NULL,
	[crtDT] [datetime] NULL,
	[modDT] [datetime] NULL,
	[crtUserId] [int] NULL,
	[modUserId] [int] NULL,
	[comments] [nvarchar](200) NULL,
	[candidateNo] [nvarchar](50) NULL,
 CONSTRAINT [PK_tblCandidate] PRIMARY KEY CLUSTERED 
(
	[cId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tblCandidateStatusCat]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblCandidateStatusCat](
	[csCatId] [int] IDENTITY(1,1) NOT NULL,
	[csCat] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblCandidateStatusSubCat]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCandidateStatusSubCat](
	[csSubCatId] [int] IDENTITY(1,1) NOT NULL,
	[csCatId] [int] NULL,
	[csSubCat] [nvarchar](50) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tblClient]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblClient](
	[clientId] [int] IDENTITY(1,1) NOT NULL,
	[clientName] [nvarchar](50) NULL,
	[website] [nvarchar](50) NULL,
	[recruitmetLeadId] [int] NULL,
	[crtUserId] [int] NULL,
	[modUserId] [int] NULL,
	[crtDT] [datetime] NULL,
	[modDT] [datetime] NULL,
	[recruiterId] [int] NULL,
	[aboutCompany] [nvarchar](1000) NULL,
 CONSTRAINT [PK_tblClient] PRIMARY KEY CLUSTERED 
(
	[clientId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tblClient_AccountManager]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblClient_AccountManager](
	[c_amId] [int] IDENTITY(1,1) NOT NULL,
	[clientId] [int] NULL,
	[accountManager] [nvarchar](50) NULL,
	[crtDT] [datetime] NULL,
	[modDT] [datetime] NULL,
	[contactNo] [nvarchar](15) NULL,
	[emailId] [nvarchar](50) NULL,
 CONSTRAINT [PK_tblClient_AccountManager] PRIMARY KEY CLUSTERED 
(
	[c_amId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tblContact]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblContact](
	[contactId] [int] IDENTITY(1,1) NOT NULL,
	[preName] [nvarchar](10) NULL,
	[firstName] [nvarchar](50) NULL,
	[lastName] [nvarchar](50) NULL,
	[clientId] [int] NULL,
	[email] [nvarchar](50) NULL,
	[workPhone] [nvarchar](20) NULL,
	[mobile] [nvarchar](15) NULL,
	[crtUserId] [int] NULL,
	[modUserId] [int] NULL,
	[crtDT] [datetime] NULL,
	[modDT] [datetime] NULL,
 CONSTRAINT [PK_tblContact] PRIMARY KEY CLUSTERED 
(
	[contactId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tblEducationDetails]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblEducationDetails](
	[eduId] [int] IDENTITY(1,1) NOT NULL,
	[cId] [int] NULL,
	[institute] [nvarchar](100) NULL,
	[departmant] [nvarchar](100) NULL,
	[degree] [nvarchar](100) NULL,
	[currentlyPursuing] [bit] NULL,
	[fromMonth] [nvarchar](10) NULL,
	[fromYear] [int] NULL,
	[toMonth] [nvarchar](10) NULL,
	[toYear] [int] NULL,
	[crtDT] [datetime] NULL,
	[modDT] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tblEmailTemplate]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblEmailTemplate](
	[etId] [int] IDENTITY(1,1) NOT NULL,
	[title] [nvarchar](50) NULL,
	[description] [nvarchar](500) NULL,
	[crtUserId] [int] NULL,
	[modUserId] [int] NULL,
	[crtDT] [datetime] NULL,
	[modDT] [datetime] NULL,
	[subject] [nvarchar](100) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tblExperienceDetails]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblExperienceDetails](
	[expId] [int] IDENTITY(1,1) NOT NULL,
	[cId] [int] NULL,
	[occupation] [nvarchar](100) NULL,
	[company] [nvarchar](100) NULL,
	[summery] [nvarchar](100) NULL,
	[currentlyWork] [bit] NULL,
	[fromMonth] [nvarchar](10) NULL,
	[fromYear] [int] NULL,
	[toMonth] [nvarchar](10) NULL,
	[toYear] [int] NULL,
	[crtDT] [datetime] NULL,
	[modDT] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tblInterviewNameMaster]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblInterviewNameMaster](
	[imId] [int] IDENTITY(1,1) NOT NULL,
	[interviewName] [nvarchar](50) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tblInterviews]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblInterviews](
	[interviewId] [int] IDENTITY(1,1) NOT NULL,
	[imId] [int] NULL,
	[candidateId] [int] NULL,
	[clientId] [int] NULL,
	[joiId] [int] NULL,
	[c_amId] [int] NULL,
	[toDate] [date] NULL,
	[toTime] [nvarchar](20) NULL,
	[interviewStatus] [nvarchar](20) NULL,
	[location] [nvarchar](100) NULL,
	[scheduleComments] [nvarchar](500) NULL,
	[others_Photo_Doc] [nvarchar](100) NULL,
	[crtUserId] [int] NULL,
	[modUserId] [int] NULL,
	[crtDT] [datetime] NULL,
	[modDT] [datetime] NULL,
 CONSTRAINT [PK_tblInterviews] PRIMARY KEY CLUSTERED 
(
	[interviewId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tblJobOpeningInformation]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblJobOpeningInformation](
	[joiId] [int] IDENTITY(1,1) NOT NULL,
	[positionTile] [varchar](50) NULL,
	[contactId] [int] NULL,
	[recruitmetLeadId] [int] NULL,
	[recruiterId] [int] NULL,
	[targetDT] [date] NULL,
	[jobOpeningStatus] [varchar](50) NULL,
	[clientId] [int] NULL,
	[c_amId] [int] NULL,
	[openedDT] [date] NULL,
	[jobType] [varchar](50) NULL,
	[city] [varchar](50) NULL,
	[state] [varchar](50) NULL,
	[minWorkExperience] [varchar](50) NULL,
	[maxWorkExperience] [varchar](50) NULL,
	[noOfPositions] [varchar](10) NULL,
	[minCTC] [numeric](18, 2) NULL,
	[maxCTC] [numeric](18, 2) NULL,
	[jobDesc] [nvarchar](max) NULL,
	[jobSummery] [varchar](100) NULL,
	[crtDT] [datetime] NULL,
	[modDT] [datetime] NULL,
	[crtUserId] [int] NULL,
	[modUserId] [int] NULL,
	[jobOpeningNo] [nvarchar](5) NULL,
 CONSTRAINT [PK_tblJobOpeningInformation] PRIMARY KEY CLUSTERED 
(
	[joiId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblManageUser]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblManageUser](
	[userId] [int] IDENTITY(1,1) NOT NULL,
	[firstName] [nvarchar](50) NULL,
	[lastName] [nvarchar](50) NULL,
	[emailId] [nvarchar](50) NULL,
	[password] [nvarchar](50) NULL,
	[confirmPassword] [nvarchar](50) NULL,
	[mobileNo] [nvarchar](50) NULL,
	[role] [nvarchar](50) NULL,
	[portNo] [nvarchar](50) NULL,
	[smtpServer] [nvarchar](50) NULL,
	[status] [nvarchar](50) NULL,
	[recruitmetLeadId] [int] NULL,
	[crtDT] [datetime] NULL,
	[modDT] [datetime] NULL,
	[managerName] [nvarchar](50) NULL,
	[emailPassword] [nvarchar](50) NULL,
 CONSTRAINT [PK_tblManageUser] PRIMARY KEY CLUSTERED 
(
	[userId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tblQualificationMaster]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblQualificationMaster](
	[qualId] [int] IDENTITY(1,1) NOT NULL,
	[qualification] [nvarchar](50) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tblSource]    Script Date: 2/09/2018 9:07:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblSource](
	[sourceId] [int] IDENTITY(1,1) NOT NULL,
	[source] [nvarchar](50) NULL
) ON [PRIMARY]

GO
SET IDENTITY_INSERT [dbo].[tblAssociateJob_To_Candidate] ON 

INSERT [dbo].[tblAssociateJob_To_Candidate] ([associateJCId], [joiId], [candidateId], [comments], [crtUserId], [modUserId], [crtDT], [modDT], [csSubCatId]) VALUES (32, 26, 21, NULL, 28, NULL, CAST(0x0000A93600BA8D3D AS DateTime), NULL, 10)
INSERT [dbo].[tblAssociateJob_To_Candidate] ([associateJCId], [joiId], [candidateId], [comments], [crtUserId], [modUserId], [crtDT], [modDT], [csSubCatId]) VALUES (33, 28, 23, N'done', 28, NULL, CAST(0x0000A93800AACA86 AS DateTime), NULL, 10)
INSERT [dbo].[tblAssociateJob_To_Candidate] ([associateJCId], [joiId], [candidateId], [comments], [crtUserId], [modUserId], [crtDT], [modDT], [csSubCatId]) VALUES (34, 28, 24, NULL, 28, NULL, CAST(0x0000A93800AAF55B AS DateTime), NULL, 10)
INSERT [dbo].[tblAssociateJob_To_Candidate] ([associateJCId], [joiId], [candidateId], [comments], [crtUserId], [modUserId], [crtDT], [modDT], [csSubCatId]) VALUES (35, 28, 21, NULL, 28, NULL, CAST(0x0000A93800AAF55B AS DateTime), NULL, 10)
INSERT [dbo].[tblAssociateJob_To_Candidate] ([associateJCId], [joiId], [candidateId], [comments], [crtUserId], [modUserId], [crtDT], [modDT], [csSubCatId]) VALUES (36, 28, 19, NULL, 28, NULL, CAST(0x0000A93800AAF55B AS DateTime), NULL, 10)
INSERT [dbo].[tblAssociateJob_To_Candidate] ([associateJCId], [joiId], [candidateId], [comments], [crtUserId], [modUserId], [crtDT], [modDT], [csSubCatId]) VALUES (37, 28, 18, NULL, 28, NULL, CAST(0x0000A93800AAF55C AS DateTime), NULL, 10)
INSERT [dbo].[tblAssociateJob_To_Candidate] ([associateJCId], [joiId], [candidateId], [comments], [crtUserId], [modUserId], [crtDT], [modDT], [csSubCatId]) VALUES (38, 28, 17, NULL, 28, NULL, CAST(0x0000A93800AAF55C AS DateTime), NULL, 10)
INSERT [dbo].[tblAssociateJob_To_Candidate] ([associateJCId], [joiId], [candidateId], [comments], [crtUserId], [modUserId], [crtDT], [modDT], [csSubCatId]) VALUES (39, 30, 24, NULL, 28, NULL, CAST(0x0000A948017F3290 AS DateTime), NULL, 10)
INSERT [dbo].[tblAssociateJob_To_Candidate] ([associateJCId], [joiId], [candidateId], [comments], [crtUserId], [modUserId], [crtDT], [modDT], [csSubCatId]) VALUES (40, 30, 23, N'ejhvd', 28, NULL, CAST(0x0000A94C00FB324E AS DateTime), NULL, 10)
INSERT [dbo].[tblAssociateJob_To_Candidate] ([associateJCId], [joiId], [candidateId], [comments], [crtUserId], [modUserId], [crtDT], [modDT], [csSubCatId]) VALUES (41, 30, 21, N'ejhvd', 28, NULL, CAST(0x0000A94C00FB324E AS DateTime), NULL, 10)
INSERT [dbo].[tblAssociateJob_To_Candidate] ([associateJCId], [joiId], [candidateId], [comments], [crtUserId], [modUserId], [crtDT], [modDT], [csSubCatId]) VALUES (44, 32, 24, N'Hlo', 28, NULL, CAST(0x0000A94E00D9E8B7 AS DateTime), NULL, 10)
INSERT [dbo].[tblAssociateJob_To_Candidate] ([associateJCId], [joiId], [candidateId], [comments], [crtUserId], [modUserId], [crtDT], [modDT], [csSubCatId]) VALUES (45, 32, 23, N'Hlo', 28, NULL, CAST(0x0000A94E00D9E8B8 AS DateTime), NULL, 10)
INSERT [dbo].[tblAssociateJob_To_Candidate] ([associateJCId], [joiId], [candidateId], [comments], [crtUserId], [modUserId], [crtDT], [modDT], [csSubCatId]) VALUES (42, 30, 19, N'NO', 28, NULL, CAST(0x0000A94E00D196A2 AS DateTime), NULL, 10)
INSERT [dbo].[tblAssociateJob_To_Candidate] ([associateJCId], [joiId], [candidateId], [comments], [crtUserId], [modUserId], [crtDT], [modDT], [csSubCatId]) VALUES (43, 30, 18, N'NO', 28, NULL, CAST(0x0000A94E00D196A6 AS DateTime), NULL, 10)
INSERT [dbo].[tblAssociateJob_To_Candidate] ([associateJCId], [joiId], [candidateId], [comments], [crtUserId], [modUserId], [crtDT], [modDT], [csSubCatId]) VALUES (46, 32, 27, N'sdjasdfjh', 28, NULL, CAST(0x0000A94E0138B8E0 AS DateTime), NULL, 10)
INSERT [dbo].[tblAssociateJob_To_Candidate] ([associateJCId], [joiId], [candidateId], [comments], [crtUserId], [modUserId], [crtDT], [modDT], [csSubCatId]) VALUES (47, 30, 27, N'sdjasdfjh', 28, NULL, CAST(0x0000A94E0138B8E1 AS DateTime), NULL, 10)
SET IDENTITY_INSERT [dbo].[tblAssociateJob_To_Candidate] OFF
SET IDENTITY_INSERT [dbo].[tblCandidate] ON 

INSERT [dbo].[tblCandidate] ([cId], [email], [firstName], [middleName], [lastName], [phone], [mobile], [secondaryEmail], [street], [postalCode], [city], [state], [country], [experienceInYear], [quaId], [currentJobTitle], [currentEmployer], [expectedSalary], [currentSalary], [skillSet], [csSubCatId], [sourceId], [resume], [others], [crtDT], [modDT], [crtUserId], [modUserId], [comments], [candidateNo]) VALUES (15, N'rajatuppal33@gmail.com', N'Rajat', N'No', N'Uppal', N'1010101010', N'1001010101', NULL, N'Rtk', N'156161', N'Rohtak', N'Haryana', N'India', N'10', 2, N'Project-Manager', N'11', CAST(10.00 AS Numeric(12, 2)), CAST(10.00 AS Numeric(12, 2)), N'10', 10, 3, N'e00f32c4-2d8b-43b8-be0f-05a7704bd6f4.jpg', N'ab65d85b-015c-4efa-b62e-6af4a8420c30.jpg', CAST(0x0000A91301142AC7 AS DateTime), CAST(0x0000A9130114377F AS DateTime), 17, 17, N'NO', NULL)
INSERT [dbo].[tblCandidate] ([cId], [email], [firstName], [middleName], [lastName], [phone], [mobile], [secondaryEmail], [street], [postalCode], [city], [state], [country], [experienceInYear], [quaId], [currentJobTitle], [currentEmployer], [expectedSalary], [currentSalary], [skillSet], [csSubCatId], [sourceId], [resume], [others], [crtDT], [modDT], [crtUserId], [modUserId], [comments], [candidateNo]) VALUES (16, N'Rajatuppal331111@gmail.com', N'Rajat', N'NO', N'Uppal', N'1010101010', N'1111111110', NULL, N'No', N'1', N'1', N'1', N'1', N'1', 6, N'Project-Lead', N'1', CAST(10.00 AS Numeric(12, 2)), CAST(100.00 AS Numeric(12, 2)), N'1', 10, 2, N'9411ea20-3b67-4a0f-ba98-71c9a617752b.jpg', N'8ee6ade0-70ab-4da4-b551-841746b73437.jpg', CAST(0x0000A915014ACBBC AS DateTime), CAST(0x0000A92E0186DBE7 AS DateTime), 17, 28, N'NO', NULL)
INSERT [dbo].[tblCandidate] ([cId], [email], [firstName], [middleName], [lastName], [phone], [mobile], [secondaryEmail], [street], [postalCode], [city], [state], [country], [experienceInYear], [quaId], [currentJobTitle], [currentEmployer], [expectedSalary], [currentSalary], [skillSet], [csSubCatId], [sourceId], [resume], [others], [crtDT], [modDT], [crtUserId], [modUserId], [comments], [candidateNo]) VALUES (17, N'Rajatuppal3311@gmail.com', N'Rajat', N'no', N'uppal', N'8923483462', N'1111111111', N'y3294392493', N'392', N'382', N'y912', N'8t8', N't89t9', N't9', 5, N'Project-Lead', N'1', CAST(1.00 AS Numeric(12, 2)), CAST(1.00 AS Numeric(12, 2)), N'1', 10, 2, N'1b30fd15-0e54-4348-8e69-00e70d2b301b.jpg', NULL, CAST(0x0000A91C01409676 AS DateTime), CAST(0x0000A92E018649BE AS DateTime), 17, 28, NULL, NULL)
INSERT [dbo].[tblCandidate] ([cId], [email], [firstName], [middleName], [lastName], [phone], [mobile], [secondaryEmail], [street], [postalCode], [city], [state], [country], [experienceInYear], [quaId], [currentJobTitle], [currentEmployer], [expectedSalary], [currentSalary], [skillSet], [csSubCatId], [sourceId], [resume], [others], [crtDT], [modDT], [crtUserId], [modUserId], [comments], [candidateNo]) VALUES (18, N'test1@gmail.com', N'test', N'no', N'testlast', N'1010101010', N'1111111111', NULL, N'10', N'1', N'Rtk', N'Haryana', N'India', N'10', 2, N'Project-Lead', N'NO', CAST(10.00 AS Numeric(12, 2)), CAST(100.00 AS Numeric(12, 2)), N'Angularjs', 10, 2, NULL, NULL, CAST(0x0000A91F010B8F23 AS DateTime), CAST(0x0000A92E0186544D AS DateTime), 17, 28, N'NO', NULL)
INSERT [dbo].[tblCandidate] ([cId], [email], [firstName], [middleName], [lastName], [phone], [mobile], [secondaryEmail], [street], [postalCode], [city], [state], [country], [experienceInYear], [quaId], [currentJobTitle], [currentEmployer], [expectedSalary], [currentSalary], [skillSet], [csSubCatId], [sourceId], [resume], [others], [crtDT], [modDT], [crtUserId], [modUserId], [comments], [candidateNo]) VALUES (19, N'Rajatuppal22@gmail.com', N'Rajat', N'm', N'uppal', N'3242349234', N'3128368612', N'u3t234', N'7`77', N'7', N'7', N'7', N'7', N'7', 1, N'Fresher', N'No', CAST(111.00 AS Numeric(12, 2)), CAST(111.00 AS Numeric(12, 2)), N'1', 10, 2, N'b337d003-cd60-4dd6-830d-96c58f056f8f.pdf', N'2cf24a60-0065-4be2-8f17-7a332761611d.doc', CAST(0x0000A92F00C3F1DE AS DateTime), CAST(0x0000A92F00E23184 AS DateTime), 28, 28, N'NO', N'00001')
INSERT [dbo].[tblCandidate] ([cId], [email], [firstName], [middleName], [lastName], [phone], [mobile], [secondaryEmail], [street], [postalCode], [city], [state], [country], [experienceInYear], [quaId], [currentJobTitle], [currentEmployer], [expectedSalary], [currentSalary], [skillSet], [csSubCatId], [sourceId], [resume], [others], [crtDT], [modDT], [crtUserId], [modUserId], [comments], [candidateNo]) VALUES (21, N'geet@gmail.com', N'Geet', NULL, N'Roy', N'0124-42099', N'7777777777', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, CAST(0.00 AS Numeric(12, 2)), CAST(0.00 AS Numeric(12, 2)), NULL, 10, 1, NULL, NULL, CAST(0x0000A93600B9948E AS DateTime), NULL, 28, NULL, N'ejhvd', N'00001')
INSERT [dbo].[tblCandidate] ([cId], [email], [firstName], [middleName], [lastName], [phone], [mobile], [secondaryEmail], [street], [postalCode], [city], [state], [country], [experienceInYear], [quaId], [currentJobTitle], [currentEmployer], [expectedSalary], [currentSalary], [skillSet], [csSubCatId], [sourceId], [resume], [others], [crtDT], [modDT], [crtUserId], [modUserId], [comments], [candidateNo]) VALUES (23, N'mehul@g.com', N'mehul', NULL, NULL, N'345t678902', N'2345678934', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, CAST(0.00 AS Numeric(12, 2)), CAST(0.00 AS Numeric(12, 2)), NULL, 10, 1, N'e51af6a8-13c4-4fe4-9bf3-a6afa42b2cff.doc', NULL, CAST(0x0000A93700FBD626 AS DateTime), CAST(0x0000A93700FBFB87 AS DateTime), 28, 28, N'Hlo', N'00003')
INSERT [dbo].[tblCandidate] ([cId], [email], [firstName], [middleName], [lastName], [phone], [mobile], [secondaryEmail], [street], [postalCode], [city], [state], [country], [experienceInYear], [quaId], [currentJobTitle], [currentEmployer], [expectedSalary], [currentSalary], [skillSet], [csSubCatId], [sourceId], [resume], [others], [crtDT], [modDT], [crtUserId], [modUserId], [comments], [candidateNo]) VALUES (24, N'amit@gmail.com', N'Amit', N'no', N'uppal', N'3784523846', N'8638648236', NULL, N'1', N'1', N'1', N'1', N'1', N'1', 1, N'Fresher', N'11', CAST(11.00 AS Numeric(12, 2)), CAST(11.00 AS Numeric(12, 2)), N'11', 10, 2, NULL, NULL, CAST(0x0000A9370137FF9C AS DateTime), NULL, 28, NULL, N'Hlo', N'00004')
INSERT [dbo].[tblCandidate] ([cId], [email], [firstName], [middleName], [lastName], [phone], [mobile], [secondaryEmail], [street], [postalCode], [city], [state], [country], [experienceInYear], [quaId], [currentJobTitle], [currentEmployer], [expectedSalary], [currentSalary], [skillSet], [csSubCatId], [sourceId], [resume], [others], [crtDT], [modDT], [crtUserId], [modUserId], [comments], [candidateNo]) VALUES (26, N'jhsvsjxvzVJVS', N'KJBbkbks', N'skb', N'ksxbk', N'98634892346968969', N'6896924692', N'sadbjk@gmail.com', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, CAST(0.00 AS Numeric(12, 2)), CAST(0.00 AS Numeric(12, 2)), NULL, 4, 4, NULL, NULL, CAST(0x0000A94E01316ED4 AS DateTime), NULL, 28, NULL, NULL, N'00005')
INSERT [dbo].[tblCandidate] ([cId], [email], [firstName], [middleName], [lastName], [phone], [mobile], [secondaryEmail], [street], [postalCode], [city], [state], [country], [experienceInYear], [quaId], [currentJobTitle], [currentEmployer], [expectedSalary], [currentSalary], [skillSet], [csSubCatId], [sourceId], [resume], [others], [crtDT], [modDT], [crtUserId], [modUserId], [comments], [candidateNo]) VALUES (27, N'asdghfdsajhfj', N'vjsvj', N'sdfufavj', N'vjsvj', N'782328482364823686', N'8358452384', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, CAST(0.00 AS Numeric(12, 2)), CAST(0.00 AS Numeric(12, 2)), NULL, 10, 4, NULL, NULL, CAST(0x0000A94E01364F66 AS DateTime), NULL, 28, NULL, N'sdjasdfjh', N'00006')
SET IDENTITY_INSERT [dbo].[tblCandidate] OFF
SET IDENTITY_INSERT [dbo].[tblCandidateStatusCat] ON 

INSERT [dbo].[tblCandidateStatusCat] ([csCatId], [csCat]) VALUES (1, N'Screening')
INSERT [dbo].[tblCandidateStatusCat] ([csCatId], [csCat]) VALUES (2, N'Submission')
INSERT [dbo].[tblCandidateStatusCat] ([csCatId], [csCat]) VALUES (3, N'Interview')
INSERT [dbo].[tblCandidateStatusCat] ([csCatId], [csCat]) VALUES (4, N'Offered')
INSERT [dbo].[tblCandidateStatusCat] ([csCatId], [csCat]) VALUES (5, N'Hired')
SET IDENTITY_INSERT [dbo].[tblCandidateStatusCat] OFF
SET IDENTITY_INSERT [dbo].[tblCandidateStatusSubCat] ON 

INSERT [dbo].[tblCandidateStatusSubCat] ([csSubCatId], [csCatId], [csSubCat]) VALUES (1, 1, N'New')
INSERT [dbo].[tblCandidateStatusSubCat] ([csSubCatId], [csCatId], [csSubCat]) VALUES (2, 1, N'Waiting-for-Evaluation')
INSERT [dbo].[tblCandidateStatusSubCat] ([csSubCatId], [csCatId], [csSubCat]) VALUES (3, 1, N'Contacted')
INSERT [dbo].[tblCandidateStatusSubCat] ([csSubCatId], [csCatId], [csSubCat]) VALUES (4, 1, N'Contact in Future')
INSERT [dbo].[tblCandidateStatusSubCat] ([csSubCatId], [csCatId], [csSubCat]) VALUES (5, 1, N'Not Contacted')
INSERT [dbo].[tblCandidateStatusSubCat] ([csSubCatId], [csCatId], [csSubCat]) VALUES (6, 1, N'Attempted to Contact')
INSERT [dbo].[tblCandidateStatusSubCat] ([csSubCatId], [csCatId], [csSubCat]) VALUES (7, 1, N'Qualified')
INSERT [dbo].[tblCandidateStatusSubCat] ([csSubCatId], [csCatId], [csSubCat]) VALUES (8, 1, N'Unqualified')
INSERT [dbo].[tblCandidateStatusSubCat] ([csSubCatId], [csCatId], [csSubCat]) VALUES (9, 1, N'Junk Candidate')
INSERT [dbo].[tblCandidateStatusSubCat] ([csSubCatId], [csCatId], [csSubCat]) VALUES (10, 1, N'Associated')
INSERT [dbo].[tblCandidateStatusSubCat] ([csSubCatId], [csCatId], [csSubCat]) VALUES (11, 1, N'Rejected')
INSERT [dbo].[tblCandidateStatusSubCat] ([csSubCatId], [csCatId], [csSubCat]) VALUES (12, 2, N'Submitted-to-client')
INSERT [dbo].[tblCandidateStatusSubCat] ([csSubCatId], [csCatId], [csSubCat]) VALUES (13, 2, N'Approved by client')
INSERT [dbo].[tblCandidateStatusSubCat] ([csSubCatId], [csCatId], [csSubCat]) VALUES (14, 2, N'Rejected by client')
INSERT [dbo].[tblCandidateStatusSubCat] ([csSubCatId], [csCatId], [csSubCat]) VALUES (15, 3, N'Interview-to-be-Scheduled')
INSERT [dbo].[tblCandidateStatusSubCat] ([csSubCatId], [csCatId], [csSubCat]) VALUES (16, 3, N'Interview-Scheduled')
INSERT [dbo].[tblCandidateStatusSubCat] ([csSubCatId], [csCatId], [csSubCat]) VALUES (17, 3, N'Interview-in-Progress')
INSERT [dbo].[tblCandidateStatusSubCat] ([csSubCatId], [csCatId], [csSubCat]) VALUES (18, 3, N'On-Hold')
INSERT [dbo].[tblCandidateStatusSubCat] ([csSubCatId], [csCatId], [csSubCat]) VALUES (19, 3, N'Rejected-Hirable')
INSERT [dbo].[tblCandidateStatusSubCat] ([csSubCatId], [csCatId], [csSubCat]) VALUES (20, 3, N'Rejected-for-Interview ')
INSERT [dbo].[tblCandidateStatusSubCat] ([csSubCatId], [csCatId], [csSubCat]) VALUES (21, 4, N'To-be-Offered')
INSERT [dbo].[tblCandidateStatusSubCat] ([csSubCatId], [csCatId], [csSubCat]) VALUES (22, 4, N'Offer-Accepted')
INSERT [dbo].[tblCandidateStatusSubCat] ([csSubCatId], [csCatId], [csSubCat]) VALUES (23, 4, N'Offer-Made')
INSERT [dbo].[tblCandidateStatusSubCat] ([csSubCatId], [csCatId], [csSubCat]) VALUES (24, 4, N'Offer-Declined')
INSERT [dbo].[tblCandidateStatusSubCat] ([csSubCatId], [csCatId], [csSubCat]) VALUES (25, 4, N'Offer-Withdrawn')
INSERT [dbo].[tblCandidateStatusSubCat] ([csSubCatId], [csCatId], [csSubCat]) VALUES (26, 5, N'Hired')
INSERT [dbo].[tblCandidateStatusSubCat] ([csSubCatId], [csCatId], [csSubCat]) VALUES (27, 5, N'Joined')
INSERT [dbo].[tblCandidateStatusSubCat] ([csSubCatId], [csCatId], [csSubCat]) VALUES (28, 5, N'No-Show')
INSERT [dbo].[tblCandidateStatusSubCat] ([csSubCatId], [csCatId], [csSubCat]) VALUES (29, 5, N'Converted-Employee')
SET IDENTITY_INSERT [dbo].[tblCandidateStatusSubCat] OFF
SET IDENTITY_INSERT [dbo].[tblClient] ON 

INSERT [dbo].[tblClient] ([clientId], [clientName], [website], [recruitmetLeadId], [crtUserId], [modUserId], [crtDT], [modDT], [recruiterId], [aboutCompany]) VALUES (67, N'kaka', N'www.kaka.com', 13, 17, NULL, CAST(0x0000A91C00CBB0CC AS DateTime), NULL, 17, N'1')
INSERT [dbo].[tblClient] ([clientId], [clientName], [website], [recruitmetLeadId], [crtUserId], [modUserId], [crtDT], [modDT], [recruiterId], [aboutCompany]) VALUES (88, N'TCS', N'www.okn.com', 13, 28, 28, CAST(0x0000A93500D6C434 AS DateTime), CAST(0x0000A9350135CC38 AS DateTime), 17, NULL)
INSERT [dbo].[tblClient] ([clientId], [clientName], [website], [recruitmetLeadId], [crtUserId], [modUserId], [crtDT], [modDT], [recruiterId], [aboutCompany]) VALUES (89, N'HCL', N'www.hcl.com', 29, 28, NULL, CAST(0x0000A93500D77208 AS DateTime), NULL, 31, NULL)
INSERT [dbo].[tblClient] ([clientId], [clientName], [website], [recruitmetLeadId], [crtUserId], [modUserId], [crtDT], [modDT], [recruiterId], [aboutCompany]) VALUES (90, N'oKN', N'www.oknsoftware.com', 13, 28, NULL, CAST(0x0000A93500D8BA10 AS DateTime), NULL, 19, NULL)
INSERT [dbo].[tblClient] ([clientId], [clientName], [website], [recruitmetLeadId], [crtUserId], [modUserId], [crtDT], [modDT], [recruiterId], [aboutCompany]) VALUES (91, N'company', N'www.company.com', 13, 28, NULL, CAST(0x0000A93500D9936E AS DateTime), NULL, 17, N'dsj')
INSERT [dbo].[tblClient] ([clientId], [clientName], [website], [recruitmetLeadId], [crtUserId], [modUserId], [crtDT], [modDT], [recruiterId], [aboutCompany]) VALUES (92, N'company2', N'www.comapny.com', 13, 28, NULL, CAST(0x0000A93500E17B89 AS DateTime), NULL, 17, NULL)
INSERT [dbo].[tblClient] ([clientId], [clientName], [website], [recruitmetLeadId], [crtUserId], [modUserId], [crtDT], [modDT], [recruiterId], [aboutCompany]) VALUES (93, N'abc.com', N'ojkn@gmail.com', 13, 28, NULL, CAST(0x0000A93500E26555 AS DateTime), NULL, 17, N'jefjfds')
INSERT [dbo].[tblClient] ([clientId], [clientName], [website], [recruitmetLeadId], [crtUserId], [modUserId], [crtDT], [modDT], [recruiterId], [aboutCompany]) VALUES (94, N'jadfs', N'jvasj', 13, 28, NULL, CAST(0x0000A93500F2870B AS DateTime), NULL, 19, NULL)
INSERT [dbo].[tblClient] ([clientId], [clientName], [website], [recruitmetLeadId], [crtUserId], [modUserId], [crtDT], [modDT], [recruiterId], [aboutCompany]) VALUES (95, N'Rajat', N'ab.com', 13, 28, NULL, CAST(0x0000A93500F2BC26 AS DateTime), NULL, 17, NULL)
INSERT [dbo].[tblClient] ([clientId], [clientName], [website], [recruitmetLeadId], [crtUserId], [modUserId], [crtDT], [modDT], [recruiterId], [aboutCompany]) VALUES (96, N'ytdsf', N'vdshaj', 13, 28, NULL, CAST(0x0000A93500F3F7F9 AS DateTime), NULL, 17, NULL)
INSERT [dbo].[tblClient] ([clientId], [clientName], [website], [recruitmetLeadId], [crtUserId], [modUserId], [crtDT], [modDT], [recruiterId], [aboutCompany]) VALUES (97, N'dsjh', N'vjhasjv', 13, 28, NULL, CAST(0x0000A93500F4A90C AS DateTime), NULL, 17, NULL)
INSERT [dbo].[tblClient] ([clientId], [clientName], [website], [recruitmetLeadId], [crtUserId], [modUserId], [crtDT], [modDT], [recruiterId], [aboutCompany]) VALUES (98, N'sdjf', N'jhvasjh', 13, 28, NULL, CAST(0x0000A93500F56D02 AS DateTime), NULL, 19, NULL)
INSERT [dbo].[tblClient] ([clientId], [clientName], [website], [recruitmetLeadId], [crtUserId], [modUserId], [crtDT], [modDT], [recruiterId], [aboutCompany]) VALUES (99, N'djhsv', N'jvdasj', 13, 28, NULL, CAST(0x0000A93500F5F87A AS DateTime), NULL, 17, NULL)
INSERT [dbo].[tblClient] ([clientId], [clientName], [website], [recruitmetLeadId], [crtUserId], [modUserId], [crtDT], [modDT], [recruiterId], [aboutCompany]) VALUES (100, N'aedhsvh', N'vjvasjh', 13, 28, NULL, CAST(0x0000A93500F6B1BA AS DateTime), NULL, 19, N'jvb')
INSERT [dbo].[tblClient] ([clientId], [clientName], [website], [recruitmetLeadId], [crtUserId], [modUserId], [crtDT], [modDT], [recruiterId], [aboutCompany]) VALUES (101, N'jasdavj H', N'VH', 13, 28, NULL, CAST(0x0000A93500F713A0 AS DateTime), NULL, 19, N'JHVJ  H')
INSERT [dbo].[tblClient] ([clientId], [clientName], [website], [recruitmetLeadId], [crtUserId], [modUserId], [crtDT], [modDT], [recruiterId], [aboutCompany]) VALUES (102, N'asdfjvh', N'hvjasj', 29, 28, NULL, CAST(0x0000A93500F80E66 AS DateTime), NULL, 31, N'adsj')
INSERT [dbo].[tblClient] ([clientId], [clientName], [website], [recruitmetLeadId], [crtUserId], [modUserId], [crtDT], [modDT], [recruiterId], [aboutCompany]) VALUES (103, N'asjhv', N'jhasbj', 13, 28, NULL, CAST(0x0000A93500F860F1 AS DateTime), NULL, 19, N'asdjh')
INSERT [dbo].[tblClient] ([clientId], [clientName], [website], [recruitmetLeadId], [crtUserId], [modUserId], [crtDT], [modDT], [recruiterId], [aboutCompany]) VALUES (104, N'hs', N'jas j', 13, 28, NULL, CAST(0x0000A93500F8DF56 AS DateTime), NULL, 17, N'DSJH')
INSERT [dbo].[tblClient] ([clientId], [clientName], [website], [recruitmetLeadId], [crtUserId], [modUserId], [crtDT], [modDT], [recruiterId], [aboutCompany]) VALUES (106, N'Amazon', NULL, 38, 28, NULL, CAST(0x0000A93600B20EF3 AS DateTime), NULL, 39, NULL)
INSERT [dbo].[tblClient] ([clientId], [clientName], [website], [recruitmetLeadId], [crtUserId], [modUserId], [crtDT], [modDT], [recruiterId], [aboutCompany]) VALUES (107, N'Microsft', NULL, 38, 28, NULL, CAST(0x0000A9370164D396 AS DateTime), NULL, 39, NULL)
INSERT [dbo].[tblClient] ([clientId], [clientName], [website], [recruitmetLeadId], [crtUserId], [modUserId], [crtDT], [modDT], [recruiterId], [aboutCompany]) VALUES (108, N'flip', NULL, 38, 28, NULL, CAST(0x0000A93701665D7C AS DateTime), NULL, 39, NULL)
INSERT [dbo].[tblClient] ([clientId], [clientName], [website], [recruitmetLeadId], [crtUserId], [modUserId], [crtDT], [modDT], [recruiterId], [aboutCompany]) VALUES (109, N'sybjn', NULL, 38, 28, NULL, CAST(0x0000A93800AA09A4 AS DateTime), NULL, 39, NULL)
INSERT [dbo].[tblClient] ([clientId], [clientName], [website], [recruitmetLeadId], [crtUserId], [modUserId], [crtDT], [modDT], [recruiterId], [aboutCompany]) VALUES (110, N'New Tech', N'none', 38, 28, NULL, CAST(0x0000A948017B04C1 AS DateTime), NULL, 42, NULL)
SET IDENTITY_INSERT [dbo].[tblClient] OFF
SET IDENTITY_INSERT [dbo].[tblClient_AccountManager] ON 

INSERT [dbo].[tblClient_AccountManager] ([c_amId], [clientId], [accountManager], [crtDT], [modDT], [contactNo], [emailId]) VALUES (1, 30, N'1', CAST(0x0000A91900FDD66E AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[tblClient_AccountManager] ([c_amId], [clientId], [accountManager], [crtDT], [modDT], [contactNo], [emailId]) VALUES (2, 30, N'2', CAST(0x0000A91900FDD694 AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[tblClient_AccountManager] ([c_amId], [clientId], [accountManager], [crtDT], [modDT], [contactNo], [emailId]) VALUES (3, 31, NULL, CAST(0x0000A919010683ED AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[tblClient_AccountManager] ([c_amId], [clientId], [accountManager], [crtDT], [modDT], [contactNo], [emailId]) VALUES (4, 33, N'Rajat', CAST(0x0000A919010BFFAB AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[tblClient_AccountManager] ([c_amId], [clientId], [accountManager], [crtDT], [modDT], [contactNo], [emailId]) VALUES (5, 33, N'Uppal', CAST(0x0000A919010BFFAC AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[tblClient_AccountManager] ([c_amId], [clientId], [accountManager], [crtDT], [modDT], [contactNo], [emailId]) VALUES (6, 43, N'10', CAST(0x0000A919012686CA AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[tblClient_AccountManager] ([c_amId], [clientId], [accountManager], [crtDT], [modDT], [contactNo], [emailId]) VALUES (7, 43, N'10', CAST(0x0000A919012686D5 AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[tblClient_AccountManager] ([c_amId], [clientId], [accountManager], [crtDT], [modDT], [contactNo], [emailId]) VALUES (8, 44, N'10', CAST(0x0000A91901297EE7 AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[tblClient_AccountManager] ([c_amId], [clientId], [accountManager], [crtDT], [modDT], [contactNo], [emailId]) VALUES (9, 45, N'10', CAST(0x0000A919012984A2 AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[tblClient_AccountManager] ([c_amId], [clientId], [accountManager], [crtDT], [modDT], [contactNo], [emailId]) VALUES (10, 46, N'1', CAST(0x0000A91901305831 AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[tblClient_AccountManager] ([c_amId], [clientId], [accountManager], [crtDT], [modDT], [contactNo], [emailId]) VALUES (11, 46, N'1', CAST(0x0000A91901305831 AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[tblClient_AccountManager] ([c_amId], [clientId], [accountManager], [crtDT], [modDT], [contactNo], [emailId]) VALUES (12, 64, N'Rajat', CAST(0x0000A91B00BED4A9 AS DateTime), NULL, N'101010101010101', NULL)
INSERT [dbo].[tblClient_AccountManager] ([c_amId], [clientId], [accountManager], [crtDT], [modDT], [contactNo], [emailId]) VALUES (13, 64, N'Sunny', CAST(0x0000A91B00BED4AF AS DateTime), NULL, N'100000000000000', NULL)
INSERT [dbo].[tblClient_AccountManager] ([c_amId], [clientId], [accountManager], [crtDT], [modDT], [contactNo], [emailId]) VALUES (14, 65, N'Rajat', CAST(0x0000A91B013D8D69 AS DateTime), CAST(0x0000A92F00AA1F88 AS DateTime), N'101010101010101', NULL)
INSERT [dbo].[tblClient_AccountManager] ([c_amId], [clientId], [accountManager], [crtDT], [modDT], [contactNo], [emailId]) VALUES (15, 65, N'Sunny', CAST(0x0000A91B013D8D6D AS DateTime), CAST(0x0000A92F00AA1F88 AS DateTime), N'893468923648962', NULL)
INSERT [dbo].[tblClient_AccountManager] ([c_amId], [clientId], [accountManager], [crtDT], [modDT], [contactNo], [emailId]) VALUES (16, 66, N'Satyneder', CAST(0x0000A91C00BF9970 AS DateTime), NULL, N'101010101010', N'Rajatuppal33@gmail.com')
INSERT [dbo].[tblClient_AccountManager] ([c_amId], [clientId], [accountManager], [crtDT], [modDT], [contactNo], [emailId]) VALUES (17, 66, N'Satynder1', CAST(0x0000A91C00BF9971 AS DateTime), NULL, N'101010101010100', N'Uppall33@gmail.com')
INSERT [dbo].[tblClient_AccountManager] ([c_amId], [clientId], [accountManager], [crtDT], [modDT], [contactNo], [emailId]) VALUES (18, 67, N'Rajat', CAST(0x0000A91C00CBB0CC AS DateTime), NULL, N'10', N'rajat@gmail.com')
INSERT [dbo].[tblClient_AccountManager] ([c_amId], [clientId], [accountManager], [crtDT], [modDT], [contactNo], [emailId]) VALUES (19, 67, N'10', CAST(0x0000A91C00CBB0CC AS DateTime), NULL, N'10', N'1')
INSERT [dbo].[tblClient_AccountManager] ([c_amId], [clientId], [accountManager], [crtDT], [modDT], [contactNo], [emailId]) VALUES (20, 88, N'Manger1', CAST(0x0000A9350135CC42 AS DateTime), NULL, N'111111111111111', N'w')
INSERT [dbo].[tblClient_AccountManager] ([c_amId], [clientId], [accountManager], [crtDT], [modDT], [contactNo], [emailId]) VALUES (21, 106, N'Preety', CAST(0x0000A93600B20EF7 AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[tblClient_AccountManager] OFF
SET IDENTITY_INSERT [dbo].[tblContact] ON 

INSERT [dbo].[tblContact] ([contactId], [preName], [firstName], [lastName], [clientId], [email], [workPhone], [mobile], [crtUserId], [modUserId], [crtDT], [modDT]) VALUES (59, N'None', N'TCS_Contact', N'nO', 88, N'Rajat@gmail..com', N'10101010', N'1010101010', 28, 28, CAST(0x0000A93500D6F2CD AS DateTime), CAST(0x0000A93500D7A23C AS DateTime))
INSERT [dbo].[tblContact] ([contactId], [preName], [firstName], [lastName], [clientId], [email], [workPhone], [mobile], [crtUserId], [modUserId], [crtDT], [modDT]) VALUES (60, N'None', N'Test_HCL', N'n', 89, N'hcl@gmail.com', N'11', N'11', 28, NULL, CAST(0x0000A93500D790FD AS DateTime), NULL)
INSERT [dbo].[tblContact] ([contactId], [preName], [firstName], [lastName], [clientId], [email], [workPhone], [mobile], [crtUserId], [modUserId], [crtDT], [modDT]) VALUES (61, N'-None-', N'djhgVJHAS', N'JSA', 95, N'hascsJ', N'JBJ', N'3846823648', 28, NULL, CAST(0x0000A93500F9EDC7 AS DateTime), NULL)
INSERT [dbo].[tblContact] ([contactId], [preName], [firstName], [lastName], [clientId], [email], [workPhone], [mobile], [crtUserId], [modUserId], [crtDT], [modDT]) VALUES (62, N'Mr.', N'dujsdv j', N'b', 103, N'dsjh', N'bsdja', N'8828939309', 28, NULL, CAST(0x0000A93500FACADF AS DateTime), NULL)
INSERT [dbo].[tblContact] ([contactId], [preName], [firstName], [lastName], [clientId], [email], [workPhone], [mobile], [crtUserId], [modUserId], [crtDT], [modDT]) VALUES (64, N'Mr.', N'neetu', NULL, 106, N'neetu@gmail.com', NULL, NULL, 28, NULL, CAST(0x0000A93600B7BDAC AS DateTime), NULL)
INSERT [dbo].[tblContact] ([contactId], [preName], [firstName], [lastName], [clientId], [email], [workPhone], [mobile], [crtUserId], [modUserId], [crtDT], [modDT]) VALUES (65, N'Mr.', N'Rajat', NULL, 107, N'r@m.com', NULL, NULL, 28, NULL, CAST(0x0000A93701659550 AS DateTime), NULL)
SET IDENTITY_INSERT [dbo].[tblContact] OFF
SET IDENTITY_INSERT [dbo].[tblEducationDetails] ON 

INSERT [dbo].[tblEducationDetails] ([eduId], [cId], [institute], [departmant], [degree], [currentlyPursuing], [fromMonth], [fromYear], [toMonth], [toYear], [crtDT], [modDT]) VALUES (18, 15, N'City', N'10', N'10', 1, N'Nov', 2012, N'', 0, CAST(0x0000A91301142BD4 AS DateTime), CAST(0x0000A91301143785 AS DateTime))
INSERT [dbo].[tblEducationDetails] ([eduId], [cId], [institute], [departmant], [degree], [currentlyPursuing], [fromMonth], [fromYear], [toMonth], [toYear], [crtDT], [modDT]) VALUES (19, 16, N'City', N'1', N'1', 0, N'Oct', 2011, N'Aug', 2014, CAST(0x0000A915014ACBD4 AS DateTime), CAST(0x0000A92E0186DBE8 AS DateTime))
INSERT [dbo].[tblEducationDetails] ([eduId], [cId], [institute], [departmant], [degree], [currentlyPursuing], [fromMonth], [fromYear], [toMonth], [toYear], [crtDT], [modDT]) VALUES (20, 17, N'no', NULL, NULL, 0, NULL, 0, NULL, 0, CAST(0x0000A91F00D94845 AS DateTime), CAST(0x0000A92E018649BF AS DateTime))
INSERT [dbo].[tblEducationDetails] ([eduId], [cId], [institute], [departmant], [degree], [currentlyPursuing], [fromMonth], [fromYear], [toMonth], [toYear], [crtDT], [modDT]) VALUES (21, 17, N'no', NULL, NULL, 0, NULL, 0, NULL, 0, CAST(0x0000A91F00D94875 AS DateTime), CAST(0x0000A92E018649C0 AS DateTime))
SET IDENTITY_INSERT [dbo].[tblEducationDetails] OFF
SET IDENTITY_INSERT [dbo].[tblEmailTemplate] ON 

INSERT [dbo].[tblEmailTemplate] ([etId], [title], [description], [crtUserId], [modUserId], [crtDT], [modDT], [subject]) VALUES (6, N'test', N'<p><span style="color:#3498db"><span style="font-size:28px">sdjkjk sdvjas dmasdjas djasbdjs m</span></span></p>

<p><span style="color:#3498db"><span style="font-size:28px">sdjkjk sdvjas dmasdjas djasbdjs m</span></span></p>

<p><span style="color:#3498db"><span style="font-size:28px">sdjkjk sdvjas dmasdjas djasbdjs msdjkjk sdvjas dmasdjas djasbdjs msdjkjk sdvjas dmasdjas djasbdjs msdjkjk sdvjas dmasdjas djasbdjs msdjkjk sdvjas dmasdjas djasbdjs msdjkjk sdvjas dmasdjas djasbdjs msdjkjk sdvjas dm', 28, NULL, CAST(0x0000A92E014194A1 AS DateTime), CAST(0x0000A92F013ACECD AS DateTime), N'subject1')
INSERT [dbo].[tblEmailTemplate] ([etId], [title], [description], [crtUserId], [modUserId], [crtDT], [modDT], [subject]) VALUES (7, N'welcome message', N'<p>dear $name$ welcom to our portal and this is best portal for you. here you can easily find project $jobtitle$.</p>

<p>asdf</p>

<p>acasd</p>

<p>fasdfcasdc</p>

<p>THan&nbsp;</p>

<p>&nbsp;</p>
', 28, NULL, CAST(0x0000A92F0112F8B6 AS DateTime), CAST(0x0000A92F013B3E5E AS DateTime), N'welcome2')
SET IDENTITY_INSERT [dbo].[tblEmailTemplate] OFF
SET IDENTITY_INSERT [dbo].[tblExperienceDetails] ON 

INSERT [dbo].[tblExperienceDetails] ([expId], [cId], [occupation], [company], [summery], [currentlyWork], [fromMonth], [fromYear], [toMonth], [toYear], [crtDT], [modDT]) VALUES (1, 16, N'NO', N'okn', N'10', 0, N'Sept', 2011, N'May', 2012, CAST(0x0000A915014ACBF2 AS DateTime), CAST(0x0000A92E0186DBEA AS DateTime))
SET IDENTITY_INSERT [dbo].[tblExperienceDetails] OFF
SET IDENTITY_INSERT [dbo].[tblInterviewNameMaster] ON 

INSERT [dbo].[tblInterviewNameMaster] ([imId], [interviewName]) VALUES (1, N'None')
INSERT [dbo].[tblInterviewNameMaster] ([imId], [interviewName]) VALUES (2, N'Internal Interview')
INSERT [dbo].[tblInterviewNameMaster] ([imId], [interviewName]) VALUES (3, N'General Interview')
INSERT [dbo].[tblInterviewNameMaster] ([imId], [interviewName]) VALUES (4, N'Online Interview')
INSERT [dbo].[tblInterviewNameMaster] ([imId], [interviewName]) VALUES (5, N'Phone Interview')
INSERT [dbo].[tblInterviewNameMaster] ([imId], [interviewName]) VALUES (6, N'Level 1 Interview')
INSERT [dbo].[tblInterviewNameMaster] ([imId], [interviewName]) VALUES (7, N'Level 2 Interview')
INSERT [dbo].[tblInterviewNameMaster] ([imId], [interviewName]) VALUES (8, N'Level 3 Interview')
INSERT [dbo].[tblInterviewNameMaster] ([imId], [interviewName]) VALUES (9, N'Level 4 Interview')
SET IDENTITY_INSERT [dbo].[tblInterviewNameMaster] OFF
SET IDENTITY_INSERT [dbo].[tblInterviews] ON 

INSERT [dbo].[tblInterviews] ([interviewId], [imId], [candidateId], [clientId], [joiId], [c_amId], [toDate], [toTime], [interviewStatus], [location], [scheduleComments], [others_Photo_Doc], [crtUserId], [modUserId], [crtDT], [modDT]) VALUES (5, 6, 19, 88, 24, 20, CAST(0x973E0B00 AS Date), N'10:00am', N'Dummy1', N'1', N'1', NULL, 28, NULL, CAST(0x0000A935013643F3 AS DateTime), NULL)
INSERT [dbo].[tblInterviews] ([interviewId], [imId], [candidateId], [clientId], [joiId], [c_amId], [toDate], [toTime], [interviewStatus], [location], [scheduleComments], [others_Photo_Doc], [crtUserId], [modUserId], [crtDT], [modDT]) VALUES (6, 6, 19, 88, 24, 20, CAST(0x933E0B00 AS Date), N'10', N'Dummy1', N'10', N'10', NULL, 28, NULL, CAST(0x0000A935013697AE AS DateTime), NULL)
INSERT [dbo].[tblInterviews] ([interviewId], [imId], [candidateId], [clientId], [joiId], [c_amId], [toDate], [toTime], [interviewStatus], [location], [scheduleComments], [others_Photo_Doc], [crtUserId], [modUserId], [crtDT], [modDT]) VALUES (7, 5, 19, 88, 24, 20, CAST(0xA03E0B00 AS Date), N'10', N'Dummy3', NULL, NULL, NULL, 28, NULL, CAST(0x0000A935013752AA AS DateTime), NULL)
INSERT [dbo].[tblInterviews] ([interviewId], [imId], [candidateId], [clientId], [joiId], [c_amId], [toDate], [toTime], [interviewStatus], [location], [scheduleComments], [others_Photo_Doc], [crtUserId], [modUserId], [crtDT], [modDT]) VALUES (8, 6, 19, 88, 24, 20, CAST(0x973E0B00 AS Date), N'10:00', N'Dummy2', N'100', N'100', NULL, 28, NULL, CAST(0x0000A935013C49E5 AS DateTime), NULL)
INSERT [dbo].[tblInterviews] ([interviewId], [imId], [candidateId], [clientId], [joiId], [c_amId], [toDate], [toTime], [interviewStatus], [location], [scheduleComments], [others_Photo_Doc], [crtUserId], [modUserId], [crtDT], [modDT]) VALUES (9, 7, 16, 88, 24, 20, CAST(0xA63E0B00 AS Date), N'10:am', N'Dummy1', N'1', N'1', NULL, 28, NULL, CAST(0x0000A935013C711A AS DateTime), NULL)
INSERT [dbo].[tblInterviews] ([interviewId], [imId], [candidateId], [clientId], [joiId], [c_amId], [toDate], [toTime], [interviewStatus], [location], [scheduleComments], [others_Photo_Doc], [crtUserId], [modUserId], [crtDT], [modDT]) VALUES (10, 7, 19, 88, 24, 20, CAST(0x993E0B00 AS Date), N'10:00am', N'Dummy3', N'1', N'1', NULL, 28, NULL, CAST(0x0000A935013D18CB AS DateTime), NULL)
INSERT [dbo].[tblInterviews] ([interviewId], [imId], [candidateId], [clientId], [joiId], [c_amId], [toDate], [toTime], [interviewStatus], [location], [scheduleComments], [others_Photo_Doc], [crtUserId], [modUserId], [crtDT], [modDT]) VALUES (11, 2, 21, 106, 26, 21, CAST(0x923E0B00 AS Date), N'11.00 AM', N'Dummy1', N'Gurgaon', NULL, NULL, 28, NULL, CAST(0x0000A93600BB43E7 AS DateTime), NULL)
INSERT [dbo].[tblInterviews] ([interviewId], [imId], [candidateId], [clientId], [joiId], [c_amId], [toDate], [toTime], [interviewStatus], [location], [scheduleComments], [others_Photo_Doc], [crtUserId], [modUserId], [crtDT], [modDT]) VALUES (12, 6, 21, 106, 26, 21, CAST(0x923E0B00 AS Date), N'11', N'Dummy1', N'ggg', NULL, NULL, 28, NULL, CAST(0x0000A93700FCF199 AS DateTime), NULL)
INSERT [dbo].[tblInterviews] ([interviewId], [imId], [candidateId], [clientId], [joiId], [c_amId], [toDate], [toTime], [interviewStatus], [location], [scheduleComments], [others_Photo_Doc], [crtUserId], [modUserId], [crtDT], [modDT]) VALUES (13, 2, 23, 106, 28, 21, CAST(0x923E0B00 AS Date), N'11.00 am', N'Dummy1', N'ggn', NULL, NULL, 0, NULL, CAST(0x0000A937012B626D AS DateTime), NULL)
SET IDENTITY_INSERT [dbo].[tblInterviews] OFF
SET IDENTITY_INSERT [dbo].[tblJobOpeningInformation] ON 

INSERT [dbo].[tblJobOpeningInformation] ([joiId], [positionTile], [contactId], [recruitmetLeadId], [recruiterId], [targetDT], [jobOpeningStatus], [clientId], [c_amId], [openedDT], [jobType], [city], [state], [minWorkExperience], [maxWorkExperience], [noOfPositions], [minCTC], [maxCTC], [jobDesc], [jobSummery], [crtDT], [modDT], [crtUserId], [modUserId], [jobOpeningNo]) VALUES (24, N'MD', 59, 29, 31, CAST(0xA63E0B00 AS Date), N'Declined', 88, 0, NULL, N'Part Time', N'1', N'1', N'1', N'1', N'1', CAST(1.00 AS Numeric(18, 2)), CAST(1.00 AS Numeric(18, 2)), NULL, NULL, CAST(0x0000A93500D7272B AS DateTime), NULL, 28, NULL, N'00001')
INSERT [dbo].[tblJobOpeningInformation] ([joiId], [positionTile], [contactId], [recruitmetLeadId], [recruiterId], [targetDT], [jobOpeningStatus], [clientId], [c_amId], [openedDT], [jobType], [city], [state], [minWorkExperience], [maxWorkExperience], [noOfPositions], [minCTC], [maxCTC], [jobDesc], [jobSummery], [crtDT], [modDT], [crtUserId], [modUserId], [jobOpeningNo]) VALUES (26, N'Team lead', 64, 38, 39, CAST(0x913E0B00 AS Date), N'In Process', 106, 21, NULL, N'Full Time', N'Gurgaon', N'Haryana', N'2', N'10', N'2', CAST(5.00 AS Numeric(18, 2)), CAST(9.00 AS Numeric(18, 2)), N'<p>Dot Net</p>
', N'9a0e6656-7efe-4036-bbc9-f4c4570be261.doc', CAST(0x0000A93600B81801 AS DateTime), NULL, 28, NULL, N'00001')
INSERT [dbo].[tblJobOpeningInformation] ([joiId], [positionTile], [contactId], [recruitmetLeadId], [recruiterId], [targetDT], [jobOpeningStatus], [clientId], [c_amId], [openedDT], [jobType], [city], [state], [minWorkExperience], [maxWorkExperience], [noOfPositions], [minCTC], [maxCTC], [jobDesc], [jobSummery], [crtDT], [modDT], [crtUserId], [modUserId], [jobOpeningNo]) VALUES (28, N'Test Manager', 64, 38, 39, CAST(0xA73E0B00 AS Date), N'In Process', 106, 21, NULL, N'None', N'gurgaon', N'haryana', N'2', N'5', N'5', CAST(1.00 AS Numeric(18, 2)), CAST(10.00 AS Numeric(18, 2)), N'<p>no skill</p>
', NULL, CAST(0x0000A93700F8323E AS DateTime), CAST(0x0000A93700FB6600 AS DateTime), 28, 28, N'00002')
INSERT [dbo].[tblJobOpeningInformation] ([joiId], [positionTile], [contactId], [recruitmetLeadId], [recruiterId], [targetDT], [jobOpeningStatus], [clientId], [c_amId], [openedDT], [jobType], [city], [state], [minWorkExperience], [maxWorkExperience], [noOfPositions], [minCTC], [maxCTC], [jobDesc], [jobSummery], [crtDT], [modDT], [crtUserId], [modUserId], [jobOpeningNo]) VALUES (30, N'Module Lead', 64, 38, 39, CAST(0x983E0B00 AS Date), N'ON Hold', 106, 21, NULL, N'Full Time', N'Gurgaon', N'Haryana', N'2', N'5', N'1', CAST(5.00 AS Numeric(18, 2)), CAST(10.00 AS Numeric(18, 2)), NULL, NULL, CAST(0x0000A94801771BDC AS DateTime), NULL, 28, NULL, N'00003')
INSERT [dbo].[tblJobOpeningInformation] ([joiId], [positionTile], [contactId], [recruitmetLeadId], [recruiterId], [targetDT], [jobOpeningStatus], [clientId], [c_amId], [openedDT], [jobType], [city], [state], [minWorkExperience], [maxWorkExperience], [noOfPositions], [minCTC], [maxCTC], [jobDesc], [jobSummery], [crtDT], [modDT], [crtUserId], [modUserId], [jobOpeningNo]) VALUES (32, N'sdkn', 64, 38, 39, CAST(0xBB3E0B00 AS Date), N'Waiting for approval', 106, 21, NULL, N'Full Time', N'Rohatk', N'Haryan', NULL, NULL, NULL, CAST(0.00 AS Numeric(18, 2)), CAST(0.00 AS Numeric(18, 2)), NULL, NULL, CAST(0x0000A94E00D0D82F AS DateTime), NULL, 28, NULL, N'00004')
SET IDENTITY_INSERT [dbo].[tblJobOpeningInformation] OFF
SET IDENTITY_INSERT [dbo].[tblManageUser] ON 

INSERT [dbo].[tblManageUser] ([userId], [firstName], [lastName], [emailId], [password], [confirmPassword], [mobileNo], [role], [portNo], [smtpServer], [status], [recruitmetLeadId], [crtDT], [modDT], [managerName], [emailPassword]) VALUES (13, N'sunny', N'uppal', N'sunnyuppal33@gmail.com', N'1234', N'1234', N'1223456789', N'Recruitmet Lead', N'1', N'1', N'Active', 0, CAST(0x0000A8F80143A67B AS DateTime), CAST(0x0000A90600C8D828 AS DateTime), NULL, NULL)
INSERT [dbo].[tblManageUser] ([userId], [firstName], [lastName], [emailId], [password], [confirmPassword], [mobileNo], [role], [portNo], [smtpServer], [status], [recruitmetLeadId], [crtDT], [modDT], [managerName], [emailPassword]) VALUES (17, N'rajat', N'uppal', N'rajatuppal33@gmail.com', N'1234', N'1234', N'1234567890', N'Recruiter', N'1', N'1', N'Active', 13, CAST(0x0000A90600DB246E AS DateTime), CAST(0x0000A91B01584A93 AS DateTime), NULL, NULL)
INSERT [dbo].[tblManageUser] ([userId], [firstName], [lastName], [emailId], [password], [confirmPassword], [mobileNo], [role], [portNo], [smtpServer], [status], [recruitmetLeadId], [crtDT], [modDT], [managerName], [emailPassword]) VALUES (18, N'superadmin', NULL, NULL, N'12345', N'12345', N'1234567890', N'Admin', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblManageUser] ([userId], [firstName], [lastName], [emailId], [password], [confirmPassword], [mobileNo], [role], [portNo], [smtpServer], [status], [recruitmetLeadId], [crtDT], [modDT], [managerName], [emailPassword]) VALUES (19, N'Rajat', N'uppal', N'rajatuppal33@gmail.com', N'1234', N'1234', N'1010101010', N'Recruiter', N'1', N'1', N'Active', 13, CAST(0x0000A915014A088B AS DateTime), CAST(0x0000A91C00A55A53 AS DateTime), NULL, NULL)
INSERT [dbo].[tblManageUser] ([userId], [firstName], [lastName], [emailId], [password], [confirmPassword], [mobileNo], [role], [portNo], [smtpServer], [status], [recruitmetLeadId], [crtDT], [modDT], [managerName], [emailPassword]) VALUES (28, N'superadmin', NULL, N'superadmin', N'12345', N'12345', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tblManageUser] ([userId], [firstName], [lastName], [emailId], [password], [confirmPassword], [mobileNo], [role], [portNo], [smtpServer], [status], [recruitmetLeadId], [crtDT], [modDT], [managerName], [emailPassword]) VALUES (29, N'Rajat', N'uppal', N'rajatuppal33@gmail.com', N'12345', N'12345', N'1010101010', N'Recruitmet Lead', N'10', N'10', N'Active', 0, CAST(0x0000A91B0157F7F7 AS DateTime), CAST(0x0000A94600BDB11B AS DateTime), N'Sunny', N'1234')
INSERT [dbo].[tblManageUser] ([userId], [firstName], [lastName], [emailId], [password], [confirmPassword], [mobileNo], [role], [portNo], [smtpServer], [status], [recruitmetLeadId], [crtDT], [modDT], [managerName], [emailPassword]) VALUES (31, N'Rajat test17', N'uppal', N'dvasjdvj@gmail.com', N'1234', N'1234', N'3472846238', N'Recruiter', N'1', N'1', N'Active', 29, CAST(0x0000A92D00BA1F02 AS DateTime), CAST(0x0000A92D01040B8B AS DateTime), NULL, NULL)
INSERT [dbo].[tblManageUser] ([userId], [firstName], [lastName], [emailId], [password], [confirmPassword], [mobileNo], [role], [portNo], [smtpServer], [status], [recruitmetLeadId], [crtDT], [modDT], [managerName], [emailPassword]) VALUES (36, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, CAST(0x0000A93600B18133 AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[tblManageUser] ([userId], [firstName], [lastName], [emailId], [password], [confirmPassword], [mobileNo], [role], [portNo], [smtpServer], [status], [recruitmetLeadId], [crtDT], [modDT], [managerName], [emailPassword]) VALUES (37, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, CAST(0x0000A93600B181A3 AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[tblManageUser] ([userId], [firstName], [lastName], [emailId], [password], [confirmPassword], [mobileNo], [role], [portNo], [smtpServer], [status], [recruitmetLeadId], [crtDT], [modDT], [managerName], [emailPassword]) VALUES (38, N'Tinu', NULL, N'Tinu@gmail.com', N'Tinu123', N'Tinu123', N'9877316402', N'Recruitmet Lead', NULL, NULL, N'Active', 0, CAST(0x0000A93600B181DD AS DateTime), NULL, N'Sahil', N'tinu@123')
INSERT [dbo].[tblManageUser] ([userId], [firstName], [lastName], [emailId], [password], [confirmPassword], [mobileNo], [role], [portNo], [smtpServer], [status], [recruitmetLeadId], [crtDT], [modDT], [managerName], [emailPassword]) VALUES (39, N'Ram', NULL, N'ram@gamil.com', N'Ram@123', N'Ram@123', N'9876543212', N'Recruiter', NULL, NULL, N'Active', 38, CAST(0x0000A93600B1BF44 AS DateTime), NULL, NULL, N'1234')
INSERT [dbo].[tblManageUser] ([userId], [firstName], [lastName], [emailId], [password], [confirmPassword], [mobileNo], [role], [portNo], [smtpServer], [status], [recruitmetLeadId], [crtDT], [modDT], [managerName], [emailPassword]) VALUES (40, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, CAST(0x0000A9370101C711 AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[tblManageUser] ([userId], [firstName], [lastName], [emailId], [password], [confirmPassword], [mobileNo], [role], [portNo], [smtpServer], [status], [recruitmetLeadId], [crtDT], [modDT], [managerName], [emailPassword]) VALUES (41, N'sunny uppal sunny uppal sunny uppal sunny uppal ss', NULL, N'r@gmail.com', N'12345', N'12345', N'9876542354', N'Recruitmet Lead', NULL, NULL, N'Active', 0, CAST(0x0000A9370101C7A8 AS DateTime), CAST(0x0000A937013744A8 AS DateTime), N'ana', N'123')
INSERT [dbo].[tblManageUser] ([userId], [firstName], [lastName], [emailId], [password], [confirmPassword], [mobileNo], [role], [portNo], [smtpServer], [status], [recruitmetLeadId], [crtDT], [modDT], [managerName], [emailPassword]) VALUES (42, N'shyam', NULL, N'a@gmail.com', N'1234', N'1234', N'9383937484', N'Recruiter', NULL, NULL, N'Active', 38, CAST(0x0000A9370163FBAB AS DateTime), NULL, NULL, N'123')
INSERT [dbo].[tblManageUser] ([userId], [firstName], [lastName], [emailId], [password], [confirmPassword], [mobileNo], [role], [portNo], [smtpServer], [status], [recruitmetLeadId], [crtDT], [modDT], [managerName], [emailPassword]) VALUES (43, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, CAST(0x0000A93E00DD993A AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[tblManageUser] ([userId], [firstName], [lastName], [emailId], [password], [confirmPassword], [mobileNo], [role], [portNo], [smtpServer], [status], [recruitmetLeadId], [crtDT], [modDT], [managerName], [emailPassword]) VALUES (44, N'sandeep', NULL, N'sandy@gmail.com', N'12345', N'12345', N'9876545678', N'Recruitmet Lead', NULL, NULL, N'Active', 0, CAST(0x0000A93E00DD9AA6 AS DateTime), NULL, N'owner', N'12345')
INSERT [dbo].[tblManageUser] ([userId], [firstName], [lastName], [emailId], [password], [confirmPassword], [mobileNo], [role], [portNo], [smtpServer], [status], [recruitmetLeadId], [crtDT], [modDT], [managerName], [emailPassword]) VALUES (45, N'Prince', N'Sehgal', N'symbolizee@gmail.com', N'password', N'password', N'9802915930', N'Recruitmet Lead', N'1045', N'Test', N'Active', 29, CAST(0x0000A9480172209B AS DateTime), CAST(0x0000A94E012FEDA0 AS DateTime), N'Sahil', N'password')
INSERT [dbo].[tblManageUser] ([userId], [firstName], [lastName], [emailId], [password], [confirmPassword], [mobileNo], [role], [portNo], [smtpServer], [status], [recruitmetLeadId], [crtDT], [modDT], [managerName], [emailPassword]) VALUES (46, N'Prince1', N'aa', N'symbolizee1@gmail.com', N'1234', N'1234', N'9802915931', N'Recruitmet Lead', N'12', N'12', N'Active', 0, CAST(0x0000A94E0130F9B4 AS DateTime), NULL, N'm4', N'12')
INSERT [dbo].[tblManageUser] ([userId], [firstName], [lastName], [emailId], [password], [confirmPassword], [mobileNo], [role], [portNo], [smtpServer], [status], [recruitmetLeadId], [crtDT], [modDT], [managerName], [emailPassword]) VALUES (47, N'Prince2', N'afh', N'symbolizee2@gmail.com', N'1234', N'1234', N'9802915932', N'Recruitmet Lead', N'11', N'11', N'Active', 0, CAST(0x0000A94E0135D7B0 AS DateTime), NULL, N'11', N'1234')
SET IDENTITY_INSERT [dbo].[tblManageUser] OFF
SET IDENTITY_INSERT [dbo].[tblQualificationMaster] ON 

INSERT [dbo].[tblQualificationMaster] ([qualId], [qualification]) VALUES (1, N'B.C.A')
INSERT [dbo].[tblQualificationMaster] ([qualId], [qualification]) VALUES (2, N'M.C.A')
INSERT [dbo].[tblQualificationMaster] ([qualId], [qualification]) VALUES (3, N'B.COM')
INSERT [dbo].[tblQualificationMaster] ([qualId], [qualification]) VALUES (4, N'M.B.A')
INSERT [dbo].[tblQualificationMaster] ([qualId], [qualification]) VALUES (5, N'B.COM(hons)')
INSERT [dbo].[tblQualificationMaster] ([qualId], [qualification]) VALUES (6, N'B.A')
INSERT [dbo].[tblQualificationMaster] ([qualId], [qualification]) VALUES (7, N'M.A')
INSERT [dbo].[tblQualificationMaster] ([qualId], [qualification]) VALUES (8, N'PH.D')
INSERT [dbo].[tblQualificationMaster] ([qualId], [qualification]) VALUES (9, N'B.TECH')
INSERT [dbo].[tblQualificationMaster] ([qualId], [qualification]) VALUES (10, N'M.TECH')
SET IDENTITY_INSERT [dbo].[tblQualificationMaster] OFF
SET IDENTITY_INSERT [dbo].[tblSource] ON 

INSERT [dbo].[tblSource] ([sourceId], [source]) VALUES (1, N'dummy1')
INSERT [dbo].[tblSource] ([sourceId], [source]) VALUES (2, N'dummy2')
INSERT [dbo].[tblSource] ([sourceId], [source]) VALUES (3, N'dummy3')
INSERT [dbo].[tblSource] ([sourceId], [source]) VALUES (4, N'dummy4')
SET IDENTITY_INSERT [dbo].[tblSource] OFF
ALTER TABLE [dbo].[tblAssociateJob_To_Candidate]  WITH CHECK ADD  CONSTRAINT [FK_tblAssociateJob_To_Candidate_tblCandidate] FOREIGN KEY([candidateId])
REFERENCES [dbo].[tblCandidate] ([cId])
GO
ALTER TABLE [dbo].[tblAssociateJob_To_Candidate] CHECK CONSTRAINT [FK_tblAssociateJob_To_Candidate_tblCandidate]
GO
ALTER TABLE [dbo].[tblAssociateJob_To_Candidate]  WITH CHECK ADD  CONSTRAINT [FK_tblAssociateJob_To_Candidate_tblJobOpeningInformation] FOREIGN KEY([joiId])
REFERENCES [dbo].[tblJobOpeningInformation] ([joiId])
GO
ALTER TABLE [dbo].[tblAssociateJob_To_Candidate] CHECK CONSTRAINT [FK_tblAssociateJob_To_Candidate_tblJobOpeningInformation]
GO
ALTER TABLE [dbo].[tblClient]  WITH CHECK ADD  CONSTRAINT [FK_tblClient_tblManageUser] FOREIGN KEY([recruitmetLeadId])
REFERENCES [dbo].[tblManageUser] ([userId])
GO
ALTER TABLE [dbo].[tblClient] CHECK CONSTRAINT [FK_tblClient_tblManageUser]
GO
ALTER TABLE [dbo].[tblClient]  WITH CHECK ADD  CONSTRAINT [FK_tblClient_tblManageUser1] FOREIGN KEY([recruiterId])
REFERENCES [dbo].[tblManageUser] ([userId])
GO
ALTER TABLE [dbo].[tblClient] CHECK CONSTRAINT [FK_tblClient_tblManageUser1]
GO
ALTER TABLE [dbo].[tblContact]  WITH CHECK ADD  CONSTRAINT [FK_tblContact_tblClient] FOREIGN KEY([clientId])
REFERENCES [dbo].[tblClient] ([clientId])
GO
ALTER TABLE [dbo].[tblContact] CHECK CONSTRAINT [FK_tblContact_tblClient]
GO
ALTER TABLE [dbo].[tblInterviews]  WITH CHECK ADD  CONSTRAINT [FK_tblInterviews_tblCandidate] FOREIGN KEY([candidateId])
REFERENCES [dbo].[tblCandidate] ([cId])
GO
ALTER TABLE [dbo].[tblInterviews] CHECK CONSTRAINT [FK_tblInterviews_tblCandidate]
GO
ALTER TABLE [dbo].[tblInterviews]  WITH CHECK ADD  CONSTRAINT [FK_tblInterviews_tblClient] FOREIGN KEY([clientId])
REFERENCES [dbo].[tblClient] ([clientId])
GO
ALTER TABLE [dbo].[tblInterviews] CHECK CONSTRAINT [FK_tblInterviews_tblClient]
GO
ALTER TABLE [dbo].[tblInterviews]  WITH CHECK ADD  CONSTRAINT [FK_tblInterviews_tblClient_AccountManager] FOREIGN KEY([c_amId])
REFERENCES [dbo].[tblClient_AccountManager] ([c_amId])
GO
ALTER TABLE [dbo].[tblInterviews] CHECK CONSTRAINT [FK_tblInterviews_tblClient_AccountManager]
GO
ALTER TABLE [dbo].[tblInterviews]  WITH CHECK ADD  CONSTRAINT [FK_tblInterviews_tblJobOpeningInformation] FOREIGN KEY([joiId])
REFERENCES [dbo].[tblJobOpeningInformation] ([joiId])
GO
ALTER TABLE [dbo].[tblInterviews] CHECK CONSTRAINT [FK_tblInterviews_tblJobOpeningInformation]
GO
ALTER TABLE [dbo].[tblJobOpeningInformation]  WITH CHECK ADD  CONSTRAINT [FK_tblJobOpeningInformation_tblClient] FOREIGN KEY([clientId])
REFERENCES [dbo].[tblClient] ([clientId])
GO
ALTER TABLE [dbo].[tblJobOpeningInformation] CHECK CONSTRAINT [FK_tblJobOpeningInformation_tblClient]
GO
ALTER TABLE [dbo].[tblJobOpeningInformation]  WITH CHECK ADD  CONSTRAINT [FK_tblJobOpeningInformation_tblContact] FOREIGN KEY([contactId])
REFERENCES [dbo].[tblContact] ([contactId])
GO
ALTER TABLE [dbo].[tblJobOpeningInformation] CHECK CONSTRAINT [FK_tblJobOpeningInformation_tblContact]
GO
ALTER TABLE [dbo].[tblJobOpeningInformation]  WITH CHECK ADD  CONSTRAINT [FK_tblJobOpeningInformation_tblJobOpeningInformation] FOREIGN KEY([joiId])
REFERENCES [dbo].[tblJobOpeningInformation] ([joiId])
GO
ALTER TABLE [dbo].[tblJobOpeningInformation] CHECK CONSTRAINT [FK_tblJobOpeningInformation_tblJobOpeningInformation]
GO
ALTER TABLE [dbo].[tblJobOpeningInformation]  WITH CHECK ADD  CONSTRAINT [FK_tblJobOpeningInformation_tblManageUser] FOREIGN KEY([recruitmetLeadId])
REFERENCES [dbo].[tblManageUser] ([userId])
GO
ALTER TABLE [dbo].[tblJobOpeningInformation] CHECK CONSTRAINT [FK_tblJobOpeningInformation_tblManageUser]
GO
ALTER TABLE [dbo].[tblJobOpeningInformation]  WITH CHECK ADD  CONSTRAINT [FK_tblJobOpeningInformation_tblManageUser1] FOREIGN KEY([recruiterId])
REFERENCES [dbo].[tblManageUser] ([userId])
GO
ALTER TABLE [dbo].[tblJobOpeningInformation] CHECK CONSTRAINT [FK_tblJobOpeningInformation_tblManageUser1]
GO
USE [master]
GO
ALTER DATABASE [okn_dbadroit] SET  READ_WRITE 
GO
