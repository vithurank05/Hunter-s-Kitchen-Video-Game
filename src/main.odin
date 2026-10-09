package cafe

import rl "vendor:raylib"

main :: proc() {
    rl.InitWindow(1120, 720, "Campus Cafe - Checkpoint 2")
    if !rl.IsWindowReady() { return }
    defer rl.CloseWindow()
    // Escape pauses instead of silently closing the game.
    rl.SetExitKey(rl.KeyboardKey(0))
    rl.SetTargetFPS(60)
    game := Game{state = .Title, selected = -1, feedback = "Welcome to Campus Cafe"}
    for !rl.WindowShouldClose() {
        actions := read_actions(game.state)
        dt := min(rl.GetFrameTime(), f32(0.1))
        update_game(&game, actions, dt)
        rl.BeginDrawing()
        render_game(&game)
        rl.EndDrawing()
    }
}
