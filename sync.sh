#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR/vault-config/.obsidian"

usage() {
    cat <<EOF
Usage: $(basename "$0") <vault-path>

Syncs Obsidian config from <vault-path> back into this repo.

Examples:
    $(basename "$0") ~/obsidian/main
EOF
    exit 1
}

if [[ $# -ne 1 ]]; then
    usage
fi

VAULT_PATH="${1/#\~/$HOME}"

if [[ ! -d "$VAULT_PATH/.obsidian" ]]; then
    echo "Error: '$VAULT_PATH' does not look like an Obsidian vault."
    exit 1
fi

echo "Syncing config from: $VAULT_PATH"

# Sync top-level config files
for f in "$VAULT_PATH/.obsidian"/*.json; do
    fname="$(basename "$f")"
    # Skip session-specific files
    case "$fname" in
        workspace*.json) continue ;;
    esac
    cp "$f" "$CONFIG_DIR/$fname"
done

# Sync snippets
mkdir -p "$CONFIG_DIR/snippets"
cp -r "$VAULT_PATH/.obsidian/snippets/"* "$CONFIG_DIR/snippets/"

# Sync plugin data.json files
for plugin_dir in "$VAULT_PATH/.obsidian/plugins"/*/; do
    plugin_name="$(basename "$plugin_dir")"
    if [[ -f "$plugin_dir/data.json" ]]; then
        mkdir -p "$CONFIG_DIR/plugins/$plugin_name"
        cp "$plugin_dir/data.json" "$CONFIG_DIR/plugins/$plugin_name/data.json"
    fi
done

echo "Config synced to repo. Review changes and commit."
