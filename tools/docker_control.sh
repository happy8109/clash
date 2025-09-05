#!/bin/bash

# 脚本名称: docker_control.sh
# 功能: 控制 Docker 容器的启动、停止、重启和状态查询。
# 用法: ./docker_control.sh <container_name> <action>
#      <container_name>:  要控制的 Docker 容器的名称。
#      <action>:          要执行的操作 (start, stop, restart, status)。

# 检查 root 权限 (可选，如果需要)
if [[ $EUID -ne 0 ]]; then
  echo "错误: 请使用 root 权限运行此脚本 (sudo)。"
  exit 1
fi

# 检查参数数量
if [ $# -ne 2 ]; then
  echo "用法: $0 <container_name> <action>"
  echo "     <action>: start, stop, restart, status"
  exit 1
fi

# 获取容器名称和操作
container_name="$1"
action="$2"

# 定义函数：检查容器状态
container_status() {
  docker inspect -f '{{.State.Status}}' "$container_name" 2>/dev/null || echo "not found"
}

# 定义函数：启动容器
start_container() {
  local current_status=$(container_status)
  if [ "$current_status" == "running" ]; then
    echo "容器 $container_name 已经在运行中。"
  elif [ "$current_status" == "not found" ]; then
    echo "容器 $container_name 未找到。"
  else
    echo "启动容器 $container_name..."
    docker start "$container_name"
    if [ $? -eq 0 ]; then
      echo "容器 $container_name 启动成功。"
    else
      echo "容器 $container_name 启动失败。"
    fi
  fi
}

# 定义函数：停止容器
stop_container() {
  local current_status=$(container_status)
  if [ "$current_status" == "running" ]; then
    echo "停止容器 $container_name..."
    docker stop "$container_name"
    if [ $? -eq 0 ]; then
      echo "容器 $container_name 停止成功。"
    else
      echo "容器 $container_name 停止失败。"
    fi
  elif [ "$current_status" == "not found" ]; then
    echo "容器 $container_name 未找到。"
  else
    echo "容器 $container_name 未运行。"
  fi
}

# 定义函数：重启容器
restart_container() {
  local current_status=$(container_status)
  if [ "$current_status" == "running" ]; then
    echo "重启容器 $container_name..."
    docker restart "$container_name"
    if [ $? -eq 0 ]; then
      echo "容器 $container_name 重启成功。"
    else
      echo "容器 $container_name 重启失败。"
    fi
  elif [ "$current_status" == "not found" ]; then
    echo "容器 $container_name 未找到。"
  else
    echo "容器 $container_name 未运行，尝试启动..."
    docker start "$container_name"
    if [ $? -eq 0 ]; then
      echo "容器 $container_name 启动成功。"
    else
      echo "容器 $container_name 启动失败。"
    fi
  fi
}

# 定义函数：查询容器状态
status_container() {
  local current_status=$(container_status)
  if [ "$current_status" == "not found" ]; then
    echo "容器 $container_name 未找到。"
  else
    echo "容器 $container_name 的状态: $current_status"
  fi
}

# 根据 action 执行相应的操作
case "$action" in
  start)
    start_container
    ;;
  stop)
    stop_container
    ;;
  restart)
    restart_container
    ;;
  status)
    status_container
    ;;
  *)
    echo "无效的操作: $action"
    echo "用法: $0 <container_name> <action>"
    echo "     <action>: start, stop, restart, status"
    exit 1
    ;;
esac

exit 0
