#!/bin/sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
cat /tmp/v2ray_conf_backup.txt |sed -i '/------Web/,$d' /tmp/v2ray_conf_backup.txt
sleep 1
dos2unix /tmp/v2ray_conf_backup.txt
mv /tmp/v2ray_conf_backup.txt /koolshare/bin/v2ray_config.json

if [ $? -eq 0 ];then
    echo_date 导入配置成功！>> /tmp/v2ray_log.log
else
    echo_date 导入配置失败! >> /tmp/v2ray_log.log
fi