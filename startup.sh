#!/bin/bash
cmd=$1
if [ "$2" ]; then
  port=$2
else
  port=8188
fi
# shellcheck disable=SC2164
if [ ! -d "log" ]; then
  mkdir log
fi
source venv/bin/activate

if [ "$cmd" = "start" ]; then
  nohup python main.py --force-fp16 --dont-upcast-attention --preview-method auto --port "$port" >log/comfy.log 2>&1 &
elif [ "$cmd" = "stop" ]; then
  ps -ef | grep "main.py" | grep -v "grep" | grep "$port" | awk '{print $2}' | xargs kill
elif [ "$cmd" = "restart" ]; then
  ps -ef | grep "main.py" | grep -v "grep" | grep "$port" | awk '{print $2}' | xargs kill
  nohup python main.py --force-fp16 --dont-upcast-attention --preview-method auto --port "$port" >log/comfy.log 2>&1 &
else
  echo "unknown command $cmd"
  exit 1
fi
