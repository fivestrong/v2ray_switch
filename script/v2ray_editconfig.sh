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
            \"mtu\": 1350,
            \"tti\": 50,
            \"uplinkCapacity\": 12,
            \"downlinkCapacity\": 100,
            \"congestion\": false,
            \"readBufferSize\": 2,
            \"writeBufferSize\": 2,
            \"header\": {
              \"type\": \"$v2ray_headtype\",
              \"request\": null,
              \"response\": null
            }
          }"
                ;;
        tcp)
          if [ "$v2ray_headtype" == "http" ];then
            tcp="{
                \"connectionReuse\": true,
                \"header\": {
                    \"type\": \"http\",
                    \"request\": {
                        \"version\": \"1.1\",
                        \"method\": \"GET\",
                        \"path\": [
                            \"/\"
                        ],
                        \"headers\": {
                              \"Host\": [
                                  \"\"
                            ],
                              \"User-Agent\": [
                                  \"Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.75 Safari/537.36\",
                                  \"Mozilla/5.0 (iPhone; CPU iPhone OS 10_0_2 like Mac OS X) AppleWebKit/601.1 (KHTML, like Gecko) CriOS/53.0.2785.109 Mobile/14A456 Safari/601.1.46\"
                            ],
                              \"Accept-Encoding\": [
                                  \"gzip, deflate\"
                            ],
                             \"Connection\": [
                                    \"keep-alive\"
                           ],
                            \"Pragma\": \"no-cache\"
                       }
                     },
                    \"response\": {
                        \"version\": \"1.1\",
                         \"status\": \"200\",
                         \"reason\": \"OK\",
                          \"headers\": {
                                \"Content-Type\": [
                                    \"application/octet-stream\",
                                     \"video/mpeg\"
                          ],
                               \"Transfer-Encoding\": [
                                     \"chunked\"
                          ],
                               \"Connection\": [
                                      \"keep-alive\"
                         ],
                                \"Pragma\": \"no-cache\"
                            }
                    }
              }
          }"
          else
              tcp="null"
          fi        
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
      "enabled": $v2ray_network_mux
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