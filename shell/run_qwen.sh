#!/bin/bash
export CUDA_VISIBLE_DEVICES=0
model_path=../Qwen-14B-Chat-Int4
host=0.0.0.0
fastchat_port=21001
vllm_port=21002
web_port=7080

if pgrep -f "fastchat.serve.controller" > /dev/null
then
   	echo "fastchat.serve.controller程序已经在运行."
	echo "CUDA_VISIBLE_DEVICES: $CUDA_VISIBLE_DEVICES"
	nohup python -m fastchat.serve.vllm_worker --model-path $model_path \
	--num-gpus 1 \
	--controller-address http://$host:$fastchat_port \
	--worker-address http://$host:$vllm_port \
	--host $host \
	--port $vllm_port \
	--trust-remote-code \
	--tensor-parallel-size 1 \
	--enforce-eager > vllm_server.log 2>&1 &
else
	echo "CUDA_VISIBLE_DEVICES: $CUDA_VISIBLE_DEVICES"
	nohup python -m fastchat.serve.controller --host $host --port $fastchat_port & python -m fastchat.serve.vllm_worker --model-path $model_path \
	--num-gpus 1 \
	--controller-address http://$host:$fastchat_port \
	--worker-address http://$host:$vllm_port \
	--host $host \
	--port $vllm_port \
	--trust-remote-code \
	--tensor-parallel-size 1 \
	--enforce-eager > vllm_server.log 2>&1 &
fi

sleep 5
while :; do
    echo "waiting"
    if [ -z `tail -1 vllm_server.log | grep "Uvicorn running on http://0.0.0.0:21002 (Press CTRL+C to quit)"` ]; then
        sleep 5
    else
        uvicorn llm_application:my_app  --host $host --port $web_port
    fi
done
