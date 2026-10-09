package cafe

import rl "vendor:raylib"

clicked :: proc(rect: rl.Rectangle) -> bool {
    return rl.IsMouseButtonPressed(.LEFT) && rl.CheckCollisionPointRec(rl.GetMousePosition(), rect)
}
read_actions :: proc(state: Game_State) -> Actions {
    a := Actions{customer_slot = -1}
    a.start = rl.IsKeyPressed(.ENTER)
    a.demo = rl.IsKeyPressed(.D)
    a.pause = rl.IsKeyPressed(.P) || rl.IsKeyPressed(.ESCAPE)
    a.title = rl.IsKeyPressed(.T)
    if state == .Title || state == .Results {
        a.start = a.start || clicked(START_RECT)
        a.demo = a.demo || clicked(DEMO_RECT)
    }
    if state != .Playing { return a }
    a.add = {rl.IsKeyPressed(.ONE), rl.IsKeyPressed(.TWO), rl.IsKeyPressed(.THREE)}
    for i in 0..<ITEM_COUNT { a.add[i] = a.add[i] || clicked(item_rect(i)) }
    a.previous = rl.IsKeyPressed(.LEFT)
    a.next = rl.IsKeyPressed(.RIGHT) || rl.IsKeyPressed(.TAB)
    a.price_delta = int(rl.IsKeyPressed(.UP) || clicked(PLUS_RECT)) - int(rl.IsKeyPressed(.DOWN) || clicked(MINUS_RECT))
    a.serve = rl.IsKeyPressed(.SPACE) || clicked(SERVE_RECT)
    a.clear = rl.IsKeyPressed(.C) || clicked(CLEAR_RECT)
    for i in 0..<MAX_CUSTOMERS { if clicked(customer_rect(i)) { a.customer_slot = i } }
    return a
}
