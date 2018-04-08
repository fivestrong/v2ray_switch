#!/bin/sh
alias echo_date='echo $(date +%Y年%m月%d日\ %X):'

echo_date 更新v2ray >> /tmp/v2ray_log.log
/koolshare/scripts/go_arm.sh >> /tmp/v2ray_log.log

if [ -d "/jffs/v2ray" ];then
    echo_date 复制文件 >> /tmp/v2ray_log.log
    cp -rf /jffs/v2ray/* /koolshare/bin/
    echo_date 复制文件完成 >> /tmp/v2ray_log.log
fi
