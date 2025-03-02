-- 10h58 - 11h58
-- Câu 1.
-- a.
use master
go

create database QLSinhVien
go

use QLSinhVien
go

create table Khoa
(
	MaKhoa nvarchar(10) not null primary key,
	TenKhoa nvarchar(30) not null,
	diachi nvarchar(30) not null,
	SoDT varchar(15) not null,
	Email varchar(30) not null
)
create table Lop
(
	MaLop nvarchar(10) not null primary key,
	TenLop nvarchar(30) not null,
	SiSo int not null,
	MaKhoa nvarchar(10) not null,
	Phong nvarchar(30) not null,
	constraint fk_lop_makhoa foreign key(MaKhoa) references Khoa(MaKhoa)
)
create table SinhVien
(
	MaSV nvarchar(10) not null primary key,
	HoTen nvarchar(30) not null,
	NgaySinh date not null,
	GioiTinh nvarchar(10) not null,
	MaLop nvarchar(10) not null,
	constraint fk_sinhvien_malop foreign key(MaLop) references Lop(MaLop)
)
go

-- b.
-- Chèn dữ liệu
insert into Khoa(MaKhoa, TenKhoa, diachi, SoDT, Email)
values ('K01', N'Công nghệ thông tin', '101A1', '0128913401', 'cntt@gmail.com'),	
	   ('K02', N'Kế kiểm', '102A1', '0128913402', 'kk@gmail.com'),
	   ('K03', N'Quản lý kinh doanh', '103A1', '0128913403', 'qlkd@gmail.com')

insert into Lop(MaLop, TenLop, SiSo, MaKhoa, Phong)
values ('L01', 'CNTT01', 50, 'K01', '101A9'),
	   ('L02', 'KT01', 61, 'K02', '102A9'),
	   ('L03', 'QTKD01', 55, 'K03', '103A9')

insert into SinhVien(MaSV, HoTen, NgaySinh, GioiTinh, MaLop)
values ('SV01', N'Nguyễn Văn A', '01/01/2004', N'Nam', 'L01'),
	   ('SV02', N'Nguyễn Văn B', '01/02/2005', N'Nam', 'L02'),
	   ('SV03', N'Nguyễn Thị C', '01/03/2006', N'Nữ', 'L03'),
	   ('SV04', N'Nguyễn Văn D', '01/04/2002', N'Nam', 'L01'),
	   ('SV05', N'Nguyễn Thị E', '01/05/2001', N'Nữ', 'L02')
go

-- Kiểm tra dữ liệu
select * from Khoa
select * from Lop
select * from SinhVien
go

-- Câu 2.
create function fn_cau_2(@tenkhoa nvarchar(30), @tenlop nvarchar(30))
returns @kq table
(
	MaSV nvarchar(10),
	HoTen nvarchar(30),
	Tuoi int
)
as
begin
	insert into @kq
	select MaSV, HoTen, year(getdate()) - year(NgaySinh)
	from SinhVien sv
	inner join Lop l on sv.MaLop = l.MaLop
	inner join Khoa k on l.MaKhoa = k.MaKhoa
	where TenKhoa = @tenkhoa and TenLop = @tenlop
	return
end
go

-- Kiểm tra hàm 
select * from fn_cau_2(N'Kế kiểm', 'KT01')
go

-- Câu 3.
create proc sp_cau_3(@tutuoi int, @dentuoi int)
as
begin
	select MaSV, HoTen, NgaySinh, TenLop, TenKhoa, year(getdate()) - year(NgaySinh) as 'Tuoi'
	from SinhVien sv
	inner join Lop l on sv.MaLop = l.MaLop
	inner join Khoa k on l.MaKhoa = k.MaKhoa
	where year(getdate()) - year(NgaySinh) between @tutuoi and @dentuoi
end
go

-- Kiểm tra procedure
exec sp_cau_3 22, 25
go

-- Câu 4.
create trigger trg_cau_4
on SinhVien
instead of insert
as
begin
	declare @masv nvarchar(10), @malop nvarchar(10)
	select @masv = MaSV, @malop = MaLop from inserted

	if exists(select * from SinhVien where MaSV = @masv)
	begin
		raiserror(N'Mã sinh viên đã tồn tại, hãy nhập mã sinh viên khác!', 16, 1)
		rollback transaction
		return
	end

	if not exists(select * from Lop where MaLop = @malop)
	begin
		raiserror(N'Mã lớp không tồn tại, hãy nhập mã lớp khác!', 16, 1)
		rollback transaction
		return
	end

	if (select SiSo from Lop where MaLop = @malop) > 60
	begin
		raiserror(N'Sĩ số lớp > 60, không thể thêm!', 16, 1)
		rollback transaction
		return
	end

	insert into SinhVien 
	select * from inserted

	update Lop
	set SiSo = SiSo + 1
	where MaLop = @malop
end
go

-- Trường hợp masv đã tồn tại
insert into SinhVien(MaSV, HoTen, NgaySinh, GioiTinh, MaLop)
values ('SV05', N'Nguyễn Văn F', '01/01/2005', N'Nam', 'L01')

-- Trường hợp malop không tồn tại
insert into SinhVien(MaSV, HoTen, NgaySinh, GioiTinh, MaLop)
values ('SV06', N'Nguyễn Văn F', '01/01/2005', N'Nam', 'L04')

-- Trường hợp sĩ số lớp > 60
insert into SinhVien(MaSV, HoTen, NgaySinh, GioiTinh, MaLop)
values ('SV06', N'Nguyễn Văn F', '01/01/2005', N'Nam', 'L02')

-- Trường hợp thỏa mãn mọi điều kiện
insert into SinhVien(MaSV, HoTen, NgaySinh, GioiTinh, MaLop)
values ('SV06', N'Nguyễn Văn F', '01/01/2005', N'Nam', 'L03')

select * from Lop
select * from SinhVien
go

-- Câu 4. Bài làm khi đi thi
alter trigger trg_cau_4_c2
on SinhVien
for insert
as
begin
	declare @masv nvarchar(10), @malop nvarchar(10)
	select @masv = MaSV, @malop = MaLop from inserted

	if (select SiSo from Lop where MaLop = @malop) > 60
	begin
		raiserror(N'Sĩ số lớp > 60, không thể thêm!', 16, 1)
		rollback transaction
	end
	else
		update Lop set SiSo = SiSo + 1 where MaLop = @malop
end
go

-- Trường hợp sĩ số lớp > 60
insert into SinhVien(MaSV, HoTen, NgaySinh, GioiTinh, MaLop)
values ('SV06', N'Nguyễn Văn F', '01/01/2005', N'Nam', 'L02')

-- Trường hợp thỏa mãn mọi điều kiện
insert into SinhVien(MaSV, HoTen, NgaySinh, GioiTinh, MaLop)
values ('SV06', N'Nguyễn Văn F', '01/01/2005', N'Nam', 'L03')

select * from Lop
select * from SinhVien
go