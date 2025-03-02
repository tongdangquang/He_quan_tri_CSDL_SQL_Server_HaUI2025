-- 5.1. giới hạng số lượng dòng trả về
SELECT top 5 * FROM Customers; -- lấy ra 5 khách hàng đầu tiên với tất cả các trường
SELECT TOP 10 PERCENT * FROM Customers; -- lấy ra 10 percent (%) khách hàng đầu tiên với tất cả các trường   
SELECT DISTINCT top 5 * FROM Customers; -- lấy 5 dòng đầu tiên khách nhau
SELECT distinct top 5 CustomerID, CompanyName FROM Customers; -- lấy ra 5 CustomerID và CompanyName đầu tiên không trùng nhau

-- 5.2. sắp xếp dữ liệu
SELECT UnitPrice FROM Products Order by UnitPrice ASC; -- sắp xếp tăng dần (ascending)
SELECT UnitPrice FROM Products Order by UnitPrice DESC; -- sắp xếp giảm (descending)
SELECT * FROM Products Order by UnitPrice ASC;
SELECT * FROM Customers Order by Country, City;