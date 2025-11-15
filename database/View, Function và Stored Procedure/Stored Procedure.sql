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