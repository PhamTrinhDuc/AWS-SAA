### 🔑 Nguyên lý cốt lõi: Aurora khác gì RDS truyền thống?
RDS thường (MySQL/PostgreSQL) gộp chung **storage** và **compute** vào 1 instance.  
**Aurora** tách biệt hoàn toàn:
- `aws_rds_cluster` → Lớp lưu trữ chung (shared storage) + cấu hình điều khiển cluster
- `aws_rds_cluster_instance` → Lớp tính toán (CPU/RAM) gắn vào cluster đó

👉 Đây là lý do chính tại sao code **phải tách thành 2 resource riêng**. Bạn không thể tạo instance Aurora mà không có cluster trước.

---
### 🧩 Giải thích từng thành phần

#### 1. `aws_db_subnet_group`
- **Làm gì:** Gom các subnet thuộc **ít nhất 2 Availability Zone (AZ)** lại thành 1 nhóm.
- **Tại sao cần:** AWS bắt buộc Aurora phải deploy đa AZ để đảm bảo **High Availability**. Nếu 1 AZ mất điện/sự cố, Aurora tự động failover sang AZ kia mà không mất dữ liệu.
- **Liên kết:** Được gán vào `db_subnet_group_name` của cả cluster lẫn instance.

#### 2. `aws_security_group`
- **Làm gì:** Đóng vai trò firewall cho database. Chỉ cho phép traffic vào cổng `3306` (MySQL) từ các CIDR hoặc Security Group được phép.
- **Tại sao cần:** Bảo mật tối thiểu (least privilege). Tránh expose DB ra internet hoặc bị truy cập trái phép.
- **Liên kết:** Gán vào `vpc_security_group_ids` của `aws_rds_cluster`.

#### 3. `aws_rds_cluster`
- **Làm gì:** Cấu hình "bộ não" & "ổ cứng chung" của Aurora. Quản lý:
  - Engine, version, tên DB, user/password gốc
  - Backup, maintenance window
  - Mã hóa dữ liệu (`storage_encrypted = true`)
- **Tại sao cần:** Mọi instance trong cluster sẽ dùng chung storage, backup, encryption này. Cấu hình ở đây áp dụng cho toàn bộ hệ thống.
- 💡 Lưu ý lab: `skip_final_snapshot = true` & `deletion_protection = false` giúp xóa nhanh khi test. **Production phải đổi lại** để tránh mất dữ liệu ngoài ý muốn.

#### 4. `aws_rds_cluster_instance` (writer & reader)
- **Làm gì:** Tạo máy chủ compute thực tế.
  - `writer`: Xử lý cả đọc & ghi (duy nhất 1 node)
  - `reader`: Chỉ xử lý đọc, dùng để scale out tải truy vấn. `count = var.enable_reader ? 1 : 0` là cách Terraform bật/tắt linh hoạt.
- **Tại sao cần:** Aurora cho phép scale compute độc lập với storage. Khi tải đọc tăng, bạn chỉ thêm reader mà không chạm vào storage hay writer.
- **Liên kết:** `cluster_identifier` trỏ về cluster, dùng chung subnet group, engine version.

#### 5. `aws_ssm_parameter`
- **Làm gì:** Lưu `master_password` (dạng `SecureString`) và `endpoint` (dạng `String`) vào AWS Systems Manager Parameter Store.
- **Tại sao cần:** 
  - Không hardcode mật khẩu trong code hoặc Terraform state file
  - Dễ rotate secret, tích hợp với CI/CD hoặc ứng dụng
  - Đây là **security best practice** bắt buộc trong môi trường thực tế.

---
### 🔗 Chúng hoạt động với nhau thế nào? (Luồng Dependency)
Terraform tự động phân tích dependency và chạy theo thứ tự:
```
Subnet Group & Security Group 
        ↓
   RDS Cluster (cần subnet & SG)
        ↓
   RDS Instances (cần cluster identifier)
        ↓
   SSM Parameters (cần endpoint từ cluster)
```
Khi `terraform apply`:
1. AWS tạo network foundation (subnet group, SG)
2. Provision shared storage & cluster control plane
3. Attach compute nodes (writer → reader nếu bật)
4. Lưu endpoint & password vào SSM
5. Ứng dụng của bạn đọc từ SSM để kết nối DB → không cần lộ thông tin trong code/env

---
### 📐 Tại sao lại thiết kế code như vậy? (5 lý do chính)
| Lý do | Giải thích |
|-------|------------|
| **1. Tuân thủ kiến trúc AWS** | Aurora bắt buộc tách Cluster (storage) và Instance (compute). Code phản ánh đúng mô hình này. |
| **2. Security-by-default** | SG giới hạn IP, `storage_encrypted=true`, password đưa vào SSM thay vì plain text. |
| **3. High Availability & Recoverability** | Multi-AZ subnet, backup window, maintenance window được cấu hình sẵn. |
| **4. IaC Best Practices** | Dùng biến (`var.`), tagging nhất quán, `merge()` cho tag linh hoạt, không hardcode. |
| **5. Linh hoạt môi trường** | `enable_reader`, `skip_final_snapshot`, `publicly_accessible` có thể điều chỉnh qua `variables.tf` để chuyển từ lab → staging → prod. |

---
### 💡 Lưu ý quan trọng cho người mới
1. `publicly_accessible` trên `aws_rds_cluster_instance` đang là **legacy pattern**. Với Aurora hiện đại, tính này thường được quản lý ở cluster level hoặc tắt hẳn. Trong production, Aurora nên đặt trong private subnet, truy cập qua NAT Gateway/Endpoint.
2. Bạn có thể dùng `terraform graph` hoặc `terraform plan` để xem rõ thứ tự tạo resource và dependency.
3. Khi chuyển sang production, hãy:
   - Đặt `deletion_protection = true`
   - Đặt `skip_final_snapshot = false`
   - Dùng AWS Secrets Manager thay SSM nếu cần auto-rotation password.
   - Tắt `publicly_accessible`, deploy Aurora trong private subnet.
