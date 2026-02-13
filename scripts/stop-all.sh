#!/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PID_DIR="$ROOT_DIR/scripts"

echo "Stopping assignment-01 services..."

### --- Stop backend ---
if [ -f "$PID_DIR/backend.pid" ]; then
  BACKEND_PID=$(cat "$PID_DIR/backend.pid")

  if ps -p "$BACKEND_PID" > /dev/null 2>&1; then
    echo "Stopping Rails backend (PID: $BACKEND_PID)..."
    kill "$BACKEND_PID"
  else
    echo "Rails backend already stopped."
  fi

  > "$PID_DIR/backend.pid"
else
  echo "backend.pid not found."
fi

### --- Stop frontend ---
if [ -f "$PID_DIR/frontend.pid" ]; then
  FRONTEND_PID=$(cat "$PID_DIR/frontend.pid")

  if ps -p "$FRONTEND_PID" > /dev/null 2>&1; then
    echo "Stopping React frontend (PID: $FRONTEND_PID)..."
    kill "$FRONTEND_PID"
  else
    echo "React frontend already stopped."
  fi

  > "$PID_DIR/frontend.pid"
else
  echo "frontend.pid not found."
fi

echo "All services stopped."
