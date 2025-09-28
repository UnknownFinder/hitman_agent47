#!/bin/bash
SERVICE_NAME="hitman"
EXEC_FILE="${SCRIPT_DIRECTORY}/hitman2.sh"
UNIT_FILE="/etc/systemd/system/hitman.service"
echo "[Unit]" > $UNIT_FILE
echo "Description=Daemon to avoid hardware crushs" >> $UNIT_FILE
echo "After=network.service" >> $UNIT_FILE

echo "[Service]" >> $UNIT_FILE
echo "Type=simple" >> $UNIT_FILE
echo "ExecStart="$SCRIPT_DIRECTORY/hitman2.sh"" >> $UNIT_FILE
echo "Restart=always" >> $UNIT_FILE

echo "[Install]" >> $UNIT_FILE
echo "WantedBy=multi-user.target" >> $UNIT_FILE
sudo systemctl daemon-reload
sudo systemctl enable "hitman.service"
sudo systemctl start "hitman.service"
