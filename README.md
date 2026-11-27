# Quick Point Dropper

A CloudTAK plugin for dropping and editing map points quickly.

Pick an icon, click the map, and a CoT point is created. Click an existing point to change its title, remarks, icon, or location. Shared **Favorites** sit at the top of the menu so the icons you use most are one tap away.

**Minimum CloudTAK: v14.4.1**. Built and verified against CloudTAK v14.4.1 (commit 184ecb2, 2026-11-27). There is no upper limit, and newer CloudTAK versions are expected to work. Please report breakage as an issue.

## What it does

- Drop points from **Favorites**, CloudTAK’s four **Standard** points (unknown, friendly, hostile, neutral), or any icon pack
- Type a **Title / Callsign** and **Notes / Remarks** that apply to the next drop
- Paste coordinates (**DD, DM, DMS, MGRS, or UTM**) to place or move a point without clicking the map
- **Enumerate Points** appends a running number to each dropped callsign
- Click an existing point to edit it in place: retitle, rewrite remarks, **Move**, **Change Icon**, or **Delete**
- **Favorites** are shared for everyone on the server. Only a CloudTAK system admin can add, remove, or arrange them

## Install

Do not use CloudTAK’s `WEB_PLUGINS` setting. Use this installer:

```bash
git clone https://github.com/ValleyTacticalSolutions/cloudtak-plugin-quick-point-dropper.git
cd cloudtak-plugin-quick-point-dropper
./install.sh
```

The script finds CloudTAK at `$CLOUDTAK`, `~/CloudTAK`, `/home/takwerx/CloudTAK`, or `/home/*/CloudTAK`. If yours is somewhere else:

```bash
./install.sh /path/to/CloudTAK
```

The first install rebuilds the CloudTAK API image (about 5–15 minutes). Run the same `./install.sh` later to update.

After it finishes, in CloudTAK go to **Settings → Refresh App**. A normal browser refresh is not enough. The plugin appears at the bottom of the right-side menu.

```bash
./install.sh --remove
```

## How to use

1. Open **Quick Point Dropper** from the right-side menu.
2. Choose **Favorites**, **Standard**, or an icon pack. Search to filter; use the list/grid button to show names.
3. Tap an icon. The cursor becomes a crosshair — each map click (or tap, on a phone) drops a new point.
4. Optional: set Title / Callsign, Notes / Remarks, or paste coordinates before you drop.
5. Tap **Stop Dropping Points** in the bottom bar, or press **Escape**, to leave drop mode. On a phone, close the menu sheet to reach the map: drop mode stays on until you tap **Stop Dropping Points**.
6. With drop mode off, click a point on the map to edit it. Overlapping points use CloudTAK’s picker.
7. System admins tap **Edit Favorites** to star icons and arrange sections.

Closing the plugin also stops drop mode (on a phone, drop mode keeps running with the menu closed, so you can tap the map).

## Key commands

These apply while the plugin is open. **Ctrl** is Control, not Command.

| Key | When | Action |
| --- | --- | --- |
| **Escape** | Dropping | Stop dropping and clear the title, remarks, and selected icon |
| **Escape** | A point is selected | Deselect that point |
| **Escape** | Move or Change Icon | Cancel that mode |
| **Escape** | Edit Favorites | Close the editor |
| **Ctrl+M** | A point is selected | Start **Move** |
| **Ctrl+I** | A point is selected | Start **Change Icon** |
| **Delete** or **Backspace** (twice) | A point is selected | Same as **Delete** — first press asks to confirm, second press deletes |
| Any letter or number | A point is selected | Clear the title and start typing a new one |
| **Enter** | Coordinates field | Place or move the point at those coordinates |

Shortcuts do not run while you are typing in a text box. Type a title or remarks first, or click the map, then use the keys above.

## Core imports

None. The plugin no longer imports anything from CloudTAK's `src/`, so it also works as a runtime bundle:

- `plugin/lib/host.ts` resolves the CloudTAK server URL and token and makes authenticated requests (`apiFetch`). `PluginAPI` has no server-URL or authenticated-fetch helper, so this is local to the plugin. It also reads the host's live `cloudtak` map store from `api.pinia` (`radial`, `select`, `coordFormat`, `refresh`, `worker.db.get/add/remove`) and the `cloudtak-app` store (`isMobileDetected`). `api.map`, `api.router`, `api.menu` and `api.bottomBar` come from `PluginAPI`.
- `plugin/lib/vendor/MenuTemplate.vue` is a copy of CloudTAK's menu frame, and `plugin/lib/vendor/coordinateFormat.ts` a copy of its coordinate helper. Re-sync them when CloudTAK changes the menu chrome or coordinate handling.
- Icons and icon packs are read from the CloudTAK iconset endpoints (`/api/iconset`, `/api/icon`) instead of the host's local icon cache.
- `@tak-ps/node-cot/normalize_geojson` is bundled into the plugin.
- Server: `../../common/auth.js`, `../config.js`

## Mobile (CloudTAK iOS/Android app)

The mobile bundle needs **CloudTAK v14.4.1 or newer** (runtime plugins, the same minimum as the compiled install).

The native apps only run runtime bundles, not plugins compiled into the web build. The bundle covers the web half only, so **the server-side install is still required**: the `/api/qpd/*` routes (Favorites) must be installed on the CloudTAK server with `./install.sh` and the API image rebuilt.

1. Build: `npm install && npm run bundle` creates `release/quick-point-dropper-<version>.tar.gz` (`manifest.json` + `index.js`). GitHub releases carry the same file.
2. Upload (CloudTAK admin): `POST /api/plugin/bundle` with the tar.gz.
3. On the phone: **Settings → Plugins**, then load Quick Point Dropper. It is stored on the device and loads offline.

The bundle contains everything except `vue`, `vue-router` and `@tak-ps/vue-tabler`, which the app provides.

On a phone, dropping works by tap alone: pick an icon, close the menu sheet, then tap the map for each point. The **Stop Dropping Points** button sits in CloudTAK's bottom bar (50 px tall). The title field is not focused automatically, so the keyboard stays closed. The key commands above apply to keyboards only.

## Development

The compiled install builds the plugin inside CloudTAK. To check it against the latest CloudTAK `main` (ESLint, `vue-tsc`, Vite build, API oxlint and `tsc`):

```bash
bash verify-cloudtak.sh . quick-point-dropper
```
