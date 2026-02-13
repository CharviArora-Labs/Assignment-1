# Implementation Steps (With Commands & Concepts)

## 1) Backend Setup (Rails)

**Terminal commands used**

```bash
cd assignment-01
rails new backend
cd backend
bundle install
bin/rails server
```

**What was created**

* A Rails application scaffolded in the `backend/` directory
* Rails boots locally on `http://localhost:3000`

**Key Rails components**

* **ApplicationController**

  * Base controller class provided by Rails
  * All custom controllers inherit from this
  * Handles shared request/response behavior

* **HealthController**

  * Custom controller created to expose backend service health
  * Inherits from `ApplicationController`
  * Returns backend availability as JSON

**Why this matters**

* Keeps health logic isolated
* Demonstrates understanding of Rails MVC fundamentals
* Enables independent backend verification

---

## 2) Frontend Setup (React)

**Terminal commands used**

```bash
cd assignment-01
npm create vite@latest frontend
cd frontend
npm install
npm run dev
```

**What was created**

* A React application in the `frontend/` directory
* Vite development server running on `http://localhost:5173`

**Purpose**

* Acts as a client to the Rails backend
* Displays backend health state visually

---

## 3) Backend Health Check

**Implementation**

* Added a `/health` route in `config/routes.rb`
* Mapped route to `HealthController#show`
* Controller action returns JSON

```ruby
# config/routes.rb
get "/health", to: "health#show"
```

```ruby
# app/controllers/health_controller.rb
class HealthController < ApplicationController
  def show
    render json: { status: "ok" }
  end
end
```

**How it was tested**

```bash
curl http://localhost:3000/health
```

**Why `curl` was used**

* Verifies backend independently of frontend
* Confirms routing + controller wiring
* Helps isolate backend failures early

---

## 4) Display Health Status in the UI

**Implementation**

* Frontend performs an HTTP request to:

  ```
  http://localhost:3000/health
  ```
* UI state updates based on success or failure

**Observed behavior**

* Backend running → UI shows healthy state
* Backend stopped → UI shows error/unhealthy state

**Why this matters**

* Confirms **cross-service communication**
* Makes backend dependency explicit in the UI
* Ensures frontend fails gracefully when backend is unavailable

---

## 5) Cross-Port Communication Issue (Observed & Resolved)

**Problem encountered**

* Backend runs on port `3000`
* Frontend runs on port `5173`
* Initial frontend requests failed due to:

  * Backend not running
  * Incorrect assumptions about service availability

**How it was diagnosed**

* Backend health endpoint tested independently using `curl`
* Frontend tested while backend was stopped
* Confirmed failures were **connection-level**, not UI bugs

**Resolution**

* Ensured backend is started before frontend requests
* Centralized startup using scripts (see next section)
* Treated backend as an external dependency rather than assuming availability

**Engineering takeaway**

* Explicit cross-port dependencies must be validated
* Health endpoints are essential for multi-service systems
* Frontend must never assume backend uptime

---

## 6) Startup and Shutdown Scripts (Process Management)

**Files added**

```
scripts/start-all.sh
scripts/stop-all.sh
scripts/backend.pid
scripts/frontend.pid
```

### Why PID files were necessary

**Problem encountered**

* Services were started in the background
* Terminal closure did not stop processes
* Manual stopping caused:

  * Orphaned processes
  * Port conflicts on re-run
  * Inconsistent system state

**Solution**

* Store process IDs (PIDs) in files
* Use PID files to reliably stop services later

---

### start-all.sh

**Responsibilities**

* Starts Rails backend on port `3000`
* Starts React frontend on port `5173`
* Runs both processes in the background
* Writes process IDs to:

  * `scripts/backend.pid`
  * `scripts/frontend.pid`
* Overwrites PID files on re-run to avoid stale data

**Key concept**

> Process lifecycle must be explicitly managed when running detached services.

---

### stop-all.sh

**Responsibilities**

* Reads PIDs from stored `.pid` files
* Terminates backend and frontend processes individually
* Prevents port conflicts
* Ensures clean shutdown
* Works even if services were started in a different terminal

---

## 7) PID Handling Bug (Observed & Fixed)

**Issue encountered**

* Backend created `tmp/pids/server.pid`
* Frontend PID was not being saved initially
* Stop script could not terminate frontend reliably

**Fix applied**

* Explicitly captured `$!` (last background PID) in `start-all.sh`
* Wrote PIDs manually into:

  * `scripts/backend.pid`
  * `scripts/frontend.pid`
* Stop script updated to read from these files

**Result**

* Both services start predictably
* Both services stop cleanly
* No orphaned processes
* No port conflicts on restart

---

## Final Result

* Backend and frontend are cleanly separated
* Backend health endpoint validates service availability
* Frontend reflects backend state correctly
* Cross-port dependency is explicitly handled
* Services start and stop using two commands
* Process lifecycle is deterministic and reproducible
* Setup works from a fresh clone without manual steps
