#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR/vault-config/.obsidian"

usage() {
    cat <<EOF
Usage: $(basename "$0") <vault-path>

Applies this Obsidian configuration to the vault at <vault-path>.

Examples:
    $(basename "$0") ~/obsidian/main
    $(basename "$0") /path/to/my/vault

What it does:
    1. Backs up existing .obsidian config (if any) to .obsidian.bak
    2. Copies all config files, snippets, and plugin settings
    3. Lists community plugins that need manual installation
EOF
    exit 1
}

if [[ $# -ne 1 ]]; then
    usage
fi

VAULT_PATH="${1/#\~/$HOME}"

if [[ ! -d "$VAULT_PATH" ]]; then
    echo "Error: Vault path '$VAULT_PATH' does not exist."
    echo "Create the vault first in Obsidian, then run this script."
    exit 1
fi

if [[ ! -d "$VAULT_PATH/.obsidian" ]]; then
    echo "Error: '$VAULT_PATH' does not look like an Obsidian vault (no .obsidian directory)."
    echo "Open this folder as a vault in Obsidian first, then run this script."
    exit 1
fi

echo "Applying Obsidian config to: $VAULT_PATH"

# Backup existing config
if [[ -d "$VAULT_PATH/.obsidian.bak" ]]; then
    rm -rf "$VAULT_PATH/.obsidian.bak"
fi
if [[ -d "$VAULT_PATH/.obsidian" ]]; then
    cp -r "$VAULT_PATH/.obsidian" "$VAULT_PATH/.obsidian.bak"
    echo "Backed up existing config to .obsidian.bak"
fi

# Copy top-level config files
for f in "$CONFIG_DIR"/*.json; do
    fname="$(basename "$f")"
    # Skip workspace files - those are session-specific
    if [[ "$fname" == workspace*.json ]]; then
        continue
    fi
    cp "$f" "$VAULT_PATH/.obsidian/$fname"
done

# Copy snippets
mkdir -p "$VAULT_PATH/.obsidian/snippets"
cp -r "$CONFIG_DIR/snippets/"* "$VAULT_PATH/.obsidian/snippets/"

# Copy plugin data.json files
for plugin_dir in "$CONFIG_DIR/plugins"/*/; do
    plugin_name="$(basename "$plugin_dir")"
    if [[ -f "$plugin_dir/data.json" ]]; then
        mkdir -p "$VAULT_PATH/.obsidian/plugins/$plugin_name"
        cp "$plugin_dir/data.json" "$VAULT_PATH/.obsidian/plugins/$plugin_name/data.json"
    fi
done

echo ""
echo "Config applied successfully!"
echo ""

# List community plugins that need manual installation
if [[ -f "$CONFIG_DIR/community-plugins.json" ]]; then
    plugins=$(python3 -c "import json; print('\n  '.join(json.load(open('$CONFIG_DIR/community-plugins.json'))))" 2>/dev/null || echo "")
    if [[ -n "$plugins" ]]; then
        echo "Community plugins to install manually in Obsidian:"
        echo "  Settings > Community Plugins > Browse > Install"
        echo ""
        echo "  $plugins"
        echo ""
        echo "After installing each plugin, restart Obsidian so the data.json settings take effect."
    fi
fi

echo "Done."
