# wolf3d-assist

A browser-playable build of the original 1992 *Wolfenstein 3D*, with an "assist mode" sidebar (cheats, a fog-of-war explored map, per-floor hints) that links out to [Code Museum](https://blue-rock-0e6a0831e.7.azurestaticapps.net/#/wolf3d)'s annotated source pages for the underlying code.

**Live:** https://ashy-forest-06f3c1f1e.7.azurestaticapps.net/

## What's here

- `engine/` — a fork of [fabiangreffrath/wolf4sdl](https://github.com/fabiangreffrath/wolf4sdl) (a portable SDL2 port of [id-Software/wolf3d](https://github.com/id-Software/wolf3d)), compiled to WebAssembly via Emscripten. A few small patches on top: `DebugOk` defaults on (so assist-mode cheats work without the original 3-key unlock combo), and a handful of `assist_get_*` exports the JS side polls for live level/position/map data.
- `web/shell.html` — the custom Emscripten shell: the assist-mode UI (cheats, hints, explored map) wrapped around the game canvas.
- `data/shareware/` — the original 1992 shareware episode data files (`*.WL1`). id Software has permitted free redistribution of these since the game shipped as shareware; the full registered game's data is not included (and isn't bundled/downloadable from here).
- `staticwebapp.config.json`, `.github/workflows/azure-static-web-apps.yml` — Azure Static Web Apps (free tier) deployment.

## Running locally

```bash
# 1. Get the Emscripten SDK (one-time; ~1GB, not checked into the repo)
git clone https://github.com/emscripten-core/emsdk.git tools/emsdk
cd tools/emsdk && python emsdk.py install 6.0.6 && python emsdk.py activate 6.0.6 && cd ../..

# 2. Activate it in your shell
source tools/emsdk-env.sh

# 3. Build the engine
cd engine && bash build-emscripten.sh && cd ..

# 4. Serve it (can't open the file directly -- browsers block wasm/fetch
#    requests from file:// URLs)
cd engine && python -m http.server 8090

# 5. Open http://localhost:8090/index.html
```

If `tools/emsdk` already exists (e.g. from a previous setup), skip straight to step 2.

## Deployment

Pushing to `main` triggers `.github/workflows/azure-static-web-apps.yml`, which builds the engine fresh in CI and deploys the result to Azure Static Web Apps using the `AZURE_STATIC_WEB_APPS_API_TOKEN` repo secret.

## License / credits

- Wolfenstein 3D source: id Software, released under a 1995 educational-use license (see `engine/license-id.txt`). This project is personal and non-commercial.
- Engine portability layer: [Wolf4SDL](https://github.com/fabiangreffrath/wolf4sdl), GPL-2.0 (see `engine/license-gpl.txt`).
- Code Museum annotations linked from assist mode: [PatAltimore/code-museum](https://github.com/PatAltimore/code-museum).
