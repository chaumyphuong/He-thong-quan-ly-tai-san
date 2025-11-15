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
