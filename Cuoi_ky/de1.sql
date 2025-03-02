-- 1h15 -> 2h15
-- Câu 1.
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
	SoluongCungung int not null,
	ngaycungung datetime not null,
	constraint pk_cungung primary key(MaCT, MaSP),
	constraint fk_cungung_mact foreign key(MaCT) references CONGTY(MaCT),
	constraint fk_cungung_masp foreign key(MaSP) references SANPHAM(MaSP)
)
go

insert into CONGTY(MaCT, TenCT, trangthai, ThanhPho)
values	('CT01', 'Samsung', N'Đang hoạt động', N'Hà Nội'),
		('CT02', 'Oppo', N'Đang hoạt động', N'Thái Bình'),
		('CT03', 'Nvidia', N'Đang hoạt động', N'Hải Phòng')

insert into SANPHAM(MaSP, TenSP, mausac, soluong, giaban)
values	('SP01', N'Samsung Galaxy Y', N'Trắng', 1000, 1000000),
		('SP02', N'Oppo Reno 6Z', N'Xanh', 2000, 7000000),
		('SP03', N'RTX 4090', N'Đen', 3000, 9000000)

insert into CUNGUNG(MaCT, MaSP, SoluongCungung, ngaycungung)
values	('CT01', 'SP01', 400, '01/01/2025'),
		('CT02', 'SP02', 200, '01/02/2025'),
		('CT03', 'SP03', 600, '01/03/2025'),
		('CT01', 'SP03', 400, '01/04/2025'),
		('CT02', 'SP01', 400, '01/05/2025')
go

select * from CONGTY
select * from SANPHAM
select * from CUNGUNG
go

-- Câu 2.
create function fn_cau_2(@tenct nvarchar(30), @ngaycungung datetime)
returns table
as
return
(
	select TenSP, mausac, soluong, giaban
	from SANPHAM sp
	inner join CUNGUNG cu on sp.MaSP = cu.MaSP
	inner join CONGTY ct on cu.MaCT = ct.MaCT
	where TenCT = @tenct and ngaycungung = @ngaycungung
)
go

-- Trường hợp tìm thấy
select * from fn_cau_2('Samsung', '01/04/2025')
go
-- Trường hợp không tìm thấy
select * from fn_cau_2('Vinaphone', '01/04/2025')
go

-- Câu 3.
create proc sp_cau_3(@tenct nvarchar(10), @tensp nvarchar(30), @soluong int, @ngaycu datetime)
as
begin
	if not exists(select * from CONGTY where TenCT = @tenct)
	begin
		print N'Tên công ty không tồn tại!'
		return
	end
	
	if not exists(select * from SANPHAM where TenSP = @tensp)
	begin
		print N'Tên sản phẩm không tông tại!'
		return
	end

	if (select soluong from SANPHAM where TenSP = @tensp) < @soluong
	begin
		print N'Số lượng sản phẩm còn lại không đủ để cung ứng!'
		return
	end

	declare @mact nvarchar(10), @masp nvarchar(10)
	select @mact = MaCT from CONGTY where TenCT = @tenct
	select @masp = MaSP from SANPHAM where TenSP = @tensp
	
	insert into CUNGUNG
	values (@mact, @masp, @soluong, @ngaycu)

	update SANPHAM
	set	soluong = soluong - @soluong
	where MaSP = @masp

	print N'Thêm mới cung ứng thành công!'
end
go

-- TH tên công ty không tồn tại
exec sp_cau_3 'Vinaphone', 'RTX 4090', 100, '01/06/2025'

-- TH tên sản phẩm không tồn tại
exec sp_cau_3 'Samsung', 'RTX 4070', 100, '01/06/2025'

-- TH số lượng sản phẩm không đủ
exec sp_cau_3 'Samsung', N'Oppo Reno 6Z', 9000, '01/06/2025'

-- TH thỏa mãn
exec sp_cau_3 'Samsung', N'Oppo Reno 6Z', 900, '01/06/2025'

select * from SANPHAM
select * from CUNGUNG
go

-- Câu 4.
create trigger trg_cau_4
on CUNGUNG
for update
as
begin
	declare @slm int, @slc int, @slco int, @masp nvarchar(10)
	select @slm = SoluongCungung from inserted
	select @slc = SoluongCungung, @masp = MaSP from deleted
	select @slco = soluong from SANPHAM where MaSP = @masp

	if @slm - @slc <= @slco
		update SANPHAM
		set	soluong = soluong - (@slm - @slc)
		where MaSP = @masp
	else
	begin
		raiserror(N'Số lượng không đủ để cập nhật!', 16, 1)
		rollback transaction
	end
end
go

select * from SANPHAM
select * from CUNGUNG
go

-- TH không đủ số lượng để cập nhật
update CUNGUNG
set	 SoluongCungung = 2000
where MaCT = 'CT01' and MaSP = 'SP01'
go

-- TH đủ số lượng để cập nhật
update CUNGUNG
set	 SoluongCungung = 600
where MaCT = 'CT01' and MaSP = 'SP01'

select * from SANPHAM
select * from CUNGUNG
go
