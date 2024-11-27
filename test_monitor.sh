#!/bin/bash

#Переменные
LOG_FILE="/var/log/monitoing.log"
MONITORING_URL="https://test.com/monitoring/test/api"
PROCESS_NAME="test"

#Проверка запущен ли процесс
if pgrep -x "$PROCESS_NAME" > /dev/null; then
	#Пытаемся стучаться на сервер
	if ! curl -s --head --request GET "$MONITORING_URL" | grep "200 OK" > /dev/null; then
		echo "$(date): Сервер недоступен" >> "$LOG_FILE"
	fi
	
	PID_FILE="/var/run/${PROCESS_NAME}_monitor.pid"
	CURRENT_PID=$(pgrep -x "PROCESS_NAME")

	if [ ! -f "PID_FILE" ] || [ "$(cat "PID_FILE")" != "$CURRENT_PID" ]; then
		echo "$CURRENT_PID" > "$PID_FILE"
		echo "$(date): Процесс '$PROCESS_NAME' был перезапущен (PID: $CURRENT_PID)" >> "$LOG_FILE"
	fi
fi