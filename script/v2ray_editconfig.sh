#!/bin/sh
alias echo_date='echo $(date +%Y年%m月%d日\ %X):'
echo_date 加载v2ray数据
eval `dbus export v2ray`
CONFIG_FILE="/tmp/v2ray_config_tmp.json"
rm -rf $CONFIG_FILE
kcp="null"
tcp="null"
ws="null"
case $v2ray_network in
        kcp)
                kcp="{
        \"header\": {
          \"type\": \"$v2ray_headtype\"
        }
      }"
                ;;
        tcp)
                tcp="{
        \"header\": {
          \"type\": \"$v2ray_headtype\"
        }
      }"
                ;;
		    ws)
                ws="{
        \"connectionReuse\": true,
        \"path\": \"$v2ray_network_path\",
        \"headers\": null
      }"
                ;;
        ws_hd)
                v2ray_network="ws"
                ws="{
        \"connectionReuse\": true,
        \"path\": \"$v2ray_network_path\",
        \"headers\": {
          \"Host\": \"$v2ray_network_host\"
        }     
      }"
                ;;
esac

echo_date 写入文件
cat > $CONFIG_FILE <<-EOF
{
  "log": {
    "access": "/dev/null",
    "error": "/tmp/v2ray_log.log",
    "loglevel": "error"
  },
  "inbound": {
    "port": 23456,
    "listen": "0.0.0.0",
    "protocol": "socks",
    "settings": {
      "auth": "noauth",
      "udp": true,
      "ip": "127.0.0.1",
      "clients": null
    },
    "streamSettings": null
  },
  "outbound": {
    "tag": "agentout",
    "protocol": "vmess",
    "settings": {
      "vnext": [
        {
          "address": "$v2ray_server_address",
          "port": $v2ray_server_port,
          "users": [
            {
              "id": "$v2ray_id",
              "alterId": $v2ray_alterid,
              "security": "$v2ray_security"
            }
          ]
        }
      ]
    },
    "streamSettings": {
      "network": "$v2ray_network",
      "security": "$v2ray_network_security",
      "tcpSettings": $tcp,
      "kcpSettings": $kcp,
      "wsSettings": $ws
    },
    "mux": {
      "enabled": true
    }
  },
  "inboundDetour": [
    {
      "listen": "0.0.0.0",
      "port": 3333,
      "protocol": "dokodemo-door",
      "settings": {
        "network": "tcp,udp",
        "followRedirect": true
      }
    }
  ]
}
		EOF
echo_date 写入成功到$CONFIG_FILE