-- 1h40 -> 2h40
-- Câu 1.
-- a. 
use master
go

create database QLbanhang
go

use QLbanhang
go

create table CONGTY
(
	MaCT nvarchar(10) not null primary key,
	TenCT nvarchar(30) not null,
	trangthai nvarchar(30) not null,
	ThanhPho nvarchar(30) not null
)
create table SANPHAM
(
	MaSP nvarchar(10) not null primary key,
	TenSP nvarchar(30) not null,
	mausac nvarchar(30) not null,
	soluong int not null,
	giaban money not null
)
create table CUNGUNG
(
	MaCT nvarchar(10) not null,
	MaSP nvarchar(10) not null,
	SoLuongCungung int not null,
	constraint pk_cungung primary key(MaCT, MaSP),
	constraint fk_cung_ung_mact foreign key(MaCT) references CONGTY(MaCT),
	constraint fk_cung_ung_masp foreign key(MaSP) references SANPHAM(MaSP)
)
go

-- b. 
-- Nhập dữ liệu
insert into CONGTY(MaCT, TenCT, trangthai, ThanhPho)
values ('CT01', N'Samsung', N'Đang hoạt động', N'Hà Nội'),
	   ('CT02', N'Oppo', N'Đang hoạt động', N'Hải Dương'),
	   ('CT03', N'Nvidia', N'Đang hoạt động', N'Hải Phòng')

insert into SANPHAM(MaSP, TenSP, mausac, soluong, giaban)
values ('SP01', N'Samsung Galaxy', N'Trắng', 1000, 1000000),
	   ('SP02', N'Oppo Reno', N'Xanh', 2000, 9000000),
	   ('SP03', N'RTX 4090', N'Đen', 3000, 8000000)

insert into CUNGUNG(MaCT, MaSP, SoLuongCungung)
values ('CT01', 'SP01', 200),
	   ('CT02', 'SP02', 300),
	   ('CT03', 'SP03', 500),
	   ('CT01', 'SP02', 200),
	   ('CT02', 'SP03', 100)
go

-- Kiểm tra dữ liệu
select * from CONGTY
select * from SANPHAM
select * from CUNGUNG
go

-- Câu 2.
create function fn_cau_2(@tenct nvarchar(30))
returns @kq table
(
	TenSP nvarchar(30),
	mausac nvarchar(30),
	soluong int,
	giaban money
)
as
begin
	insert into @kq
	select TenSP, mausac, soluong, giaban
	from SANPHAM sp
	inner join CUNGUNG cu on sp.MaSP = cu.MaSP
	inner join CONGTY ct on cu.MaCT = ct.MaCT
	where TenCT = @tenct
	return
end
go

-- Kiểm tra hàm 
select * from fn_cau_2('Nvidia')
go

-- Câu 3.
create proc sp_cau_3(@mact nvarchar(10), @tensp nvarchar(30), @slcu int)
as
begin
	if not exists(select * from SANPHAM where TenSP = @tensp)
		print N'Tên sản phẩm không tồn tại trong bảng sản phẩm!'
	else
	begin
		declare @masp nvarchar(10)
		select @masp = MaSP from SANPHAM where TenSP = @tensp

		insert into CUNGUNG values(@mact, @masp, @slcu)
		print N'Thêm mới cung ứng thành công!'
	end
end
go

-- Trường hợp tên sản phẩm không tồn tại
exec sp_cau_3 'CT03', 'RTX 4070', 100
-- Trường hợp tên sản phẩm có trong bảng sản phẩm
exec sp_cau_3 'CT03', 'Samsung Galaxy', 100
select * from CUNGUNG
go
		
-- Câu 4.
create trigger trg_cau_4
on CUNGUNG
for update
as
begin
	declare @slmoi int, @slcu int, @slco int, @masp nvarchar(10)
	select @slmoi = SoLuongCungung, @masp = MaSP from inserted
	select @slcu = SoLuongCungung from deleted
	select @slco = soluong from SANPHAM where MaSP = @masp
	
	if @slmoi - @slcu <= @slco
		update SANPHAM
		set soluong = soluong - (@slmoi - @slcu)
		where MaSP = @masp
	else
	begin
		raiserror(N'Số lượng không đủ để cập nhật!', 16, 1)
		rollback transaction
	end
end
go

-- Trường hợp không đủ số lượng
update CUNGUNG 
set SoLuongCungung = 5000
where MaCT = 'CT01' and MaSP = 'SP01'

-- Trường hợp thỏa mãn số lượng
update CUNGUNG 
set SoLuongCungung = 1200
where MaCT = 'CT01' and MaSP = 'SP01'
go

select * from SANPHAM
select * from CUNGUNG
go

