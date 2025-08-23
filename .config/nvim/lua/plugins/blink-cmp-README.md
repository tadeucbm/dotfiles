# Blink.cmp Custom Keybindings

This configuration adds custom keybindings for toggling various sources and features in the `blink.cmp` plugin for Neovim.

## Keybindings

### Source Toggles
- `<leader>Bl` - Toggle LSP source
- `<leader>Bp` - Toggle Path source
- `<leader>Bs` - Toggle Snippets source
- `<leader>Bb` - Toggle Buffer source
- `<leader>Bc` - Toggle Copilot source

### Feature Toggles
- `<leader>Bg` - Toggle ghost text
- `<leader>Bm` - Toggle completion menu (mini menu)

### Other Commands
- `<leader>Bt` - Toggle completion completely (fallback disable)
- `<leader>BS` - Show current status of all sources and features

## Features

- **Dynamic Configuration**: Attempts to modify blink.cmp configuration at runtime
- **State Management**: Tracks enabled/disabled state for all sources and features
- **Error Handling**: Graceful fallback when dynamic reconfiguration fails
- **User Feedback**: Notifications show current state when toggling
- **Status Display**: View current configuration with `<leader>BS`

## Implementation Details

The plugin configuration:
1. Sets up default blink.cmp options with all sources enabled
2. Provides runtime toggle functions for each source and feature
3. Stores original configuration for reliable restoration
4. Uses global functions to enable keymap access
5. Includes fallback completion disable method if dynamic config fails

## Usage

All keybindings use the `<leader>B*` pattern for easy access. Toggle any source or feature and receive immediate feedback about the new state.