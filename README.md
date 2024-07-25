# clash rule

https://github.com/ACL4SSR/ACL4SSR/tree/master/Clash
https://github.com/blackmatrix7/ios_rule_script/tree/master/rule/Clash

subconverter后端 Docker安装：
安装命令：
docker run -d --restart=always -p 25500:25500 tindy2013/subconverter:latest
检查命令：（SSH连接openwrt执行命令）
curl http://localhost:25500/version
如果出现 subconverter vx.x.x backend 则说明容器已经成功运行。
如果容器无法启动  重启docker ！
http://localhost:25500/sub   openwrt本机docker地址
https://sub.qichiyu.com/sub  VPS 域名反代 地址
http://192.168.10.5:25500/sub 局域网其他设备地址
