# OpenClaude Complete Setup Guide

Complete copy/paste instructions to get OpenClaude CLI and VS Code extension working on Windows.

---

## Part 1: Prerequisites (One-Time Setup)

### Step 1: Install Node.js 22+

1. Download Node.js 22 LTS from: https://nodejs.org/
2. Run the installer and follow the default options
3. Open PowerShell and verify:

```powershell
node --version
npm --version
```

You should see version 22 or higher for Node.js.

### Step 2: Install Bun (For Development Only)

If you're just using the CLI, skip this. Install Bun only if you want to build from source or contribute.

```powershell
npm install -g bun
```

Verify:

```powershell
bun --version
```

---

## Part 2: Run Pre-Built CLI (Fastest Option)

### Install Globally

Simply install and run:

```powershell
npm install -g @gitlawb/openclaude@latest
```

Verify:

```powershell
openclaude --version
```

### Pick a Provider and Run

Choose ONE option below and run the code:

#### Option A: OpenAI (GPT-4, GPT-4o)

```powershell
$env:CLAUDE_CODE_USE_OPENAI="1"
$env:OPENAI_API_KEY="sk-your-actual-key"
$env:OPENAI_MODEL="gpt-4o"

openclaude
```

#### Option B: DeepSeek

```powershell
$env:CLAUDE_CODE_USE_OPENAI="1"
$env:OPENAI_API_KEY="sk-your-deepseek-key"
$env:OPENAI_BASE_URL="https://api.deepseek.com/v1"
$env:OPENAI_MODEL="deepseek-v4-flash"

openclaude
```

#### Option C: Ollama (Local - Free)

1. Install Ollama: https://ollama.com/download/windows
2. Open PowerShell and run:

```powershell
ollama pull llama3.1:8b
```

3. Keep Ollama running, open another PowerShell tab:

```powershell
$env:CLAUDE_CODE_USE_OPENAI="1"
$env:OPENAI_BASE_URL="http://localhost:11434/v1"
$env:OPENAI_MODEL="llama3.1:8b"

openclaude
```

#### Option D: LM Studio (Local - Free)

1. Install LM Studio: https://lmstudio.ai/
2. In LM Studio: Download a model (e.g., Llama 3.1 8B)
3. Go to "Developer" tab and enable the server
4. Open PowerShell:

```powershell
$env:CLAUDE_CODE_USE_OPENAI="1"
$env:OPENAI_BASE_URL="http://localhost:1234/v1"
$env:OPENAI_MODEL="llama3.1:8b"

openclaude
```

---

## Part 3: Build from Source & Local Development

### Clone and Setup

```powershell
cd c:\Users\Circle\Documents\GitHub\openclaude
bun install
```

### Build the CLI

```powershell
bun run build
```

Verify the build:

```powershell
bun run smoke
```

### Run Locally

Using Ollama (free local option):

```powershell
$env:CLAUDE_CODE_USE_OPENAI="1"
$env:OPENAI_BASE_URL="http://localhost:11434/v1"
$env:OPENAI_MODEL="llama3.1:8b"

bun run dev
```

Or with OpenAI:

```powershell
$env:OPENAI_API_KEY="sk-your-key"
$env:OPENAI_MODEL="gpt-4o"

bun run dev
```

### Run Tests

```powershell
# Quick smoke test
bun run smoke

# All tests (single concurrency, matches CI)
bun run test:full

# Provider-specific tests
bun run test:provider

# Type checking
bun run typecheck
```

---

## Part 4: VS Code Extension Setup

### Option A: Use Pre-Built Extension (Easiest)

1. Install the CLI globally first (see Part 2)
2. Open VS Code
3. Go to Extensions (Ctrl+Shift+X)
4. Search for "OpenClaude" by devnull-bootloader
5. Click Install
6. Reload VS Code
7. Open Command Palette (Ctrl+Shift+P)
8. Run: `OpenClaude: Open Control Center`

That's it! You can now:
- Click "Launch OpenClaude" to start the CLI
- Use the Control Center to see status
- Use other commands from the palette

### Option B: Develop Extension Locally

#### Setup

1. Navigate to the extension folder:

```powershell
cd c:\Users\Circle\Documents\GitHub\openclaude\vscode-extension\openclaude-vscode
```

2. Install dependencies:

```powershell
npm install
```

3. Run tests (optional):

```powershell
npm run test
npm run lint
```

#### Run in Debug Mode

1. In VS Code, open the extension folder:
   - File → Open Folder
   - Select: `c:\Users\Circle\Documents\GitHub\openclaude\vscode-extension\openclaude-vscode`

2. Click on the "Run and Debug" icon (or Ctrl+Shift+D)

3. Select "Run Extension" from the dropdown

4. A new VS Code window opens with the extension loaded

5. In the new window:
   - Open Command Palette (Ctrl+Shift+P)
   - Run: `OpenClaude: Open Control Center`
   - Test the features

#### Reload After Changes

1. Make your changes to the extension files
2. Press `Ctrl+Shift+F5` in the debug window to reload the extension
3. Test your changes

#### Package Extension (Optional)

To create a `.vsix` file for distribution:

```powershell
cd c:\Users\Circle\Documents\GitHub\openclaude\vscode-extension\openclaude-vscode
npm run package
```

The `.vsix` file will be in that folder.

---

## Part 5: Verification Checklist

### CLI is Working

```powershell
openclaude --version
# Should show version like: 0.20.0 (or current version)
```

### VS Code Extension is Installed

- Open VS Code
- Look for the OpenClaude icon in the Activity Bar (left sidebar)
- Or press Ctrl+Shift+P and search for "OpenClaude"

### Can Launch CLI from VS Code

1. Open VS Code
2. Open a project folder
3. Press Ctrl+Shift+P
4. Type "OpenClaude: Launch in Terminal"
5. A terminal should open with OpenClaude running

### Dev Build Works

```powershell
bun run check
```

This runs smoke test + all tests. Should pass.

---

## Part 6: Environment Variables (Save Them)

### Windows (Permanent Setup)

Instead of typing them every time, add them to Windows Environment Variables:

1. Press `Win+R`, type `sysdm.cpl`, press Enter
2. Click "Environment Variables" button (bottom right)
3. Click "New" under "User variables"
4. Add these (one at a time):

```
Variable: CLAUDE_CODE_USE_OPENAI
Value:    1

Variable: OPENAI_API_KEY
Value:    sk-your-actual-key

Variable: OPENAI_MODEL
Value:    gpt-4o
```

5. Click OK, restart PowerShell/VS Code
6. Now just run: `openclaude`

### PowerShell Profile (Optional)

Create a profile file that sets variables automatically:

1. Open PowerShell
2. Run:

```powershell
$PROFILE | Select-Object -ExpandProperty CurrentUserCurrentHost
# Note the path shown
```

3. Create/edit that file (e.g., in Notepad):

```powershell
$env:CLAUDE_CODE_USE_OPENAI="1"
$env:OPENAI_API_KEY="sk-your-actual-key"
$env:OPENAI_MODEL="gpt-4o"
```

4. Save and reload PowerShell

---

## Troubleshooting

### "openclaude not found" or "command not found"

- **CLI not installed**: Run `npm install -g @gitlawb/openclaude@latest` again
- **PATH issue**: Close and reopen PowerShell
- **Check installation**: `npm list -g @gitlawb/openclaude`

### Extension not appearing in VS Code

- Reload VS Code (Ctrl+R)
- Check if `openclaude` command works in terminal first
- Check VS Code version: must be 1.95 or higher

### CLI starts but says "ripgrep not found"

Install ripgrep system-wide:

```powershell
# Using Chocolatey
choco install ripgrep

# Or download from: https://github.com/BurntSushi/ripgrep/releases
# Then add to PATH
```

Verify:

```powershell
rg --version
```

### Ollama connection issues

- Ensure Ollama is running (check system tray)
- Test Ollama: `curl http://localhost:11434/api/tags`
- Keep Ollama window open while using OpenClaude

### Build fails with "bun not found"

```powershell
npm install -g bun
# Then retry: bun run build
```

### Tests fail

Run a single test file:

```powershell
bun test ./path/to/test-file.test.ts
```

Check runtime diagnostics:

```powershell
bun run doctor:runtime
```

---

## Quick Reference Commands

```powershell
# Global Install
npm install -g @gitlawb/openclaude@latest

# Run CLI
openclaude

# Development Build
bun install
bun run build
bun run dev
bun run smoke

# Tests
bun run test:full
bun run typecheck

# VS Code Extension
npm run test       # in vscode-extension folder
npm run lint
npm run package
```

---

## What's Next?

1. **Start using OpenClaude**: Run `openclaude` and try a prompt
2. **Read the docs**: https://github.com/Gitlawb/openclaude
3. **Configure providers**: Use `/provider` command to save profiles
4. **Setup profiles**: Create `.openclaude-profile.json` in your project
5. **Customize VS Code theme**: Use the "OpenClaude Terminal Black" theme

---

## Support

- **Issues**: https://github.com/Gitlawb/openclaude/issues
- **Discussions**: https://github.com/Gitlawb/openclaude/discussions
- **Discord**: https://discord.gg/k68zFR6AcB

