--Scalar Fonksiyonlar geriye istediðimiz tip de deðer döndüren fonksiyonlardýr
CREATE FUNCTION CARPIM(@SAYI1 INT,@SAYI2 INT)
RETURNS INT
AS	
BEGIN 
RETURN @SAYI1*@SAYI2
END

SELECT DBO.CARPIM(5,4)

CREATE FUNCTION FN_ADD_UNITPRICE(@UNITPRÝCE INT)
RETURNS INT 
BEGIN
DECLARE @Deger INT
SET @DEGER=@UNITPRÝCE+5
RETURN @DEGER
END


SELECT DBO.FN_ADD_UNITPRICE(12)
SELECT DBO.FN_ADD_UNITPRICE(UnitPrice)  FROM [Order Details] --UnitPrice degerlerine 5 eklenecek
SELECT (UnitPrice)  FROM [Order Details]


CREATE FUNCTION YAZDIR(@SAYI INT)
RETURNS VARCHAR(20)
BEGIN 
DECLARE @SONUC VARCHAR(20)
SELECT  @SONUC= CASE
  WHEN @SAYI=1 THEN  'OCAK'
    WHEN @SAYI=2 THEN 'ÞUBAT'
	WHEN @SAYI=3 THEN 'MART'
    WHEN @SAYI=4 THEN  'NÝSAN'
    WHEN @SAYI=5 THEN 'MAYIS' 
    WHEN @SAYI=6 THEN  'HAZÝRAN'
    WHEN @SAYI=7 THEN 'TEMMUZ'
    WHEN @SAYI=8 THEN  'AÐUSTOS'
	WHEN @SAYI=9 THEN 'EYLÜL'
    WHEN @SAYI=10 THEN  'EKÝM'
    WHEN @SAYI=11 THEN 'KASIM'
    WHEN @SAYI=12 THEN  'ARALIK'
    ELSE 'HATALI DEÐER GÝRÝLDÝ'
 END
RETURN @SONUC
END

SELECT DBO.YAZDIR(12)


CREATE FUNCTION HESAPLA(@UnitPrice FLOAT,@KDV FLOAT)
RETURNS FLOAT
BEGIN
DECLARE @FIYAT FLOAT
SET @FIYAT=@UnitPrice+(@UnitPrice*(@KDV/100))
RETURN @FIYAT
END


SELECT P.ProductName,P.UnitPrice,DBO.HESAPLA(UnitPrice,18) AS [KDV'LÝ FÝYAT]
FROM Products P 

CREATE FUNCTION CALISAN(@EMPLOYEEID INT ,@YIL INT )
RETURNS INT  
BEGIN 
RETURN
(
SELECT COUNT(ORDERID) FROM Orders
WHERE EmployeeID=@EMPLOYEEID AND YEAR(OrderDate)=@YIL
)
END
SELECT*FROM Orders WHERE  EmployeeID=2 AND 

SELECT DBO.CALISAN(2,1996) AS TOPLAM

--INLENE FONKSIYONLAR geriye tablo döndüren fonksýyonlardýr.
CREATE FUNCTION Musteri(@customer nvarchar(10))
RETURNS TABLE 
AS
RETURN 
(
SELECT p.ProductName,p.UnitPrice,p.UnitsInStock
FROM Customers C 
inner join Orders o on c.CustomerID=o.CustomerID
inner join [Order Details] od on od.OrderID=o.OrderID
inner join Products p on p.ProductID=od.ProductID
where c.CustomerID=@customer
)

SELECT * FROM DBO.Musteri('ANTON')


create function liste(@employe int , @date int)
returns table
as
return
(
select e.FirstName+' '+e.LastName as Name ,p.ProductName,od.UnitPrice,p.UnitsInStock
from Employees e 
inner join Orders o on o.EmployeeID=e.EmployeeID
inner join [Order Details] od on od.OrderID=o.OrderID
inner join Products p on p.ProductID=od.ProductID
where e.EmployeeID=@employe and YEAR(OrderDate)=@date
)

select * from dbo.liste(3,1996)


create function Listele(@ID INT )
returns @YeniTablo TABLE(ID int,ProductName nvarchar(50),UnitPrice money)
as
begin
	if @ID < 0
		insert into @YeniTablo select ProductID,ProductName,UnitPrice from Products
	else if @ID > 0
		insert into @YeniTablo select ProductID,ProductName,UnitPrice  from Products
		where ProductID=@ID
	else
		insert into @YeniTablo values (0,'Test Ürünü',10)
return 
end

select * from dbo.Listele(10)


CREATE FUNCTION FN_GETPRODUCTS
(
--Parametreler
)
RETURNS @PRODUCTS_OF_CUSTOMER TABLE /*Geri dönecek olan tablo*/
							(
							ID	INT,
							PRODUCTNAME NVARCHAR,
							UNITPRICE MONEY
							)
AS 
BEGIN
--Fonksiyonun iþlevini programlayan satýrlar
RETURN
END

/*Ürünler tablosundan ProductName ve UnitPrice verilerini görüntüleyecek bir functýons yazýlacak. 
Functions dýþarýdan bir ID parametresi alacak
ID<0 ise Product tablosundaki bütün ürünler, Product_of_Customers tablosuna
ID>o ise girilen IDye ait ürünü Products tablosundan  Product_of_Customer tablosuna,
eðer ID=0 ise Products_of_Customer tablosuna (0,"Test Ürünü",10) þeklinde bir kayýt girilecek.*/

CREATE FUNCTION YENITABLE (@URUNID INT)
RETURNS @PRODUCTS_OF_CUSTOMER TABLE /*Geri dönecek olan tablo*/
(
  ID	INT,
  PRODUCTNAME NVARCHAR(50),
  UNITPRICE MONEY
  )
AS 
BEGIN

	IF @URUNID<0
		BEGIN 
		INSERT INTO @PRODUCTS_OF_CUSTOMER (ID,PRODUCTNAME,UNITPRICE)
		SELECT ProductID,ProductName,UnitPrice FROM Products
		END
	ELSE IF @URUNID>0
		BEGIN
		INSERT INTO @PRODUCTS_OF_CUSTOMER (ID,PRODUCTNAME,UNITPRICE)
		SELECT ProductID,ProductName,UnitPrice FROM Products
		WHERE ProductID=@URUNID
		END
	ELSE
		BEGIN
		INSERT INTO @PRODUCTS_OF_CUSTOMER (ID,PRODUCTNAME,UNITPRICE)
		VALUES(0,'Test Ürünü',10)
		END
RETURN
END

-- Çalýþtýrmak için

SELECT*FROM YENITABLE(-2)





