# Obsidian Dotfiles

My Obsidian vault configuration — themes, snippets, hotkeys, plugin settings, and core preferences.

## What's Included

- **Core settings** — app preferences, appearance, graph view, canvas, backlinks
- **Hotkeys** — custom keybindings
- **CSS snippets** — `snippets/obsidian.css` (hides ribbon icons, sidebar tabs, Notebook Navigator layout)
- **Plugin configs** (`data.json` for each):
  - Advanced Canvas
  - Cmdr
  - Notebook Navigator
  - Obsidian Git
  - Obsidian Hider
  - Obsidian LaTeX Suite
  - Obsidian Style Settings
  - Omnisearch
  - Templater
  - Todoist Sync

## Applying to a New Device

### Prerequisites

- [Obsidian](https://obsidian.md) installed
- Git (to clone this repo)

### Steps

1. **Clone this repo** on the new machine:

   ```bash
   git clone <your-repo-url> ~/obsidian-dotfiles
   ```

2. **Create or open a vault** in Obsidian on the new device. You can either:
   - Create a new empty vault (File > New vault), or
   - Open an existing synced vault

3. **Run the install script**:

   ```bash
   ./install.sh ~/path/to/your/vault
   ```

   This will:
   - Back up your existing `.obsidian` config to `.obsidian.bak`
   - Copy all settings, snippets, and plugin configs into the vault
   - Print a list of community plugins to install

4. **Install community plugins** in Obsidian:
   - Go to **Settings > Community Plugins > Browse**
   - Search for and install each plugin listed by the script
   - Restart Obsidian after installing plugins so the `data.json` settings load

5. **Enable CSS snippets**:
   - Go to **Settings > Appearance > CSS Snippets**
   - Toggle on `obsidian`

6. **Set up Obsidian Git** (if using):
   - Go to **Settings > Obsidian Git**
   - Set the **Repository Path** to your vault path
   - Enter your GitHub PAT in the **Password** field — it's stored in your OS keychain, not in any file
   - **Never commit tokens or credentials to this repo**

### Updating Config

When you change settings on any device, update this repo:

```bash
cd ~/obsidian-dotfiles

# Re-sync config from your vault
./sync.sh ~/path/to/your/vault

# Commit and push
git add -A && git commit -m "update config" && git push
```

Then pull and re-run `install.sh` on other devices.

## File Structure

```
.
├── README.md
├── install.sh
├── sync.sh
└── vault-config/
    └── .obsidian/
        ├── app.json
        ├── appearance.json
        ├── backlink.json
        ├── canvas.json
        ├── community-plugins.json
        ├── core-plugins.json
        ├── graph.json
        ├── hotkeys.json
        ├── templates.json
        ├── types.json
        ├── zk-prefixer.json
        ├── snippets/
        │   └── obsidian.css
        └── plugins/
            ├── advanced-canvas/data.json
            ├── cmdr/data.json
            ├── notebook-navigator/data.json
            ├── obsidian-git/data.json
            ├── obsidian-hider/data.json
            ├── obsidian-latex-suite/data.json
            ├── obsidian-style-settings/data.json
            ├── omnisearch/data.json
            ├── templater-obsidian/data.json
            └── todoist-sync-plugin/data.json
```

## Notes

- `workspace.json` is intentionally excluded — it's session-specific and shouldn't be synced
- Plugin `main.js`, `manifest.json`, and `styles.css` are excluded — Obsidian installs these when you enable a plugin
- The `todoist-sync-plugin` config contains a secret reference (`swt-todoist-api-token`), not the actual token. You'll need to re-enter your Todoist API token in the plugin settings on each device
