# 部署指南

## 服务器信息
- IP地址: 175.178.193.103
- 用户名: administrator
- 本地构建目录: `./dist`

## 自动部署（如果服务器支持SSH/SMB）

运行以下命令：
```bash
./deploy.sh
```

## 手动部署方式

### 方式1: 使用Windows远程桌面

1. 使用远程桌面连接到服务器：
   - 服务器地址: `175.178.193.103`
   - 用户名: `administrator`
   - 输入密码

2. 在远程桌面上，将 `dist` 目录的内容复制到 Web 服务器目录（如 `C:\inetpub\wwwroot`）

### 方式2: 使用FTP客户端

如果服务器启用了FTP服务，可以使用FTP客户端（如FileZilla）上传文件。

### 方式3: 使用PowerShell远程执行

在本地Mac上，可以使用PowerShell（如果已安装）或创建Windows批处理脚本在服务器上执行。

### 方式4: 使用rsync（如果服务器支持）

```bash
rsync -avz -e ssh ./dist/ administrator@175.178.193.103:/C:/inetpub/wwwroot/
```

## 检查服务器服务状态

请确认服务器上已启用以下服务之一：
- SSH服务（端口22）
- SMB/CIFS共享服务（端口445）
- FTP服务（端口21）
- 或使用远程桌面进行手动部署

