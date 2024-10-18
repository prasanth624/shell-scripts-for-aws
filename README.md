# 🌩️ shell-scripts-for-aws

Welcome to the **shell-scripts-for-aws** repository! This collection of shell scripts is designed to help you manage AWS resources efficiently and effectively.

## 📚 Table of Contents

- [Prerequisites](#prerequisites)
- [Scripts](#scripts)
- [Usage](#usage)
- [License](#license)

## ✅ Prerequisites

Before running the scripts, make sure you have the following:

- An **AWS account** with the necessary permissions to access resources.
- **AWS CLI** installed and configured on your machine. You can configure it using:

  ```bash
  aws configure
  ```

- Basic knowledge of shell scripting and command line usage.

## 🛠️ Scripts

This repository currently includes scripts that perform the following functions:

- **Find Running EC2 Instances**: Retrieves a list of all running EC2 instances in a specified region.
- **Find Stopped EC2 Instances**: Retrieves a list of all stopped EC2 instances in a specified region.
- **Find Unattached EBS Volumes**: Retrieves a list of all unattached EBS volumes in a specified region.

*More scripts and functionalities will be added in the future!*

## 🚀 Usage

To get started, follow these steps:

1. **Clone the repository**:

   ```bash
   git clone https://github.com/prasanth624/shell-scripts-for-aws.git
   cd shell-scripts-for-aws
   ```

2. **Make the scripts executable**:

   ```bash
   chmod +x *.sh
   ```

3. **Run the desired script**:

   ```bash
   ./your_script_name.sh
   ```

## 📜 License

This project is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for details.
