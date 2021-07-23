//Player input

//W = Up, D = Right, A = Left, S = Down
// num_pad 1 = fire, num_pad 2 = , num_pad 3 = 

init_player :: ()
{
    reset_player();
    // Load texture texture to player
    player.texture = LoadTexture("resources/player_texture_yellow.png");

    //Load speed boost texture
    player.texture_speedboost = LoadTexture("resources/Speed_Boost.png");

    //Load Sheild texture
    player.texture_shield = LoadTexture("resources/shield_texture.png");
}

reset_player :: ()
{
    //set player alive to true.
    player.alive = true;

    width := GetScreenWidth();
    height := GetScreenHeight();

    player.pos.x = width * 0.5;
    player.pos.y = height * 0.8;

    player.last_shot_time = GetTime();
    player.rate_of_fire = 0.28;

    player.radius = cast(float)(player.texture.width) / 2.5;
    player.health = 200;
}


simulate_player :: ()
{
    //do not simulate player if player is dead, Early return.
    if player.alive == false
    {
        return;
    }

    //Screen Size   
    width := GetScreenWidth();
    height := GetScreenHeight();
    time := GetTime();
    
    //print("drawing player");
    //DrawCircle(xx player.pos.x, xx player.pos.y, 10, BLUE);

    //Player Movement speed
    speed := GetFrameTime() * 400.0;
    speed_boost_active : bool = false;
    speed_boost_rate := GetFrameTime() * 300.0;

    //Input keys
    //Speed Boost Input
    if IsKeyDown(.KEY_KP_3) 
    {
    speed_boost_active = true;
    speed = speed + speed_boost_rate;
    }

    //Movement input
    if IsKeyDown(.KEY_D) player.pos.x += speed;
    if IsKeyDown(.KEY_A) player.pos.x -= speed;
    if IsKeyDown(.KEY_W) player.pos.y -= speed;
    if IsKeyDown(.KEY_S) player.pos.y += speed;

    if IsKeyDown(.KEY_KP_1) && can_player_shoot()
    {
        //DLC content true
        is_powerup_active : bool = false;

        if is_powerup_active
        {
            BULLET_VELOCITY :: Vector2. {0, -700};
            spawn_player_bullet(player.pos,                     BULLET_VELOCITY);
            spawn_player_bullet(player.pos + Vector2.{-20,+20}, BULLET_VELOCITY); //bot left bullet
            spawn_player_bullet(player.pos + Vector2.{+20,+20}, BULLET_VELOCITY); // bot right bullet
        }
        else
        {
            BULLET_VELOCITY :: Vector2. {0, -700};
            spawn_player_bullet(player.pos, BULLET_VELOCITY );
        }
        player.last_shot_time = time;
    } 
    //Bounds Check
    {   
        player.pos.x = clamp(player.pos.x, 0, xx width);
        player.pos.y = clamp(player.pos.y, 0, xx height);
    }
    //draw player icon
    {   
        scale: float = 0.8;
        pos: Vector2;
        pos.x = player.pos.x - (player.texture.width  * 0.5 * scale);
        pos.y = player.pos.y - (player.texture.height * 0.5 * scale);

        DrawTextureEx(player.texture, pos, 0, scale, WHITE);
        //DrawCircleSectorLines(player.pos, player.radius, 0, 360, 32, WHITE);
    }
    //draw Player boost texture
    {
        scale_boost: float = 0.1;
        offset: float = -15;
        pos: Vector2;
        pos.x = player.pos.x - (player.texture_speedboost.width  * 0.5 * scale_boost);
        pos.y = player.pos.y + (player.texture_speedboost.height * 0.5 * scale_boost);
        pos.y = pos.y + offset;

        if speed_boost_active
        {
            DrawTextureEx(player.texture_speedboost, pos, 0, scale_boost, WHITE);
        }
    }

    //draw player shield and check if key in down
    //Make player invincible
    if IsKeyDown(.KEY_KP_2)
    {
        scale_shield: float = 0.17;
        offset: float = 10;
        pos: Vector2;
        pos.x = player.pos.x - (player.texture_shield.width  * 0.5 * scale_shield);
        pos.y = player.pos.y - (player.texture_shield.height * 0.5 * scale_shield);
        pos.y = pos.y + offset;
        player.is_invicible = true;
        DrawTextureEx(player.texture_shield, pos, 0, scale_shield, GREEN);
    }
    else
    {
        player.is_invicible = false;
    }   
}

damage_player :: (amount: int)
{
    if player.is_invicible
    {
        return;
    }

    player.health -= amount;

    if player.health <= 0
    {
        //play_player_death_sound();
        //Play_player_death_VFX();
        //print("YOU HAVE DIED!\n");
        player.alive = false;

        //calculate player kill count
        
        change_game_state(GameState.Loose);
    }
}

can_player_shoot :: () -> bool
{
    time: float64 = GetTime();
    time_since_last_shot : float64 = time - player.last_shot_time;

    if time_since_last_shot >= player.rate_of_fire
    {
        return true;
    }
    else
    {
        return false;
    }
}

Player :: struct
{
    pos: Vector2;
    radius: float;
    health: int;
    last_shot_time: float64;
    rate_of_fire: float64;
    texture: Texture2D;
    texture_speedboost: Texture2D;
    texture_shield: Texture2D;
    is_invicible: bool;
    is_powerup_active: bool;
    alive: bool;
}
player: Player;


