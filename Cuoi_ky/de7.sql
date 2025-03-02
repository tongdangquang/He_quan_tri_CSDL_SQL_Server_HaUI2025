-- 10h57 - 11h57
-- Câu 1.
-- a.
use master 
go

create database QlBenhNhan
go

use QLBenhNhan
go

create table BenhVien
(
	MaBV nvarchar(10) not null primary key,
	TenBV nvarchar(30) not null
)
create table KhoaKham
(
	MaKhoa nvarchar(10) not null primary key,
	TenKhoa nvarchar(30) not null,
	SoBenhNhan int not null,
	MaBV nvarchar(10) not null,
	constraint fk_khoakham_mabv foreign key(MaBV) references BenhVien(MaBV)
)
create table BenhNhan
(
	MaBN nvarchar(10) not null primary key,
	HoTen nvarchar(30) not null,
	NgaySinh date not null,
	GioiTinh nvarchar(10) not null,
	SoNgayNV int not null,
	MaKhoa nvarchar(10) not null,
	constraint fk_benhnhan_makhoa foreign key(MaKhoa) references KhoaKham(MaKhoa)
)
go

-- b.
insert into BenhVien(MaBV, TenBV)
values ('BV01', N'Bạch Mai'),
	   ('BV02', N'Hữu Nghị'),
	   ('BV03', N'Việt Đức')

insert into KhoaKham(MaKhoa, TenKhoa, SoBenhNhan, MaBV)
values ('K01', N'Tai mũi họng', 101, 'BV01'),
	   ('K02', N'Da liễu', 80, 'BV02'),
	   ('K03', N'Thần kinh', 60, 'BV03')

insert into BenhNhan(MaBN, HoTen, NgaySinh, GioiTinh, SoNgayNV, MaKhoa)
values ('BN01', N'Nguyễn Văn A', '01/01/2004', N'Nam', 10, 'K01'),
	   ('BN02', N'Nguyễn Thị B', '01/02/2004', N'Nữ', 4, 'K02'),
	   ('BN03', N'Nguyễn Văn C', '01/03/2004', N'Nam', 5, 'K03'),
	   ('BN04', N'Nguyễn Thị D', '01/04/2004', N'Nữ', 7, 'K01'),
	   ('BN05', N'Nguyễn Văn E', '01/05/2004', N'Nam', 3, 'K02')
go

select * from BenhVien
select * from KhoaKham
select * from BenhNhan
go

-- Câu 2.
create view vw_cau_2
as
	select kk.MaKhoa, TenKhoa, count(bn.MaBN) as N'Số_người'
	from KhoaKham kk
	left join BenhNhan bn on kk.MaKhoa = bn.MaKhoa and GioiTinh = N'Nữ'
	group by kk.MaKhoa, TenKhoa
go

-- Kiểm tra view 
select * from vw_cau_2
go

-- Câu 3.
create proc sp_cau_3(@makhoa nvarchar(10)) 
as
begin
	declare @tien int
	select @tien = sum(SoNgayNV * 80000)
	from BenhNhan
	where MaKhoa = @makhoa
	return @tien
end
go

declare @kq int
exec @kq = sp_cau_3 'K03'
select @kq as N'Tổng số tiền của khoa'
go

-- Câu 4.
create trigger trg_cau_4
on BenhNhan
for insert
as
begin
	declare @makhoa nvarchar(10), @sbn int
	select @makhoa = MaKhoa from inserted
	select @sbn = SoBenhNhan from KhoaKham where MaKhoa = @makhoa
	
	if @sbn > 100
	begin
		raiserror(N'Không thể thêm bênh nhân mới vì số bệnh nhân trong khoa khám > 100', 16, 1)
		rollback transaction
	end
	else
		update KhoaKham
		set SoBenhNhan = SoBenhNhan + 1
		where MaKhoa = @makhoa
end
go

-- TH số bệnh nhân > 100
insert into BenhNhan values ('BN09', N'Nguyễn Văn F', '01/06/2004', N'Nam', 3, 'K01')
-- TH số bệnh nhân <= 100
insert into BenhNhan values ('BN10', N'Nguyễn Văn F', '01/06/2004', N'Nam', 3, 'K02')
select * from BenhNhan
select * from KhoaKham
go
