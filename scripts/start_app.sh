#!/bin/bash
set -e
cd /opt/student-app

docker build -t student-app:latest .

VERSION=$(grep -oP 'MODEL_VERSION\s*=\s*"\K[^"]+' app.py | head -n 1)
if [ -z "$VERSION" ]; then
  echo "Could not read MODEL_VERSION from app.py"
  exit 1
fi

docker run -d \
  --name student-app \
  --restart unless-stopped \
  -p 80:5000 \
  -e MODEL_VERSION="$VERSION" \
  student-app:latest

sleep 3
if ! docker ps --filter "name=student-app" --filter "status=running" | grep -q student-app; then
  docker logs student-app || true
  exit 1
fi
