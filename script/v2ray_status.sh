#!/bin/sh
CONFIG_FILE="/tmp/v2ray_status.json"
rm -rf $CONFIG_FILE
is_run="false"
# is_gfwlist="false"
# is_chain="false"
# is_redirect="false"
run_date=$(date +%Y年%m月%d日\ %X)
cur_ver=`/koolshare/bin/v2ray -version 2>/dev/null | head -n 1 | cut -d " " -f2`
if [ $(ps -w |grep '/koolshare/bin/v2ray'|grep -v grep|grep -v watchdog|wc -l) -gt 0 ]; then is_run="true"; fi
# if [ $(ipset list | grep -c "Name: gfwlist") -gt 0 ]; then is_gfwlist="true"; fi
# if [ $(iptables -nvL V2RAY -t nat | grep -c "match-set gfwlist") -gt 0 ]; then is_chain="true"; fi
# if [ $(iptables -nvL PREROUTING -t nat | grep -c "V2RAY") -gt 0 ]; then is_redirect="true"; fi
# cat > $CONFIG_FILE <<-EOF
# {"is_run":$is_run,"is_gfwlist":$is_gfwlist,"is_chain":$is_chain,"is_redirect":$is_redirect,"date":"$run_date"}
cat > $CONFIG_FILE <<-EOF
{"is_run":$is_run,"date":"$run_date","version":"$cur_ver"}
		EOF
echo 写入完成
