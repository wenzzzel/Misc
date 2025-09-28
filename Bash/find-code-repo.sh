#!/bin/bash

# find-code-repo.sh - Bash version of Find-CodeRepo PowerShell function
# Usage: find-code-repo.sh <filter> [--force-refresh]

find_code_repo() {
    local filter="$1"
    local force_refresh=false

    if ! dpkg -l | grep -q "gh"; then
		echo -e "⚠️  \e[1;31mERROR: Install gh CLI to use this script!\e[0m"
        return;
    fi

    # Parse arguments
    if [[ -z "$filter" ]]; then
        echo "Error: Filter parameter is required"
        echo "Usage: find_code_repo <filter> [--force-refresh]"
        return 1
    fi
    
    # Check for force refresh flag
    if [[ "$2" == "--force-refresh" ]] || [[ "$2" == "-f" ]]; then
        force_refresh=true
    fi
    
    # Get the script directory (equivalent to $thisRepoRootDir)
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local repo_root_dir="$(dirname "$script_dir")"
    
    local githubrepos_file_path="$repo_root_dir/githubrepos.json"
    local state_path="$repo_root_dir/state.json"
    
    # Create githubrepos.json if it doesn't exist
    if [[ ! -f "$githubrepos_file_path" ]]; then
        echo -e "\033[34mNo githubrepos.json found @ $githubrepos_file_path . Creating it...\033[0m"
        sudo touch "$githubrepos_file_path"
    fi
    
    # Create state.json if it doesn't exist
    if [[ ! -f "$state_path" ]]; then
        echo -e "\033[34mNo state.json found @ $state_path . Creating it...\033[0m"
        sudo touch "$state_path"
        echo '{}' | sudo tee "$state_path"
    fi
    
    # Get current date and week
    local current_date=$(date +%Y-%m-%d)
    local current_year=$(date +%Y)
    local current_week=$(date +%V)
    local current_week_key="${current_year}-${current_week}"
    
    # Read state file
    local last_sync_week=""
    if [[ -s "$state_path" ]]; then
        last_sync_week=$(jq -r '.LastGithubReposSyncWeek // ""' "$state_path" 2>/dev/null || echo "")
    fi
    
    # Check if we need to refresh
    if [[ "$force_refresh" == false ]] && [[ "$last_sync_week" == "$current_week_key" ]] && [[ -s "$githubrepos_file_path" ]]; then
        # Return filtered results from cache
        if command -v jq >/dev/null 2>&1; then
            jq -r ".[] | select(.name | test(\".*$filter.*\"; \"i\")) | .name" "$githubrepos_file_path" 2>/dev/null || {
                grep -i "$filter" "$githubrepos_file_path" | sed 's/.*"name": *"\([^"]*\)".*/\1/'
            }
        else
            grep -i "$filter" "$githubrepos_file_path" | sed 's/.*"name": *"\([^"]*\)".*/\1/'
        fi
        return 0
    fi
    
    echo " ⏳ Github repos hasn't been updated this week. Need to update. This will take a while. Please be patient!"
    
    # Check if gh CLI is available
    if ! command -v gh >/dev/null 2>&1; then
        echo "Error: GitHub CLI (gh) is not installed or not in PATH"
        return 1
    fi
    
    # Fetch GitHub repos using gh CLI
    local github_repos
    github_repos=$(gh repo list volvo-cars --limit 99999 --json name --jq '.[] | select(.name | startswith("grip"))')
    
    if [[ $? -ne 0 ]]; then
        echo "Error: Failed to fetch GitHub repositories"
        return 1
    fi
    
    # Save to file as JSON array
    echo "$github_repos" | sudo tee "$githubrepos_file_path" > /dev/null
    
    echo " ✔️ Github repos updated successfully! Caching until next week."
    
    # Update state file
    local state_content
    if [[ -s "$state_path" ]]; then
        state_content=$(cat "$state_path")
    else
        state_content='{}'
    fi
    
    # Update the LastGithubReposSyncWeek field
    if command -v jq >/dev/null 2>&1; then
        echo "$state_content" | jq --arg week "$current_week_key" '.LastGithubReposSyncWeek = $week' | sudo tee "$state_path" > /dev/null
    else
        # Fallback if jq is not available
        if grep -q "LastGithubReposSyncWeek" "$state_path"; then
            sed -i "s/\"LastGithubReposSyncWeek\"[^,}]*/\"LastGithubReposSyncWeek\": \"$current_week_key\"/" "$state_path"
        else
            # Add the field to the JSON object
            sed -i 's/{/{"LastGithubReposSyncWeek": "'"$current_week_key"'",/' "$state_path"
            sed -i 's/,}/}/' "$state_path"
        fi
    fi
    
    # Return filtered results
    if command -v jq >/dev/null 2>&1; then
        jq -r ".[] | select(.name | test(\".*$filter.*\"; \"i\")) | .name" "$githubrepos_file_path" 2>/dev/null || {
            grep -i "$filter" "$githubrepos_file_path" | sed 's/.*"name": *"\([^"]*\)".*/\1/'
        }
    else
        grep -i "$filter" "$githubrepos_file_path" | sed 's/.*"name": *"\([^"]*\)".*/\1/'
    fi
}

# Create alias equivalent
alias fcr='find_code_repo'

# If script is called directly (not sourced), run the function
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    find_code_repo "$@"
fi
