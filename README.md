# SPMeVaBe — Hệ thống bán hàng mẹ và bé

> **Bài tập lớn** — Ứng dụng web thương mại điện tử chuyên về sản phẩm mẹ và bé, xây dựng bằng Jakarta EE (Servlet + JSP) và MySQL/MariaDB.

---

## Mục lục

- [Tính năng](#tính-năng)
- [Kiến trúc & Công nghệ](#kiến-trúc--công-nghệ)
- [Cấu trúc dự án](#cấu-trúc-dự-án)
- [Cơ sở dữ liệu](#cơ-sở-dữ-liệu)
- [Hệ thống xác thực](#hệ-thống-xác-thực)
- [Phân quyền](#phân-quyền)
- [Cài đặt & Chạy](#cài-đặt--chạy)
- [Tài khoản mặc định](#tài-khoản-mặc-định)

---

## Tính năng

### Khách hàng
| Tính năng | Mô tả |
|-----------|-------|
| Duyệt sản phẩm | Xem theo danh mục, tìm kiếm, lọc |
| Chi tiết sản phẩm | Hình ảnh, mô tả, thành phần, đánh giá |
| Giỏ hàng | Thêm, cập nhật, xóa sản phẩm |
| Thanh toán | Chọn địa chỉ, mã giảm giá, COD/chuyển khoản |
| Lịch sử đơn hàng | Xem, in hóa đơn, hủy đơn hàng |
| Đánh giá | Đánh giá sản phẩm kèm hình ảnh, ẩn danh |
| Hồ sơ | Cập nhật thông tin, đổi mật khẩu |
| Quên mật khẩu | Reset qua OTP gửi email |
| Điểm tích lũy | Tích điểm từ đơn hàng đã giao |

### Quản trị (ADMIN)
| Tính năng | Mô tả |
|-----------|-------|
| Dashboard | Tổng quan đơn hàng, doanh thu |
| Quản lý sản phẩm | Thêm, sửa, xóa, upload hình ảnh |
| Quản lý đơn hàng | Xem chi tiết, cập nhật trạng thái, in hóa đơn |
| Quản lý người dùng | Thêm, sửa, khóa tài khoản, phân quyền |

### Nhân viên (STAFF)
| Tính năng | Mô tả |
|-----------|-------|
| Quản lý sản phẩm | Thêm, sửa, xóa sản phẩm |
| Quản lý đơn hàng | Xem và cập nhật trạng thái đơn hàng |
| Không thể | Quản lý tài khoản người dùng |

---

## Kiến trúc & Công nghệ

```
+--------------------------------------------------+
|                    Browser                       |
|          JWT (HttpOnly cookie 30 ngày)           |
+----------------------+---------------------------+
                       |
+----------------------v---------------------------+
|              Jakarta EE Web App                  |
|                                                  |
|  AuthFilter (/*)                                 |
|   -- Xác thực JWT -> inject jwtClaims            |
|                                                  |
|  AdminFilter (/admin/*)                          |
|   -- Kiểm tra role ADMIN/STAFF                   |
|   -- Block STAFF khỏi /admin/users               |
|                                                  |
|  Servlets (Controller)                           |
|   -- Đọc jwtClaims từ request attribute          |
|                                                  |
|  JSP (View)                                      |
|   -- JSTL + Custom CSS                           |
+----------------------+---------------------------+
                       |
+----------------------v---------------------------+
|           DAO Layer (JDBC)                       |
|   NguoiDungDAO . SanPhamDAO . DonHangDAO         |
|   KhachHangDAO . DanhGiaDAO . MaGiamGiaDAO ...   |
+----------------------+---------------------------+
                       |
+----------------------v---------------------------+
|           MySQL / MariaDB                        |
|           Database: BTL_SPMeVaBe                 |
+--------------------------------------------------+
```

### Stack
| Thành phần | Công nghệ |
|-----------|----------|
| Backend | Jakarta EE 10, Servlet 6, JSP 3 |
| Frontend | JSP, JSTL 2.0, Vanilla CSS |
| Database | MySQL 8 / MariaDB |
| JDBC Driver | `mysql-connector-j-8.3.0` |
| Auth | JJWT 0.12.6 (HS256 JWT), jBCrypt 0.4 |
| Email | Jakarta Mail 2.0 |
| Build | Apache Ant (NetBeans) |
| Server | Apache Tomcat 10+ |

---

## Cấu trúc dự án

```
BTL_SPMeVaBe/
├── conf/
│   └── create_tables.sql        # DDL + Seed data
├── lib/                         # Compile-time JARs
│   ├── mysql-connector-j-8.3.0.jar
│   ├── jjwt-api/impl/jackson-0.12.6.jar
│   ├── jbcrypt-0.4.jar
│   ├── jackson-*.jar
│   └── jakarta.mail-2.0.1.jar
├── src/java/
│   ├── controller/
│   │   ├── auth/                # Login, Logout, Register, ForgotPWD, VerifyOTP, ResetPWD
│   │   ├── admin/               # Admin_QLSanPham, Admin_QLDonHang, Admin_QLNguoiDung
│   │   ├── GioHangServlet.java
│   │   ├── ThanhToanServlet.java
│   │   ├── LichSuMuaHangServlet.java
│   │   ├── ProfileServlet.java
│   │   └── ReviewServlet.java
│   ├── dao/
│   │   ├── DBConnect.java
│   │   ├── NguoiDungDAO.java    # BCrypt login, CRUD, password migration
│   │   ├── KhachHangDAO.java
│   │   ├── SanPhamDAO.java
│   │   ├── DonHangDAO.java
│   │   ├── DanhGiaDAO.java
│   │   └── MaGiamGiaDAO.java
│   ├── filter/
│   │   ├── AuthFilter.java      # /* — JWT validation
│   │   ├── AdminFilter.java     # /admin/* — role enforcement
│   │   └── NoCacheFilter.java
│   ├── model/
│   │   ├── NguoiDung.java
│   │   ├── KhachHang.java       # extends NguoiDung
│   │   ├── NhanVien.java        # extends NguoiDung
│   │   ├── Role.java            # Enum: CUSTOMER | STAFF | ADMIN
│   │   ├── SanPham.java
│   │   ├── DonHang.java
│   │   ├── ChiTietDonHang.java
│   │   ├── DanhGia.java
│   │   ├── MaGiamGia.java
│   │   └── DiaChiNhanHang.java
│   └── utils/
│       ├── JwtUtil.java         # JWT generate / validate / cookie builders
│       ├── PasswordUtil.java    # BCrypt hash / verify
│       └── EmailUtility.java    # SMTP email sender
└── web/
    ├── admin/                   # Admin JSPs
    ├── css/ js/                 # Static assets
    ├── uploads/                 # User-uploaded images
    ├── index.jsp
    ├── login.jsp / register.jsp
    ├── products.jsp / product-detail.jsp
    ├── cart.jsp / checkout.jsp
    ├── history.jsp / order_detail.jsp
    └── profile.jsp
```

---

## Cơ sở dữ liệu

**Tên DB:** `BTL_SPMeVaBe`  
**Script:** [`conf/create_tables.sql`](conf/create_tables.sql)

### Sơ đồ quan hệ

```
DanhMuc --< SanPham
                 |--< ChiTietDonHang >--|
                                        |
NguoiDung --< KhachHang --< DonHang ---+
          |--< NhanVien        |--< DiaChiNhanHang
                               |--> MaGiamGia
SanPham --< DanhGia >-- KhachHang
```

### Bảng chính

| Bảng | Mô tả |
|------|-------|
| `NguoiDung` | Tài khoản người dùng (base entity) |
| `KhachHang` | Thông tin khách hàng (điểm tích lũy) |
| `NhanVien` | Thông tin nhân viên |
| `SanPham` | Sản phẩm (giá `DECIMAL(15,2)`) |
| `DanhMuc` | Danh mục sản phẩm |
| `DonHang` | Đơn hàng |
| `ChiTietDonHang` | Chi tiết đơn hàng |
| `DanhGia` | Đánh giá sản phẩm |
| `MaGiamGia` | Mã giảm giá |
| `DiaChiNhanHang` | Địa chỉ nhận hàng |

---

## Hệ thống xác thực

### JWT (JSON Web Token)

- Token ký bằng **HS256**, hết hạn sau **30 ngày**
- Lưu trong cookie **HttpOnly, SameSite=Strict** tên `auth_token`
- Claims: `sub` (userId), `role`, `usr` (username), `nam` (display name)
- Không dùng HTTP Session để xác thực — hoàn toàn **stateless**

### Luồng đăng nhập

```
POST /login
  -> NguoiDungDAO.checkLogin()   # BCrypt.verify(rawPwd, storedHash)
  -> JwtUtil.generateToken(user)
  -> Set-Cookie: auth_token=<jwt>; HttpOnly; SameSite=Strict
  -> Redirect theo role
```

### BCrypt Password Hashing

- Work factor: **12**
- Tất cả mật khẩu lưu dưới dạng BCrypt hash (`$2a$12$...`)
- Seed data trong SQL đã được hash sẵn

---

## Phân quyền

### Luồng kiểm tra quyền

```
Request
  |
  v
AuthFilter (/*)
  Parse JWT cookie -> đặt jwtClaims vào request attribute
  |
  |-- [/admin/*] AdminFilter
  |     ADMIN/STAFF  -> cho qua
  |     STAFF + /admin/users -> 403 Forbidden
  |     Không token  -> redirect /login
  |
  +-- [Servlets] kiểm tra jwtClaims trực tiếp
        null -> redirect /login hoặc 403
```

### Ma trận phân quyền

| Trang / Chức năng | CUSTOMER | STAFF | ADMIN |
|-------------------|:--------:|:-----:|:-----:|
| Cửa hàng, giỏ hàng, thanh toán | Yes | No | No |
| Lịch sử đơn hàng, hồ sơ | Yes | No | No |
| `/admin/products` — quản lý SP | No | Yes | Yes |
| `/admin/orders` — quản lý đơn | No | Yes | Yes |
| `/admin/users` — quản lý TK | No | No (403) | Yes |
| `/admin/migrate-passwords` | No | No | Yes |

---

## Cài đặt & Chạy

### Yêu cầu hệ thống

- **JDK** 17+
- **Apache Tomcat** 10.1+
- **MySQL** 8.0+ hoặc **MariaDB** 10.6+
- **NetBeans** 17+ (hoặc IDE hỗ trợ Ant)

### Bước 1 — Clone & mở project

```bash
git clone <repo-url>
```

Mở bằng NetBeans: **File -> Open Project -> BTL_SPMeVaBe**

### Bước 2 — Tạo cơ sở dữ liệu

```sql
CREATE DATABASE BTL_SPMeVaBe CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE BTL_SPMeVaBe;
SOURCE conf/create_tables.sql;
```

### Bước 3 — Cấu hình kết nối DB

Mở [`src/java/dao/DBConnect.java`](src/java/dao/DBConnect.java) và chỉnh:

```java
String dbPort     = "3306";
String dbUsername = "root";
String dbPassword = "";       // đổi thành mật khẩu MySQL của bạn
String dbName     = "BTL_SPMeVaBe";
```

### Bước 4 — Cấu hình Email (Quên mật khẩu)

Mở [`src/java/utils/EmailUtility.java`](src/java/utils/EmailUtility.java) và điền thông tin SMTP:

```java
final String FROM_EMAIL = "your-email@gmail.com";
final String PASSWORD    = "your-app-password";  // Gmail App Password
```

### Bước 5 — Build & Deploy

Trong NetBeans: **Run -> Clean and Build Project** -> **Run Project**

Hoặc bằng Ant:

```bash
ant clean build
# Copy dist/*.war vào thư mục webapps của Tomcat
```

### Bước 6 — Truy cập

| URL | Mô tả |
|-----|-------|
| `http://localhost:8080/BTL_SPMeVaBe/` | Trang chủ khách hàng |
| `http://localhost:8080/BTL_SPMeVaBe/admin/` | Trang quản trị |
| `http://localhost:8080/BTL_SPMeVaBe/login` | Đăng nhập |

---

## Tài khoản mặc định

> Mật khẩu đã được BCrypt hash trong `create_tables.sql`.

| Role | Username | Mật khẩu |
|------|----------|----------|
| **ADMIN** | `admin` | `admin` |
| **CUSTOMER** | `khachhang` | `123456` |

> **Nếu import DB cũ** (mật khẩu plain-text), hãy chạy endpoint migration sau khi đăng nhập:
> ```
> GET /BTL_SPMeVaBe/admin/migrate-passwords
> ```

---

## Thư viện sử dụng

| JAR | Version | Mục đích |
|-----|---------|---------|
| `mysql-connector-j` | 8.3.0 | JDBC driver cho MySQL |
| `jjwt-api/impl/jackson` | 0.12.6 | JWT tạo & xác thực |
| `jbcrypt` | 0.4 | BCrypt mã hoá mật khẩu |
| `jackson-core/databind/annotations` | 2.17.2 | JSON cho JJWT |
| `jakarta.mail` | 2.0.1 | Gửi email SMTP |
| `jakarta.activation` | 2.0.1 | Hỗ trợ Jakarta Mail |
| `jakarta.servlet.jsp.jstl` | 2.0.0 | JSTL tag library |
