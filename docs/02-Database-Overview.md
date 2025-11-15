Bảng: Tài sản
| Tên thuộc tính | Kiểu dữ liệu | Độ dài | Ràng buộc      | Mô tả              |
| -------------- | -----------: | :----: | -------------- | ------------------ |
| maTB           |         char |    4   | PK, Not null   | Mã thiết bị        |
| tenTB          |     nvarchar |   35   | Not null       | Tên thiết bị       |
| tgmua          |         date |    —   | Not null       | Thời gian mua      |
| tgkhauhao      |         date |    —   | Not null       | Thời gian khấu hao |
| loai           |     nvarchar |   25   | Null           | Loại thiết bị      |
| tinhtrang      |     nvarchar |   70   | Not null       | Tình trạng tài sản |
| chiphi         |        money |    —   | Not null       | Chi phí mua        |
| mota           |     nvarchar |   200  | Null           | Mô tả              |
| HDSD           |     nvarchar |   300  | Null           | Hướng dẫn sử dụng  |
| maQR           |        image |    —   | Null           | Mã QR thiết bị     |
| super_maTB     |         char |    4   | FK (self)      | Thiết bị cha       |
| maNV           |         char |    4   | FK → nhan_vien | Nhân viên quản lý  |

Bảng: Dự án
| Thuộc tính  |     Kiểu | Độ dài | Ràng buộc    | Mô tả         |
| ----------- | -------: | :----: | ------------ | ------------- |
| maDA        |     char |    4   | PK, Not null | Mã dự án      |
| tenDA       | nvarchar |   40   | Not null     | Tên dự án     |
| mota        | nvarchar |   200  | Null         | Mô tả         |
| khachhang   | nvarchar |   40   | Null         | Khách hàng    |
| ngaybatdau  |     date |    —   | Not null     | Ngày bắt đầu  |
| ngayketthuc |     date |    —   | Not null     | Ngày kết thúc |

Bảng: Phòng ban
| Thuộc tính |     Kiểu | Độ dài | Ràng buộc | Mô tả         |
| ---------- | -------: | :----: | --------- | ------------- |
| maPB       |     char |    4   | PK        | Mã phòng ban  |
| tenphong   | nvarchar |   30   | Not null  | Tên phòng ban |

Bảng: Nhân viên
| Thuộc tính |     Kiểu | Độ dài | Ràng buộc     | Mô tả           |
| ---------- | -------: | :----: | ------------- | --------------- |
| maNV       |     char |    4   | PK            | Mã nhân viên    |
| ho         | nvarchar |   15   | Not null      | Họ              |
| tendem     | nvarchar |   30   | Null          | Tên đệm         |
| ten        | nvarchar |   15   | Not null      | Tên             |
| diachi     | nvarchar |   100  | Not null      | Địa chỉ         |
| chucvu     | nvarchar |   25   | Not null      | Chức vụ         |
| SDT        |  varchar |   12   | Not null      | Số điện thoại   |
| gioitinh   |     char |    1   | Not null      | Giới tính       |
| ngaysinh   |     date |    —   | Null          | Ngày sinh       |
| luong      |    money |    —   | Not null      | Lương           |
| maPB       |     char |    4   | FK → phongban | Thuộc phòng ban |

Bảng: Tài khoản
| Thuộc tính |    Kiểu | Độ dài | Ràng buộc      | Mô tả         |
| ---------- | ------: | :----: | -------------- | ------------- |
| tenTK      | varchar |   20   | PK             | Tên tài khoản |
| matkhau    | varchar |   20   | Not null       | Mật khẩu      |
| maNV       |    char |    4   | FK → nhan_vien | Mã nhân viên  |

Bảng: Biên bản giao
| Thuộc tính | Kiểu | Độ dài | Ràng buộc          | Mô tả          |
| ---------- | ---: | :----: | ------------------ | -------------- |
| maNV       | char |    4   | PK, FK → nhan_vien | Người nhận     |
| tggiao     | date |    —   | Not null           | Thời gian giao |
| maNVgiao   | char |    4   | FK → nhan_vien     | Người giao     |
| maTB       | char |    4   | PK, FK → tai_san   | Thiết bị giao  |

Bảng: Biên bản trả
| Thuộc tính   |     Kiểu | Độ dài | Ràng buộc          | Mô tả               |
| ------------ | -------: | :----: | ------------------ | ------------------- |
| maNV         |     char |    4   | PK, FK → nhan_vien | Người trả           |
| tgtra        |     date |    —   | Not null           | Thời gian trả       |
| maNVnhan     |     char |    4   | FK → nhan_vien     | Người nhận          |
| tinhtrangtra | nvarchar |   25   | Not null           | Tình trạng thiết bị |
| maTB         |     char |    4   | PK, FK → tai_san   | Thiết bị            |

Bảng: Tham gia dự án
| Thuộc tính |     Kiểu | Độ dài | Ràng buộc          | Mô tả               |
| ---------- | -------: | :----: | ------------------ | ------------------- |
| maDA       |     char |    4   | PK, FK → du_an     | Mã dự án            |
| maNV       |     char |    4   | PK, FK → nhan_vien | Nhân viên tham gia  |
| vaitro     | nvarchar |   25   | Null               | Vai trò trong dự án |