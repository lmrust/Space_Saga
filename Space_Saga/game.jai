//Game state enum
GameState :: enum
{
    None;   
    Start;      //start screen
    Loose;      //Game over
    Win;        //Win
    Gameplay;   //game running
}
controls_texture : Texture2D;
death_texture : Texture2D;
win_texture : Texture2D;

init_game_state :: ()
{
    controls_texture = LoadTexture("resources/controls.png");
    death_texture = LoadTexture("resources/Death.png");
    win_texture = LoadTexture("resources/win.png");
}

reset_game_state :: ()
{
    g_enemy_turrets_spanwed = 0;
}

simulate_game_state :: ()
{
    width := GetScreenWidth();
    height := GetScreenHeight();
    

    if #complete g_current_game_state ==
    {
        case;                assert(false, "This state is Invalid");  //Do Nothing default case
        case GameState.None; assert(false, "This state is Invalid");  //Do Nothing

        case GameState.Start;

            if IsKeyDown(.KEY_SPACE)
            {
                change_game_state(.Gameplay);
                return;
            }
            {
            text :: "Space Saga";
            font_size : s32= 64;
            text_width := MeasureText(text, font_size);
            x := (width/2) - (text_width/2);
            DrawText(text, x, 100, font_size, WHITE);
            }
        
            {
            text :: "Controls";
            font_size : s32= 64;
            text_width := MeasureText(text, font_size);
            x := (width/2) - (text_width/2);
            DrawText(text, x, 180, font_size, WHITE);;
            }
            //Displays Controls Image
            {
            scale: float = 0.6;
            pos: Vector2;
            pos.x = (width*0.5) - (controls_texture.width*0.3);
            pos.y = (height*0.3) - (controls_texture.height*0.1);
            DrawTextureEx(controls_texture, pos, 0, scale, WHITE);
            }

        case GameState.Loose;
            // You Loose screen, Press space to try again.
            if IsKeyDown(.KEY_SPACE)
            {
                change_game_state(.Gameplay);
                return;
            }
            {
            text :: "Defeated!";
            font_size : s32= 64;
            text_width := MeasureText(text, font_size);
            x := (width/2) - (text_width/2);
            DrawText(text, x, 100, font_size, WHITE);
            }
            //Press SPACE to replay
            {
            text :: "Press SPACE to Replay";
            font_size : s32= 64;
            text_width := MeasureText(text, font_size);
            x := (width/2) - (text_width/2);
            DrawText(text, x, 175, font_size, WHITE);
            }
            //Displays skeleton Image
            {
            scale: float = 1.0;
            pos: Vector2;
            pos.x = (width*0.5) - (death_texture.width*0.5);
            pos.y = (height*0.3) - (death_texture.height*0.1);
            DrawTextureEx(death_texture, pos, 0, scale, WHITE);
            }
            {
            display_score : string = sprint ("Your Kill count: %\0", g_enemy_turrets_killed);
            font_size : s32= 64;
            text_width := MeasureText(display_score.data, font_size);
            x := (width/2) - (text_width/2);
            DrawText(display_score.data, x, 800, font_size, WHITE);
            }

        case GameState.Win;
            //Press Space to restart game
            if IsKeyDown(.KEY_SPACE)
            {
                change_game_state(.Gameplay);
                return;
            }
            //Victory Text
            {
            text :: "Victory!";
            font_size : s32= 64;
            text_width := MeasureText(text, font_size);
            x := (width/2) - (text_width/2);
            DrawText(text, x, 75, font_size, WHITE);
            }
            //Score text
            {
            display_score : string = sprint ("Your Kill count: %\0", g_enemy_turrets_killed);
            defer free(display_score);
            font_size : s32= 64;
            text_width := MeasureText(display_score.data, font_size);
            x := (width/2) - (text_width/2);
            DrawText(display_score.data, x, 150, font_size, WHITE);
            }
            //Displays victory trophy Image
            {
            scale: float = 0.8;
            pos: Vector2;
            pos.x = (width*0.5) - (win_texture.width*0.5);
            pos.y = (height*0.4) - (win_texture.height*0.1);
            DrawTextureEx(win_texture, pos, 0, scale, WHITE);
            }
            //press space to play again
            {
            text :: "Press SPACE to Replay";
            font_size : s32= 64;
            text_width := MeasureText(text, font_size);
            x := (width/2) - (text_width/2);
            DrawText(text, x, 800, font_size, WHITE);
            }

        case GameState.Gameplay;
        {
            time := GetTime();
            width := GetScreenWidth();
            //Kills to win the game!
            kills_to_win := 20; 
            
            //enemy counters
            total_count   := g_enemy_turrets_spanwed;
            current_count := enemy_turret_instances.count;
            kill_count    := total_count - current_count;
            g_enemy_turrets_killed = kill_count;

            //Check for Win State
            if kill_count >= kills_to_win
            {
                change_game_state(.Win);
                return;
            }

            //Display players current kill count
            {
                display_kill_count: string = sprint("Kills: %\0", kill_count);
                defer free(display_kill_count);
                font_size : s32= 32;
                DrawText(display_kill_count.data, 15, 15, font_size, WHITE);
            }

            //Display players health
            {
                display_health: string = sprint("Health: %\0", player.health);
                defer free(display_health);
                font_size : s32= 32;
                DrawText(display_health.data, 15, 62, font_size, WHITE);
            }

            max_allowed_on_screen := 5 + (xx kill_count / 3);
            can_spawn_enemy : bool = (current_count < max_allowed_on_screen);
            is_spawning_time : bool = (xx time % 10) == 0;

            if (can_spawn_enemy && is_spawning_time)
            {
            spawn_pos : Vector2;   
            spawn_pos.x = xx GetRandomValue(50, width - 50);
            spawn_pos.y = xx GetRandomValue(50, 350);

            spawn_enemy_turret(spawn_pos);
            g_enemy_turrets_spanwed += 1;
            print("Spawned Enemy Turrets: %", g_enemy_turrets_spanwed);
            }
            
        }
    } 
}

change_game_state :: (new_game_state : GameState)
{
    g_current_game_state = new_game_state;

    if #complete new_game_state ==
    {
        case;                assert(false);  //Do Nothing defaul case
        case GameState.None; assert(false);  //Do Nothing

        case GameState.Start;
            disable_gameplay();

        case GameState.Loose;
            disable_gameplay();

        case GameState.Win;
            disable_gameplay();
            reset_game_state();

        case GameState.Gameplay;
            g_enemy_turrets_killed = 0;
            reset_player();
            reset_game_state();
            enable_gameplay();
    }
}

enable_gameplay :: ()
{
}

disable_gameplay :: ()
{
    array_reset_keeping_memory(*bullet_instances);
    array_reset_keeping_memory(*enemy_turret_instances);
    player.alive = false;
}

#scope_file
g_current_game_state : GameState = .None;

g_enemy_turrets_spanwed: int;
g_enemy_turrets_killed: int;

