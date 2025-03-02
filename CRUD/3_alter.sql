-- 1. ALTER TABLE - ADD Column - Bổ sung một cột vào bảng
ALTER TABLE SV
ADD Email VARCHAR(255);

ALTER TABLE SV
ADD Phone_number CHAR(10) CONSTRAINT check_sv_pn CHECK (Phone_number LIKE '0[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]');


-- 2. ALTER TABLE - DROP COLUMN - Xóa một cột khỏi bảng
-- 2.1. Xóa một cột trong bảng
ALTER TABLE SV
DROP COLUMN Email;

-- 2.2. Xóa nhiều cột trong bảng
ALTER TABLE SV 
ADD Email1 VARCHAR(30), Email2 VARCHAR(40), Email3 VARCHAR(50);

ALTER TABLE SV 
DROP COLUMN Email1, Email2, Email3;

-- 2.3. Xóa cột có các ràng buộc check, primary key, foreign key, ...
-- Lưu ý: Xóa ràng buộc trước rồi xóa cột sau
ALTER TABLE SV 
DROP CONSTRAINT check_sv_pn; -- xóa ràng buộc của cột Phone_number

ALTER TABLE SV
DROP COLUMN Phone_number; -- xóa cột Phone_number


-- 3. ALTER TABLE - ALTER COLUMN - thay đổi định nghĩa, kiểu dữ liệu của cột trong bảng
ALTER TABLE SV
ALTER COLUMN Que NVARCHAR(50) NOT NULL; -- thay đổi cột Que thành not null  

ALTER TABLE SV 
ALTER COLUMN Que VARCHAR(30) NULL; -- thay đổi cột Que thành null


-- 4. ALTER TABLE - ADD CONSTRAINT - bổ sung ràng buộc cho cột trong bảng
ALTER TABLE SV 
ADD Email VARCHAR(30);

ALTER TABLE SV
ADD CONSTRAINT ck_sv_email CHECK (LEN(Email) >= 10); -- bổ sung ràng buộc về chiều dài cho cột Email


-- 5. ALTER TABLE - RENAME COLUMN - thay đổi tên cột
ALTER TABLE SV 
ADD Phone VARCHAR(10) NULL;

-- thay đổi tên bảng 
EXEC sp_rename 'SV.Phone', 'Phone_number', 'COLUMN';

-- kiểm tra cấu trúc bảng
EXEC sp_help SV;