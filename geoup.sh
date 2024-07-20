#!/bin/bash
# 该脚本从 /usr/share/xray/ 目录中删除 geoip.dat 和 geosite.dat 文件，
# 并从指定的 URL 下载这些文件的最新版本。

# 定义目标目录
target_dir="/usr/share/xray/"

# 如果目标目录不存在，则创建该目录
if [ ! -d "$target_dir" ]; then
  mkdir -p "$target_dir"
  echo "目录 $target_dir 已创建。"
fi

# 切换到目标目录
cd "$target_dir" || { echo "无法切换到目录 $target_dir。"; exit 1; }

# 删除 geoip.dat 和 geosite.dat 文件
rm -f geoip.dat
rm -f geosite.dat

# 下载最新版本的 geoip.dat 和 geosite.dat 文件
wget -O geoip.dat https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/geoip.dat
wget -O geosite.dat https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/geosite.dat

echo "geoip.dat 和 geosite.dat 已更新。"
