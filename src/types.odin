package cafe

import rl "vendor:raylib"

Game_State :: enum { Title, Playing, Paused, Results }
Item :: enum { Coffee, Sandwich, Muffin }
ITEM_COUNT :: 3
MAX_CUSTOMERS :: 3
SHIFT_SECONDS :: f32(600)
DEMO_SECONDS :: f32(90)
Menu_Item :: struct { name: cstring, price: int }
MENU := [ITEM_COUNT]Menu_Item{{"Coffee", 3}, {"Sandwich", 5}, {"Muffin", 4}}
// Each student is one data record. Systems iterate the same fixed collection.
Customer :: struct {
    active: bool,
    id: int,
    order: [ITEM_COUNT]int,
    patience, max_patience: f32,
}
Game :: struct {
    state: Game_State,
    customers: [MAX_CUSTOMERS]Customer,
    selected: int,
    tray: [ITEM_COUNT]int,
    charge: int,
    remaining, duration, spawn_timer: f32,
    next_id, served, missed, mistakes, revenue: int,
    feedback: cstring,
    feedback_time: f32,
    feedback_ok: bool,
}
// Input is sampled once. Gameplay consumes actions, not Raylib key queries.
Actions :: struct {
    start, demo, pause, title, serve, clear: bool,
    add: [ITEM_COUNT]bool,
    previous, next: bool,
    price_delta: int,
    customer_slot: int,
}
customer_rect :: proc(i: int) -> rl.Rectangle { return {f32(40+i*360), 165, 340, 215} }
item_rect :: proc(i: int) -> rl.Rectangle { return {f32(40+i*220), 425, 200, 105} }
SERVE_RECT :: rl.Rectangle{770, 445, 300, 65}
CLEAR_RECT :: rl.Rectangle{770, 525, 140, 45}
MINUS_RECT :: rl.Rectangle{470, 555, 55, 45}
PLUS_RECT :: rl.Rectangle{615, 555, 55, 45}
START_RECT :: rl.Rectangle{390, 315, 340, 60}
DEMO_RECT :: rl.Rectangle{390, 390, 340, 60}
