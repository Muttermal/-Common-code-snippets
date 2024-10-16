# 使用官方的 Python 基础镜像
FROM python:3.11.9-slim-bullseye

RUN apt-get update && \
    apt-get install -y vim procps && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 设置工作目录
WORKDIR /app

# 将 requirements.txt 复制到工作目录
COPY requirements.txt .

# 安装依赖包
RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
RUN pip install --no-cache-dir -r requirements.txt

CMD ["/bin/bash"]