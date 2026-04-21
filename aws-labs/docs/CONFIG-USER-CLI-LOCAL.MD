## 1. Cấu hình AWS CLI trên máy tính cá nhân
```bash
aws configure
```

## 2. Điền thông tin `AWS Access Key ID`, `AWS Secret Access Key`, `Default region name` và `Default output format` như hình dưới đây:
```bash
AWS Access Key ID:     AKIA...........
AWS Secret Access Key: xxxxxxxxxxxxxxx
Default region name:   ap-southeast-1
Default output format: json
```

## 3. Kiểm tra xem AWS CLI đã được cấu hình đúng chưa bằng cách chạy lệnh sau:
```bash
aws sts get-caller-identity

# output formatted as JSON
{
    "UserId": "AIDA...........",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/your-username"
}
```

## 4. Creadentials của AWS CLI sẽ được lưu trữ trong file `~/.aws/credentials` và cấu hình sẽ được lưu trong file `~/.aws/config`. Bạn có thể mở các file này để kiểm tra hoặc chỉnh sửa thông tin nếu cần thiết.
```bash
# Nội dung file ~/.aws/credentials
[default]
aws_access_key_id = AKIA...........
aws_secret_access_key = xxxxxxxxxxxxxxx
```

## 5. Tạo public key và private key để sử dụng cho việc kết nối SSH đến EC2 instance:
```bash
ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa.pub

# Nội dung file ~/.ssh/id_rsa.pub được lưu tại ~/.ssh/id_rsa.pub
cat ~/.ssh/id_rsa.pub
```
