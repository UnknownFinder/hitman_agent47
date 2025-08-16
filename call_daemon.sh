#!/bin/bash
sudo su
SERVICE_NAME="hitman"
EXEC_FILE="${SCRIPT_DIRECTORY}/hitman2.sh $max_cpu $max_ram"
UNIT_FILE="/etc/systemd/system/${SERVICE_NAME}.service"
echo "[Unit]" > $UNIT_FILE
echo "Description=Daemon to avoid hardware crushs" >> $UNIT_FILE
echo "After=network.service" >> $UNIT_FILE

echo "[Service]" >> $UNIT_FILE
echo "Type=exec" >> $UNIT_FILE
echo "ExecStart=$EXEC_FILE" >> $UNIT_FILE
echo "Restart=always" >> $UNIT_FILE

echo "[Install]" >> $UNIT_FILE
echo "WantedBy=multi-user.target" >> $UNIT_FILE
sudo systemctl daemon-reload
sudo systemctl enable "${SERVICE_NAME}.service"
sudo systemctl start "${SERVICE_NAME}.service"
