-- Bài tập
CREATE TRIGGER trg_insert_Xuat
ON Xuat
FOR INSERT
AS
BEGIN
    DECLARE @masp_inserted nvarchar(10), @soluongn_inserted INT, @dongiann_inserted MONEY;
    SELECT @masp_inserted = MaSP, @soluongn_inserted = SoLuongN, @dongiann_inserted = DonGiaN 
    FROM inserted;

    IF NOT EXISTS(SELECT 1 FROM SanPham WHERE MaSP = @masp_inserted)
    BEGIN
        RAISERROR(N'MaSP không tồn tại!', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
    
    IF @soluongn_inserted < 0
    BEGIN
        RAISERROR(N'Số lượng nhập phải lớn hơn 0!', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    IF @dongiann_inserted < 0
    BEGIN
        RAISERROR(N'Đơn giá nhập phải lớn hơn 0!', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    UPDATE SanPham
    SET SoLuong = SoLuong + @soluongn_inserted
    WHERE MaSP = @masp_inserted;
END
GO

SELECT * FROM Nhap;

INSERT INTO Nhap
VALUES ('N06', 'SP06', 20, 100000);
GO 

