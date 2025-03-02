-- 1.1. lấy ra 1 trường (cột) dữ liệu
SELECT ProductID FROM dbo.Products;

-- 1.2. lấy ra 2 hoặc nhiều trường (dùng dấu phẩy để ngăn cách giữa các trường)
SELECT ProductID, ProductName FROM dbo.Products;

-- 1.3. lấy ra tất cả các trường trong database (db)
SELECT * FROM Products; -- có thể bỏ "dbo." cho gọn

-- 1.4. truy vấn các dữ liệu khác nhau trong một trường (loại bỏ sự trùng hợp)
SELECT DISTINCT ShipCountry FROM Orders;
SELECT DISTINCT ContactTitle, City FROM Customers; -- ví dụ như trường hợp này, có nhiều giá trị Owner-Mexico D.F trong cả 2 trường thì SQL sẽ trả về kết quả là 1 Owener-Mexico D.F thôi
