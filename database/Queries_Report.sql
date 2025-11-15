--Liệt kê tên thiết bị, phòng ban và các nhân viên nhận thiết bị.
--Nếu nhân viên chưa nhận thiết bị nào thì số thiết bị = 0
Select nv.maNV as 'Mã nhân viên',concat(nv.ho,' ',nv.tendem,' ' ,nv.ten) as 'Họ tên nhân viên', k.[Tên thiết bị] as 'Tên thiết bị',
pb.tenphong as 'Tên phòng', isnull(k.num,0) 
from nhan_vien nv left join phongban pb on nv.maphong = pb.maphong
left join (Select g.maNV,ts.tenTB as 'Tên thiết bị', count(g.maTB) as num from bienban_giao g left join tai_san ts on
ts.maTB = g.maTB group by g.maNV,ts.tenTB) as k on NV.maNV = k.maNV
go
--Liệt kê tên, chi phí và tình trạng các thiết bị bị mất mát
Select ts.tenTB as 'Tên thiết bị', ts.chiphi as 'Chi phí', tr.tinhtrangtra as 'Tình trạng trả'
from tai_san ts join bienban_tra tr on ts.maTB = tr.maTB
where tr.tinhtrangtra =N'Mất mát'
go
--Liệt kê các nhân viên nữ có mức lương cao hơn mức lương trung bình của toàn nhân viên và sắp xếp theo tên từ A-Z
Select * from nhan_vien where luong > 
((Select sum(luong) from nhan_vien)/(Select count(*) from nhan_vien)) and gioitinh = 'F'
order by ten asc
go
--Liệt kê danh sách nhân viên: mã nhân viên, tên nhân viên, chức vụ. Nếu nhân viên chưa tham gia dự án nào thì để số dự án = 0.
Select nv.maNV as 'Mã nhân viên',concat(nv.ho,' ',nv.tendem,' ' ,nv.ten) as 'Họ tên nhân viên', nv.chucvu as 'Chức vụ', 
isnull(N.num,0) from nhan_vien nv left join
(Select maNV, COUNT(t.maDA) as num from tham_gia t group by maNV) as n on nv.maNV = n.maNV
Go
--Liệt kê lương thấp nhất, cao nhất của mỗi phòng ban
Select min(nv.luong) as 'Lương thấp nhất', max(nv.luong) as 'Lương cao nhất', pb.tenphong as 'Tên phòng ban'
from phongban pb join nhan_vien nv 
on nv.maphong = pb.maphong
group by tenphong
go