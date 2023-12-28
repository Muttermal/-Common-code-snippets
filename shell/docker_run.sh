#!/bin/bash

# 定义 Docker 镜像名称和容器名称
DOCKER_IMAGE="nvcr.io/nvidia/pytorch:23.10-py3"
CONTAINER_NAME="nvidia_pytorch"

# 检测 Docker 镜像是否存在
if sudo docker image inspect "$DOCKER_IMAGE" &> /dev/null; then
    # 镜像存在，检查容器是否在运行
    if sudo docker ps -q -f name="$CONTAINER_NAME" | grep -q .; then
        # 容器在运行状态，进入容器
        echo "Docker 镜像 $DOCKER_IMAGE 存在且容器 $CONTAINER_NAME 在运行状态，正在进入容器..."
        sudo docker exec -it "$CONTAINER_NAME" /bin/bash
    else
        # 容器不在运行状态，启动并进入容器
        echo "Docker 镜像 $DOCKER_IMAGE 存在但容器 $CONTAINER_NAME 不在运行状态，正在启动并进入容器..."
        sudo docker start "$CONTAINER_NAME" && sudo docker exec -it "$CONTAINER_NAME" /bin/bash
    fi
else
    # 镜像不存在，创建并进入容器
    echo "Docker 镜像 $DOCKER_IMAGE 不存在，正在创建并进入容器..."
    sudo docker run -it --gpus all --ipc host -v /home/nlp/zgy:/workspace/zhanggy --name "$CONTAINER_NAME" --privileged "$DOCKER_IMAGE" /bin/bash
	pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
	
fi
