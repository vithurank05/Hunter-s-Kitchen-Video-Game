# Campus Café

A 2D solo café game for CSCI 4160U, built with Odin and Raylib. This repository is named Hunter-s-Kitchen-Video-Game, but the game follows the Campus Café design from Checkpoint 1.

## Checkpoint 2

Runnable architecture prototype: customers stored as records in a collection; Title, Playing, Paused and Results states; separate input, update and render procedures; original ranked scope explicitly locked in `docs/gdd.md`.

Includes three menu items, generated orders, tray assembly, manual pricing, validation, patience, revenue, shift timer, restart and gradual difficulty. Placeholder shapes and Raylib's default font are used. Sound and external asset/data loading remain future work.

## Build and run

Install the official Odin toolchain for your OS: https://odin-lang.org/docs/install/ . Raylib bindings and libraries ship with Odin; no separate game engine is needed.

Open a terminal **in this repository folder**, then run:

```sh
odin run src
```

Windows PowerShell example:

```powershell
cd "C:\path\to\Hunter-s-Kitchen-Video-Game"
odin run src
```

macOS Terminal example:

```sh
cd ~/Downloads/Hunter-s-Kitchen-Video-Game
odin run src
```

Build without running: `odin build src -out:campus-cafe` (Windows: `-out:campus-cafe.exe`). Linux needs a C linker/compiler and Raylib's desktop system dependencies.

## Controls

| Action | Control |
| --- | --- |
| Start normal 10-minute shift | Enter or Start button |
| Start short 90-second demonstration | D or Demo button |
| Select student | Click card, Left/Right or Tab |
| Add coffee / sandwich / muffin | 1 / 2 / 3 or menu card |
| Increase / decrease charge by $1 | Up / Down or + / - |
| Serve | Space or Serve button |
| Clear tray and charge | C or Clear button |
| Pause / resume | P or Escape (Enter also resumes) |
| Return to title | T while paused or on results |
| Quit | Close window |

Switching students clears the tray to avoid mixing orders. Food quantities must match exactly. Wrong food or price counts a mistake and costs three seconds of patience, but lets you retry. Customers leave when patience runs out. Revenue increases only after correct service. When time expires the results screen appears; remaining customers are not counted as walkouts. Demo mode uses the same progression compressed into 90 seconds.

## Repository guide

- `src/main.odin`: startup and visible input → update → render loop.
- `src/types.odin`: state enum, customer data, game model, action data and UI rectangles.
- `src/input.odin`: keys/clicks mapped to actions.
- `src/update.odin`: gameplay and state transitions.
- `src/render.odin`: drawing from game data.
- `src/game_test.odin`: automated checks (`odin test src`).
- `docs/gdd.md`: original design with scope-lock annotation.
- `docs/CP2-WALKTHROUGH.md`: explanation and live demonstration checklist.
- `docs/postmortem.md`: blank prompts for your own notes.
- `assets/`, `data/`: reserved for later checkpoints.
- `ATTRIBUTION.md`: AI disclosure and source credits.

Read the walkthrough, test the game on your own machine, and make sure you can explain the code before the lab.
