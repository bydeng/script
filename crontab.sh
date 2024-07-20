#!/bin/bash

# 提示用户输入需要运行的内容
echo "请输入需要运行的内容（例如：'/path/to/your/script.sh'）："
read -r command

# 判断用户输入是否为空
if [ -z "$command" ]; then
  echo "输入不能为空，请重新运行脚本并输入有效内容。"
  exit 1
fi

# 获取命令的基名称以创建日志文件名
logfile=$(basename "$command")
logfile="/var/log/${logfile}.log"

# 提示用户选择定时任务类型
echo "请选择定时任务类型："
echo "1. 开机后运行"
echo "2. 自定义时间"

read -r choice

case $choice in
  1)
    # 添加开机后运行的定时任务到crontab
    (crontab -l 2>/dev/null; echo "@reboot $command > $logfile 2>&1") | crontab -
    if [ $? -eq 0 ]; then
      echo "已成功添加开机后运行的定时任务。日志文件：$logfile"
    else
      echo "添加开机后运行的定时任务失败，请手动添加。"
    fi
    ;;
  2)
    # 提示用户选择运行频率
    echo "请选择运行频率："
    echo "1. 每月"
    echo "2. 每周"
    echo "3. 每天"

    read -r frequency

    # 提示用户输入小时和分钟
    echo "请输入小时（0-23）："
    read -r hour
    echo "请输入分钟（0-59）："
    read -r minute

    # 验证小时和分钟是否有效
    if ! [[ "$hour" =~ ^[0-9]+$ ]] || [ "$hour" -lt 0 ] || [ "$hour" -gt 23 ]; then
      echo "无效的小时，请重新运行脚本并输入有效的小时（0-23）。"
      exit 1
    fi

    if ! [[ "$minute" =~ ^[0-9]+$ ]] || [ "$minute" -lt 0 ] || [ "$minute" -gt 59 ]; then
      echo "无效的分钟，请重新运行脚本并输入有效的分钟（0-59）。"
      exit 1
    fi

    case $frequency in
      1)
        # 每月运行
        custom_cron="$minute $hour 1 * *"
        ;;
      2)
        # 每周运行
        echo "请输入星期几运行（0-6，其中0代表星期天）："
        read -r day_of_week
        if ! [[ "$day_of_week" =~ ^[0-6]$ ]]; then
          echo "无效的星期几，请重新运行脚本并输入有效的值（0-6）。"
          exit 1
        fi
        custom_cron="$minute $hour * * $day_of_week"
        ;;
      3)
        # 每天运行
        custom_cron="$minute $hour * * *"
        ;;
      *)
        echo "无效的选择。"
        exit 1
        ;;
    esac

    # 添加自定义时间的定时任务到crontab
    (crontab -l 2>/dev/null; echo "$custom_cron $command > $logfile 2>&1") | crontab -
    if [ $? -eq 0 ]; then
      echo "已成功添加自定义时间的定时任务。日志文件：$logfile"
    else
      echo "添加自定义时间的定时任务失败，请手动添加。"
    fi
    ;;
  *)
    echo "无效的选择。"
    exit 1
    ;;
esac

exit 0
