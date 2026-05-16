-- SQL schema for BTL_SPMeVaBe (MariaDB)

CREATE TABLE IF NOT EXISTS DanhMuc (
  id INT AUTO_INCREMENT PRIMARY KEY,
  tenDanhMuc VARCHAR(255) NOT NULL,
  moTa TEXT
);

CREATE TABLE IF NOT EXISTS SanPham (
  MaSanPham INT AUTO_INCREMENT PRIMARY KEY,
  TenSanPham VARCHAR(255) NOT NULL,
  ThongTinSanPham TEXT,
  hinhAnh VARCHAR(1024),
  thanhPhan TEXT,
  xuatXu VARCHAR(255),
  khoiLuong VARCHAR(255),
  GiaTien DECIMAL(10,2) DEFAULT 0,
  SoLuong INT DEFAULT 0,
  danhMucId INT,
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  is_deleted TINYINT(1) DEFAULT 0,
  FOREIGN KEY (danhMucId) REFERENCES DanhMuc(id)
);

-- Table NguoiDung (Base table for Users)
CREATE TABLE IF NOT EXISTS NguoiDung (
  id INT AUTO_INCREMENT PRIMARY KEY,
  hoTen VARCHAR(255),
  email VARCHAR(255) UNIQUE,
  dienThoai VARCHAR(50),
  tenDangNhap VARCHAR(255) UNIQUE NOT NULL,
  matKhau VARCHAR(255) NOT NULL,
  role VARCHAR(50) DEFAULT 'CUSTOMER',
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  status VARCHAR(50) DEFAULT 'ACTIVE',
  is_deleted TINYINT(1) DEFAULT 0
);

-- Table KhachHang (Inherits NguoiDung)
CREATE TABLE IF NOT EXISTS KhachHang (
  id INT PRIMARY KEY,
  diemTichLuy INT DEFAULT 0,
  FOREIGN KEY (id) REFERENCES NguoiDung(id) ON DELETE CASCADE
);

-- Table NhanVien (Inherits NguoiDung)
CREATE TABLE IF NOT EXISTS NhanVien (
  id INT PRIMARY KEY,
  maNhanVien VARCHAR(50) UNIQUE,
  chucVu VARCHAR(255),
  FOREIGN KEY (id) REFERENCES NguoiDung(id) ON DELETE CASCADE
);

-- Table DonHang
CREATE TABLE IF NOT EXISTS DonHang (
    id INT AUTO_INCREMENT PRIMARY KEY,
    khachHangId INT NOT NULL,
    ngayDat TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    tongTien DOUBLE NOT NULL,
    trangThai VARCHAR(50) DEFAULT 'PENDING',
    tenNguoiNhan VARCHAR(255),
    sdtNhanHang VARCHAR(50),
    diaChiGiaoHang VARCHAR(255),
    ghiChu TEXT,
    is_deleted TINYINT(1) DEFAULT 0,
    FOREIGN KEY (khachHangId) REFERENCES KhachHang(id)
);

-- Table DiaChiNhanHang
CREATE TABLE IF NOT EXISTS DiaChiNhanHang (
    id INT AUTO_INCREMENT PRIMARY KEY,
    khachHangId INT NOT NULL,
    tenNguoiNhan VARCHAR(255) NOT NULL,
    soDienThoai VARCHAR(50) NOT NULL,
    diaChi VARCHAR(255) NOT NULL,
    is_default TINYINT(1) DEFAULT 0,
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (khachHangId) REFERENCES KhachHang(id) ON DELETE CASCADE
);

-- Table ChiTietDonHang
CREATE TABLE IF NOT EXISTS ChiTietDonHang (
    id INT AUTO_INCREMENT PRIMARY KEY,
    donHangId INT NOT NULL,
    sanPhamId INT NOT NULL,
    soLuong INT NOT NULL,
    donGia DOUBLE NOT NULL,
    FOREIGN KEY (donHangId) REFERENCES DonHang(id) ON DELETE CASCADE,
    FOREIGN KEY (sanPhamId) REFERENCES SanPham(MaSanPham)
);

-- Table DanhGia (Reviews)
CREATE TABLE IF NOT EXISTS DanhGia (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sanPhamId INT NOT NULL,
    khachHangId INT,
    hoTen VARCHAR(255),
    diemDanhGia INT NOT NULL CHECK (diemDanhGia BETWEEN 1 AND 5),
    binhLuan TEXT,
    anDanh TINYINT(1) DEFAULT 0,
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sanPhamId) REFERENCES SanPham(MaSanPham) ON DELETE CASCADE,
    FOREIGN KEY (khachHangId) REFERENCES KhachHang(id) ON DELETE SET NULL
);

-- Dữ liệu mẫu
INSERT INTO NguoiDung (hoTen, email, dienThoai, tenDangNhap, matKhau, role) VALUES 
('Nguyễn Văn Khách', 'khach@gmail.com', '0987654321', 'khachhang', '123456', 'CUSTOMER'),
('Trần Thị Quản Trị', 'admin@gmail.com', '0909090909', 'admin', 'admin', 'ADMIN');

INSERT INTO KhachHang (id, diemTichLuy) VALUES (1, 0);
INSERT INTO NhanVien (id, maNhanVien, chucVu) VALUES (2, 'NV001', 'Quản lý');

INSERT INTO DanhMuc (id, tenDanhMuc, moTa) VALUES
(1, 'Mẹ bầu và sau sinh', 'Sản phẩm dành cho mẹ bầu và sau sinh'),
(2, 'Sữa cho bé', 'Các loại sữa bột, sữa tươi cho bé'),
(3, 'Bé ăn dặm', 'Thực phẩm và đồ dùng ăn dặm cho bé'),
(4, 'Bỉm tã và vệ sinh', 'Bỉm, tã và các sản phẩm vệ sinh'),
(5, 'Bình sữa và phụ kiện', 'Bình sữa, núm ti và phụ kiện đi kèm'),
(6, 'Đồ sơ sinh', 'Quần áo và đồ dùng cho trẻ sơ sinh'),
(7, 'Thời trang và phụ kiện', 'Thời trang và phụ kiện cho bé'),
(8, 'Vitamin và sức khỏe', 'Vitamin và thực phẩm chức năng'),
(9, 'Đồ dùng mẹ và bé', 'Các đồ dùng tiện ích cho mẹ và bé'),
(10, 'Giặt xả và Tắm gội', 'Sản phẩm tắm gội, giặt xả an toàn'),
(11, 'Đồ chơi và Học tập', 'Đồ chơi giáo dục và đồ dùng học tập');

INSERT INTO SanPham (TenSanPham, ThongTinSanPham, GiaTien, SoLuong, danhMucId) VALUES 
-- 1. Mẹ bầu và sau sinh
('Sữa bầu Morinaga', 'Sữa bầu Morinaga vị trà sữa', 250000, 50, 1),
('Gối bầu chữ U', 'Gối ôm chữ U giảm đau lưng cho bà bầu', 350000, 30, 1),
('Tai nghe bà bầu', 'Tai nghe chuyên dụng cho thai nhi', 450000, 20, 1),
('Kem chống rạn da', 'Kem chống rạn da bụng, đùi', 320000, 40, 1),
('Quần lót bầu', 'Quần lót cạp chéo thoải mái cho mẹ bầu', 80000, 100, 1),

-- 2. Sữa cho bé
('Sữa Meiji số 0', 'Sữa Meiji Nhật Bản cho trẻ 0-1 tuổi', 520000, 60, 2),
('Sữa Nan Optipro 1', 'Sữa Nan cho trẻ sơ sinh', 380000, 50, 2),
('Sữa Pediasure BA', 'Sữa cho trẻ biếng ăn, nhẹ cân', 650000, 40, 2),
('Sữa Aptamil Úc số 2', 'Sữa Aptamil phát triển trí não', 850000, 30, 2),
('Sữa non ColosBaby', 'Sữa non tăng cường miễn dịch', 480000, 45, 2),

-- 3. Bé ăn dặm
('Bột ăn dặm Heinz', 'Bột ăn dặm vị rau củ', 120000, 80, 3),
('Bánh ăn dặm Gerber', 'Bánh tan hình sao cho bé', 90000, 100, 3),
('Ghế ăn dặm Hanbei', 'Ghế ăn dặm điều chỉnh độ cao', 450000, 20, 3),
('Bộ bát thìa lúa mạch', 'Bộ bát thìa ăn dặm an toàn', 150000, 50, 3),
('Nồi nấu cháo chậm', 'Nồi nấu cháo chậm Bear 0.8L', 380000, 15, 3),

-- 4. Bỉm tã và vệ sinh
('Bỉm Merries tã dán M', 'Bỉm Merries nội địa Nhật', 380000, 60, 4),
('Bỉm Moony tã quần L', 'Bỉm Moony siêu thấm hút', 320000, 70, 4),
('Khăn ướt Bobby', 'Khăn ướt không mùi an toàn', 35000, 200, 4),
('Nước muối sinh lý', 'Nước muối sinh lý vệ sinh mắt mũi', 5000, 500, 4),
('Kem hăm Sudocrem', 'Kem chống hăm tã Sudocrem 60g', 110000, 80, 4),

-- 5. Bình sữa và phụ kiện
('Bình sữa Pigeon 160ml', 'Bình sữa cổ rộng PPSU', 320000, 50, 5),
('Máy hâm sữa Fatz', 'Máy hâm sữa và thức ăn Fatzbaby', 280000, 30, 5),
('Máy tiệt trùng UV', 'Máy tiệt trùng sấy khô UV Moaz', 1500000, 10, 5),
('Núm ty Moyuum', 'Núm ty silicone siêu mềm', 95000, 100, 5),
('Cọ rửa bình sữa', 'Cọ rửa bình sữa silicon 3 chi tiết', 65000, 120, 5),

-- 6. Đồ sơ sinh
('Bộ quần áo sơ sinh', 'Bộ cotton thun lạnh Nous', 120000, 80, 6),
('Khăn tắm xô 6 lớp', 'Khăn xô tắm siêu thấm hút', 85000, 100, 6),
('Bao tay bao chân', 'Set bao tay chân chống trầy xước', 25000, 150, 6),
('Mũ thóp sơ sinh', 'Mũ che thóp chất cotton', 30000, 100, 6),
('Tấm lót chống thấm', 'Tấm lót thay bỉm chống thấm', 60000, 90, 6),

-- 7. Thời trang và phụ kiện
('Váy công chúa', 'Váy dự tiệc cho bé gái', 250000, 30, 7),
('Bộ đồ bơi trẻ em', 'Đồ bơi hình thú ngộ nghĩnh', 150000, 40, 7),
('Giày tập đi', 'Giày chống trượt siêu nhẹ', 120000, 50, 7),
('Mũ cói rộng vành', 'Mũ đi biển mùa hè cho bé', 80000, 60, 7),
('Kính mát trẻ em', 'Kính mát chống tia UV', 90000, 70, 7),

-- 8. Vitamin và sức khỏe
('Vitamin D3 K2 MK7', 'Vitamin D3 K2 Lineabon', 295000, 50, 8),
('DHA Nature Way', 'DHA giọt cho bé phát triển não bộ', 350000, 40, 8),
('Men vi sinh Biogaia', 'Men vi sinh dạng giọt', 415000, 30, 8),
('Siro ho Prospan', 'Siro ho chiết xuất lá thường xuân', 180000, 60, 8),
('Kẽm Bio Island', 'Kẽm bổ sung cho bé', 250000, 45, 8),

-- 9. Đồ dùng mẹ và bé
('Địu em bé', 'Địu 4 tư thế siêu nhẹ', 350000, 20, 9),
('Xe đẩy gấp gọn', 'Xe đẩy du lịch gấp siêu gọn', 950000, 15, 9),
('Túi bỉm sữa', 'Túi xách đựng đồ bỉm sữa đa năng', 180000, 40, 9),
('Máy hút sữa điện đôi', 'Máy hút sữa rảnh tay Spectra', 2500000, 5, 9),
('Nhiệt kế hồng ngoại', 'Nhiệt kế đo trán Microlife', 650000, 25, 9),

-- 10. Giặt xả và Tắm gội
('Nước giặt Dnee', 'Nước giặt xả cho bé Dnee 3L', 165000, 100, 10),
('Sữa tắm gội Cetaphil', 'Sữa tắm gội toàn thân Cetaphil', 220000, 50, 10),
('Dầu tràm trà', 'Dầu tràm phòng cảm lạnh', 90000, 80, 10),
('Nước xả vải Comfort', 'Nước xả cho da nhạy cảm', 85000, 60, 10),
('Kem dưỡng ẩm', 'Kem nẻ dưỡng da Dexeryl', 150000, 40, 10),

-- 11. Đồ chơi và Học tập
('Xếp hình Lego', 'Bộ xếp hình Lego Duplo', 450000, 20, 11),
('Truyện tranh Ehon', 'Bộ sách Ehon phát triển EQ', 120000, 50, 11),
('Đàn piano đồ chơi', 'Đàn piano mini có nhạc', 250000, 30, 11),
('Bảng vẽ tự xóa', 'Bảng LCD vẽ tự xóa', 90000, 60, 11),
('Bộ học chữ số', 'Thẻ flashcard số và chữ', 85000, 70, 11);

UPDATE SanPham SET hinhAnh = 'https://dummyimage.com/300x300/e0e0e0/000000.png&text=SP1' WHERE MaSanPham = 1;
UPDATE SanPham SET hinhAnh = 'https://dummyimage.com/300x300/e0e0e0/000000.png&text=SP2' WHERE MaSanPham = 2;
UPDATE SanPham SET hinhAnh = 'https://dummyimage.com/300x300/e0e0e0/000000.png&text=SP3' WHERE MaSanPham = 3;
UPDATE SanPham SET hinhAnh = 'https://dummyimage.com/300x300/e0e0e0/000000.png&text=SP4' WHERE MaSanPham = 4;
UPDATE SanPham SET hinhAnh = 'https://dummyimage.com/300x300/e0e0e0/000000.png&text=SP5' WHERE MaSanPham = 5;

INSERT INTO DonHang (khachHangId, tongTien, trangThai, diaChiGiaoHang) VALUES 
(1, 600000, 'PENDING', 'Số 1, Đường 2, Phường 3, Quận 4');

INSERT INTO ChiTietDonHang (donHangId, sanPhamId, soLuong, donGia) VALUES 
(1, 1, 1, 250000),
(1, 2, 1, 350000);

-- Update sample data for SanPham details
UPDATE SanPham SET thanhPhan = 'Sữa bột, DHA, ARA, Vitamin D3, Kẽm...', xuatXu = 'Nhật Bản', khoiLuong = '800g' WHERE MaSanPham = 1;
UPDATE SanPham SET thanhPhan = 'Vải cotton 100%', xuatXu = 'Việt Nam', khoiLuong = '500g' WHERE MaSanPham = 2;

-- Sample Reviews
INSERT INTO DanhGia (sanPhamId, khachHangId, hoTen, diemDanhGia, binhLuan, anDanh) VALUES 
(1, 1, 'Nguyễn Văn Khách', 5, 'Sữa rất thơm, dễ uống, mẹ bầu không bị nghén.', 0),
(1, NULL, 'Trần Thị Bích', 4, 'Giá hơi cao nhưng chất lượng tốt.', 0),
(1, 1, 'Nguyễn Văn Khách', 5, 'Giao hàng nhanh, đóng gói cẩn thận', 1),
(2, NULL, 'Lê Văn C', 5, 'Gối ôm rất êm, ngủ ngon hơn hẳn.', 0);

-- Table for back-in-stock subscriptions
CREATE TABLE IF NOT EXISTS BackInStockSubscription (
  id INT AUTO_INCREMENT PRIMARY KEY,
  productId INT NOT NULL,
  email VARCHAR(255) NOT NULL,
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (productId) REFERENCES SanPham(MaSanPham) ON DELETE CASCADE
);
