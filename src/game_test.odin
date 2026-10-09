package cafe

import "core:testing"

@(test)
state_and_pause :: proc(t: ^testing.T) {
    g := Game{state = .Title, selected = -1}
    update_game(&g, Actions{demo = true, customer_slot = -1}, 0.1)
    testing.expect(t, g.state == .Playing && g.remaining == DEMO_SECONDS)
    update_game(&g, Actions{pause = true, customer_slot = -1}, 1)
    patience := g.customers[0].patience
    update_game(&g, Actions{customer_slot = -1}, 10)
    testing.expect(t, g.state == .Paused && g.remaining == DEMO_SECONDS)
    testing.expect(t, g.customers[0].patience == patience)
    update_game(&g, Actions{pause = true, customer_slot = -1}, 0.1)
    g.remaining = 0.05
    update_game(&g, Actions{customer_slot = -1}, 0.1)
    testing.expect(t, g.state == .Results)
}
@(test)
validation_and_restart :: proc(t: ^testing.T) {
    g := Game{state = .Playing, selected = 0, duration = 90, remaining = 90}
    g.customers[0] = Customer{active = true, order = {1, 1, 0}, patience = 30, max_patience = 30}
    g.tray = {1, 0, 0}; g.charge = 8
    serve_order(&g)
    testing.expect(t, g.mistakes == 1 && g.served == 0 && g.customers[0].active)
    g.tray = {1, 1, 0}; g.charge = 7
    serve_order(&g)
    testing.expect(t, g.mistakes == 2 && g.served == 0)
    g.charge = 8
    serve_order(&g)
    testing.expect(t, g.served == 1 && g.revenue == 8 && !g.customers[0].active && g.selected == -1)
    testing.expect(t, g.tray == [ITEM_COUNT]int{} && g.charge == 0)
    start_shift(&g, DEMO_SECONDS)
    testing.expect(t, g.served == 0 && g.mistakes == 0 && g.revenue == 0 && g.customers[0].active)
}
@(test)
timeout_and_selection :: proc(t: ^testing.T) {
    g := Game{state = .Playing, selected = 0, duration = 90, remaining = 90, spawn_timer = 10}
    g.customers[0] = Customer{active = true, patience = 0.01, max_patience = 30}
    g.customers[1] = Customer{active = true, patience = 30, max_patience = 30}
    g.tray = {2, 0, 0}; g.charge = 6
    update_shift(&g, Actions{customer_slot = -1}, 0.1)
    testing.expect(t, g.missed == 1 && g.selected == 1 && !g.customers[0].active)
    testing.expect(t, g.tray == [ITEM_COUNT]int{} && g.charge == 0)
    g.customers[2] = Customer{active = true, patience = 30}
    g.tray = {1, 0, 0}
    select_customer(&g, 2)
    testing.expect(t, g.selected == 2 && g.tray == [ITEM_COUNT]int{})
}
