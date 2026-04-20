# Lab 02 — S3

## Mục tiêu
- Tạo private bucket với versioning
- Tạo static website bucket với public read
- Hiểu block public access, encryption, versioning

## Scenarios
| Bucket | Public | Versioning | Website |
|--------|--------|------------|---------|
| private | No | Yes | No |
| website | Yes | No | Yes |

## Chạy lab
```bash
terraform init
terraform plan
terraform apply
```

## Kiểm tra website
Sau apply, mở URL từ output `website_url` trên browser.

## Dọn dẹp
```bash
terraform destroy
```