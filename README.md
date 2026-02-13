# Assignment 01

Full-stack application with Rails backend and React frontend.

## Prerequisites

-Ruby 3.4.8 (2025-12-17 revision 995b59f666) +PRISM [arm64-darwin25]
-Rails 8.1.2
-Node 20.20.x
-npm 10.8.2


## Quick Start

### Option 1: Use the startup script (recommended)

```bash
# Clone the repository
git clone <repository-url>
cd assignment-01

# Start both services
./scripts/start-all.sh
```

### Option 2: Manual setup

#### Backend Setup

```bash
# Navigate to backend directory
cd backend

# Install gems
bundle install

# Start Rails server
rails server -p 3000
```

#### Frontend Setup

```bash
# Navigate to frontend directory (in a new terminal)
cd frontend

# Install npm packages
npm install

# Start development server
npm run dev
```

## Access Points

- **Frontend**: http://localhost:5173
- **Backend API**: http://localhost:3000
- **Health Check**: http://localhost:3000/health

## Project Structure

```
assignment-01/
├── backend/          # Rails API backend
│   ├── app/
│   ├── config/
│   ├── Gemfile
│   └── ...
├── frontend/         # React frontend
│   ├── src/
│   ├── public/
│   ├── package.json
│   └── ...
└── scripts/          # Utility scripts
    ├── start-all.sh
    └── stop-all.sh
```

## API Endpoints

- `GET /health` - Health check endpoint
- `GET /up` - Rails health check endpoint

## Development Notes

- The backend is configured as an API-only Rails application
- CORS is configured to allow requests from localhost:5173
- The frontend includes a health status display that calls the backend health endpoint

## Stop Services

```bash
# Stop both services
./scripts/stop-all.sh

# Or manually stop with Ctrl+C in each terminal
```
