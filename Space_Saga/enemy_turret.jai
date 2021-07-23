Enemy_Turret :: struct
{
    pos: Vector2;
    radius: float;
    health: int;
    last_shot_time: float64;
    rate_of_fire: float64;
}

init_enemy_turret :: ()
{
    enemy_turret_base_texture= LoadTexture("resources/enemy_turret_base_texture.png");
    enemy_turret_gun_texture= LoadTexture("resources/enemy_turret_gun_texture.png");
}

spawn_enemy_turret :: (position :Vector2)
{
    et: Enemy_Turret;

    et.pos = position;
    et.radius = 32;
    et.health = 200;
    et.last_shot_time = GetTime();
    et.rate_of_fire = 1.68; //rate bullets are fired

    array_add(*enemy_turret_instances, et);
}

simulate_enemy_turrets :: ()
{
    base_texture_offset : Vector2;
    gun_texture_offset : Vector2;
    scale: float32 = 0.2;
    turret_death_count : int;
    turret_death_count_win  : int = 2 ;

    // get enemy turret texture offset
    {
        first_frame: Texture2D = bullet_frames[0];
        base_texture_offset.x = -(enemy_turret_base_texture.width * 0.5 * scale);
        base_texture_offset.y = -(enemy_turret_base_texture.height * 0.5 * scale);
        gun_texture_offset.x = -(enemy_turret_gun_texture.width * 0.5 * scale);
        gun_texture_offset.y = -(enemy_turret_gun_texture.height * 0.5 * scale);
    }

    //Shoot at player
    time: float64 = GetTime();
    for *et : enemy_turret_instances
    {
        time_since_last_shot : float64 = time - et.last_shot_time;
        if time_since_last_shot >= et.rate_of_fire
        {
            vecToPlayer : Vector2 = player.pos - et.pos;
            vecToPlayerNorm : Vector2 = Vector2Normalize(vecToPlayer);
            bullet_veloctiy : Vector2 = vecToPlayerNorm * 280;

            spawn_enemy_turret_bullet(et.pos, bullet_veloctiy);
            et.last_shot_time = time;
            //DrawCircleSectorLines(et.pos, et.radius,0 , 360, 32, VIOLET);
        }
        //Draw enemy turrets
        vecToPlayer : Vector2 = player.pos - et.pos;
        vecToPlayerNorm : Vector2 = Vector2Normalize(vecToPlayer);
        bullet_veloctiy : Vector2 = vecToPlayerNorm * 280;

        RAD_TO_DEG :: 180.0 / Math.PI;
        DEG_TO_RAD :: Math.PI / 180.0;
        angle_radians : float = Math.atan2(vecToPlayerNorm.y, vecToPlayerNorm.x) - (Math.PI);
        angle_degrees : float = angle_radians * RAD_TO_DEG;
        
        pos_base : Vector2;
        pos_base.x = et.pos.x + base_texture_offset.x;
        pos_base.y = et.pos.y + base_texture_offset.y;

        gun_rotated_offset := calculate_rotated_offset(gun_texture_offset, angle_radians);
        pos_gun : Vector2;
        pos_gun.x = et.pos.x + gun_rotated_offset.x;
        pos_gun.y = et.pos.y + gun_rotated_offset.y;

        DrawTextureEx(enemy_turret_base_texture, pos_base, 0, scale, WHITE);
        DrawTextureEx(enemy_turret_gun_texture, pos_gun, angle_degrees, scale, WHITE);

        //Prints the angle between turret and player ship
        //print("angle %\n", angle_degrees);

        //Enemy Movement
        //dt := GetFrameTime();
        //Enemy_speed := dt * 50;
        //et.pos.y += Enemy_speed;
    }
}
enemy_turret_base_texture: Texture2D;
enemy_turret_gun_texture: Texture2D;
enemy_turret_instances: [..]Enemy_Turret;
