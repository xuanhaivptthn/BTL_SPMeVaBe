-- SQL schema for BTL_SPMeVaBe (MariaDB)

CREATE TABLE IF NOT EXISTS SanPham (
  MaSanPham INT AUTO_INCREMENT PRIMARY KEY,
  TenSanPham VARCHAR(255) NOT NULL,
  ThongTinSanPham TEXT,
  GiaTien DECIMAL(10,2) DEFAULT 0,
  SoLuong INT DEFAULT 0,
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  is_deleted TINYINT(1) DEFAULT 0
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

CREATE TABLE IF NOT EXISTS AnhSanPham (
  id INT AUTO_INCREMENT PRIMARY KEY,
  product_MaSanPham INT NOT NULL,
  url VARCHAR(1024) NOT NULL,
  altText VARCHAR(255),
  sortOrder INT DEFAULT 0,
  createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (product_MaSanPham) REFERENCES SanPham(MaSanPham) ON DELETE CASCADE
);

-- Table DonHang
CREATE TABLE IF NOT EXISTS DonHang (
    id INT AUTO_INCREMENT PRIMARY KEY,
    khachHangId INT NOT NULL,
    ngayDat TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    tongTien DOUBLE NOT NULL,
    trangThai VARCHAR(50) DEFAULT 'PENDING',
    diaChiGiaoHang VARCHAR(255),
    ghiChu TEXT,
    is_deleted TINYINT(1) DEFAULT 0,
    FOREIGN KEY (khachHangId) REFERENCES KhachHang(id)
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

-- Dữ liệu mẫu
INSERT INTO NguoiDung (hoTen, email, dienThoai, tenDangNhap, matKhau, role) VALUES 
('Nguyễn Văn Khách', 'khach@gmail.com', '0987654321', 'khachhang', '123456', 'CUSTOMER'),
('Trần Thị Quản Trị', 'admin@gmail.com', '0909090909', 'admin', 'admin', 'ADMIN');

INSERT INTO KhachHang (id, diemTichLuy) VALUES (1, 0);
INSERT INTO NhanVien (id, maNhanVien, chucVu) VALUES (2, 'NV001', 'Quản lý');

INSERT INTO SanPham (TenSanPham, ThongTinSanPham, GiaTien, SoLuong) VALUES 
('Sữa Bột Dielac Alpha Gold', 'Sữa bột công thức dành cho trẻ từ 0-6 tháng tuổi.', 350000, 100),
('Bỉm Merries size M', 'Tã dán cao cấp Nhật Bản, siêu mềm mại.', 420000, 50),
('Bình sữa Pigeon Cổ rộng 160ml', 'Bình sữa nhựa PPSU an toàn.', 250000, 200),
('Nôi em bé tự động', 'Nôi điện thiết kế an toàn, có nhạc.', 1500000, 10);

INSERT INTO AnhSanPham (product_MaSanPham, url, sortOrder) VALUES 
(1, 'https://dummyimage.com/300x300/e0e0e0/000000.png&text=Sữa+Dielac', 0),
(2, 'https://dummyimage.com/300x300/e0e0e0/000000.png&text=Bỉm+Merries', 0),
(3, 'https://dummyimage.com/300x300/e0e0e0/000000.png&text=Bình+sữa+Pigeon', 0),
(4, 'https://dummyimage.com/300x300/e0e0e0/000000.png&text=Nôi+điện', 0);

INSERT INTO DonHang (khachHangId, tongTien, trangThai, diaChiGiaoHang) VALUES 
(1, 770000, 'PENDING', 'Số 1, Đường 2, Phường 3, Quận 4');

INSERT INTO ChiTietDonHang (donHangId, sanPhamId, soLuong, donGia) VALUES 
(1, 1, 1, 350000),
(1, 2, 1, 420000);
