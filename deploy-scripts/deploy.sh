
#!/bin/bash
set -e

APP_DIR=/home/ubuntu/ml-app
VENV=/opt/ml-venv

# Install Python tools
apt-get update -y
apt-get install -y python3-venv python3-pip

# Create virtual environment only once
if [ ! -d "$VENV" ]; then
    python3 -m venv "$VENV"
fi

# Install libraries and train model
cd "$APP_DIR"
"$VENV/bin/pip" install --no-cache-dir -r requirements.txt
"$VENV/bin/python" train.py

# Create a systemd service for the Flask application
cat > /etc/systemd/system/ml-app.service <<SERVICE
[Unit]
Description=Student Result Predictor
After=network.target

[Service]
WorkingDirectory=$APP_DIR
Environment=MODEL_VERSION=1.0
ExecStart=$VENV/bin/gunicorn --workers 2 --bind 0.0.0.0:80 app:app
Restart=always
User=root

[Install]
WantedBy=multi-user.target
SERVICE

# Enable and restart the service
systemctl daemon-reload
systemctl enable ml-app
systemctl restart ml-app

echo "Student Result Predictor deployed successfully."
