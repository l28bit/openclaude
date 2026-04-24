# OpenClaude VS Code Extension

A VS Code companion for OpenClaude with a **Control Center**, **terminal launch**, **Microsoft Foundry / Azure OpenAI** settings, and the **OpenClaude Terminal Black** theme.

## Install into VS Code

### Option A — Run from this repo (recommended for development)

1. Open the extension folder in VS Code: **File → Open Folder…** and choose `vscode-extension/openclaude-vscode`.
2. Press **F5** (Run Extension). A new **Extension Development Host** window opens with this extension loaded.
3. In that window, use the **OpenClaude** activity bar icon or **View → Open View… → OpenClaude → Control Center**.

### Option B — Install a VSIX package

From `vscode-extension/openclaude-vscode`:

```bash
npm run package
```

Then in your main VS Code: **Extensions** → **…** menu → **Install from VSIX…** and select the generated `.vsix`.

## Requirements

- VS Code `1.95+`
- `openclaude` on your `PATH` (for example `npm install -g @gitlawb/openclaude`)

## Microsoft Foundry / Azure OpenAI (chat)

OpenClaude’s OpenAI shim supports Azure-style chat completions (`api-key` header, `api-version`, deployment path). The extension can inject these into the integrated terminal when you launch.

### Quick setup (wizard)

1. Command Palette (**Ctrl+Shift+P** / **Cmd+Shift+P**).
2. Run **OpenClaude: Configure Azure / Foundry Chat (wizard)**.
3. Enter in order:
   - **API endpoint** — resource base URL only (no `api-version` query). Example: `https://YOUR_RESOURCE.openai.azure.com`
   - **API version** — matches your deployment (for example `2024-12-01-preview`)
   - **Deployment / model** — the Azure **deployment name** (this becomes `OPENAI_MODEL` for the shim)
   - **API key** — stored in **VS Code Secret Storage** (not in `settings.json`)

4. Launch with **OpenClaude: Launch in Terminal** or the Control Center **Launch OpenClaude** button.

### Manual settings

Open **Settings** and search for `openclaude.azure`, or use **OpenClaude: Open Azure / Foundry Settings**.

| Setting | Maps to |
|--------|---------|
| `openclaude.azure.enabled` | Turn injection on for launched terminals |
| `openclaude.azure.endpoint` | `OPENAI_BASE_URL` |
| `openclaude.azure.apiVersion` | `AZURE_OPENAI_API_VERSION` |
| `openclaude.azure.deployment` | `OPENAI_MODEL` (deployment name) |
| `openclaude.azure.forceAzureUrlStyle` | `OPENAI_AZURE_STYLE=1` (recommended for Foundry) |

Set the key with **OpenClaude: Set Azure / Foundry API Key (Secret Storage)** (preferred), or `openclaude.azure.apiKey` in settings only if you accept storing a key in plain settings.

### Notes

- When Azure injection is **enabled** and complete, the extension sets `CLAUDE_CODE_USE_OPENAI=1` for that terminal so the OpenAI shim is used.
- If you rely on `.openclaude-profile.json` in the project folder instead, leave `openclaude.azure.enabled` **false** and use the profile alone (avoid double-configuring).

## Commands

- `OpenClaude: Open Control Center`
- `OpenClaude: Launch in Terminal`
- `OpenClaude: Open Repository`
- `OpenClaude: Configure Azure / Foundry Chat (wizard)`
- `OpenClaude: Set Azure / Foundry API Key (Secret Storage)`
- `OpenClaude: Clear Azure / Foundry API Key`
- `OpenClaude: Open Azure / Foundry Settings`

## Settings

- `openclaude.launchCommand` (default: `openclaude`)
- `openclaude.terminalName` (default: `OpenClaude`)
- `openclaude.useOpenAIShim` (default: `false`) — optional `CLAUDE_CODE_USE_OPENAI=1` when not using Azure injection or a saved profile
- `openclaude.azure.*` — Foundry / Azure OpenAI chat (see above)

## Development

From this folder:

```bash
npm run lint
```

To package:

```bash
npm run package
```
