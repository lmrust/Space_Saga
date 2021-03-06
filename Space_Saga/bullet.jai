//Bullet file
//load sounds
Sound_List :: struct
{
    player_bullet : Sound;
    enemy_bullet : Sound;
    player_death : Sound;
    enemy_death : Sound;
}

G_SOUND_LIST : Sound_List;

bullet_frames: [..]Texture2D;

Team :: enum
{
    Player :: 1;
    Enemy  :: 2;
}

Bullet :: struct
{
    //bullet details
    pos:       Vector2;
    velocity : Vector2;

    radius :     float32;
    birth:       float64;
    team :       Team;
    bullet_dmg : int;
    lifespan :   float64; //in seconds
    damage :     int; //bullet damage
}

bullet_instances : [..]Bullet;
spawn_player_bullet :: (position: Vector2, inital_velocity: Vector2)
{
    b: Bullet;

    b.pos = position;
    b.velocity = inital_velocity;
    b.radius = 10;
    b.birth = GetTime();
    b.team = Team.Player;
    b.lifespan = 2.0;  //Life of bullet in seconds
    b.damage = 75;

    array_add(*bullet_instances, b);
    //PlaySound(G_SOUND_LIST.player_bullet);
}

spawn_enemy_turret_bullet :: (position: Vector2, inital_velocity: Vector2)
{
    b: Bullet;

    b.pos = position;
    b.velocity = inital_velocity;
    b.radius = 10;
    b.birth = GetTime();
    b.team = Team.Enemy;
    b.lifespan = 3.0;  //Life of bullet in seconds
    b.damage = 25;

    array_add(*bullet_instances, b);
}


init_bullets :: ()
{
    
    //Load Bullet Textures
    array_add(*bullet_frames, LoadTexture("resources/bullet_frame_0.png"));
    array_add(*bullet_frames, LoadTexture("resources/bullet_frame_1.png"));
    array_add(*bullet_frames, LoadTexture("resources/bullet_frame_2.png"));
    array_add(*bullet_frames, LoadTexture("resources/bullet_frame_3.png"));

    //Load Bullets Sounds
    G_SOUND_LIST.player_bullet = LoadSound("resources/sounds/player_bullet.wav");
}

//simulate bullets
simulate_bullets :: ()
{
    physics_bullets();
    draw_bullets();
}
physics_bullets :: ()
{
    for *bullet : bullet_instances
    {
        end_bullet: bool;
        if bullet.team == Team.Player
        {
            for *et : enemy_turret_instances
            {
                if overlapping_cirles(bullet.pos, bullet.radius, et.pos, et.radius)
                {
                    //If over lapping turret
                    et.health -= bullet.damage;
                    end_bullet = true;
                    if et.health <= 0
                    {
                        remove; //remove enemy turret or et
                    }
                    break;
                }
            }
        }
        if bullet.team == Team.Enemy && player.alive
        {
            if overlapping_cirles(bullet.pos, bullet.radius, player.pos, player.radius)
            {
                //If over lapping turret
                damage_player(bullet.damage);
                end_bullet = true;
            }
        }
        if end_bullet
        {
            remove; // remove bullet
        }
    }
}

// Draw bullets
draw_bullets :: ()
{
    time := GetTime();
    dt := GetFrameTime();
    speed := dt * 350;
    texture_offset : Vector2;
    scale: float32 = 0.5;

    {
        first_frame: Texture2D = bullet_frames[0];
        texture_offset.x = -(first_frame.width * 0.5 * scale);
        texture_offset.y = -(first_frame.height * 0.5 * scale);
    }
    for *bullet : bullet_instances
    {
        //Move Bullet by it's velocity
        bullet.pos = bullet.pos + bullet.velocity * dt;

        frame_count := bullet_frames.count;
        bullet_time := time - bullet.birth;
        frame_peroid : float64 = 1.0/15.0; //10 fps

        frame_index := round_to_nearest_int(bullet_time / frame_peroid) % frame_count;

        //Bullet frames  
        scale: float = 0.5;
        pos :Vector2;
        pos.x = bullet.pos.x + texture_offset.x;
        pos.y = bullet.pos.y + texture_offset.y;
        DrawTextureEx(bullet_frames[frame_index], pos, 0, scale, WHITE);

        //debug
        //DrawCircleSectorLines(bullet.pos, bullet.radius,0 , 360, 32, WHITE);

        //Check if bullet is dead
        if bullet_time >= bullet.lifespan
        {
            remove;
            continue;
        }
    }
}

//Helper rounding function
round_to_nearest_int :: (f: float64) -> int
{
    return cast (int)(f + 0.5);
}