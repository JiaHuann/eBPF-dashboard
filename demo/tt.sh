#!/bin/bash

# 读取/proc/meminfo文件
meminfo=$(cat /proc/meminfo)

# 提取MemTotal和MemFree的值（以kB为单位）
mem_total=$(echo "$meminfo" | grep "MemTotal:" | awk '{print $2}')
mem_free=$(echo "$meminfo" | grep "MemFree:" | awk '{print $2}')

# 计算内存使用率
mem_used=$(($mem_total - $mem_free))
mem_usage=$(echo "scale=2; $mem_used / $mem_total" | bc)

mem_usage_rounded=$(printf "%.2f" $mem_usage)
cpu_usage=$(uptime | awk -F 'load average: ' '{print $2}' | awk -F ',' '{print $1}')
# 输出内存使用率
echo "Memory usage: $mem_usage_rounded"

echo "tob_mem_using $mem_usage_rounded" | curl --data-binary @- http://134.175.197.22:9091/metrics/job/android_phone/lable/127.0.0.3

echo "tob_cpu_using $cpu_usage" | curl --data-binary @- http://134.175.197.22:9091/metrics/job/android_phone/lable/127.0.0.2
