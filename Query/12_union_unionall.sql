-- Hãy liệt kê toàn bộ các quốc gia tồn tại trong 2 bảng Suppliers và Customers với hai tình huống sử dụng union và union all
-- 1. Union
-- Cấu trúc:
-- SELECT column_name(s) FROM table1
-- UNION
-- SELECT column_name(s) FROM table2;
-- union: trường hợp không lấy sự trùng lặp. Ví dụ cả 2 bảng đều có Country là Brazil thì chỉ lấy 1 Brazil
SELECT DISTINCT Country FROM Suppliers
UNION
SELECT DISTINCT Country FROM Customers
ORDER BY Country;

-- 2. Union all
-- Cấu trúc:
-- SELECT column_name(s) FROM table1
-- UNION ALL
-- SELECT column_name(s) FROM table2;
-- union: trường hợp lấy sự trùng lặp. Ví dụ cả 2 bảng đều có Country là Brazil thì chỉ lấy cả 2 Brazil
SELECT DISTINCT Country FROM Suppliers
UNION ALL
SELECT DISTINCT Country FROM Customers
ORDER BY Country;

-- Bài 1: Sử dụng câu lệnh SQL để trả về các thành phố của Đức (chỉ các giá trị khác biệt) từ cả bảng "Customers" và "Suppliers"
SELECT City, Country FROM Customers
WHERE Country='Germany'
UNION
SELECT City, Country FROM Suppliers
WHERE Country='Germany'
ORDER BY City;

-- Bài 2: Sử dụng câu lệnh SQL để trả về các thành phố của Đức (chỉ các giá trị khác biệt) từ cả bảng "Customers" và "Suppliers"
SELECT City, Country FROM Customers
WHERE Country='Germany'
UNION ALL
SELECT City, Country FROM Suppliers
WHERE Country='Germany'
ORDER BY City;