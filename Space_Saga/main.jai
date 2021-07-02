#import "Basic";
#import "raylib-jai";
#load "raylib-jai/raymath.jai";
Math :: #import "math";
#load "background.jai";
#load "player.jai";
#load "bullet.jai";
#load "enemy_turret.jai";
#load "sandbox.jai";
#load "utilites.jai";

// Project 1: Space Saga
// 
// Control a powerful ship in this top-down 2D shooter manuvering through enemy attacks
// while delivering devistating blows to the enemy fleet. Become wanted and the empire
// will send elite battleships to destoy you. Scavenge enemy wreckage to empower your arsence
// in this epic space saga.
//
// elements:
//  player ship
//      controls/input, HP, art/sprite/texture, size, weapons, movement, dodge/ Barrel roll?, 
//      movement
//          speed, velocity,
//      movement
//          speed, velocity,
// 
// enemy ship (2)
//      HP, AI, weapons, movement,
//  Elite ship (1)
//      HP, AI, weapons,
//  Background (DONE)
//      art/texture, star partivles.
//
//Window width
screenWidth :: 1600;
//Window height
screenHeight :: 900;

main :: ()
{
    InitWindow(screenWidth, screenHeight, "Project 1");
    defer CloseWindow();

    InitAudioDevice();
    defer CloseAudioDevice();

    SetTargetFPS(60);
    init_background();
    init_bullets();
    init_player();
    init_enemy_turret();

    spawn_enemy_turret(Vector2.{400,  60});
    //spawn_enemy_turret(Vector2.{500,  25});
    //spawn_enemy_turret(Vector2.{600,  25});
    //spawn_enemy_turret(Vector2.{700,  25});
    //spawn_enemy_turret(Vector2.{800,  25});
    //spawn_enemy_turret(Vector2.{900,  25});

    while !WindowShouldClose()    // Detect window close button or ESC key
    {
        BeginDrawing();
        defer EndDrawing();

        ClearBackground(WHITE);

        //DrawText("Congrats! You created your first window!", 190, 200, 20, LIGHTGRAY);
        draw_backgroud(); 
        simulate_bullets();
        simulate_player();
        simulate_enemy_turrets();
        //test_circle_to_circle();
        
        //print("FPS: %", GetFPS());

    }

}