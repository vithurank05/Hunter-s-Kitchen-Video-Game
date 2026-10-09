package cafe

import rl "vendor:raylib"

BG :: rl.Color{19, 29, 39, 255}
PANEL :: rl.Color{32, 47, 60, 255}
INK :: rl.Color{237, 240, 232, 255}
MUTED :: rl.Color{166, 185, 192, 255}
ACCENT :: rl.Color{240, 183, 93, 255}
GREEN :: rl.Color{108, 218, 165, 255}
RED :: rl.Color{255, 126, 123, 255}
text :: proc(s: cstring, x, y, size: i32, color := INK) { rl.DrawText(s, x, y, size, color) }
button :: proc(rect: rl.Rectangle, label: cstring, color := ACCENT) {
    rl.DrawRectangleRounded(rect, 0.15, 8, color)
    text(label, i32(rect.x)+16, i32(rect.y)+i32(rect.height)/2-10, 20, BG)
}
// Rendering only reads the model. No timers, spawns or state transitions here.
render_game :: proc(g: ^Game) {
    rl.ClearBackground(BG)
    text("CAMPUS CAFE", 40, 30, 36, ACCENT)
    text("CHECKPOINT 2  /  ARCHITECTURE PROTOTYPE", 40, 78, 16, MUTED)
    switch g.state {
    case .Title:
        text("The between-classes rush starts with you.", 265, 180, 28)
        text("Read orders. Assemble food. Charge the correct price.", 250, 230, 20, MUTED)
        button(START_RECT, "ENTER / 10-minute shift")
        button(DEMO_RECT, "D / 90-second demo", GREEN)
        text("1 / 2 / 3: add food   |   Up / Down: price   |   Space: serve", 230, 505, 20)
        text("Click a student to select them. Switching clears your tray.", 235, 545, 20, MUTED)
        text("C: clear tray   |   Left / Right / Tab: select student   |   P: pause", 220, 585, 18, MUTED)
    case .Playing, .Paused:
        render_shift(g)
        if g.state == .Paused {
            rl.DrawRectangle(0, 0, 1120, 720, {10, 18, 25, 230})
            text("SHIFT PAUSED", 375, 260, 40, ACCENT)
            text("P / Escape / Enter: resume", 390, 330, 24)
            text("T: abandon shift and return to title", 335, 380, 24, MUTED)
            text("The shift and every student's patience are frozen.", 280, 445, 22, MUTED)
        }
    case .Results:
        text("SHIFT COMPLETE", 350, 155, 40, GREEN)
        text(rl.TextFormat("Served: %i    Left: %i    Mistakes: %i", i32(g.served), i32(g.missed), i32(g.mistakes)), 300, 225, 26)
        text(rl.TextFormat("Revenue: $%i", i32(g.revenue)), 450, 265, 28, ACCENT)
        button(START_RECT, "ENTER / New 10-min shift")
        button(DEMO_RECT, "D / New 90-sec demo", GREEN)
        text("T: return to title", 455, 495, 22, MUTED)
        text("Practice improves both speed and accuracy.", 310, 555, 24)
    }
}
render_shift :: proc(g: ^Game) {
    seconds := i32(g.remaining)
    text(rl.TextFormat("TIME %02i:%02i", seconds/60, seconds%60), 780, 35, 28, GREEN)
    text(rl.TextFormat("Served %i   Left %i   Revenue $%i", i32(g.served), i32(g.missed), i32(g.revenue)), 630, 85, 20)
    text("WAITING STUDENTS  /  click an order to select it", 40, 125, 20, MUTED)
    for c, i in g.customers {
        rect := customer_rect(i)
        rl.DrawRectangleRounded(rect, 0.08, 8, PANEL)
        if i == g.selected { rl.DrawRectangleLinesEx(rect, 3, ACCENT) }
        x, y := i32(rect.x)+18, i32(rect.y)+18
        if !c.active { text("Next student arriving...", x, y+60, 20, MUTED); continue }
        text(rl.TextFormat("STUDENT #%i", i32(c.id)), x, y, 22, ACCENT)
        row := 0
        for count, j in c.order {
            if count > 0 {
                text(rl.TextFormat("%i x %s", i32(count), MENU[j].name), x, y+40+i32(row)*28, 22)
                row += 1
            }
        }
        fraction := clamp(c.patience/c.max_patience, 0, 1)
        color := GREEN
        if fraction < 0.3 { color = RED }
        rl.DrawRectangle(x, y+155, 300, 12, BG)
        rl.DrawRectangle(x, y+155, i32(300*fraction), 12, color)
        text(rl.TextFormat("Patience: %.0f seconds", f64(c.patience)), x, y+175, 16, MUTED)
    }
    text("BUILD YOUR TRAY", 40, 395, 22, ACCENT)
    for item, i in MENU {
        rect := item_rect(i)
        rl.DrawRectangleRounded(rect, 0.1, 8, PANEL)
        text(rl.TextFormat("%i  %s", i32(i+1), item.name), i32(rect.x)+15, 445, 23)
        text(rl.TextFormat("$%i  /  On tray: %i", i32(item.price), i32(g.tray[i])), i32(rect.x)+15, 490, 20, GREEN)
    }
    text("CHARGE (Up / Down)", 40, 565, 22)
    button(MINUS_RECT, "-")
    text(rl.TextFormat("$%i", i32(g.charge)), 545, 565, 28, ACCENT)
    button(PLUS_RECT, "+")
    button(SERVE_RECT, "SPACE  /  Serve order", GREEN)
    button(CLEAR_RECT, "C / Clear")
    text(rl.TextFormat("Mistakes: %i", i32(g.mistakes)), 770, 590, 20, MUTED)
    if g.feedback_time > 0 {
        color := RED
        if g.feedback_ok { color = GREEN }
        text(g.feedback, 40, 635, 20, color)
    }
    text("Left / Right: student   |   Switching clears tray   |   P / Escape: pause", 40, 686, 18, MUTED)
}
