# Checkpoint 2 technical walkthrough

This is AI-assisted explanatory documentation. It is not a student-written trade-off memo or postmortem.

## How the architecture meets CP2

| Criterion | Where to show it | Explanation |
| --- | --- | --- |
| Entities as data (2 points) | `types.odin`, `Game.customers` | A fixed collection contains three `Customer` records. Each record holds an ID, requested quantities, active flag and patience. There is no separate customer1/customer2/customer3 implementation. |
| Explicit states and update/render seam (2 points) | `Game_State`, `update_game`, `main`, `render_game` | One enum selects Title, Playing, Paused or Results. Input is gathered once, update changes the model, render draws the model. |
| Locked specific scope (1 point) | End of `gdd.md` | Original ranked features and cut line are preserved, with an explicit lock and concrete boundaries. Scope changes need a TA/instructor conversation. |

## The files

`main.odin` creates the window and owns the loop. Every frame it reads an `Actions` record, clamps the delta time, calls `update_game`, then draws. Closing the window shuts down Raylib.

`types.odin` defines records. `Customer.order` is a three-element quantity array: index 0 is coffee, 1 sandwich, 2 muffin. `{1, 2, 0}` means one coffee and two sandwiches. `Game` owns the collection, selected slot, tray, price, timers and totals. `Actions` represents player intent. The fixed collection bounds the simultaneous queue to three customers and needs no dynamic allocation.

`input.odin` translates key presses and mouse clicks into actions. Gameplay does not need to know whether Serve came from Space or a click. `customer_slot = -1` means no customer selection request. This must be explicitly set when constructing input in tests; an all-zero record would select slot zero.

`update.odin` owns mutations. `spawn_customer` reuses an inactive slot, assigns its next ID and builds a random order. `update_shift` changes time, expires waiting students, generates arrivals, applies selection and tray actions, then validates service. `serve_order` requires both exact food quantities and the correct price. A mismatch costs patience and increments mistakes; success records payment and frees the slot. If the selected customer leaves, the first remaining active slot is selected and the old tray cleared.

`render.odin` draws cards, buttons, patience bars and totals. It does not change gameplay data or consume input. Raylib `TextFormat` produces temporary formatted text that is immediately drawn rather than retained in the game model. Drawing the paused screen first draws the café then overlays a translucent panel.

## State transitions

- Title → Playing: Enter/start, or D/demo; reset every session field.
- Playing → Paused: P or Escape; return immediately so that frame does not advance timers.
- Paused → Playing: P, Escape or Enter.
- Paused → Title: T, abandoning the current shift.
- Playing → Results: shift timer reaches zero.
- Results → Playing: start a new normal or demo shift.
- Results → Title: T.

One state enum prevents impossible combinations such as simultaneously paused and on the title screen. The `active` customer flag describes whether a collection slot is occupied; it is not a substitute for the game state enum.

## Timing and progression

Delta time is elapsed seconds. Patience loses `dt`, so gameplay is based on time rather than the number of frames. The frame delta is capped at 0.1 seconds to avoid a large jump after a stall; consequently the shift measures simulated time and may run slower than wall-clock time under severe stalls.

Progress is `1 - remaining / duration`. Orders contain one item in the first third, two in the second, three in the last. Patience moves from 34 toward 20 seconds; arrival intervals move from nine toward four seconds. A full queue skips that scheduled arrival rather than building an invisible backlog. These numbers are prototype literals; moving them into files is CP3 work.

## Live demo checklist

1. Run `odin run src` from the project root. Show the title.
2. Press D for the 90-second demonstration.
3. Show `customers` in source, then point to the visible cards using those records.
4. Fulfil one order: press 1/2/3 for the requested quantities. Calculate from Coffee $3, Sandwich $5, Muffin $4; set the charge with Up; press Space.
5. Submit a wrong food combination or price. Explain that the student remains and patience decreases.
6. Select another waiting card and show that the tray clears.
7. Press P. Watch that shift time and patience stay frozen. Resume.
8. Allow a student to time out and show the left count increasing.
9. Reach Results; restart and show that revenue and counters reset.
10. Walk through `main`: input → update → render. Open the GDD scope lock.

## Questions to practise answering

- What is the difference between a customer's ID and its array slot?
- Why is the order stored as quantities instead of three booleans?
- Why does rendering not decrement patience?
- How does pause stop spawning and patience together?
- What does a pointer such as `^Game` allow update procedures to do?
- Why use integer dollars here? What would change for cents?
- How would you add a fourth menu item or move tuning into a file?
- Which scope items remain for later checkpoints?

## Local verification

Run `odin test src` for checks of state transitions, frozen pause timers, correct/wrong service, restart, timeouts and tray clearing. Also run the actual window on the computer you will bring to the lab and use the checklist above. Automated checks are supporting verification; the course requires your live demonstration.

## Verification performed during preparation

- Odin October 2026 Linux toolchain: compiled and linked the executable successfully.
- `odin test src`: all three test procedures passed.
- Ran the Raylib window under a virtual X11 display; visually reviewed title, playing and paused screens and exercised starting a demo and pausing it.
- `git diff --check`: passed.
- Windows and macOS executables were not run here. Run and demonstrate on your own machine before submission. No playtest results or instructor approval are claimed.
