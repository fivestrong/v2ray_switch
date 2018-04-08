#!/bin/sh
alias echo_date='echo $(date +%Y年%m月%d日\ %X):'

echo_date 启动前关闭现有进程... >> /tmp/v2ray_log.log
/koolshare/scripts/v2ray_run.sh stop
v2ray_count=`ps -w |grep '/koolshare/bin/v2ray'|grep -v grep|grep -v watchdog|wc -l`
if [ "$v2ray_count" -eq 0 ];then
    echo_date v2ray 关闭成功！ >> /tmp/v2ray_log.log
else
    echo_date v2ray 关闭失败！ >> /tmp/v2ray_log.log
fi


echo_date 重启 v2ray... >> /tmp/v2ray_log.log
/koolshare/scripts/v2ray_run.sh start

v2ray_count=`ps -w |grep '/koolshare/bin/v2ray'|grep -v grep|grep -v watchdog|wc -l`
if [ "$v2ray_count" -gt 0 ];then
    echo_date v2ray 启动成功！ >> /tmp/v2ray_log.log
else
    echo_date v2ray 启动失败！ >> /tmp/v2ray_log.log
fi
