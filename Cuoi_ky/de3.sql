-- 10h -> 11h
-- Câu 1.
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
	SoDienThoai varchar(15) not null,
)
create table Lop
(
	MaLop nvarchar(10) not null primary key,
	TenLop nvarchar(30) not null,
	SiSo int not null,
	MaKhoa nvarchar(10) not null,
	constraint fk_lop_makhoa foreign key(MaKhoa) references Khoa(MaKhoa)
)
create table SinhVien
(
	MaSV nvarchar(10) not null primary key,
	HoTen nvarchar(30) not null,
	GioiTinh nvarchar(10) not null,
	NgaySinh date not null,
	MaLop nvarchar(10) not null,
	constraint fk_sinhvien_malop foreign key(MaLop) references Lop(MaLop)
)
go

insert into Khoa(MaKhoa, TenKhoa, SoDienThoai)
values	('K01', N'Công nghệ thông tin', '0123456789'),
		('K02', N'Công nghệ hóa', '0123456987'),
		('K03', N'Quản lý kinh doanh', '0123456897')

insert into Lop(MaLop, TenLop, SiSo, MaKhoa)
values	('L01', 'CNTT01', 50, 'K01'),
		('L02', 'CNH01', 80, 'K02'),
		('L03', 'QTKD01', 60, 'K03')

insert into SinhVien(MaSV, HoTen, GioiTinh, NgaySinh, MaLop)
values	('SV01', N'Nguyễn Văn A', N'Nam', '01/01/2004', 'L01'),
		('SV02', N'Nguyễn Thị C', N'Nữ', '01/02/2004', 'L02'),
		('SV03', N'Nguyễn Văn D', N'Nam', '01/03/2004', 'L03'),
		('SV04', N'Nguyễn Thị E', N'Nữ', '01/04/2004', 'L01'),
		('SV05', N'Nguyễn Văn F', N'Nam', '01/05/2004', 'L02')
go

select * from Khoa
select * from Lop
select * from SinhVien
go

-- Câu 2.
create function fn_cau_2(@tenkhoa nvarchar(30))
returns @kq table
(
	MaLop nvarchar(10),
	TenLop nvarchar(30),
	SiSo int
)
as
begin
	insert into @kq
	select MaLop, TenLop, SiSo
	from Lop l
	inner join Khoa k on l.MaKhoa = k.MaKhoa
	where TenKhoa = @tenkhoa
	return 
end
go

-- Kiểm tra hàm
select * from fn_cau_2(N'Quản lý kinh doanh')
go

-- Câu 3.
create proc sp_cau_3(@masv nvarchar(10), @hoten nvarchar(30), @ngaysinh date, @gioitinh nvarchar(10), @tenlop nvarchar(30))
as
begin
	if not exists(select * from Lop where TenLop = @tenlop)
		print N'Tên lớp không tồn tại trong danh sách các lớp!'
	else
	begin
		if exists(select * from SinhVien where MaSV = @masv)
			print N'Mã sinh viên đã tồn tại. Mã sinh viên không được trùng lặp!'
		else
		begin
			declare @malop nvarchar(10)
			select @malop = MaLop from Lop where TenLop = @tenlop
			insert into SinhVien
			values (@masv, @hoten, @gioitinh, @ngaysinh, @malop)
		end
	end
end
go

-- Trường hợp tên lớp không tồn tại
exec sp_cau_3 'SV06', N'Nguyễn Văn G', '01/06/2004', N'Nam', 'CNTT02'
-- Trường hợp mã sinh viên đã tồn tại
exec sp_cau_3 'SV05', N'Nguyễn Văn G', '01/06/2004', N'Nam', 'QTKD01'
-- Trường hợp thỏa mãn điều kiện
exec sp_cau_3 'SV06', N'Nguyễn Văn G', '01/06/2004', N'Nam', 'QTKD01'
go

select * from SinhVien
go

-- Câu 4. 
create trigger trg_cau_4
on SinhVien
for update
as
begin
	if update(MaLop)
	begin
		declare @malop_moi nvarchar(10), @malop_cu nvarchar(10), @ss_lop_moi int
		select @malop_moi = MaLop from inserted
		select @malop_cu = MaLop from deleted
		select @ss_lop_moi = SiSo from Lop where MaLop = @malop_moi

		if @ss_lop_moi >= 80
		begin
			raiserror(N'Không thể chuyển lớp vì lớp mới đã đủ 80 sinh viên!', 16, 1)
			rollback transaction
		end
		else
		begin
			update Lop set SiSo = SiSo + 1 where MaLop = @malop_moi
			update Lop set SiSo = SiSo - 1 where MaLop = @malop_cu
		end
	end
end
go

-- Trường hợp lớp mới đã đủ 80 sinh viên
update SinhVien set MaLop = 'L02' where MaSV = 'SV01'
-- Trường hợp thỏa mãn mọi điều kiện
update SinhVien set MaLop = 'L03' where MaSV = 'SV01'

select * from SinhVien
select * from Lop
go