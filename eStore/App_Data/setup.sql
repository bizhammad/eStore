-------------------------------------------------------------
-- CREATE DATABASE IF NOT EXISTS
-------------------------------------------------------------
IF NOT EXISTS(SELECT * FROM sys.databases WHERE name = 'eStore')
BEGIN
    CREATE DATABASE [eStore];
END
GO

USE [eStore];
GO

-------------------------------------------------------------
-- CREATE TABLE TYPE (CART ITEMS)
-------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.types WHERE name = 'CartItemType')
BEGIN
    CREATE TYPE [dbo].[CartItemType] AS TABLE(
        [ProductName] NVARCHAR(100),
        [Category] NVARCHAR(50),
        [Quantity] INT,
        [UnitPrice] DECIMAL(10, 2)
    );
END
GO

-------------------------------------------------------------
-- USERS TABLE
-------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'Users')
BEGIN
    CREATE TABLE [dbo].[Users](
        [Username] NVARCHAR(50) PRIMARY KEY,
        [Password] NVARCHAR(255) NOT NULL,
        [Email] NVARCHAR(100) NOT NULL,
        [Role] NVARCHAR(50) NOT NULL
    );
END
GO

-------------------------------------------------------------
-- INVENTORY TABLE
-------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'Inventory')
BEGIN
    CREATE TABLE [dbo].[Inventory](
        [ID] INT IDENTITY(1,1) PRIMARY KEY,
        [ProductName] NVARCHAR(100) NOT NULL,
        [Category] NVARCHAR(50) NOT NULL,
        [Units] INT NOT NULL,
        [Price] DECIMAL(10, 2) NOT NULL
    );
END
GO

-------------------------------------------------------------
-- ORDER TABLE
-------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'Order')
BEGIN
    CREATE TABLE [dbo].[Order](
        [OrderID] INT IDENTITY(1,1) PRIMARY KEY,
        [Username] NVARCHAR(50) NOT NULL,
        [OrderDateTime] DATETIME DEFAULT GETDATE(),
        [OrderStatus] NVARCHAR(50) DEFAULT 'Pending Payment'
    );
END
GO

-------------------------------------------------------------
-- SALES TABLE
-------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'Sales')
BEGIN
    CREATE TABLE [dbo].[Sales](
        [SID] INT IDENTITY(1,1) PRIMARY KEY,
        [ProductID] INT NOT NULL,
        [Quantity] INT NOT NULL,
        [Amount] DECIMAL(10, 2) NOT NULL,
        [OrderID] INT NOT NULL
    );
END
GO

-------------------------------------------------------------
-- FOREIGN KEYS
-------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_Order_User')
BEGIN
    ALTER TABLE [dbo].[Order]
    ADD CONSTRAINT [FK_Order_User]
    FOREIGN KEY ([Username]) REFERENCES [dbo].[Users]([Username])
    ON DELETE CASCADE ON UPDATE CASCADE;
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_Sales_Order')
BEGIN
    ALTER TABLE [dbo].[Sales]
    ADD CONSTRAINT [FK_Sales_Order]
    FOREIGN KEY ([OrderID]) REFERENCES [dbo].[Order]([OrderID])
    ON DELETE CASCADE ON UPDATE CASCADE;
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_Sales_Product')
BEGIN
    ALTER TABLE [dbo].[Sales]
    ADD CONSTRAINT [FK_Sales_Product]
    FOREIGN KEY ([ProductID]) REFERENCES [dbo].[Inventory]([ID])
    ON DELETE CASCADE ON UPDATE CASCADE;
END
GO

-------------------------------------------------------------
-- PROCEDURE: VALIDATE USER
-------------------------------------------------------------
IF EXISTS(SELECT * FROM sys.objects WHERE name='validateUser')
    DROP PROCEDURE validateUser;
GO

CREATE PROCEDURE [dbo].[validateUser] 
    @u NVARCHAR(50),
    @p NVARCHAR(255)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Users WHERE Username=@u AND Password=@p)
        SELECT 1 AS IsValidUser;
    ELSE
        SELECT 0 AS IsValidUser;
END
GO

-------------------------------------------------------------
-- PROCEDURE: FETCH CATEGORY
-------------------------------------------------------------
IF EXISTS(SELECT * FROM sys.objects WHERE name='fetchCategory')
    DROP PROCEDURE fetchCategory;
GO

CREATE PROCEDURE [dbo].[fetchCategory]
AS
BEGIN
    SELECT DISTINCT Category FROM Inventory;
END
GO

-------------------------------------------------------------
-- PROCEDURE: FETCH PRODUCTS BY CATEGORY
-------------------------------------------------------------
IF EXISTS(SELECT * FROM sys.objects WHERE name='fetchProduct')
    DROP PROCEDURE fetchProduct;
GO

CREATE PROCEDURE [dbo].[fetchProduct]
    @c NVARCHAR(50)
AS
BEGIN
    SELECT DISTINCT ProductName 
    FROM Inventory 
    WHERE Category = @c;
END
GO

-------------------------------------------------------------
-- PROCEDURE: RETURN UNIT PRICE
-------------------------------------------------------------
IF EXISTS(SELECT * FROM sys.objects WHERE name='retUnitPrice')
    DROP PROCEDURE retUnitPrice;
GO

CREATE PROCEDURE [dbo].[retUnitPrice]
    @p NVARCHAR(50),
    @c NVARCHAR(50)
AS
BEGIN
    SELECT Price 
    FROM Inventory 
    WHERE ProductName=@p AND Category=@c;
END
GO

-------------------------------------------------------------
-- PROCEDURE: FETCH ORDERS
-------------------------------------------------------------
IF EXISTS(SELECT * FROM sys.objects WHERE name='fetchOrders')
    DROP PROCEDURE fetchOrders;
GO

CREATE PROCEDURE [dbo].[fetchOrders] 
    @user NVARCHAR(50)
AS
BEGIN
    SELECT 
        o.OrderID,
        o.OrderDateTime AS Date,
        o.OrderStatus,
        SUM(s.Quantity) AS [Total Items]
    FROM [Order] o
    INNER JOIN Sales s ON o.OrderID = s.OrderID
    WHERE o.Username = @user
    GROUP BY o.OrderID, o.OrderDateTime, o.OrderStatus;
END
GO

-------------------------------------------------------------
-- PROCEDURE: CREATE ORDER (without Sales)
-------------------------------------------------------------
IF EXISTS(SELECT * FROM sys.objects WHERE name='CreateOrder')
    DROP PROCEDURE CreateOrder;
GO

CREATE PROCEDURE [dbo].[CreateOrder]
    @Username NVARCHAR(50),
    @NewOrderID INT OUTPUT
AS
BEGIN
    INSERT INTO [Order] (Username)
    VALUES (@Username);

    SET @NewOrderID = SCOPE_IDENTITY();
END
GO

-------------------------------------------------------------
-- PROCEDURE: CREATE ORDER WITH SALES (CART)
-------------------------------------------------------------
IF EXISTS(SELECT * FROM sys.objects WHERE name='CreateOrderWithSales')
    DROP PROCEDURE CreateOrderWithSales;
GO

CREATE PROCEDURE [dbo].[CreateOrderWithSales]
    @Username NVARCHAR(50),
    @CartItems CartItemType READONLY,
    @NewOrderID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;

    BEGIN TRY
        INSERT INTO [Order] (Username)
        VALUES (@Username);

        SET @NewOrderID = SCOPE_IDENTITY();

        INSERT INTO Sales (ProductID, Quantity, Amount, OrderID)
        SELECT i.ID, c.Quantity, c.Quantity * c.UnitPrice, @NewOrderID
        FROM @CartItems c
        INNER JOIN Inventory i
            ON i.ProductName = c.ProductName
            AND i.Category = c.Category;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

-------------------------------------------------------------
-- DATABASE IS READY
-------------------------------------------------------------
PRINT '✔ eStore database setup completed successfully!';
