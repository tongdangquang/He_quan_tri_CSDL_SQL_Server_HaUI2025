-- 4.1. tính tổng giá trị của 1 trường nhất định
SELECT SUM(Freight) FROM Orders; -- chương trình chỉ chấp nhận giá trị số, không thể đưa (*) hoặc trường có giá trị là string hoặc là Null vào trong SUM()

-- 4.2. tính giá trị trung bình của 1 trường nhất định
SELECT AVG(Freight) FROM Orders; -- chương trình chỉ chấp nhận giá trị số, không thể đưa (*) hoặc trường có giá trị là string hoặc là Null vào trong AVG()

-- 4.3. toán tử số học +-*/%
SELECT UnitsInStock + UnitsOnOrder AS [Hàng chưa đi] FROM Products;
SELECT ([UnitsInStock] - [UnitsOnOrder]) AS [Hàng tồn kho] FROM Products;
SELECT UnitPrice * Quantity AS [Thành tiền] FROM [Order Details];
SELECT (UnitPrice) / (SELECT AVG(UnitPrice) FROM [Order Details]) AS [Tỉ lệ giá trung bình] FROM [Order Details]; -- lưu ý phải tinh AVG() trước nên cho AVG() vào ngoặc như kiểu tính trong ngoặc trước ngoài ngoặc sau
SELECT UnitPrice AS [Giá gốc], UnitPrice - (UnitPrice*0.1) AS [Giá giảm 10%] FROM Products;
