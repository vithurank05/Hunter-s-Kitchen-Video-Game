package cafe

import rl "vendor:raylib"

order_total :: proc(order: [ITEM_COUNT]int) -> int {
    total := 0
    for count, i in order { total += count * MENU[i].price }
    return total
}
clear_tray :: proc(g: ^Game) { g.tray = {}; g.charge = 0 }
first_active :: proc(g: ^Game) -> int {
    for c, i in g.customers { if c.active { return i } }
    return -1
}
set_feedback :: proc(g: ^Game, message: cstring, ok: bool) {
    g.feedback = message; g.feedback_ok = ok; g.feedback_time = 3
}
start_shift :: proc(g: ^Game, duration: f32) {
    g^ = Game{state = .Playing, selected = -1, duration = duration, remaining = duration,
              feedback = "Select food, set the price, then serve.", feedback_time = 4, feedback_ok = true}
    spawn_customer(g)
    g.spawn_timer = 9
}
spawn_customer :: proc(g: ^Game) {
    for &c, i in g.customers {
        if c.active { continue }
        progress := 1 - g.remaining / g.duration
        count := 1
        if progress >= 0.33 { count = 2 }
        if progress >= 0.66 { count = 3 }
        patience := 34 - 14 * progress
        g.next_id += 1
        c = Customer{active = true, id = g.next_id, patience = patience, max_patience = patience}
        for _ in 0..<count { c.order[int(rl.GetRandomValue(0, ITEM_COUNT-1))] += 1 }
        if g.selected < 0 { g.selected = i }
        return
    }
}
select_customer :: proc(g: ^Game, index: int) {
    if index < 0 || index >= MAX_CUSTOMERS || !g.customers[index].active || index == g.selected { return }
    g.selected = index
    clear_tray(g)
}
cycle_customer :: proc(g: ^Game, direction: int) {
    for offset in 1..=MAX_CUSTOMERS {
        index := (max(g.selected, 0) + direction*offset + MAX_CUSTOMERS*2) % MAX_CUSTOMERS
        if g.customers[index].active { select_customer(g, index); return }
    }
}
serve_order :: proc(g: ^Game) {
    if g.selected < 0 { set_feedback(g, "No student waiting. A new order will arrive soon.", false); return }
    c := &g.customers[g.selected]
    correct_food := g.tray == c.order
    if !correct_food || g.charge != order_total(c.order) {
        g.mistakes += 1
        c.patience = max(0, c.patience - 3)
        if !correct_food { set_feedback(g, "Wrong food: clear the tray and check the order.", false) }
        else { set_feedback(g, "Wrong price: add the menu prices and try again.", false) }
        return
    }
    g.served += 1
    g.revenue += g.charge
    c.active = false
    g.selected = first_active(g)
    clear_tray(g)
    set_feedback(g, "Order served! Payment received.", true)
}
update_game :: proc(g: ^Game, a: Actions, dt: f32) {
    switch g.state {
    case .Title, .Results:
        if a.start { start_shift(g, SHIFT_SECONDS) }
        else if a.demo { start_shift(g, DEMO_SECONDS) }
        else if a.title { g.state = .Title }
    case .Paused:
        if a.title { g.state = .Title }
        else if a.pause || a.start { g.state = .Playing }
    case .Playing:
        if a.pause { g.state = .Paused; return }
        update_shift(g, a, dt)
    }
}
update_shift :: proc(g: ^Game, a: Actions, dt: f32) {
    g.remaining = max(0, g.remaining - dt)
    if g.remaining <= 0 { g.state = .Results; return }
    g.feedback_time = max(0, g.feedback_time - dt)
    for &c in g.customers {
        if !c.active { continue }
        c.patience = max(0, c.patience - dt)
        if c.patience <= 0 {
            c.active = false; g.missed += 1
            set_feedback(g, "A student left. Keep going!", false)
        }
    }
    if g.selected >= 0 && !g.customers[g.selected].active {
        g.selected = first_active(g); clear_tray(g)
    }
    g.spawn_timer -= dt
    if g.spawn_timer <= 0 {
        spawn_customer(g)
        progress := 1 - g.remaining / g.duration
        g.spawn_timer = 9 - 5 * progress
    }
    if a.customer_slot >= 0 { select_customer(g, a.customer_slot) }
    if a.previous { cycle_customer(g, -1) }
    if a.next { cycle_customer(g, 1) }
    if a.clear { clear_tray(g) }
    if g.selected >= 0 {
        for add, i in a.add { if add { g.tray[i] = min(g.tray[i]+1, 3) } }
        g.charge = clamp(g.charge+a.price_delta, 0, 30)
    }
    if a.serve { serve_order(g) }
}
