#!/bin/bash

# Get the current pane's process
current_process=$(tmux display-message -p '#{pane_current_command}')

# Check if nvim is running in current pane
if [[ "$current_process" == "nvim" ]]; then
    # Get all nvim PIDs related to this pane
    pane_pid=$(tmux display-message -p '#{pane_pid}')
    nvim_pids=$(pgrep -P $pane_pid nvim 2>/dev/null)
    
    # If no child nvim processes, try to find any nvim process
    if [[ -z "$nvim_pids" ]]; then
        nvim_pids=$(pgrep nvim 2>/dev/null)
    fi
    
    # Try each nvim PID to find a mode file
    for nvim_pid in $nvim_pids; do
        mode_file="/tmp/nvim_mode_$nvim_pid"
        
        if [[ -f "$mode_file" ]]; then
            mode=$(cat "$mode_file" 2>/dev/null)
            case "$mode" in
                "NORMAL") echo "#[bg=#{@thm_peach},fg=#{@thm_bg},bold] N #[default]" ;;
                "INSERT") echo "#[bg=#{@thm_peach},fg=#{@thm_bg},bold] I #[default]" ;;
                "VISUAL"|"V-LINE"|"V-BLOCK") echo "#[bg=#{@thm_peach},fg=#{@thm_bg},bold] V #[default]" ;;
                "COMMAND") echo "#[bg=#{@thm_peach},fg=#{@thm_bg},bold] C #[default]" ;;
                "REPLACE") echo "#[bg=#{@thm_peach},fg=#{@thm_bg},bold] R #[default]" ;;
                "TERMINAL") echo "#[bg=#{@thm_peach},fg=#{@thm_bg},bold] T #[default]" ;;
                *) echo "#[bg=#{@thm_peach},fg=#{@thm_bg},bold] N #[default]" ;;
            esac
            exit 0
        fi
    done
    
    # If no mode file found, default to normal mode
    echo "#[bg=#{@thm_peach},fg=#{@thm_bg},bold] N #[default]"
elif [[ "$current_process" == "vim" ]]; then
    # For regular vim, we can't easily detect mode, so show generic
    echo "#[bg=#{@thm_peach},fg=#{@thm_bg},bold] VIM #[default]"
fi