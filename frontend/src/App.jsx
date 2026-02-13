import { useState, useEffect } from 'react'
import reactLogo from './assets/react.svg'
import viteLogo from '/vite.svg'
import './App.css'

function App() {
  const [count, setCount] = useState(0)
  const [health, setHealth] = useState(null)
  const [healthError, setHealthError] = useState(null)

  useEffect(() => {
    fetch('http://127.0.0.1:3000/health')
      .then(response => response.json())
      .then(data => setHealth(data))
      .catch(error => setHealthError(error.message))
  }, [])

  return (
    <>
      <div>
        <a href="https://vite.dev" target="_blank">
          <img src={viteLogo} className="logo" alt="Vite logo" />
        </a>
        <a href="https://react.dev" target="_blank">
          <img src={reactLogo} className="logo react" alt="React logo" />
        </a>
      </div>
      <h1>Vite + React</h1>
      <div className="card">
        <button onClick={() => setCount((count) => count + 1)}>
          count is {count}
        </button>
        <p>
          Edit <code>src/App.jsx</code> and save to test HMR
        </p>
      </div>
      <div className="health-status">
        <h3>Health Check</h3>
        {healthError ? (
          <p style={{ color: 'red' }}>Error: {healthError}</p>
        ) : health ? (
          <div>
            <p>Status: <span style={{ color: 'green' }}>{health.status}</span></p>
            <p>Timestamp: {health.timestamp}</p>
          </div>
        ) : (
          <p>Loading...</p>
        )}
      </div>
      <p className="read-the-docs">
        Click on the Vite and React logos to learn more
      </p>
    </>
  )
}

export default App
