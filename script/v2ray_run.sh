#!/bin/sh
alias echo_date='echo $(date +%Y年%m月%d日\ %X):'

stop_ss() {
    rss_local=`ps -w |grep 'rss-local'|grep -v grep|wc -l`
    rss_redir=`ps -w |grep 'rss-redir'|grep -v grep|wc -l`
    if [ "$rss_local" -eq 1 ] && [ "$rss_redir" -eq 1 ];then
        dbus set sstype="rss"
        killall rss-local >/dev/null 2>&1
        killall rss-redir >/dev/null 2>&1
    else
        dbus set sstype="ss"
        killall ss-local >/dev/null 2>&1
        killall ss-redir >/dev/null 2>&1
    fi  
}

run_v2ray(){
    #v2ray='/koolshare/bin/v2ray --config=/koolshare/bin/v2ray_config.json'
    v2ray_count=`ps -w |grep '/koolshare/bin/v2ray'|grep -v grep|grep -v watchdog|wc -l`
    if [ "$v2ray_count" -gt 0 ];then
        echo_date 已经在启动
    else
        stop_ss
        #$v2ray &
        /koolshare/bin/v2ray --config=/koolshare/bin/v2ray_config.json &
	    echo $$ > /tmp/v2ray.pid
	    echo_date 启动成功
    fi
}

start_v2ray(){
   echo_date ---启动进程---
   run_v2ray
   echo_date ---添加守护进程---
   if [ $(grep -c 'v2ray_watchdog.sh' /var/spool/cron/crontabs/*) -gt 0 ]; then echo_date 守护进程已添加过; else cru a v2ray_watchdog "*/2 * * * * /bin/sh /koolshare/scripts/v2ray_watchdog.sh"; fi
   echo_date ---启动结束---
}

stop_v2ray(){
   echo_date ---解除守护进程和开机启动---
   sed -i '/v2ray_watchdog/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
   v2ray=$(ps | grep "v2ray" | grep -v "grep")
   sstype=`dbus get sstype`
   if [ ! -z "$v2ray" ];then 
        echo_date 关闭v2ray进程...
        killall v2ray
        echo_date 重新启动rss进程...
        if [ "$sstype" == "rss" ];then
            /koolshare/bin/rss-local -l 23456 -c /koolshare/ss/ss.json -u -f /var/run/sslocal1.pid
            /koolshare/bin/rss-redir -c /koolshare/ss/ss.json -u -f /var/run/shadowsocks.pid
        else
            /koolshare/bin/ss-local -l 23456 -c /koolshare/ss/ss.json -u -f /var/run/sslocal1.pid
            /koolshare/bin/ss-redir -c /koolshare/ss/ss.json -u -f /var/run/shadowsocks.pid
        fi

   fi
   if [ -e "/koolshare/init.d/S165V2ray.sh" ];then
      rm -rf /koolshare/init.d/S165V2ray.sh
   fi
   echo_date 关闭完毕
}

case $1 in
   start)
      start_v2ray
      ;;
   stop)
      stop_v2ray
      ;;
esac
