#!/bin/sh
alias echo_date='echo $(date +%Y年%m月%d日\ %X):'

# 关闭V2ray先
enable=`dbus get v2ray_enable`
if [ "$enable" == "1" ];then
	restart=1
	echo_date 检测到在启动
	dbus set v2ray_enable=0
	echo_date 关闭V2ray
	/koolshare/scripts/v2ray_run.sh stop
fi

echo_date 复制文件
cp -rf /tmp/v2ray/script/* /koolshare/scripts/
cp -rf /tmp/v2ray/bin/* /koolshare/bin/
cp -rf /tmp/v2ray/web/* /koolshare/webs/
cp -rf /tmp/v2ray/res/* /koolshare/res/

echo_date 删除安装包
rm -rf /tmp/v2ray* >/dev/null 2>&1

echo_date 授予运行权限
chmod 777 /koolshare/scripts/v2ray.sh
chmod 777 /koolshare/scripts/uninstall_v2ray.sh
chmod 777 /koolshare/scripts/v2ray_*
chmod 0755 /koolshare/bin/v2ray
chmod a+x /koolshare/bin/v2ctl


#重新启动服务
if [ "$restart" == "1" ];then
	dbus set v2ray_enable=1
	echo_date 启动程序
	/koolshare/scripts/v2ray_run.sh start
fi

dbus set softcenter_module_v2ray_install=1
dbus set softcenter_module_v2ray_version=1.3
dbus set softcenter_module_v2ray_description="V2RAY来自Project V"