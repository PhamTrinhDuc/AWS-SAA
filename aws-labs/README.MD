# AWS Labs — SAA Study

Tập hợp các lab AWS dùng Terraform để ôn thi SAA.

## Cấu trúc
- `modules/` — reusable modules, tái sử dụng qua nhiều lab
- `labs/`    — từng bài lab độc lập

## Labs
| Lab | Nội dung |
|-----|----------|
| lab-01-ec2 | Tạo EC2, Security Group, Key Pair |

## Yêu cầu
- Terraform >= 1.5
- AWS CLI đã configure

## Luồng hoạt động 
```bash
labs/lab-01-ec2/main.tf
        │
        │  gọi module với các biến
        ▼
modules/ec2/main.tf
        │
        │  tạo thật trên AWS
        ▼
  Security Group + Key Pair + EC2 Instance
        │
        │  trả output ngược lên
        ▼
labs/lab-01-ec2/outputs.tf  →  in ra terminal
```