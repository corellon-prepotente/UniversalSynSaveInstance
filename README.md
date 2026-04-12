# UniversalSynSaveInstance

A powerful Roblox game saving tool with support for various exploits including JJsploit, Temple, Electron, and more.

## Features

- CloneRef support for exploits that don't have it or have poor implementations
- Dex Explorer with bypasses
- Full game saving (Workspace, UI, Lighting, etc.)
- Script decompilation with bytecode saving
- Nil instance saving
- Safe mode for undetected saving
- Anti-idle kick prevention
- Anonymous mode to remove user info

## Repository Structure

```
UniversalSynSaveInstance/
├── saveinstance.luau      # Main saveinstance script
├── CloneRef.lua           # CloneRef support utility
├── Bypasses.lua           # Dex bypasses
├── DexLoader.lua          # Dex Explorer loader with CloneRef support
├── examples/              # Usage examples
│   ├── basic_usage.lua
│   └── advanced_usage.lua
└── README.md             # This file
```

## Quick Start

### Basic Usage

```lua
local Params = {
    RepoURL = "https://raw.githubusercontent.com/YOUR_USERNAME/UniversalSynSaveInstance/main/",
    SSI = "saveinstance",
}

local synsaveinstance = loadstring(game:HttpGet(Params.RepoURL .. Params.SSI .. ".luau", true), Params.SSI)()

local CustomOptions = {
    mode = "full",
    SafeMode = true,
    IgnoreNotArchivable = true,
    FilePath = "My Game Save",
    AntiIdle = true,
    ShowStatus = true,
    SaveBytecode = true,
}

synsaveinstance(CustomOptions)
```

### Using CloneRef Support

```lua
-- Load CloneRef support first
loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/UniversalSynSaveInstance/main/CloneRef.lua", true))()

-- Then use saveinstance
local synsaveinstance = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/UniversalSynSaveInstance/main/saveinstance.luau", true))()

synsaveinstance({
    mode = "full",
    SafeMode = true
})
```

### Loading Dex Explorer

```lua
-- Load Dex with CloneRef support
loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/UniversalSynSaveInstance/main/DexLoader.lua", true))()
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `mode` | string | "optimized" | Saving mode: "full", "optimized", "scripts" |
| `SafeMode` | boolean | true | Kicks you before saving to prevent detection |
| `IgnoreNotArchivable` | boolean | true | Saves items even if Archivable is false |
| `FilePath` | string | auto | Custom file name for the save |
| `AntiIdle` | boolean | true | Prevents 20-minute AFK kick |
| `ShowStatus` | boolean | true | Shows progress bar on screen |
| `SaveBytecode` | boolean | false | Includes bytecode in output |
| `noscripts` | boolean | false | Disable script decompilation |
| `timeout` | number | 10 | Decompilation timeout in seconds |
| `NilInstances` | boolean | false | Save instances parented to nil |
| `IsolateLocalPlayer` | boolean | false | Save LocalPlayer separately |
| `RemovePlayerCharacters` | boolean | true | Ignore player characters |
| `IgnoreDefaultProperties` | boolean | true | Skip default property values |
| `Anonymous` | boolean/table | false | Remove user info from save |
| `ShutdownWhenDone` | boolean | false | Shutdown game after saving |

## Modes

- **full**: Saves everything (Workspace, Players, Lighting, Services, etc.)
- **optimized**: Saves only essential services (faster, smaller file)
- **scripts**: Only saves paths leading to scripts

## Examples

### Save Full Game

```lua
local synsaveinstance = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/UniversalSynSaveInstance/main/saveinstance.luau", true))()

synsaveinstance({
    mode = "full",
    SafeMode = true,
    FilePath = "Full Game Save",
    ShowStatus = true
})
```

### Save Only Scripts

```lua
local synsaveinstance = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/UniversalSynSaveInstance/main/saveinstance.luau", true))()

synsaveinstance({
    mode = "scripts",
    noscripts = false,
    FilePath = "Scripts Only"
})
```

### Save Specific Instance

```lua
local synsaveinstance = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/UniversalSynSaveInstance/main/saveinstance.luau", true))()

-- Save only Workspace
synsaveinstance(game.Workspace, {
    IsModel = true,
    FilePath = "Workspace Model"
})
```

### Anonymous Save

```lua
local synsaveinstance = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/UniversalSynSaveInstance/main/saveinstance.luau", true))()

synsaveinstance({
    mode = "full",
    Anonymous = {
        UserId = "123456",
        Name = "PlayerName"
    },
    FilePath = "Anonymous Save"
})
```

## Supported Executors

- Synapse X
- KRNL
- Fluxus
- Delta
- Solara
- JJsploit
- Temple
- Electron
- Wave
- And more...

## Discord

Join our Discord for support and updates: https://discord.gg/wx4ThpAsmw

## Credits

- Original saveinstance by Various Contributors
- CloneRef implementation by Babyhamsta
- UniversalSynSaveInstance improvements by luau

## License

This project is for educational purposes only. Use at your own risk.
