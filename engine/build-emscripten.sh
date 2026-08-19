#!/bin/bash
# Standalone Emscripten build for wolf4sdl (no `make` dependency).
# Mirrors Makefile + config.emscripten. Run from the engine/ directory
# after sourcing tools/emsdk-env.sh.
set -e

SRCS=(
  opl3.c
  id_ca.cpp
  id_in.cpp
  id_pm.cpp
  id_sd.cpp
  id_us_1.cpp
  id_vh.cpp
  id_vl.cpp
  signon.cpp
  wl_act1.cpp
  wl_act2.cpp
  wl_agent.cpp
  wl_atmos.cpp
  wl_cloudsky.cpp
  wl_debug.cpp
  wl_draw.cpp
  wl_floorceiling.cpp
  wl_game.cpp
  wl_inter.cpp
  wl_main.cpp
  wl_menu.cpp
  wl_parallax.cpp
  wl_play.cpp
  wl_state.cpp
  wl_text.cpp
  states.cpp
)

CFLAGS="-sUSE_SDL=2 -sUSE_SDL_MIXER=2 -O2 -Wall -Wpointer-arith -Wreturn-type -Wwrite-strings -Wcast-align"
LDFLAGS="-sASYNCIFY -sINITIAL_MEMORY=64MB -sALLOW_MEMORY_GROWTH=1 -sENVIRONMENT=web --preload-file data@/ --shell-file ../web/shell.html -sEXPORTED_FUNCTIONS=_main,_assist_get_current_level,_assist_get_map,_assist_get_mapsize,_assist_get_player_x,_assist_get_player_y,_assist_get_player_angle,_assist_is_paused,_assist_set_joystick,_assist_has_autosave,_assist_autosave -sEXPORTED_RUNTIME_METHODS=ccall,cwrap,HEAPU8,FS -lidbfs.js -O2"

mkdir -p build-em
mkdir -p data
for f in ../data/shareware/*.WL1; do
  cp "$f" "data/$(basename "$f" | tr '[:upper:]' '[:lower:]')"
done

OBJS=()
for src in "${SRCS[@]}"; do
  obj="build-em/${src%.*}.o"
  OBJS+=("$obj")
  echo "===> CXX/CC $src"
  if [[ "$src" == *.c ]]; then
    emcc $CFLAGS -std=gnu99 -c "$src" -o "$obj"
  else
    em++ $CFLAGS -c "$src" -o "$obj"
  fi
done

echo "===> LD index.html"
em++ $CFLAGS "${OBJS[@]}" $LDFLAGS -o index.html

echo "Build complete: engine/index.html, index.js, index.wasm, index.data"
