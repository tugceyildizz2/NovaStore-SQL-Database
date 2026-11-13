/*
    NovaStore E-Ticaret Veritabanı Projesi
    Hazırlayan: Tuğçe Yıldız
    Teknoloji: Microsoft SQL Server / T-SQL

    UYARI:
    Bu script, aynı isimde bir veritabanı varsa NovaStoreDB veritabanını silip
    yeniden oluşturur. Mevcut verilerinizin silinmesini istemiyorsanız
    çalıştırmadan önce aşağıdaki veritabanı oluşturma bölümünü düzenleyin.
*/

-- 1. Veritabanını oluşturma
USE master;
GO

IF DB_ID(N'NovaStoreDB') IS NOT NULL
BEGIN
    ALTER DATABASE NovaStoreDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE NovaStoreDB;
END;
GO

CREATE DATABASE NovaStoreDB;
GO

USE NovaStoreDB;
GO

-- 2. Tabloları oluşturma

-- Kategoriler tablosu
CREATE TABLE Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL
);

-- Müşteriler tablosu
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FullName VARCHAR(50),
    City VARCHAR(20),
    Email VARCHAR(100) UNIQUE
);

-- Ürünler tablosu
CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Price DECIMAL(10,2),
    Stock INT DEFAULT 0,
    CategoryID INT,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

-- Siparişler tablosu
CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT,
    OrderDate DATETIME DEFAULT GETDATE(),
    TotalAmount DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Sipariş detayları tablosu
CREATE TABLE OrderDetails (
    DetailID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
GO

-- 3. Örnek kategorileri ekleme
INSERT INTO Categories (CategoryName) VALUES
('Elektronik'),
('Giyim'),
('Kitap'),
('Kozmetik'),
('Ev ve Yaşam');

-- 4. Örnek ürünleri ekleme
INSERT INTO Products (ProductName, Price, Stock, CategoryID) VALUES
('Laptop', 25000, 15, 1),
('Telefon', 15000, 30, 1),
('Kulaklık', 500, 50, 1),
('Tişört', 200, 40, 2),
('Pantolon', 400, 25, 2),
('Roman', 120, 60, 3),
('Ders Kitabı', 300, 20, 3),
('Parfüm', 800, 10, 4),
('Krem', 150, 35, 4),
('Masa', 2000, 5, 5),
('Sandalye', 500, 18, 5),
('Lamba', 300, 22, 5);

-- 5. Örnek müşterileri ekleme
INSERT INTO Customers (FullName, City, Email) VALUES
('Ahmet Yılmaz', 'İstanbul', 'ahmet@gmail.com'),
('Ayşe Demir', 'Ankara', 'ayse@gmail.com'),
('Mehmet Kaya', 'İzmir', 'mehmet@gmail.com'),
('Zeynep Aydın', 'Bursa', 'zeynep@gmail.com'),
('Can Karaca', 'Antalya', 'can@gmail.com');

-- 6. Örnek siparişleri ekleme
INSERT INTO Orders (CustomerID, OrderDate, TotalAmount) VALUES
(1, '2026-04-01', 25500),
(2, '2026-04-02', 400),
(3, '2026-04-03', 120),
(1, '2026-04-04', 800),
(4, '2026-04-05', 2000),
(5, '2026-04-06', 500),
(2, '2026-04-07', 300),
(3, '2026-04-08', 1500);

-- 7. Örnek sipariş detaylarını ekleme
INSERT INTO OrderDetails (OrderID, ProductID, Quantity) VALUES
(1, 1, 1),
(1, 3, 1),
(2, 5, 1),
(3, 6, 1),
(4, 8, 1),
(5, 10, 1),
(6, 11, 1),
(7, 12, 1),
(8, 2, 1);

-- 8. Stok miktarı 20'den az olan ürünleri stok miktarına göre azalan sıralama
SELECT ProductName, Stock
FROM Products
WHERE Stock < 20
ORDER BY Stock DESC;

-- 9. Müşteri sipariş listesi
SELECT c.FullName, c.City, o.OrderDate, o.TotalAmount
FROM Customers AS c
INNER JOIN Orders AS o ON c.CustomerID = o.CustomerID;

-- 10. Ahmet Yılmaz'ın satın aldığı ürünlerin detayları
SELECT p.ProductName, p.Price, cat.CategoryName
FROM Customers AS c
INNER JOIN Orders AS o ON c.CustomerID = o.CustomerID
INNER JOIN OrderDetails AS od ON o.OrderID = od.OrderID
INNER JOIN Products AS p ON od.ProductID = p.ProductID
INNER JOIN Categories AS cat ON p.CategoryID = cat.CategoryID
WHERE c.FullName = 'Ahmet Yılmaz';

-- 11. Kategori bazında ürün sayısı
SELECT cat.CategoryName, COUNT(p.ProductID) AS UrunSayisi
FROM Categories AS cat
LEFT JOIN Products AS p ON cat.CategoryID = p.CategoryID
GROUP BY cat.CategoryName;

-- 12. Müşteri bazında toplam ciro analizi
SELECT c.FullName, SUM(o.TotalAmount) AS ToplamCiro
FROM Customers AS c
INNER JOIN Orders AS o ON c.CustomerID = o.CustomerID
GROUP BY c.FullName
ORDER BY ToplamCiro DESC;

-- 13. Siparişlerin üzerinden geçen gün sayısı
SELECT OrderID, DATEDIFF(DAY, OrderDate, GETDATE()) AS GecenGun
FROM Orders;
GO

-- 14. Sipariş özeti görünümü (VIEW)
CREATE VIEW vw_SiparisOzet AS
SELECT
    c.FullName,
    o.OrderDate,
    p.ProductName,
    od.Quantity
FROM Customers AS c
INNER JOIN Orders AS o ON c.CustomerID = o.CustomerID
INNER JOIN OrderDetails AS od ON o.OrderID = od.OrderID
INNER JOIN Products AS p ON od.ProductID = p.ProductID;
GO

-- Görünümü test etme
SELECT * FROM vw_SiparisOzet;
GO

/*
-- 15. İsteğe bağlı veritabanı yedekleme örneği
-- Önce C:\Yedek klasörünün mevcut olduğundan emin olun.
BACKUP DATABASE NovaStoreDB
TO DISK = 'C:\Yedek\NovaStoreDB.bak';
*/
