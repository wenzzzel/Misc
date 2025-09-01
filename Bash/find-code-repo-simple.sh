#!/bin/bash

# find-code-repo-simple.sh - Simplified bash version
# Add this to your .bashrc or source it

fcr() {
    local filter="$1"
    local force_refresh=false
    
    [[ -z "$filter" ]] && { echo "Usage: fcr <filter> [--force-refresh]"; return 1; }
    [[ "$2" == "--force-refresh" || "$2" == "-f" ]] && force_refresh=true
    
    local repo_root="$HOME/Source/Misc/Bash"  # Adjust this path as needed
    local repos_file="$repo_root/githubrepos.json"
    local state_file="$repo_root/state.json"
    
    # Create files if they don't exist
    [[ ! -f "$repos_file" ]] && touch "$repos_file"
    [[ ! -f "$state_file" ]] && echo '{}' > "$state_file"
    
    local current_week="$(date +%Y-%V)"
    local last_sync_week=""
    
    # Get last sync week from state file
    if command -v jq >/dev/null 2>&1 && [[ -s "$state_file" ]]; then
        last_sync_week=$(jq -r '.LastGithubReposSyncWeek // ""' "$state_file" 2>/dev/null)
    fi
    
    # Check if refresh is needed
    if [[ "$force_refresh" == false ]] && [[ "$last_sync_week" == "$current_week" ]] && [[ -s "$repos_file" ]]; then
        # Return cached results
        if command -v jq >/dev/null 2>&1; then
            jq -r ".[] | select(.name | test(\".*$filter.*\"; \"i\")) | .name" "$repos_file" 2>/dev/null
        else
            grep -i "$filter" "$repos_file" | sed 's/.*"name": *"\([^"]*\)".*/\1/'
        fi
        return 0
    fi
    
    # Refresh repos
    echo "⏳ Updating GitHub repos cache..."
    
    if ! command -v gh >/dev/null 2>&1; then
        echo "Error: GitHub CLI (gh) not found"
        return 1
    fi
    
    # Fetch and save repos
    if gh repo list volvo-cars --limit 99999 --json name --jq '.[] | select(.name | startswith("grip"))' > "$repos_file"; then
        echo "✔️ Repos updated successfully!"
        
        # Update state
        if command -v jq >/dev/null 2>&1; then
            jq --arg week "$current_week" '.LastGithubReposSyncWeek = $week' "$state_file" > "${state_file}.tmp" && mv "${state_file}.tmp" "$state_file"
        fi
        
        # Return filtered results
        if command -v jq >/dev/null 2>&1; then
            jq -r ".[] | select(.name | test(\".*$filter.*\"; \"i\")) | .name" "$repos_file"
        else
            grep -i "$filter" "$repos_file" | sed 's/.*"name": *"\([^"]*\)".*/\1/'
        fi
    else
        echo "Error: Failed to fetch repositories"
        return 1
    fi
}
