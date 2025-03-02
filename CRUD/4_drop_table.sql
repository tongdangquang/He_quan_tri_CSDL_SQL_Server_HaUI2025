-- 1. DROP TABLE... - xóa bảng
-- Khi đã xóa bảng bằng lệnh DROP TABLE ta sẽ không thể khôi phục lại bảng cũng như dữ liệu của nó
-- tạo bảng dữ liệu mới
CREATE TABLE LOP
(
    MaLop VARCHAR(10) NOT NULL PRIMARY KEY,
    TenLop NVARCHAR(30) NOT NULL,
    SoluongSV int NULL
);

-- thêm ràng buộc cho bảng LOP
ALTER TABLE LOP
ADD CONSTRAINT fk_LOP FOREIGN KEY (MaSV) REFERENCES SV(MaSV);

ALTER TABLE LOP
ADD CONSTRAINT ck_LOP_Soluong CHECK (SoluongSV > 20);

--  nếu bảng có ràng buộc thì bắt buộc phải xóa các ràng buộc trước khi xóa bảng
ALTER TABLE LOP
DROP CONSTRAINT fk_LOP, ck_LOP_Soluong; -- xóa ràng buộc (riêng ràng buộc primary key không cần xóa)

-- xóa bảng (xóa hoàn toàn bảng khỏi cơ sở dữ liệu)
DROP TABLE LOP; 
-- DROP TABLE LOP1, LOP2, LOP3; -- xóa nhiều bảng cùng lúc

-- xóa dữ liệu trong bảng những không xóa bảng
TRUNCATE TABLE LOP;

