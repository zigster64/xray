//
// basic_window
// Zig version: 0.6.0
// Author: Nikolas Wipper
// Date: 2020-02-15
//

const rl = @import("raylib");
const print = @import("std").debug.print;

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 1366;
    const screenHeight = 768;

    rl.InitWindow(screenWidth, screenHeight, "Raylib Experiments");

    const monitor_count = rl.GetMonitorCount();
    print("Monitors = {}\n", .{monitor_count});
    print("Screen = {}x{}\n", .{ rl.GetScreenWidth(), rl.GetScreenHeight() });

    rl.SetTargetFPS(60); // Set our game to run at 60 frames-per-second

    // rl.InitAudioDevice();
    // const track = rl.LoadSound("sounds/exorcism.opus");
    // const track = rl.LoadSound("sounds/vril.mp4");
    // const track = rl.LoadSound("sounds/detroit.mp3");
    // const track = rl.LoadSound("sounds/backhome.ogg");
    // const track = rl.LoadSound("sounds/cherrypie.ogg");
    // print("track = {}\n", .{track});
    // rl.PlaySound(track);

    //--------------------------------------------------------------------------------------
    var mx: c_int = 0;
    var my: c_int = 0;

    // Main game loop
    while (!rl.WindowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // TODO: Update your variables here
        //----------------------------------------------------------------------------------
        const mouse_x = rl.GetMouseX();
        const mouse_y = rl.GetMouseY();
        const mp = rl.GetMousePosition();
        const md = rl.GetMouseDelta();

        if (mouse_x != mx or mouse_y != my) {
            mx = mouse_x;
            my = mouse_y;
            print("mouse {}:{} {}->{}\n", .{ mx, my, mp, md });
        }

        // Draw
        //----------------------------------------------------------------------------------
        rl.BeginDrawing();

        rl.ClearBackground(rl.WHITE);

        rl.DrawText("Looking for Game Servers ...", screenWidth / 4, screenHeight / 2, 48, rl.BLUE);
        //rl.DrawText("Start Game", screenWidth / 2 - 100, screenHeight / 2, 48, rl.BLUE);

        rl.DrawFPS(20, 20);

        rl.EndDrawing();
        //----------------------------------------------------------------------------------
    }

    // De-Initialization
    //--------------------------------------------------------------------------------------
    // rl.StopSound(track);
    // rl.CloseAudioDevice();
    rl.CloseWindow(); // Close window and OpenGL context
    //--------------------------------------------------------------------------------------
}
