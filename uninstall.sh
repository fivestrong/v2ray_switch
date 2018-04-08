#!/bin/sh
alias echo_date='echo $(date +%Y年%m月%d日\ %X):'

echo_date 开始删除文件
# 关闭V2ray先
enable=`dbus get v2ray_enable`
if [ "$enable" == "1" ];then
	echo_date 检测到在启动
	dbus set v2ray_enable=0
	echo_date 关闭V2ray
	/koolshare/scripts/v2ray_run.sh stop
fi

# 删除文件
rm -rf /koolshare/bin/v2ctl
rm -rf /koolshare/bin/v2ray
rm -rf /koolshare/bin/geoip.dat
rm -rf /koolshare/bin/geosite.dat
rm -rf /koolshare/bin/v2ray_config.json
rm -rf /koolshare/scripts/v2ray.sh
rm -rf /koolshare/scripts/v2ray_*
rm -rf /koolshare/res/icon-v2ray.png
rm -rf /koolshare/res/v2ray_log.htm
rm -rf /koolshare/res/v2ray_status.htm
rm -rf /koolshare/webs/Module_v2ray.asp
rm -rf /koolshare/init.d/S165V2ray.sh
rm -rf /koolshare/scripts/uninstall_v2ray.sh
rm -rf /jffs/v2ray
