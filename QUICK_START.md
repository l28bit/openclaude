# OpenClaude 30-Second Quick Start

## Just Want It Working Now? Copy-Paste This

### 1. Install Node.js 22+
From: https://nodejs.org/

### 2. Install OpenClaude Globally
```powershell
npm install -g @gitlawb/openclaude@latest
```

### 3. Pick Your Provider

**Option A: Ollama (Free, Local)**
```powershell
# 1. Install Ollama first: https://ollama.com/download/windows
# 2. Download a model: ollama pull llama3.1:8b
# 3. Run this:
$env:CLAUDE_CODE_USE_OPENAI="1"
$env:OPENAI_BASE_URL="http://localhost:11434/v1"
$env:OPENAI_MODEL="llama3.1:8b"
openclaude
```

**Option B: OpenAI (Paid, Cloud)**
```powershell
$env:CLAUDE_CODE_USE_OPENAI="1"
$env:OPENAI_API_KEY="sk-your-key-here"
$env:OPENAI_MODEL="gpt-4o"
openclaude
```

### 4. Install VS Code Extension
- Open VS Code
- Extensions (Ctrl+Shift+X)
- Search: "OpenClaude"
- Click Install
- Done! You now have "Launch OpenClaude" command

---

## For Development (Build from Source)

```powershell
# Clone/navigate to repo
cd c:\Users\Circle\Documents\GitHub\openclaude

# Install Bun (one time)
npm install -g bun

# Install and build
bun install
bun run build
bun run smoke

# Run with environment
$env:CLAUDE_CODE_USE_OPENAI="1"
$env:OPENAI_BASE_URL="http://localhost:11434/v1"
$env:OPENAI_MODEL="llama3.1:8b"
bun run dev
```

---

See [SETUP_GUIDE.md](SETUP_GUIDE.md) for complete documentation.
