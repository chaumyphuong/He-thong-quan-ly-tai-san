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