# 添加到bashrc文件中
# >>> 终端代理 >>>
function proxy_on() {
	host_ip=$(cat /etc/resolv.conf |grep "nameserver" |cut -f 2 -d " ")
    export ALL_PROXY="http://$host_ip:7890"
    echo -e "终端代理已开启。"
	}

function proxy_off(){
    unset http_proxy https_proxy
    echo -e "终端代理已关闭。"
	}
# <<< 终端代理 >>>