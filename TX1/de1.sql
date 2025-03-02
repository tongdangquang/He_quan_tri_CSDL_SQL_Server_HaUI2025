-- Cau 1.
use master;
go

create database QLSACH;
go

use QLSACH;
create table NHAXUATBAN
(
	MaNXB nvarchar(10) not null primary key,
	TenNXB nvarchar(30) not null,
	SoLuongNXB int not null
);
create table TACGIA
(
	MaTG nvarchar(10) not null primary key,
	TenTG nvarchar(30) not null,
);
create table SACH
(
	MaSach nvarchar(10) not null primary key,
	TenSach nvarchar(30) not null,
	NamXB int not null,
	SoLuong int not null,
	DonGia money not null,
	MaTG nvarchar(10) not null,
	MaNXB nvarchar(10) not null,
	constraint fk_sach_MaTG foreign key (MaTG) references TACGIA(MaTG),
	constraint fk_sach_MaMXB foreign key (MaNXB) references NHAXUATBAN(MaNXB)
);
go

insert into NHAXUATBAN(MaNXB, TenNXB, SoLuongNXB)
values	('NXB01', N'Kim dong', 5000),
		('NXB02', N'Thanh nien', 6000);

insert into TACGIA(MaTG, TenTG)
values	('TG01', N'Nguyen Thi Lan'),
		('TG02', N'Nguyen Van Nam');

insert into SACH(MaSach, TenSach, NamXB, SoLuong, DonGia, MaTG, MaNXB)
values	('S01', N'Toan', 2020, 100, 15000, 'TG01', 'NXB01'),
		('S02', N'Ngu van', 2017, 200, 20000, 'TG02', 'NXB02'),
		('S03', N'Tieng anh', 2014, 400, 30000, 'TG01', 'NXB01'),
		('S04', N'Cau truc du lieu', 2022, 300, 10000, 'TG02', 'NXB02'),
		('S05', N'Co so du lieu', 2025, 130, 25000, 'TG02', 'NXB01'),
		('S06', N'Tri tue nhan tao', 2021, 150, 25000, 'TG01', 'NXB02');
go 

select * from NHAXUATBAN;
select * from TACGIA;
select * from SACH;
go

-- Cau 2. 
create view vw_cau_2
as
	select nxb.MaNXB, nxb.TenNXB, sum(s.SoLuong) as N'Tổng số lượng XB'
	from NHAXUATBAN nxb
	inner join SACH s on nxb.MaNXB = s.MaNXB
	group by nxb.MaNXB, nxb.TenNXB;
go

select * from dbo.vw_cau_2;
go

-- Cau 3.
-- inline table valued function
create function fn_cau_3(@tennxb nvarchar(30), @x int, @y int)
returns table
as
return
(
	select s.MaSach, s.TenSach, tg.TenTG, s.DonGia
	from SACH s
	inner join NHAXUATBAN nxb on s.MaNXB = nxb.MaNXB
	inner join TACGIA tg on s.MaTG = tg.MaTG
	where nxb.TenNXB = @tennxb and s.NamXB between @x and @y
);
go

-- table valued function
create function fn_cau_3_2(@tennxb nvarchar(30), @x int, @y int)
returns @kq table
(
	MaSach nvarchar(10),
	TenSach nvarchar(30),
	TenTG nvarchar(30),
	DonGia money
)
as
begin
	insert into @kq
	select s.MaSach, s.TenSach, tg.TenTG, s.DonGia
	from SACH s
	inner join NHAXUATBAN nxb on s.MaNXB = nxb.MaNXB
	inner join TACGIA tg on s.MaTG = tg.MaTG
	where nxb.TenNXB = @tennxb and s.NamXB between @x and @y;
	return;
end
go

select * from dbo.fn_cau_3('Thanh nien', 2015, 2025);
go

-- Cau 4. 
create procedure sp_cau_4
	@masach nvarchar(10)
as
begin
	if not exists (select 1 from SACH where MaSach = @masach)
	begin
		print N'Mã sách bạn muốn xóa không tồn tại!';
		return;
	end
	
	delete from SACH
	where MaSach = @masach;
	print N'Xóa sách thành công!';
end
go

exec dbo.sp_cau_4 'S06';
go