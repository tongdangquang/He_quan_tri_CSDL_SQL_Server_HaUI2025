-- Câu 1.
use master;
go

--drop database QLSACH
create database QLSACH;
go

use QLSACH;
go

create table NHAXB
(
	MaNXB nvarchar(10) not null primary key,
	TenNXB nvarchar(30) not null,
	soluongco int not null
);
create table TACGIA
(
	MaTG nvarchar(10) not null primary key,
	TenTG nvarchar(30) not null,
	soluongco int not null
);
create table SACH
(
	MaSach nvarchar(10) not null primary key,
	TenSach nvarchar(30) not null,
	MaNXB nvarchar(10) not null,
	MaTG nvarchar(10) not null,
	NamXB int not null,
	soluong int not null,
	DonGia money not null,
	constraint fk_sach_manxb foreign key(MaNXB) references NHAXB(MaNXB),
	constraint fk_sach_matg foreign key(MaTG) references TACGIA(MaTG)
);
go

insert into NHAXB(MaNXB, TenNXB, soluongco)
values	('NXB01', 'Kim dong', 3000),
		('NXB02', 'Thanh nien', 2000),
		('NXB03', 'Nha nam', 5000);

insert into TACGIA(MaTG, TenTG, soluongco)
values	('TG01', 'Nguyen Thi Thap', 10),
		('TG02', 'Nguyen Tuyet Nhung', 20),
		('TG03', 'Dang Thuy Tram', 15);

insert into SACH(MaSach, TenSach, MaNXB, MaTG, NamXB, soluong, DonGia)
values	('S01', 'Toan', 'NXB01', 'TG02', 2020, 100, 10000),
		('S02', 'Van', 'NXB02', 'TG01', 2024, 200, 15000),
		('S03', 'Tieng anh', 'NXB03', 'TG03', 2025, 150, 20000),
		('S04', 'Hoa hoc', 'NXB01', 'TG02', 2021, 300, 15000);

go

select * from NHAXB;
select * from TACGIA;
select * from SACH;
go
		
-- Câu 2. 
create procedure sp_cau_2(@tennxb nvarchar(30))
as
begin
	if not exists (select 1 from NHAXB where TenNXB = @tennxb)
	begin
		print N'Không tồn tại tên NXB ' + @tennxb;
		return;
	end

	select nxb.MaNXB, nxb.TenNXB, sum(s.soluong * s.DonGia) as 'TienBan'
	from NHAXB nxb
	inner join SACH s on nxb.MaNXB = s.MaNXB
	where nxb.TenNXB = @tennxb
	group by nxb.MaNXB, nxb.TenNXB;
end
go

-- TH TenNXB đúng
exec dbo.sp_cau_2 'Kim dong';
go

-- TH không tồn tại TenNXB
exec dbo.sp_cau_2 'Tuoi tre';
go

-- Câu 3.
create function fn_cau_3(@TenTG nvarchar(30))
returns money
as
begin
	declare @kq money = 0
	select @kq = sum(s.soluong * s.DonGia)
	from TACGIA tg
	inner join SACH s on tg.MaTG = s.MaTG
	where tg.TenTG = @TenTG
	group by tg.MaTG
	return @kq
end
go

-- TH tên tác giả tồn tại
select dbo.fn_cau_3('Dang Thuy Tram')
go

-- TH tên tác giả không tồn tại
select dbo.fn_cau_3('Thuy Tram')
go

-- Câu 4.
create trigger trg_cau_4
on SACH
for insert
as
begin
	declare @manxb_moi nvarchar(10), @soluong_moi int
	select @manxb_moi = MaNXB, @soluong_moi = soluong from inserted

	if not exists (select * from NHAXB where MaNXB = @manxb_moi)
	begin
		raiserror(N'MaNXB chưa có mặt trong bảng NhaXB!', 16, 1)
		rollback transaction
	end

	else
	begin
		if @soluong_moi > (select soluongco from NHAXB where MaNXB = @manxb_moi)
		begin
			raiserror(N'soluong còn lại không đủ để thêm!', 16, 1)
			rollback transaction
		end

		else
		begin
			update NHAXB
			set soluongco = soluongco - @soluong_moi
			where MaNXB = @manxb_moi
		end
	end
end
go

-- TH MaNXB không có mặt trong bảng NhaXB
insert into SACH(MaSach, TenSach, MaNXB, MaTG, NamXB, soluong, DonGia)
values ('S06', 'Tin hoc', 'NXB05', 'TG02', 2021, 300, 15000)
go

-- TH soluong không đủ để thêm
insert into SACH(MaSach, TenSach, MaNXB, MaTG, NamXB, soluong, DonGia)
values ('S05', 'Tin hoc', 'NXB03', 'TG02', 2021, 6000, 15000)
go

-- TH thỏa mãn mọi điều kiện
insert into SACH(MaSach, TenSach, MaNXB, MaTG, NamXB, soluong, DonGia)
values ('S05', 'Tin hoc', 'NXB03', 'TG02', 2021, 500, 15000)
go