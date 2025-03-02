-- 11h30 -> 12h30
-- Câu 1.
use master
go

-- Tạo cơ sở dữ liệu
create database QLBenhVien
go

use QLBenhVien
go

-- Tạo các bảng dữ liệu
create table BenhNhan
(
	MaBN nvarchar(10) not null primary key,
	TenBN nvarchar(30) not null, 
	GioiTinh nvarchar(10) not null,
	SoDT varchar(15) not null,
	Email varchar(30) not null
)
create table Khoa
(
	MaKhoa nvarchar(10) not null primary key,
	TenKhoa nvarchar(30) not null,
	diachi nvarchar(30) not null,
	tienNgay money not null,
	TongBenhNhan int not null
)
create table HoaDon
(
	SoHD nvarchar(10) not null primary key,
	MaBN nvarchar(10) not null,
	MaKhoa nvarchar(10) not null,
	SoNgay int not null,
	constraint fk_hoadon_makhoa foreign key(MaKhoa) references Khoa(MaKhoa),
	constraint fk_hoadon_mabn foreign key(MaBN) references BenhNhan(MaBN)
)
go

-- Chèn dữ liệu
insert into BenhNhan(MaBN, TenBN, GioiTinh, SoDT, Email)
values ('BN01', N'Nguyễn Văn A', N'Nam', '08777811234', 'nguyena@gmail.com'),
	   ('BN02', N'Nguyễn Thị B', N'Nữ', '08777811235', 'nguyenb@gmail.com'),
	   ('BN03', N'Nguyễn Văn C', N'Nam', '08777811236', 'nguyenc@gmail.com')

insert into Khoa(MaKhoa, TenKhoa, diachi, tienNgay, TongBenhNhan)
values ('K01', N'Tai mũi họng', N'Tầng 2', 100000, 300),
	   ('K02', N'Da liễu', N'Tầng 3', 150000, 400),
	   ('K03', N'Thần kinh', N'Tầng 4', 200000, 200)

insert into HoaDon(SoHD, MaBN, MaKhoa, SoNgay)
values ('HD01', 'BN01', 'K03', 4),
	   ('HD02', 'BN02', 'K02', 5),
	   ('HD03', 'BN03', 'K01', 3),
	   ('HD04', 'BN01', 'K01', 7),
	   ('HD05', 'BN02', 'K03', 6)
go

-- Kiểm tra dữ liệu
select * from BenhNhan
select * from Khoa
select * from HoaDon
go

-- Câu 2.
create function fb_cau_2(@mabn nvarchar(10))
returns money
as
begin
	declare @kq money
	select @kq = sum(tienNgay * SoNgay)
	from HoaDon hd
	inner join Khoa k on hd.MaKhoa = k.MaKhoa
	where MaBN = @mabn
	return @kq
end
go

-- Kiểm tra hàm
select dbo.fb_cau_2('BN03')
go

-- Câu 3.
create proc sp_cau_3(@sohd nvarchar(10), @mabn nvarchar(10), @tenkhoa nvarchar(30), @songay int)
as
begin
	if exists(select * from HoaDon where SoHD = @sohd)
	begin
		print N'Số hóa đơn đã tồn tại, hãy nhập số hóa đơn khác!'
		return
	end

	if not exists(select * from BenhNhan where MaBN = @mabn)
	begin
		print N'Mã bệnh nhân không tồn tại trong danh sách bênh nhân!'
		return
	end
	
	if not exists(select * from Khoa where TenKhoa = @tenkhoa)
	begin
		print N'Tên khoa không tồn tại trong danh sách khoa!'
		return
	end
	
	declare @makhoa nvarchar(10)
	select @makhoa = MaKhoa from Khoa where TenKhoa = @tenkhoa
	
	insert into HoaDon values (@sohd, @mabn, @makhoa, @songay)
	update Khoa 
	set	TongBenhNhan = TongBenhNhan - 1
	where MaKhoa = @makhoa
	print N'Thêm mới hóa đơn thành công!'
end
go

-- Trường hợp số hóa đơn đã tồn tại
exec sp_cau_3 'HD05', 'BN01', N'Tai mũi họng', 10
-- Trường hợp mã bệnh nhân không tồn tại
exec sp_cau_3 'HD06', 'BN04', N'Tai mũi họng', 10
-- Trường hợp tên khoa không tồn tại
exec sp_cau_3 'HD06', 'BN01', N'Công nghệ thông tin', 10
-- Trường hợp thỏa mãn
exec sp_cau_3 'HD10', 'BN01', N'Tai mũi họng', 10
select * from HoaDon
go

-- Câu 4.
create trigger trg_cau_4
on HoaDon
for insert
as
begin
	declare @makhoa nvarchar(10)
	select @makhoa = MaKhoa from inserted

	update Khoa
	set	TongBenhNhan = TongBenhNhan - 1
	where MaKhoa = @makhoa
end
go

-- Kiểm tra hàm
insert into HoaDon values ('HD08', 'BN03', 'K03', 6)
select * from Khoa
select * from HoaDon
go
