--VIEW, FUNCTION VÀ STORED PROCEDURE
--1. View
--Tạo khung nhìn các đội trưởng của từng dự án gồm tên dự án, tên đội trưởng
create view doitruongDA as
select da.tenDA as 'Tên dự án', tg.vaitro as 'Vai trò', concat(nv.ho,' ',nv.tendem,' ',nv.ten) as 'Họ và tên'
from tham_gia tg, nhan_vien nv, du_an da where tg.maNV = nv.maNV and tg.maDA = da.maDA  and tg.vaitro like N'Đội trưởng%'
go
--Tạo khung nhìn các TSTB được nhân viên nào quản lý, các thông tin nhân viên quản lý gồm mã nhân viên, tên nhân viên và sđt
create view Quanly_TSTB as
select ts.maTB as 'Mã thiết bị', ts.tenTB as 'Tên thiết bị',nv.maNV as 'Mã nhân viên', concat(nv.ho,' ',nv.tendem,' ',nv.ten) as 'Họ tên', nv.SDT as 'SĐT'
from nhan_vien nv join tai_san ts on nv.maNV =ts.maNV
go
--Tạo khung nhìn các nhân viên tham gia dự án trong tháng 4
create view DSNV_DAthang04 as
select concat(nv.ho,' ',nv.tendem,' ',nv.ten) as 'Tên nhân viên',pb.tenphong as 'Phòng ban', nv.chucvu as 'Chức vụ',nv.SDT as 'SĐT',da.tenDA as 'Tên dự án'
from tham_gia tg join nhan_vien nv on nv.maNV=tg.maNV
left join du_an da on da.maDA=tg.maDA
right join phongban pb on pb.maphong=nv.maphong
where MONTH(da.ngaybatdau) = 4
go
--Tạo khung nhìn các TBTS được sử dụng trong từng dự án
create view DSTBTS_theoDA as
select g.maTB as 'Mã thiết bị',tg.maDA as 'Mã dự án',g.tggiao as 'Thời gian giao'
from tham_gia tg join nhan_vien nv on nv.maNV=tg.maNV
right join bienban_giao g on g.maNV=nv.maNV
go
--Tạo khung nhìn tình trạng các TSTB được trả lại sau khi kết thúc dự án so với trước khi giao.
create view Tinhtrang as
select ts.maTB as 'Mã thiết bị',ts.tenTB as 'Tên thiết bị', ts.tinhtrang as 'Tình trạng ban đầu', tr.tinhtrangtra as 'Tình trạng khi trả',tr.tgtra as 'Thời gian trả'
from tai_san ts join bienban_tra tr on tr.maTB=ts.maTB
go

--2. Function (Hàm)
--Viết function xuất ra trạng thái sử dụng của 1 thiết bị 1 - dùng được, 0 - ko dùng được sau khi được trả 
create function dbo.Trangthaithietbi ( @maTB char (4), @ngaytra date)
returns int
	as
	begin
		declare @kq int;
		select @kq = iif(bb.tinhtrangtra like N'%Bình thường%','1','0')
		from bienban_tra bb
		where bb.maTB like @maTB and try_convert(date,bb.tgtra) = try_convert(date,@ngaytra)
	return @kq;
	end
go
--Viết function kiểm tra số lượng nhân viên từng phòng ban
create function dbo.SoluongNV (@Maphong char (4))
returns int
	as
	BEGIN 
	DECLARE @KQ INT;
	SELECT @KQ = COUNT(NV.maphong)
	FROM nhan_vien NV
	where NV.maphong = @Maphong
	return @KQ;
	END
	go

--3. Stored Procedure (Thủ tục)
--Viết thủ tục khi nhập mã nhân viên thì sẽ hiện họ tên, chức vụ, tên phòng ban và tên dự án mà nhân viên tham gia.
create proc thongtin_nhanvien (@maNV char(4))
as
begin
select concat(n.ho,' ', n.tendem,' ', n.ten) as 'Họ tên nhân viên', n.chucvu as 'Chức vụ', p.tenphong as 'Phòng ban', d.tenDA as 'Dự án đã tham gia'
	from nhan_vien n left join phongban p on n.maphong = p.maphong 
		left join tham_gia t on t.maNV = n.maNV
		left join du_an d on t.maDA = d.maDA
	where n.maNV = @maNV
end
go
exec thongtin_nhanvien @maNV = 'NV27'
go
--Viết thủ tục khi nhập vào thời gian bất kỳ thì sẽ trả về dự án đang thực hiện, số nhân viên tham gia và số thiết bị đã giao cho dự án đó.
create proc thoigian_duan (@thoigian date)
as
begin
select d.maDA as 'Mã dự án', d.tenDA as 'Tên dự án', count(n.maNV) as 'Số nhân viên tham gia', count(b.maTB) as 'Số thiết bị đã giao'
	from du_an d join tham_gia t on d.maDA = t.maDA
		left join nhan_vien n on t.maNV = n.maNV
		left join bienban_giao b on n.maNV = b.maNV and tggiao between ngaybatdau and ngayketthuc
	where @thoigian between ngaybatdau and ngayketthuc
	group by d.maDA, d.tenDA
end
go
exec thoigian_duan @thoigian = '2021-12-19'
go
--Viết thủ tục thay đổi mật khẩu tài khoản của nhân viên.
create proc thaydoi_matkhau (@tenTK varchar(20), @matkhau varchar(20), @matkhau_moi varchar(20))
as
begin
if exists (select * from tai_khoan where tenTK = @tenTK and matkhau = @matkhau)
	begin
update tai_khoan set matkhau = @matkhau_moi where tenTK = @tenTK
select * from tai_khoan where tenTK = @tenTK and matkhau = @matkhau_moi
	end
end
go
exec thaydoi_matkhau @tenTK = 'Noname345', @matkhau = '12c3g45i6', @matkhau_moi = 'buonquadi12'
go
--Viết thủ tục thể hiện thời gian khấu hao còn lại của các thiết bị trong một dự án sắp xếp theo thứ tự tăng dần (a) hoặc giảm dần (d) của thời gian khấu hao còn lại theo năm.
create proc khauhao_trongduan (@maDA varchar(20), @thutu char(1))
as
begin
	if @thutu = 'a'
	begin
select ts.maTB, ts.tenTB, if(datediff(year, getdate(), tgkhauhao) < 0 as 'Số năm còn lại'
		from du_an d left join tham_gia t on d.maDA = t.maDA
			join nhan_vien n on t.maNV = n.maNV
			join bienban_giao b on n.maNV = b.maNV and tggiao between ngaybatdau and ngayketthuc
			join tai_san ts on ts.maTB = b.maTB
		where d.maDA = @maDA
		order by datediff(year, getdate(), tgkhauhao) asc
	end
	else
		if @thutu = 'd'
		begin
select ts.maTB, ts.tenTB, datediff(year, getdate(), tgkhauhao) as 'Số năm còn lại'
			from du_an d left join tham_gia t on d.maDA = t.maDA
				join nhan_vien n on t.maNV = n.maNV
				join bienban_giao b on n.maNV = b.maNV and tggiao between ngaybatdau and ngayketthuc
				join tai_san ts on ts.maTB = b.maTB
			where d.maDA = @maDA
			order by datediff(year, getdate(), tgkhauhao) desc
		end
end
go
exec khauhao_trongduan @maDA = 'DA04', @thutu = 'd'
go