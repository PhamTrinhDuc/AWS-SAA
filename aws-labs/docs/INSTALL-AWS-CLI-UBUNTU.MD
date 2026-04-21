# 1. Update your Ubuntu packages
sudo apt update
sudo apt upgrade -y

# 2. Install unzip if you don't have it already
sudo apt install -y unzip curl

# 3. Download the AWS CLI v2 installation package
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

# 4. Unzip the installer
unzip awscliv2.zip

# 5. Run the install program
sudo ./aws/install

# 6. Verify the installation
aws --version