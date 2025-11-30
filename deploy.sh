#!/bin/bash

# 部署配置
SERVER_IP="175.178.193.103"
SERVER_USER="administrator"
LOCAL_PATH="./dist"
REMOTE_PATH="/C:/inetpub/wwwroot"

# 可尝试的SSH端口
SSH_PORTS=(22 2222 8022)

echo "=========================================="
echo "开始部署到 Windows 服务器"
echo "服务器IP: $SERVER_IP"
echo "用户名: $SERVER_USER"
echo "本地路径: $LOCAL_PATH"
echo "=========================================="
echo ""

# 检查dist目录是否存在
if [ ! -d "$LOCAL_PATH" ]; then
    echo "错误: $LOCAL_PATH 目录不存在，请先运行 npm run build"
    exit 1
fi

# 尝试不同的SSH端口
for PORT in "${SSH_PORTS[@]}"; do
    echo "尝试SSH连接（端口 $PORT）..."
    
    # 先测试连接
    timeout 5 ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no -p $PORT "$SERVER_USER@$SERVER_IP" "echo '连接成功'" 2>/dev/null
    
    if [ $? -eq 0 ]; then
        echo "找到可用的SSH端口: $PORT"
        echo ""
        echo "正在传输文件到服务器..."
        echo "提示: 系统将提示您输入密码，请输入 administrator 账户的密码"
        echo ""
        
        # 使用scp传输文件
        scp -r -P $PORT -o StrictHostKeyChecking=no "$LOCAL_PATH"/* "$SERVER_USER@$SERVER_IP:$REMOTE_PATH/"
        
        if [ $? -eq 0 ]; then
            echo ""
            echo "=========================================="
            echo "部署成功！"
            echo "文件已上传到: $SERVER_IP:$REMOTE_PATH"
            echo "=========================================="
            exit 0
        else
            echo "传输失败，继续尝试其他方式..."
            echo ""
        fi
    fi
done

# 如果SSH都失败，尝试SMB
echo "SSH连接失败，尝试使用SMB/CIFS共享..."
echo ""

MOUNT_POINT="/tmp/windows_deploy_$$"
REMOTE_SHARE="C$"

# 创建挂载点
mkdir -p "$MOUNT_POINT"

# 卸载可能已存在的挂载
if mount | grep -q "$MOUNT_POINT"; then
    umount "$MOUNT_POINT" 2>/dev/null
fi

echo "正在挂载Windows共享文件夹..."
echo "提示: 系统将提示您输入密码，请输入 administrator 账户的密码"
echo ""

# 尝试挂载Windows共享
mount_smbfs "//$SERVER_USER@$SERVER_IP/$REMOTE_SHARE" "$MOUNT_POINT" 2>&1

if [ $? -eq 0 ]; then
    echo "挂载成功！"
    echo ""
    
    # 复制文件
    REMOTE_DEPLOY_PATH="$MOUNT_POINT/inetpub/wwwroot"
    
    echo "正在复制文件到: $REMOTE_DEPLOY_PATH"
    
    if [ ! -d "$REMOTE_DEPLOY_PATH" ]; then
        mkdir -p "$REMOTE_DEPLOY_PATH"
    fi
    
    cp -r "$LOCAL_PATH"/* "$REMOTE_DEPLOY_PATH/"
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "=========================================="
        echo "部署成功！(通过SMB)"
        echo "文件已复制到: \\\\$SERVER_IP\\$REMOTE_SHARE\\inetpub\\wwwroot"
        echo "=========================================="
        
        # 卸载
        umount "$MOUNT_POINT"
        rmdir "$MOUNT_POINT" 2>/dev/null
        exit 0
    else
        umount "$MOUNT_POINT"
        rmdir "$MOUNT_POINT" 2>/dev/null
    fi
else
    echo "SMB挂载失败"
    echo ""
fi

# 所有自动方式都失败
echo "=========================================="
echo "自动部署失败"
echo "=========================================="
echo ""
echo "请使用以下方式之一进行手动部署："
echo ""
echo "方式1: 使用远程桌面"
echo "  1. 连接到: $SERVER_IP (用户: $SERVER_USER)"
echo "  2. 将 $LOCAL_PATH 目录内容复制到 C:\\inetpub\\wwwroot"
echo ""
echo "方式2: 使用FTP客户端"
echo "  如果服务器启用了FTP，使用FTP客户端上传文件"
echo ""
echo "方式3: 检查服务器服务"
echo "  请确认服务器已启用以下服务之一："
echo "  - SSH服务（端口22或其他）"
echo "  - SMB/CIFS共享服务（端口445）"
echo "  - 或配置防火墙允许相应端口"
echo ""
echo "构建文件位置: $(pwd)/$LOCAL_PATH"
echo "=========================================="

exit 1
