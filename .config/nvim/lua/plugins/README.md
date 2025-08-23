# Blink.cmp Toggle Keybindings

This configuration adds custom keybindings to toggle various completion sources and features in the `blink.cmp` plugin.

## Keybindings

### Toggle Completion Sources
- `<leader>Bl` - Toggle LSP source
- `<leader>Bp` - Toggle Path source  
- `<leader>Bs` - Toggle Snippets source
- `<leader>Bb` - Toggle Buffer source
- `<leader>Bc` - Toggle Copilot source

### Toggle Features
- `<leader>Bg` - Toggle ghost text

## Commands

- `:BlinkToggleStatus` - Show current status of all toggles
- `:BlinkToggleTest` - Test plugin functionality

## Usage

1. Use any of the keybindings above to toggle the respective source or feature
2. A notification will appear showing the current state (enabled/disabled)
3. Use `:BlinkToggleStatus` to see the current state of all toggles at once
4. Use `:BlinkToggleTest` to verify the plugin is working correctly

## Implementation Details

- All toggle states are persistent during the Neovim session
- The configuration attempts to dynamically reconfigure `blink.cmp` when sources or features are toggled
- Initial state: All sources and ghost text are enabled
- If dynamic updates fail, changes will take effect on Neovim restart