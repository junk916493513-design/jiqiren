#!/bin/bash

# 使用rsync部署（支持自定义SSH端口）
# 使用方法: ./deploy_rsync.sh [SSH端口，默认22]

SERVER_IP="175.178.193.103"
SERVER_USER="administrator"
LOCAL_PATH="./dist"
REMOTE_PATH="/C:/inetpub/wwwroot"
SSH_PORT=${1:-22}  # 第一个参数作为SSH端口，默认22

echo "=========================================="
echo "使用rsync部署到 Windows 服务器"
echo "服务器IP: $SERVER_IP"
echo "用户名: $SERVER_USER"
echo "SSH端口: $SSH_PORT"
echo "本地路径: $LOCAL_PATH"
echo "远程路径: $REMOTE_PATH"
echo "=========================================="
echo ""

# 检查dist目录是否存在
if [ ! -d "$LOCAL_PATH" ]; then
    echo "错误: $LOCAL_PATH 目录不存在，请先运行 npm run build"
    exit 1
fi

echo "正在使用rsync同步文件..."
echo "提示: 系统将提示您输入密码，请输入 administrator 账户的密码"
echo ""

# 使用rsync传输文件
# -a: 归档模式
# -v: 详细输出
# -z: 压缩传输
# -e: 指定远程shell命令
rsync -avz -e "ssh -p $SSH_PORT -o StrictHostKeyChecking=no" \
    "$LOCAL_PATH/" "$SERVER_USER@$SERVER_IP:$REMOTE_PATH/"

if [ $? -eq 0 ]; then
    echo ""
    echo "=========================================="
    echo "部署成功！"
    echo "文件已同步到: $SERVER_IP:$REMOTE_PATH"
    echo "=========================================="
else
    echo ""
    echo "=========================================="
    echo "部署失败"
    echo ""
    echo "如果默认端口22失败，请尝试其他端口："
    echo "  ./deploy_rsync.sh 2222"
    echo "  ./deploy_rsync.sh 8022"
    echo ""
    echo "或检查服务器是否启用了SSH服务"
    echo "=========================================="
    exit 1
fi

