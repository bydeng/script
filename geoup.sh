#!/bin/bash
# This script removes geoip.dat and geosite.dat files from /usr/share/xray/ directory and downloads the latest versions of these files from https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/
# The script should be run every day at 3:00 AM

# Change directory to /usr/share/xray/
cd /usr/share/xray/

# Remove geoip.dat and geosite.dat files
rm geoip.dat
rm geosite.dat

# Download the latest versions of geoip.dat and geosite.dat files
wget https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/geoip.dat
wget https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/geosite.dat
