USE [BIClass]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Project2].[AddForeignKeysToStarSchemaData]
AS
BEGIN

	ALTER TABLE [CH01-01-Dimension].[DimProductSubcategory] WITH CHECK ADD CONSTRAINT [FK_DimProductSubcategory_DimProductCategory] FOREIGN KEY ([ProductCategoryKey]) REFERENCES [CH01-01-Dimension].[DimProductCategory] ([ProductCategoryKey]);
	ALTER TABLE [CH01-01-Dimension].[DimProductSubcategory] CHECK CONSTRAINT [FK_DimProductSubcategory_DimProductCategory];
	
	ALTER TABLE [CH01-01-Dimension].[DimProduct] WITH CHECK ADD CONSTRAINT [FK_DimProduct_DimProductSubcategory] FOREIGN KEY ([ProductSubcategoryKey]) REFERENCES [CH01-01-Dimension].[DimProductSubcategory] ([ProductSubcategoryKey]);
    ALTER TABLE [CH01-01-Dimension].[DimProduct] CHECK CONSTRAINT [FK_DimProduct_DimProductSubcategory];

	ALTER TABLE [CH01-01-Fact].[Data] WITH CHECK ADD CONSTRAINT [FK_Data_DimMaritalStatus] FOREIGN KEY ([MaritalStatus]) REFERENCES [CH01-01-Dimension].[DimMaritalStatus] ([MaritalStatus]);
    ALTER TABLE [CH01-01-Fact].[Data] CHECK CONSTRAINT [FK_Data_DimMaritalStatus];
	
	ALTER TABLE [CH01-01-Fact].[Data] WITH CHECK ADD CONSTRAINT [FK_Data_DimGender] FOREIGN KEY ([Gender]) REFERENCES [CH01-01-Dimension].[DimGender] ([Gender]);
    ALTER TABLE [CH01-01-Fact].[Data] CHECK CONSTRAINT [FK_Data_DimGender];

    ALTER TABLE [CH01-01-Fact].[Data] WITH CHECK ADD CONSTRAINT [FK_Data_SalesManagers] FOREIGN KEY ([SalesManagerKey]) REFERENCES [CH01-01-Dimension].[SalesManagers] ([SalesManagerKey]);
    ALTER TABLE [CH01-01-Fact].[Data] CHECK CONSTRAINT [FK_Data_SalesManagers];

    ALTER TABLE [CH01-01-Fact].[Data] WITH CHECK ADD CONSTRAINT [FK_Data_DimTerritory] FOREIGN KEY ([TerritoryKey]) REFERENCES [CH01-01-Dimension].[DimTerritory] ([TerritoryKey]);
    ALTER TABLE [CH01-01-Fact].[Data] CHECK CONSTRAINT [FK_Data_DimTerritory];

	ALTER TABLE [CH01-01-Fact].[Data] WITH CHECK ADD CONSTRAINT [FK_Data_DimCustomer] FOREIGN KEY ([CustomerKey]) REFERENCES [CH01-01-Dimension].[DimCustomer] ([CustomerKey]);
    ALTER TABLE [CH01-01-Fact].[Data] CHECK CONSTRAINT [FK_Data_DimCustomer];

    ALTER TABLE [CH01-01-Fact].[Data] WITH CHECK ADD CONSTRAINT [FK_Data_DimOrderDate] FOREIGN KEY ([OrderDate]) REFERENCES [CH01-01-Dimension].[DimOrderDate] ([OrderDate]);
    ALTER TABLE [CH01-01-Fact].[Data] CHECK CONSTRAINT [FK_Data_DimOrderDate];

    ALTER TABLE [CH01-01-Fact].[Data] WITH CHECK ADD CONSTRAINT [FK_Data_DimOccupation] FOREIGN KEY ([OccupationKey]) REFERENCES [CH01-01-Dimension].[DimOccupation] ([OccupationKey]);
    ALTER TABLE [CH01-01-Fact].[Data] CHECK CONSTRAINT [FK_Data_DimOccupation];

    ALTER TABLE [CH01-01-Fact].[Data] WITH CHECK ADD CONSTRAINT [FK_Data_DimProduct] FOREIGN KEY ([ProductKey]) REFERENCES [CH01-01-Dimension].[DimProduct] ([ProductKey]);
    ALTER TABLE [CH01-01-Fact].[Data] CHECK CONSTRAINT [FK_Data_DimProduct];
END;
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Project2].[DropForeignKeysFromStarSchemaData]
AS
BEGIN
    SET NOCOUNT ON;

	ALTER TABLE [CH01-01-Dimension].[DimProductSubcategory] DROP CONSTRAINT [FK_DimProductSubcategory_DimProductCategory];
	ALTER TABLE [CH01-01-Dimension].[DimProduct] DROP CONSTRAINT [FK_DimProduct_DimProductSubcategory];
	ALTER TABLE [CH01-01-Fact].[Data] DROP CONSTRAINT [FK_Data_DimMaritalStatus];
	ALTER TABLE [CH01-01-Fact].[Data] DROP CONSTRAINT [FK_Data_DimGender];
	ALTER TABLE [CH01-01-Fact].[Data] DROP CONSTRAINT [FK_Data_SalesManagers];
	ALTER TABLE [CH01-01-Fact].[Data] DROP CONSTRAINT [FK_Data_DimTerritory];
	ALTER TABLE [CH01-01-Fact].[Data] DROP CONSTRAINT [FK_Data_DimCustomer];
	ALTER TABLE [CH01-01-Fact].[Data] DROP CONSTRAINT [FK_Data_DimOrderDate];
	ALTER TABLE [CH01-01-Fact].[Data] DROP CONSTRAINT [FK_Data_DimOccupation];
	ALTER TABLE [CH01-01-Fact].[Data] DROP CONSTRAINT [FK_Data_DimProduct];
END;
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Project2].[Load_Data]
AS
BEGIN

    SET NOCOUNT ON;

	INSERT INTO [CH01-01-Fact].[Data]
    (
        SalesManagerKey, OccupationKey, TerritoryKey, ProductKey, CustomerKey, ProductCategory, SalesManager,
        ProductSubcategory, ProductCode, ProductName, Color, ModelName, OrderQuantity, UnitPrice, ProductStandardCost,
        SalesAmount, OrderDate, MonthName, MonthNumber, Year, CustomerName, MaritalStatus, Gender, Education,
        Occupation, TerritoryRegion, TerritoryCountry, TerritoryGroup
    )
    SELECT 
		OLD.SalesManagerKey, OLD.OccupationKey, DT.TerritoryKey, DP.ProductKey, DC.CustomerKey, OLD.ProductCategory, OLD.SalesManager,
        OLD.ProductSubcategory, OLD.ProductCode, OLD.ProductName, OLD.Color, OLD.ModelName, OLD.OrderQuantity, OLD.UnitPrice, OLD.ProductStandardCost,
        OLD.SalesAmount, OLD.OrderDate, OLD.MonthName, OLD.MonthNumber,  OLD.Year, OLD.CustomerName, OLD.MaritalStatus, OLD.Gender, OLD.Education,
        OLD.Occupation, OLD.TerritoryRegion, OLD.TerritoryCountry, OLD.TerritoryGroup
    FROM FileUpload.OriginallyLoadedData AS OLD
        INNER JOIN [CH01-01-Dimension].DimProduct AS DP
            ON DP.ProductName = OLD.ProductName
        INNER JOIN [CH01-01-Dimension].DimTerritory AS DT
            ON DT.TerritoryCountry = OLD.TerritoryCountry
               AND DT.TerritoryGroup = OLD.TerritoryGroup
               AND DT.TerritoryRegion = OLD.TerritoryRegion
        INNER JOIN [CH01-01-Dimension].DimCustomer AS DC
            ON DC.CustomerName = OLD.CustomerName;
END;
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Project2].[Load_DimCustomer]
AS
BEGIN

	SET NOCOUNT ON;

	INSERT INTO [CH01-01-Dimension].[DimCustomer] (CustomerName)
	SELECT DISTINCT CustomerName
	FROM FileUpload.OriginallyLoadedData AS OLD;
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Project2].[Load_DimGender]
AS
BEGIN

    SET NOCOUNT ON;

	INSERT INTO [CH01-01-Dimension].[DimGender] (Gender, GenderDescription)
	SELECT DISTINCT OLD.Gender, 
		GenderDescription = 
			CASE 
				WHEN OLD.Gender = 'M' THEN 'Male'
				ELSE 'Female'
			END
	FROM FileUpload.OriginallyLoadedData as OLD
END;
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Project2].[Load_DimMaritalStatus]
AS
BEGIN

	SET NOCOUNT ON;

	INSERT INTO [CH01-01-Dimension].[DimMaritalStatus] (MaritalStatus, MaritalStatusDescription)
	SELECT DISTINCT OLD.MaritalStatus,
		MaritalStatusDescription = 
			CASE
				WHEN OLD.MaritalStatus = 'M' THEN 'Married'
				ELSE 'Single'
			END
	FROM FileUpload.OriginallyLoadedData AS OLD
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Project2].[Load_DimOccupation]
AS
BEGIN

	SET NOCOUNT ON;

	INSERT INTO [CH01-01-Dimension].[DimOccupation] (OccupationKey, Occupation)
	SELECT DISTINCT OLD.OccupationKey, OLD.Occupation
	FROM FileUpload.OriginallyLoadedData AS OLD
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Project2].[Load_DimOrderDate]
AS
BEGIN

	SET NOCOUNT ON;

	INSERT INTO [CH01-01-Dimension].[DimOrderDate] (OrderDate, MonthName, MonthNumber, Year)
	SELECT DISTINCT OLD.OrderDate, OLD.MonthName, OLD.MonthNumber, OLD.Year
	FROM FileUpload.OriginallyLoadedData AS OLD
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Project2].[Load_DimProduct]
AS
BEGIN

	SET NOCOUNT ON;
		 
	INSERT INTO [CH01-01-Dimension].[DimProduct]
	(
		ProductSubcategoryKey, ProductCategory, ProductSubcategory, ProductCode,
		ProductName, Color, ModelName
	)
	SELECT DISTINCT DPS.ProductSubcategoryKey, OLD.ProductCategory, DPS.ProductSubcategory, OLD.ProductCode,
		OLD.ProductName, OLD.Color, OLD.ModelName
	FROM FileUpload.OriginallyLoadedData AS OLD
		INNER JOIN [CH01-01-Dimension].DimProductSubcategory AS DPS
			ON DPS.ProductSubcategory = OLD.ProductSubcategory
		INNER JOIN [CH01-01-Dimension].DimProductCategory AS DPC
			ON DPC.ProductCategoryKey = DPS.ProductCategoryKey
			   AND DPC.ProductCategory = OLD.ProductCategory;  
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Project2].[Load_DimProductCategory]
AS
BEGIN

	SET NOCOUNT ON;

	INSERT INTO [CH01-01-Dimension].[DimProductCategory] (ProductCategory)
	SELECT DISTINCT OLD.ProductCategory
	FROM FileUpload.OriginallyLoadedData AS OLD;
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Project2].[Load_DimProductSubcategory]
AS
BEGIN

	SET NOCOUNT ON

	INSERT INTO [CH01-01-Dimension].[DimProductSubcategory] (ProductCategoryKey, ProductSubcategory)
    SELECT DISTINCT DPC.ProductCategoryKey, OLD.ProductSubcategory
    FROM FileUpload.OriginallyLoadedData AS OLD
        INNER JOIN [CH01-01-Dimension].[DimProductCategory] AS DPC
            ON DPC.ProductCategory = OLD.ProductCategory;
END;
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Project2].[Load_DimTerritory]
AS
BEGIN

	SET NOCOUNT ON;

	INSERT INTO [CH01-01-Dimension].[DimTerritory] (TerritoryGroup, TerritoryCountry, TerritoryRegion)
	SELECT DISTINCT OLD.TerritoryGroup, OLD.TerritoryCountry, OLD.TerritoryRegion
	FROM FileUpload.OriginallyLoadedData AS OLD;
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Project2].[Load_SalesManagers] 
AS
BEGIN

	SET NOCOUNT ON;

	INSERT INTO [CH01-01-Dimension].SalesManagers
	(
		SalesManagerKey,
		Category,
		SalesManager,
		Office
	)
	SELECT DISTINCT
		SalesManagerKey,
		old.ProductCategory,
		SalesManager,
		Office = CASE
					 WHEN old.SalesManager LIKE 'Marco%' THEN
						 'Redmond'
					 WHEN old.SalesManager LIKE 'Alberto%' THEN
						 'Seattle'
					 WHEN old.SalesManager LIKE 'Maurizio%' THEN
						 'Redmond'
					 ELSE
						 'Seattle'
				 END
	FROM FileUpload.OriginallyLoadedData AS old
	ORDER BY old.SalesManagerKey;
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Project2].[LoadStarSchemaData]

AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @return_value INT;

    EXEC  [Project2].[DropForeignKeysFromStarSchemaData];

	EXEC	[Project2].[ShowTableStatusRowCount]
		@TableStatus = N'''Pre-truncate of tables'''

    EXEC  [Project2].[TruncateStarSchemaData];

    EXEC  [Project2].[Load_DimProductCategory];
    EXEC  [Project2].[Load_DimProductSubcategory];
    EXEC  [Project2].[Load_DimProduct];
    EXEC  [Project2].[Load_SalesManagers];
    EXEC  [Project2].[Load_DimGender];
    EXEC  [Project2].[Load_DimMaritalStatus];
    EXEC  [Project2].[Load_DimOccupation];
    EXEC  [Project2].[Load_DimOrderDate];
    EXEC  [Project2].[Load_DimTerritory];
    EXEC  [Project2].[Load_DimCustomer];
    EXEC  [Project2].[Load_Data];
	EXEC  [Project2].[CreateDimProductCategory];
    EXEC  [Project2].[CreateDimProductSubcategory];
    EXEC  [Project2].[CreateDimProduct];
    EXEC  [Project2].[CreateSalesManagers];
    EXEC  [Project2].[CreateDimGender];
    EXEC  [Project2].[CreateDimMaritalStatus];
    EXEC  [Project2].[CreateDimOccupation];
    EXEC  [Project2].[CreateDimOrderDate];
    EXEC  [Project2].[CreateDimTerritory];
    EXEC  [Project2].[CreateDimCustomer];
    EXEC  [Project2].[CreateData];

	EXEC  [Project2].[ShowTableStatusRowCount]
		@TableStatus = N'''Row Count after loading the star schema'''
   EXEC [Project2].[AddForeignKeysToStarSchemaData];

END;
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Project2].[ShowTableStatusRowCount] 
 @TableStatus VARCHAR(64)

AS
BEGIN

	SET NOCOUNT ON;

	select TableStatus = @TableStatus, TableName ='CH01-01-Dimension.DimCustomer', COUNT(*) FROM [CH01-01-Dimension].DimCustomer
	select TableStatus = @TableStatus, TableName ='CH01-01-Dimension.DimGender', COUNT(*) FROM [CH01-01-Dimension].DimGender
	select TableStatus = @TableStatus, TableName ='CH01-01-Dimension.DimMaritalStatus', COUNT(*) FROM [CH01-01-Dimension].DimMaritalStatus
	select TableStatus = @TableStatus, TableName ='CH01-01-Dimension.DimOccupation', COUNT(*) FROM [CH01-01-Dimension].DimOccupation
	select TableStatus = @TableStatus, TableName ='CH01-01-Dimension.DimOrderDate', COUNT(*) FROM [CH01-01-Dimension].DimOrderDate
	select TableStatus = @TableStatus, TableName ='CH01-01-Dimension.DimProduct', COUNT(*) FROM [CH01-01-Dimension].DimProduct
	select TableStatus = @TableStatus, TableName ='CH01-01-Dimension.DimProductCategory', COUNT(*) FROM [CH01-01-Dimension].DimProductCategory
	select TableStatus = @TableStatus, TableName ='CH01-01-Dimension.DimProductSubcategory', COUNT(*) FROM [CH01-01-Dimension].DimProductSubcategory
	select TableStatus = @TableStatus, TableName ='CH01-01-Dimension.DimTerritory', COUNT(*) FROM [CH01-01-Dimension].DimTerritory
	select TableStatus = @TableStatus, TableName ='CH01-01-Dimension.SalesManagers', COUNT(*) FROM [CH01-01-Dimension].SalesManagers
	select TableStatus = @TableStatus, TableName ='CH01-01-Fact.Data', COUNT(*) FROM [CH01-01-Fact].Data

END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Project2].[TruncateStarSchemaData]
AS
BEGIN

	SET NOCOUNT ON;

	TRUNCATE TABLE [CH01-01-Fact].[Data];
	TRUNCATE TABLE [CH01-01-Dimension].[DimMaritalStatus];
	TRUNCATE TABLE [CH01-01-Dimension].[DimGender];
	TRUNCATE TABLE [CH01-01-Dimension].[SalesManagers]; 
	TRUNCATE TABLE [CH01-01-Dimension].[DimTerritory];
	TRUNCATE TABLE [CH01-01-Dimension].[DimCustomer];
	TRUNCATE TABLE [CH01-01-Dimension].[DimOrderDate];
	TRUNCATE TABLE [CH01-01-Dimension].[DimOccupation];
	TRUNCATE TABLE [CH01-01-Dimension].[DimProduct];
	TRUNCATE TABLE [CH01-01-Dimension].[DimProductSubcategory];
	TRUNCATE TABLE [CH01-01-Dimension].[DimProductCategory];
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Project2].[CreateDimMaritalStatus]
AS
BEGIN

	SET NOCOUNT ON;
	SET ANSI_NULLS ON
	SET QUOTED_IDENTIFIER ON

	DROP TABLE IF EXISTS [CH01-01-Dimension].[DimMaritalStatus];

	CREATE TABLE [CH01-01-Dimension].[DimMaritalStatus](
		[MaritalStatus] [char](1) NOT NULL,
		[MaritalStatusDescription] [varchar](7) NOT NULL,
		[ClassTime][char](5) NULL, 
		[GroupName][varchar](30) NULL
	 CONSTRAINT [PK_DimMaritalStatus] PRIMARY KEY CLUSTERED 
	(
		[MaritalStatus] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Project2].[CreateDimGender]
AS
BEGIN

	SET NOCOUNT ON;

	DROP TABLE IF EXISTS [CH01-01-Dimension].[DimGender];

	CREATE TABLE [CH01-01-Dimension].[DimGender](
		[Gender] [char](1) NOT NULL,
		[GenderDescription] [varchar](6) NOT NULL,
		[ClassTime][char](5) NULL, 
		[GroupName][varchar](30) NULL

	CONSTRAINT [PK_DimGender] PRIMARY KEY CLUSTERED 
	(
		[Gender] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Project2].[CreateDimOccupation]
AS
BEGIN

	SET NOCOUNT ON;
	SET ANSI_NULLS ON
	SET QUOTED_IDENTIFIER ON

	DROP TABLE IF EXISTS [CH01-01-Dimension].[DimOccupation];

	CREATE TABLE [CH01-01-Dimension].[DimOccupation](
		[OccupationKey] [int] NOT NULL,
		[Occupation] [varchar](20) NULL,
		[ClassTime][char](5) NULL,
		[GroupName][varchar](30) NULL
	CONSTRAINT [PK_DimOccupation] PRIMARY KEY CLUSTERED 
	(
		[OccupationKey] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Project2].[CreateDimCustomer]
AS
BEGIN

	SET NOCOUNT ON;
	SET ANSI_NULLS ON
	SET QUOTED_IDENTIFIER ON

	DROP TABLE IF EXISTS [CH01-01-Dimension].[DimCustomer];

	CREATE TABLE [CH01-01-Dimension].[DimCustomer](
		[CustomerKey] [int] IDENTITY(1,1) NOT NULL,
		[CustomerName] [varchar](30) NULL,
		[GroupName][varchar](30) NULL,
		[ClassTime][char](5)
	CONSTRAINT [PK__DimCusto__95011E6452BCF41C] PRIMARY KEY CLUSTERED 
	(
		[CustomerKey] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Project2].[CreateDimTerritory]
AS
BEGIN

	SET NOCOUNT ON;
	SET ANSI_NULLS ON
	SET QUOTED_IDENTIFIER ON

	DROP TABLE IF EXISTS [CH01-01-Dimension].[DimTerritory];

	CREATE TABLE [CH01-01-Dimension].[DimTerritory](
		[TerritoryKey] [int] IDENTITY(1,1) NOT NULL,
		[TerritoryGroup] [varchar](20) NULL,
		[TerritoryCountry] [varchar](20) NULL,
		[TerritoryRegion] [varchar](20) NULL,
		[GroupName][varchar](30) NULL,
		[ClassTime][char](5)
	CONSTRAINT [PK__DimTerri__C54B735D813BBCA6] PRIMARY KEY CLUSTERED 
	(
		[TerritoryKey] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Project2].[CreateDimProduct]
AS
BEGIN

	SET NOCOUNT ON;
	SET ANSI_NULLS ON
	SET QUOTED_IDENTIFIER ON

	DROP TABLE IF EXISTS [CH01-01-Dimension].[DimProduct];

	CREATE TABLE [CH01-01-Dimension].[DimProduct](
		[ProductKey] [int] IDENTITY(1,1) NOT NULL,
		[ProductCategory] [varchar](20) NULL,
		[ProductSubcategory] [varchar](20) NULL,
		[ProductCode] [varchar](10) NULL,
		[ProductName] [varchar](40) NULL,
		[Color] [varchar](10) NULL,
		[ModelName] [varchar](30) NULL,
		[GroupName][varchar](30) NULL,
		[ClassTime][char](5) NULL
	CONSTRAINT [PK__DimProdu__A15E99B3E27177EF] PRIMARY KEY CLUSTERED 
	(
		[ProductKey] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Project2].[CreateSalesManagers]
AS
BEGIN

	SET NOCOUNT ON;
	SET ANSI_NULLS ON
	SET QUOTED_IDENTIFIER ON

	DROP TABLE IF EXISTS [CH01-01-Dimension].[SalesManagers];

	CREATE TABLE [CH01-01-Dimension].[SalesManagers](
		[SalesManagerKey] [int] NOT NULL,
		[Category] [varchar](20) NULL,
		[SalesManager] [varchar](50) NULL,
		[Office] [varchar](50) NULL,
		[GroupName][varchar](30) NULL,
		[ClassTime][char](5) NULL
	CONSTRAINT [PK_SalesManagers] PRIMARY KEY CLUSTERED 
	(
		[SalesManagerKey] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Project2].[CreateDimOrderDate]
AS
BEGIN

	SET NOCOUNT ON;
	SET ANSI_NULLS ON
	SET QUOTED_IDENTIFIER ON

	DROP TABLE IF EXISTS [CH01-01-Dimension].[DimOrderDate];

	CREATE TABLE [CH01-01-Dimension].[DimOrderDate](
	[OrderDate] [date] NOT NULL,
	[MonthName] [varchar](10) NULL,
	[MonthNumber] [int] NULL,
	[Year] [int] NULL,
	[GroupName][varchar](30) NULL,
	[ClassTime][char](5) NULL
 CONSTRAINT [PK_DimOrderDate_1] PRIMARY KEY CLUSTERED 
(
	[OrderDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Project2].[CreateData]
AS
BEGIN

	SET NOCOUNT ON;

	DROP TABLE IF EXISTS [CH01-01-Fact].[Data];

	CREATE TABLE [CH01-01-Fact].[Data](
		[SalesKey] [int] NOT NULL,
		[SalesManagerKey] [int] NULL,
		[OccupationKey] [int] NULL,
		[TerritoryKey] [int] NULL,
		[ProductKey] [int] NULL,
		[CustomerKey] [int] NULL,
		[ProductCategory] [varchar](20) NULL,
		[SalesManager] [varchar](20) NULL,
		[ProductSubcategory] [varchar](20) NULL,
		[ProductCode] [varchar](10) NULL,
		[ProductName] [varchar](40) NULL,
		[Color] [varchar](10) NULL,
		[ModelName] [varchar](30) NULL,
		[OrderQuantity] [int] NULL,
		[UnitPrice] [money] NULL,
		[ProductStandardCost] [money] NULL,
		[SalesAmount] [money] NULL,
		[OrderDate] [date] NULL,
		[MonthName] [varchar](10) NULL,
		[MonthNumber] [int] NULL,
		[Year] [int] NULL,
		[CustomerName] [varchar](30) NULL,
		[MaritalStatus] [char](1) NULL,
		[Gender] [char](1) NULL,
		[Education] [varchar](20) NULL,
		[Occupation] [varchar](20) NULL,
		[TerritoryRegion] [varchar](20) NULL,
		[TerritoryCountry] [varchar](20) NULL,
		[TerritoryGroup] [varchar](20) NULL,
		[GroupName][varchar](30) NULL,
		[ClassTime][char](5) NULL
	CONSTRAINT [PK_Data] PRIMARY KEY CLUSTERED 
	(
		[SalesKey] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]
	
END
GO