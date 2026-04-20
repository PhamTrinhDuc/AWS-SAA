## 🔹 1. Bucket name + random_id
```bash
bucket = "${var.project_name}-${var.environment}-${random_id.suffix.hex}"
```

👉 Vì S3 bucket global unique
→ thêm random_id để tránh trùng tên

## 🔹 2. Block public access (best practice)
```bash
block_public_* = var.block_public_access
```

👉 Mặc định AWS khuyên block hết public
→ tránh leak data

## 🔹 3. Versioning – khi bạn “xóa nhầm / ghi đè”

**Tình huống thật:**

* Bạn upload `model.pkl` mà trước đó đã có 1 checkpoint cùng tên rồi
* 2 ngày sau deploy bản mới → ghi đè
* Model lỗi → **không rollback được**

👉 Bật versioning:

* Mỗi lần upload = 1 version (AWS tạo thêm 1 version_id cho mỗi object)
* Có thể quay lại version cũ ngay

---

## 🔹 4. Encryption – khi data bị lộ từ storage

**Tình huống thật:**

* Bucket chứa:

  * dataset
  * log user
  * model
* Nếu AWS bị leak disk / nội bộ truy cập trái phép

👉 Encryption:

* Data lưu dưới dạng **đã mã hóa**
* Ai không có quyền → đọc cũng vô nghĩa

---

## 🔹 5. Website config – khi muốn host web đơn giản

**Tình huống thật:**

* Bạn cần:

  * landing page cho project
  * demo model (HTML + JS)
* Không muốn dùng server EC2

👉 S3 website:

* Upload `index.html`
* Truy cập trực tiếp qua URL

---

## 🔹 6. Public policy – khi web phải cho người khác xem

**Tình huống thật:**

* Website phải public
* Nhưng mặc định S3 **block public hết**

👉 Cần policy:

* Cho phép `GET object`
* Nếu không → mở web sẽ bị **403 Forbidden**

---

## 🔹 7. depends_on – bug “ngẫu nhiên khó hiểu”

**Tình huống thật:**

* Terraform apply
* AWS chưa kịp apply block public
* Policy public apply trước → bị conflict → lỗi

👉 `depends_on`:

* ép thứ tự chạy
* tránh lỗi race condition

---

## 🔹 8. Upload index.html – test nhanh

**Tình huống thật:**

* Deploy xong
* Mở URL → trắng → không biết lỗi gì

👉 Có sẵn file:

* mở lên thấy ngay “Hello”
  → biết infra OK

---

## ⚡ Tóm lại (rất thực tế)

Từ mục 3 trở đi đều giải quyết 4 vấn đề:

1. **Mất dữ liệu** → versioning
2. **Rò rỉ dữ liệu** → encryption
3. **Cần public đúng lúc** → website + policy
4. **Deploy lỗi khó debug** → depends_on + sample file
