#!/bin/bash
set -e

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PID_DIR="$ROOT_DIR/scripts"
LOG_DIR="$ROOT_DIR/scripts/logs"

mkdir -p "$PID_DIR" "$LOG_DIR"

echo "Starting assignment-01 services..."
echo "Project root: $ROOT_DIR"

#################################
# Start Rails backend
#################################
echo "Starting Rails backend..."
cd "$ROOT_DIR/backend"

nohup rails server -p 3000 \
  > "$LOG_DIR/backend.log" 2>&1 &

BACKEND_PID=$!
echo "$BACKEND_PID" > "$PID_DIR/backend.pid"

echo "Rails backend PID written to scripts/backend.pid"

#################################
# Start React frontend
#################################
echo "Starting React frontend..."
cd "$ROOT_DIR/frontend"

nohup npm run dev \
  > "$LOG_DIR/frontend.log" 2>&1 &

FRONTEND_PID=$!
echo "$FRONTEND_PID" > "$PID_DIR/frontend.pid"

echo "React frontend PID written to scripts/frontend.pid"

echo ""
echo "Services started successfully."
echo "Backend:  http://localhost:3000"
echo "Frontend: http://localhost:5173"
echo ""
echo "To stop all services:"
echo "  ./scripts/stop-all.sh"
