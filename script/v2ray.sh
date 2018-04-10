#!/bin/sh
alias echo_date='echo $(date +%Y年%m月%d日\ %X):'
rm -rf /tmp/v2ray_log.log
enable=`dbus get v2ray_enable`

if [ "$enable" == "1" ];then
		echo_date 提交文件,开始执行生成配置文件..... >> /tmp/v2ray_log.log
		/koolshare/scripts/v2ray_editconfig.sh >> /tmp/v2ray_log.log
		echo_date 关闭v2ray进程..... >> /tmp/v2ray_log.log
		/koolshare/scripts/v2ray_run.sh stop >> /tmp/v2ray_log.log
		echo_date 测试文件是否通过..... >> /tmp/v2ray_log.log
		result=$(/koolshare/bin/v2ray -test -config=/tmp/v2ray_config_tmp.json | grep "Configuration OK.")
		echo $result >> /tmp/v2ray_log.log
		if [ -n "$result" ];then
			echo_date 通过测试,恭喜!!! >> /tmp/v2ray_log.log
			rm -rf /koolshare/bin/v2ray_config.json
			mv /tmp/v2ray_config_tmp.json /koolshare/bin/v2ray_config.json >> /tmp/v2ray_log.log
			killall v2ray >/dev/null 2>&1
			/koolshare/scripts/v2ray_run.sh start >> /tmp/v2ray_log.log
			# creat start_up filetmp/v2ray_log.log
			# creat start_up file
			if [ ! -L "/koolshare/init.d/S165V2ray.sh" ]; then 
				ln -sf /koolshare/scripts/v2ray_run.sh /koolshare/init.d/S165V2ray.sh
			fi
		else
			rm -rf /tmp/v2ray_config_tmp.json
			dbus set v2ray_enable=0
			echo_date 没有通过测试,请检查参数!!! >> /tmp/v2ray_log.log
		fi
		echo_date 运行完毕!!! >> /tmp/v2ray_log.log
fi
if [ "$enable" == "0" ];then
	echo_date 关闭V2ray >> /tmp/v2ray_log.log
	/koolshare/scripts/v2ray_run.sh stop >> /tmp/v2ray_log.log
fi