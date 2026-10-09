# Campus Café — Game Design Document

## Design Pillars

- **Speed vs. Accuracy** — Players must choose between serving quickly and taking enough time to make sure the food and price are correct. Any mechanic that removes either time pressure or accuracy would go against the game.
- **Simple Actions, Increasing Pressure** — Individual actions such as choosing food or entering a price should be easy to understand. The challenge comes from doing these actions quickly while more pressure is added.
- **Readable at a Glance** — Orders, food choices, prices, patience, and mistakes should always be easy to identify. If the player cannot tell why an order failed, the design is not working.
- **Escalating Café Chaos** — The beginning should feel manageable, but the café becomes increasingly busy through larger orders, shorter patience, and faster customer arrivals.

## Core Loop

**Read a customer's order → assemble the requested food → determine the correct price → serve the customer before their patience runs out → receive feedback/reward → repeat with increasing difficulty.**

## Mechanics

### Primary Mechanic — Assemble

The main verb is **assemble**.

The player assembles a customer's requested order by choosing the correct combination of food and drinks.

### Secondary Mechanics

- **Read** customer orders.
- **Select** food and drink items.
- **Calculate** the cost of the selected items.
- **Charge** the correct amount.
- **Serve** the completed order.
- **Prioritize** customers based on patience.

### Tertiary Mechanics

- Earn score/money.
- Build consecutive successful-order streaks.
- Respond to faster customer arrivals.
- Restart the shift and try for a better result.

## Goal · Opposition · Decisions · Rules

### Goal

Serve as many customers correctly as possible before the café shift ends while earning a high score or amount of money.

### Opposition

The main opposition is **time pressure**.

Customers lose patience while waiting. As the shift progresses:

- Orders become larger.
- Customers arrive more frequently.
- Patience may decrease.

The player is fighting against the café becoming increasingly busy rather than fighting a traditional enemy.

### Decisions

The player must decide:

- Which customer/order deserves attention first.
- Whether to serve quickly or double-check the order.
- Which food items belong to the order.
- What the correct total price is.
- Whether an order is ready to be submitted.

### Rules

- Each customer requests one or more menu items.
- The player must select the requested items.
- The player must provide the correct price.
- A customer has limited patience.
- Correct orders increase score/money.
- Incorrect orders cause a penalty or wasted time.
- Customers leave when their patience reaches zero.
- The shift ends when the shift timer reaches zero.

## Win / Failure Conditions

### Completion / Win Condition

The player completes the café shift when the shift timer reaches zero. The goal is to finish the shift with the highest score or amount of money possible by serving customers accurately and quickly.

### Failure Conditions

The game does not immediately end after a single mistake. Instead, the player loses opportunities to score when:

- A customer's patience reaches zero and they leave.
- The player submits the wrong food items.
- The player charges the wrong total.
- Too many mistakes reduce the player's final performance.

This keeps the focus on recovering from mistakes and improving over the full shift instead of ending the game after one error.

## Player Experience

The intended player experience is:

- **Tension** — trying to finish before patience expires.
- **Satisfaction** — completing an order correctly under pressure.
- **Mastery** — becoming faster at recognizing items and calculating totals.
- **Controlled chaos** — feeling that the café is becoming busy without becoming impossible to understand.

### Eight Pleasures

The strongest pleasures targeted are:

- **Challenge** — increasingly difficult orders and time pressure.
- **Sensation** — visual and audio feedback when orders are completed correctly or incorrectly.
- **Submission** — a simple repeatable gameplay loop that players can quickly understand and continue playing.

The game is not primarily aiming for fantasy, narrative, fellowship, discovery, or expression.

## Target Player

The game is primarily designed for **Achievers** in Bartle's player types.

The player is encouraged to:

- Improve their score.
- Serve more customers.
- Complete orders faster.
- Reduce mistakes.
- Perform better on later attempts.

Explorers, Socializers, and Killers are not the primary audience because Campus Café is a short solo game focused on performance and mastery.

## Inspirations

### Game Inspirations

**Overcooked**

Inspiration comes from the pressure of completing food-related tasks while time continues moving.

The game does not attempt to reproduce Overcooked's movement, kitchen layout, or multiplayer structure.

**Papa's Games**

Inspiration comes from receiving customer orders and completing them correctly.

Campus Café differs by emphasizing rapid item recognition, pricing, and short university café shifts.

### Non-Game Inspirations

**University campus cafés**

The setting comes from the experience of students lining up for food between classes, particularly when everyone arrives during a short break.

**Part-time customer-service work**

The speed-versus-accuracy mechanic is inspired by situations where workers must serve customers quickly while still ensuring the order and payment are correct.

## Genre, Platform and Tools

- **Genre:** 2D time-management / simulation game
- **Platform:** Desktop
- **Programming Language:** Odin
- **Library:** Raylib
- **Target Session Length:** Approximately 10 minutes per café shift.

## Progression

A single shift gradually increases in difficulty.

### Beginning

- Single-item orders.
- Long customer patience.
- Slow arrival rate.

### Middle

- One- and two-item orders.
- Faster arrivals.
- Moderate patience.

### Late Shift

- Two- and three-item orders.
- Shorter patience.
- Faster customer arrival.
- Higher chance of several demanding orders appearing close together.

The goal is for the player to become more comfortable with the basic mechanics just as the game begins demanding faster decisions.

## Theme

The game focuses on **pressure and responsibility in a busy university environment**.

The player is trying to provide good service while dealing with limited time and increasing demand.

The tone should remain light and slightly chaotic rather than serious or realistic.

# Scope

## Must-Have

1. Raylib game window.
2. Title screen with a Start option.
3. Basic in-game instructions that explain the goal and controls.
4. Main café gameplay screen.
5. At least three menu items.
6. Prices for each item.
7. Customer order generation.
8. Food selection.
9. Current selected-order display.
10. Price selection/calculation mechanic.
11. Serve button.
12. Order validation.
13. Clear correct/incorrect feedback.
14. Customer patience timer.
15. Customers leave when patience reaches zero.
16. Multiple orders during one shift.
17. Score or money tracking.
18. Shift timer.
19. End-of-shift results screen.
20. Restart option.
21. Basic difficulty progression.
22. Basic sound effects for important actions such as serving, mistakes, and shift completion.

## Should-Have

23. Different student appearances.
24. Multiple customers visible or waiting.
25. More menu items.
26. Improved UI feedback and polish.
27. Simple animations for customers or food.

---

# CUT LINE

Everything above this line is part of the planned game.

Everything below this line can be removed without preventing the game from being considered complete.

The cut line is intentional: the core game should be fully playable, understandable, and polished before any optional systems are added.

---

## Nice-to-Have / Cut Features

28. Combo/streak system.
29. Rush-hour events.
30. Unique customer personality types.
31. Customer dialogue.
32. Multiple café locations.
33. Different playable shifts.
34. High-score saving.
35. Background music.
36. Special or rare customer orders.
37. Customizable café.
38. Upgrade system.
39. More advanced character animations.

## Checkpoint 2 Scope Lock — October 9, 2026

**Status: LOCKED.** The ranked Must-Have (1–22), Should-Have (23–27), and Nice-to-Have/Cut (28–39) lists above are retained from CP1. The cut line stays after item 27. Items 28–39 are excluded from the committed project. Changes to this scope require a conversation with the TA/instructor before implementation.

Concrete boundaries: one solo desktop café, one timed shift, food assembly and manual price validation; no kitchen traversal, combat, upgrades, multiplayer, additional locations, or saved progression. The normal shift remains approximately ten minutes. A 90-second demonstration setting uses identical mechanics and exists to make lab demonstrations practical.

CP2 implementation: items 1–21 have a working prototype, with multiple waiting students (up to three) and shape-based UI feedback. Basic sound effects (22), more menu items, appearance variation and animations remain later development tasks. Placeholder graphics are intentional; CP2 assesses architecture rather than art. External tuning files and shared loaded resources belong to CP3.
