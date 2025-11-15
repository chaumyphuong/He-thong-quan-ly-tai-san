-- Tạo cơ sở dữ liệu Asset Management System
create database AMS
go

-- Chuyển vùng làm việc sang database AMS
use AMS
go
-- Lưu thông tin thiết bị/tài sản và nhân viên phụ trách quản lý
create table tai_san
(
	maTB char(4) primary key not null,         -- Mã thiết bị
	tenTB nvarchar(35) not null,               -- Tên thiết bị
	tgmua date not null,                       -- Thời gian mua
	tgkhauhao date not null,                   -- Thời gian khấu hao
	loai nvarchar(25) null,                    -- Loại tài sản
	tinhtrang nvarchar(70) not null,           -- Tình trạng ban đầu
	chiphi money not null,                     -- Giá trị tài sản
	mota nvarchar(200),                        -- Mô tả thêm
	HDSD nvarchar(300),                        -- Hướng dẫn sử dụng
	maQR image,                                -- Mã QR
	super_maTB char(4),                        -- Thiết bị cha (nếu là bộ phận cấu thành)
	maNV char(4) not null                      -- Nhân viên quản lý thiết bị
)
-- Thông tin các dự án IT
create table du_an
(
	maDA char(4) primary key,
	tenDA nvarchar(70) not null,
	mota nvarchar(200),
	khachhang nvarchar(40),                    -- Khách hàng
	ngaybatdau date not null,
	ngayketthuc date not null
)
-- Bộ phận quản lý nhân sự & tài sản
create table phongban
(
	maphong char(4) primary key not null,
	tenphong nvarchar (30) not null
)
-- Danh sách nhân viên trong tổ chức
create table nhan_vien
(
	maNV char (4) primary key,
	ho nvarchar (15) not null,
	tendem nvarchar (30) not null,
	ten nvarchar (15) not null,
	diachi nvarchar (100) not null,
	chucvu nvarchar (25) not null,             -- Chức vụ
	SDT varchar (12) not null,
	gioitinh char (1) not null,
	ngaysinh date,
	luong money not null,
	maphong char (4) not null
)
-- Thông tin đăng nhập của nhân viên
create table tai_khoan
(
	tenTK varchar(20) not null,
	matkhau varchar(20) not null,
	maNV char(4) not null
)
-- Ghi nhận việc giao tài sản cho nhân viên sử dụng
create table bienban_giao
(
	maNV char(4) not null,      -- Người nhận thiết bị
	tggiao date not null,       -- Thời gian giao
	maNVgiao char(4) not null,  -- Người phụ trách giao
	maTB char(4) not null       -- Thiết bị được giao
)
-- Ghi nhận việc trả thiết bị và tình trạng sau khi sử dụng
create table bienban_tra
(
	maNV char (4) not null,     -- Người trả thiết bị
	tgtra date not null,        -- Thời gian trả
	maNVnhan char(4) not null,  -- Người nhận lại
	tinhtrangtra nvarchar (25) not null, -- Tình trạng khi trả
	maTB char(4) not null
)
-- Liên kết nhân viên với dự án + vai trò tham gia
create table tham_gia
(
	maDA char(4) not null,
	maNV char(4) not null,
	vaitro nvarchar(25) null, -- Vai trò trong dự án
	constraint pk_mada_manv primary key(maDA, maNV)
)

--Quan hệ giữa các bảng (Foreign Keys)
-- Mỗi nhân viên thuộc một phòng ban
alter table nhan_vien
add constraint fk_nv_maphong foreign key (maphong) references phongban (maphong)
go
-- Mỗi tài khoản liên kết 1 nhân viên
alter table tai_khoan
add constraint fk_tk_manv foreign key (maNV) references nhan_vien (maNV)
go
-- Nhân viên tham gia dự án
alter table tham_gia
add constraint fk_tg_mada foreign key (maDA) references du_an (maDA),
constraint fk_tg_manv foreign key (maNV) references nhan_vien (maNV)
go
