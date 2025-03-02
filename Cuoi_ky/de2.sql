-- 12h10 -> 13h10
-- Câu 1.
use master 
go

create database QLbanhang
go

use QLbanhang
go

create table CONGTY
(
	MaCT nvarchar(10) primary key,
	TenCT nvarchar(30),
	trangthai nvarchar(30),
	ThanhPho nvarchar(30)
)

create table SANPHAM
(
	MaSP nvarchar(10) primary key,
	TenSP nvarchar(30),
	mausac nvarchar(30),
	soluong int,
	giaban money
)

create table CUNGUNG
(
	MaCT nvarchar(10) not null,
	MaSP nvarchar(10) not null,
	SoluongCunung int not null,
	ngaycungung datetime not null,
	constraint pk_cunugung primary key(MaCT, MaSP),
	constraint fk_cungung_mact foreign key(MaCT) references CONGTY(MaCT),
	constraint fk_cungung_masp foreign key(MaSP) references SANPHAM(MaSP)
)
go

insert into CONGTY(MaCT, TenCT, trangthai, ThanhPho)
values	('CT01', 'Samsung', N'Đang hoạt động', N'Hà Nội'),
		('CT02', 'Oppo', N'Đang hoạt động', N'Thái Bình'),
		('CT03', 'Nvidia', N'Đang hoạt động', N'Hải Dương')

insert into SANPHAM(MaSP, TenSP, mausac, soluong, giaban)
values	('SP01', 'Samsung Galaxy Y', N'Trắng', 1000, 1000000),
		('SP02', 'Oppo Reno 6Z', N'Xanh', 2000, 7000000),
		('SP03', 'RTX 4090', N'Đen', 3000, 9000000)

insert into CUNGUNG(MaCT, MaSP, SoluongCunung, ngaycungung)
values	('CT01', 'SP01', 100, '01/01/2025'),
		('CT02', 'SP02', 200, '01/01/2025'),
		('CT03', 'SP03', 300, '01/01/2025'),
		('CT01', 'SP02', 400, '01/01/2025'),
		('CT02', 'SP03', 500, '01/01/2025')
go

select * from CONGTY
select * from SANPHAM
select * from CUNGUNG
go

-- Câu 2. 
create function fn_cau_2(@tenct nvarchar(30), @ngaycu datetime)
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
	where TenCT = @tenct and ngaycungung = @ngaycu
	return
end
go

-- Kiểm tra hàm
select * from fn_cau_2('Samsung', '01/01/2025')
go

-- Câu 3.
create proc sp_cau_3(@tenct nvarchar(30), @tensp nvarchar(30), @slcu int, @ngaycu datetime)
as
begin
	if not exists(select * from CONGTY where TenCT = @tenct)
	begin
		print N'Tên công ty không tồn tại!'
		return
	end

	if not exists(select * from SANPHAM where TenSP = @tensp)
	begin
		print N'Tên sản phẩm không tồn tại!'
		return
	end

	declare @mact nvarchar(10), @masp nvarchar(10)
	select @mact = MaCT from CONGTY where TenCT = @tenct
	select @masp = MaSP from SANPHAM where TenSP = @tensp

	if exists(select * from CUNGUNG where MaCT = @mact and MaSP = @masp)
	begin 
		print N'Cặp tên công ty và tên sản phẩm đã tồn tại, hãy nhập lại cặp khác!'
		return 
	end

	if (select soluong from SANPHAM where MaSP = @masp) < @slcu
	begin	
		print N'Số lượng không đủ để thêm mới cung ứng'
		return
	end

	insert into CUNGUNG
	values (@mact, @masp, @slcu, @ngaycu)

	update SANPHAM
	set soluong = soluong - @slcu
	where MaSP = @masp
end
go

-- TH tên công ty không tồn tại
exec sp_cau_3 'Vinaphone', 'RTX 4090', 200, '01/01/2025'

-- TH tên sản phẩm không tồn tại
exec sp_cau_3 'Samsung', 'RTX 4070', 200, '01/01/2025'

-- TH cặp tên công ty và tên sản phẩm đã tồn tại
exec sp_cau_3 'Samsung', 'Samsung Galaxy Y', 200, '01/01/2025'

-- TH không đủ số lượng
exec sp_cau_3 'Samsung', 'RTX 4090', 5000, '01/01/2025'

-- TH thỏa mãn mọi điều kiện
exec sp_cau_3 'Samsung', 'RTX 4090', 500, '01/01/2025'
go

select * from SANPHAM
select * from CUNGUNG
go

-- Câu 4. 
create trigger trg_cau_4
on CUNGUNG
for update
as
begin
	declare @slmoi int, @slcu int, @slco int, @masp nvarchar(10)
	select @slmoi = SoluongCunung from inserted
	select @slcu = SoluongCunung, @masp = MaSP from deleted
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

-- TH không đủ số lượng
update CUNGUNG
set SoluongCunung = 2000
where MaCT = 'CT01' and MaSP = 'SP01'
go

-- TH thỏa mãn số lượng
update CUNGUNG
set SoluongCunung = 100
where MaCT = 'CT01' and MaSP = 'SP01'
go

select * from SANPHAM
select * from CUNGUNG
go