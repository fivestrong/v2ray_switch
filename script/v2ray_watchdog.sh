#!/bin/sh

is_v2ray_alive() {
    v2ray_count=`ps -w |grep '/koolshare/bin/v2ray'|grep -v grep|grep -v watchdog|wc -l`
    if [ "$v2ray_count" -gt 0 ];then
        return 0  # work ok
    else
        return 1
    fi
}
restart_v2ray() {
    killall v2ray >/dev/null 2>&1
    /koolshare/scripts/v2ray_run.sh start >> /tmp/v2ray_log.log
}

main(){
    is_v2ray_alive #判断 v2ray 是不是还活着
    if [ "$?" -ne 0 ];then
        restart_v2ray # 启动 v2ray
        echo "v2ray 重新启动在: "$(date +%Y年%m月%d日\ %X) >> /tmp/v2ray_log.log
    fi
}

main
