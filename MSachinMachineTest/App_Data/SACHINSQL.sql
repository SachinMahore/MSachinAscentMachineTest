USE [MSachinMachineTest]
GO
/****** Object:  StoredProcedure [dbo].[usp_EmployeeListData]    Script Date: 10/07/2020 2:19:11 PM ******/
DROP PROCEDURE [dbo].[usp_EmployeeListData]
GO
/****** Object:  Table [dbo].[tbl_Employee]    Script Date: 10/07/2020 2:19:11 PM ******/
DROP TABLE [dbo].[tbl_Employee]
GO
/****** Object:  Table [dbo].[tbl_Employee]    Script Date: 10/07/2020 2:19:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Employee](
	[EmployeeID] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeName] [nvarchar](500) NULL,
	[City] [nvarchar](200) NULL,
 CONSTRAINT [PK_tbl_Employee] PRIMARY KEY CLUSTERED 
(
	[EmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET IDENTITY_INSERT [dbo].[tbl_Employee] ON 

GO
INSERT [dbo].[tbl_Employee] ([EmployeeID], [EmployeeName], [City]) VALUES (1, N'Sachin Mahore', N'Nagpur')
GO
INSERT [dbo].[tbl_Employee] ([EmployeeID], [EmployeeName], [City]) VALUES (2, N'Dharvik Inc', N'Nagpur')
GO
INSERT [dbo].[tbl_Employee] ([EmployeeID], [EmployeeName], [City]) VALUES (3, N'Rahul Mane', N'Pune')
GO
INSERT [dbo].[tbl_Employee] ([EmployeeID], [EmployeeName], [City]) VALUES (4, N'John Ward', N'Pune')
GO
INSERT [dbo].[tbl_Employee] ([EmployeeID], [EmployeeName], [City]) VALUES (5, N'Peter Ward', N'Florida')
GO
INSERT [dbo].[tbl_Employee] ([EmployeeID], [EmployeeName], [City]) VALUES (6, N'Barby ward', N'florida')
GO
INSERT [dbo].[tbl_Employee] ([EmployeeID], [EmployeeName], [City]) VALUES (7, N'juhuh', N'Mumbai')
GO
SET IDENTITY_INSERT [dbo].[tbl_Employee] OFF
GO
/****** Object:  StoredProcedure [dbo].[usp_EmployeeListData]    Script Date: 10/07/2020 2:19:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- EXEC usp_EmployeeListData 'PUNE','JO',1,4
CREATE PROCEDURE [dbo].[usp_EmployeeListData]
	@City		VARCHAR(200)=NULL,
	@EmployeeName		VARCHAR(500)=NULL,
	@PageNumber		INT,
	@RowDisplay	INT
AS
BEGIN
	DECLARE @RowCount			INT
	DECLARE	@TotalRows			BIGINT
	DECLARE @LowerLimit			BIGINT
	DECLARE	@UpperLimit			BIGINT
	DECLARE @TotalNumberOfPages	BIGINT
	DECLARE @ModValue			BIGINT
	DECLARE @EmployeeData			TABLE 
	(
		EmployeeID BIGINT, EmployeeName VARCHAR(500), City VARCHAR(500), NOP INT 
	)
	DECLARE @RowNumLower BIGINT
	DECLARE @RowNumUpper BIGINT

	INSERT INTO @EmployeeData (EmployeeID, EmployeeName, City, NOP ) 
	SELECT EmployeeID, EmployeeName, City, 0
	FROM tbl_Employee
	WHERE
	EmployeeName LIKE '%'+ISNULL(@EmployeeName,'')+'%'
	AND ISNULL(City,'') LIKE '%'+ISNULL(@City ,'')+'%'
	
	 
	SET @RowNumLower=(@PageNumber*@RowDisplay-@RowDisplay)+1
	SET @RowNumUpper=@PageNumber*@RowDisplay
	 ;WITH FilterRows AS (
	SELECT (ROW_NUMBER() OVER (ORDER BY ED.EmployeeName ASC)) AS RowNum, ED.EmployeeID, ED.EmployeeName,ED.City
	FROM @EmployeeData ED)
	SELECT E.*
	FROM 
		FilterRows FR INNER JOIN tbl_Employee E ON FR.EmployeeID=E.EmployeeID
	WHERE 
		RowNum>=@RowNumLower AND RowNum<=@RowNumUpper 
	ORDER BY 
		RowNum;
	
	
END












GO
