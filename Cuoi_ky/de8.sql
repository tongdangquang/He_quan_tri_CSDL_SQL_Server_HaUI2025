-- 1h13 - 2h13
-- Câu 1.
-- a.
use master
go

create database QLBanHang
go

use QLBanHang
go

create table VatTu
(
	MaVT nvarchar(10) not null primary key,
	TenVT nvarchar(30) not null,
	DVTinh nvarchar(20) not null,
	SLCon int not null
)
create table HoaDon
(
	MaHD nvarchar(10) not null primary key,
	NgayLap date not null,
	HoTenKhach nvarchar(30) not null
)
create table CTHoaDon 
(
	MaHD nvarchar(10) not null,
	MaVT nvarchar(10) not null,
	DonGiaBan money not null,
	SLBan int not null,
	constraint pk_cthoadon primary key(MaHD, MaVT),
	constraint fk_cthoadon_mahd foreign key(MaHD) references HoaDon(MaHD),
	constraint fk_cthoadon_mavt foreign key(MaVT) references VatTu(MaVT)
)
go

-- b.
insert into VatTu(MaVT, TenVT, DVTinh, SLCon)
values ('VT01', N'Bóng điện', N'Chiếc', 1000),
	   ('VT02', N'Ống nhựa', N'Chiếc', 2000),
	   ('VT03', N'Xi măng', N'Bao', 1000)

insert into HoaDon(MaHD, NgayLap, HoTenKhach)
values ('HD01', '04/01/2020', N'Nguyễn Văn A'),
	   ('HD02', '05/01/2020', N'Nguyễn Văn B'),
	   ('HD03', '04/03/2020', N'Nguyễn Văn C')

insert into CTHoaDon(MaHD, MaVT, DonGiaBan, SLBan)
values ('HD01', 'VT01', 10000, 30),
	   ('HD02', 'VT02', 20000, 50),
	   ('HD03', 'VT03', 50000, 40),
	   ('HD01', 'VT02', 20000, 30),
	   ('HD02', 'VT03', 50000, 20)
go

select * from VatTu
select * from HoaDon
select * from CTHoaDon
go

-- Câu 2.
create function fn_cau_2(@tenvt nvarchar(30), @ngayban date)
returns money
as
begin
	declare @tt money

	select @tt = sum(DonGiaBan * SLBan)
	from CTHoaDon ct 
	inner join VatTu vt on ct.MaVT = vt.MaVT
	inner join HoaDon hd on ct.MaHD = hd.MaHD
	where TenVT = @tenvt and NgayLap = @ngayban

	return @tt
end
go

-- Kiểm tra hàm 
select dbo.fn_cau_2(N'Ống nhựa', '05/01/2020') as N'Tổng tiền'
go

-- Câu 3.
alter proc sp_cau_3(@mon int, @year int)
as
begin
	declare @t int
	select @t = sum(SLBan)
	from CTHoaDon ct
	inner join HoaDon hd on ct.MaHD = hd.MaHD
	where month(NgayLap) = @mon and year(NgayLap) = @year
	--print N'Tổng số lượng vật tư bán trong tháng ' + cast(@mon as nvarchar) + '-' + cast(@year as nvarchar) + N' là: ' + cast(isnull(@t, 0) as nvarchar)
	print concat(N'Tổng số lượng vật tư bán trong tháng ', @mon, '-', @year, N' là: ', isnull(@t, 0))
end
go

-- Trường hợp không có hóa đơn
exec sp_cau_3 4, 2020
-- Trường hợp có hóa đơn
exec sp_cau_3 10, 2020
go

-- Câu 4.
create trigger trg_cau_4
on CTHoaDon
for delete
as
begin
	if (select count(*) from CTHoaDon) = 0
	begin
		raiserror(N'Không được phép xóa vì nếu xóa thì bảng CTHoaDon sẽ trống!', 16, 1)
		rollback transaction
	end
	else
	begin
		update VatTu
		set SLCon = SLCon + d.SLBan
		from VatTu vt 
		inner join deleted d on vt.MaVT = d.MaVT
	end
end
go

-- TH có nhiều hơn 1 bản ghi
delete from CTHoaDon where MaHD = 'HD03'
select * from CTHoaDon
select * from VatTu
go
