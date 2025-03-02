-- Cau 1.
use master;
go

create database QLHANG;
go

use QLHANG;
go

create table Hang
(
	MaHang nvarchar(10) not null primary key,
	TenHang nvarchar(30),
	DVTinh nvarchar(30),
	SL int
);
create table HDBan
(
	MaHD nvarchar(10) not null primary key,
	NgayBan date,
	HoTenKhach nvarchar(30)
);
create table HangBan
(
	MaHD nvarchar(10) not null,
	MaHang nvarchar(10) not null,
	DonGia money,
	SoLuong int,
	constraint pk_HangBan primary key(MaHD, MaHang),
	constraint fk_HangBan_MaHD foreign key(MaHD) references HDBan(MaHD),
	constraint fk_HangBan_MaHang foreign key(MaHang) references Hang(MaHang)
);
go

insert into Hang(MaHang, TenHang, DVTinh, SL)
values	('H01', 'May tinh', 'Chiec', 100),
		('H02', 'Ti vi', 'Chiec', 200);

insert into HDBan(MaHD, NgayBan, HoTenKhach)
values	('HD01', '01-01-2025', 'Nguyen Van A'),
		('HD02', '02-01-2025', 'Tran Thi B');

insert into HangBan(MaHD, MaHang, DonGia, SoLuong)
values	('HD01', 'H01', 1000000, 5),
		('HD02', 'H01', 2000000, 10),
		('HD02', 'H02', 1500000, 6),
		('HD01', 'H02', 2500000, 8);
go 

select * from Hang;
select * from HDBan;
select * from HangBan;
go

-- Cau 2. 
create view vw_cau_2
as
	select h.MaHang, h.TenHang, sum(hb.SoLuong * hb.DonGia) as N'Tổng tiền'
	from Hang h
	inner join HangBan hb on h.MaHang = hb.MaHang
	group by h.MaHang, h.TenHang;
go

select * from dbo.vw_cau_2;
go

-- Cau 3.
create function fn_cau_3(@tenkhach nvarchar(30), @x date, @y date)
returns table
as
return
(
	select h.MaHang, h.TenHang, hb.SoLuong, hb.DonGia
	from Hang h
	inner join HangBan hb on h.MaHang = hb.MaHang
	inner join HDBan hd on hb.MaHD = hd.MaHD
	where hd.HoTenKhach = @tenkhach and hd.NgayBan between @x and @y
);
go

select * from dbo.fn_cau_3('Tran Thi B', '01-01-2024', '02-01-2025');
go

-- Cau 4. 
create procedure sp_cau_4(@maHD nvarchar(10))
as
begin
	if not exists (select 1 from HangBan where MaHD = @maHD)
	begin
		print N'Mã HD bạn muốn xóa không tồn tại!';
		return;
	end
	
	delete from HangBan
	where MaHD = @maHD;
	print N'Xóa hóa đơn thành công!';
end
go

exec dbo.sp_cau_4 'HD02';
select * from HangBan;
go
