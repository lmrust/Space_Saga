//Test sandbox
//Collision test WORKS!
Circle :: struct
{
    pos: Vector2;
    radius: float32;
}
test_circle_to_circle :: ()
{   
    c0: Circle;
    c0.pos = Vector2.{100, 100};
    c0.radius = 50;
    c1: Circle;
    c1.pos = Vector2.{200, 200};
    c1.radius = 150;

    vec := c1.pos - c0.pos;

    length_sqrd := (vec.x * vec.x) + (vec.y * vec.y);
    //length := Math.sqrt(length_sqrd);

    radius_sum := c0.radius + c1.radius;
    radius_sum_sqrd := radius_sum * radius_sum;

    if length_sqrd <= radius_sum_sqrd //circles are overlapping
    {
        //print("circles are Colliding!\n");
    }

    //DrawLineV(c0.pos, c1.pos, GRAY);
    //DrawCircleSectorLines(c0.pos, c0.radius, 0, 360, 32, VIOLET);
    //DrawCircleSectorLines(c1.pos, c1.radius, 0, 360, 32, LIME);
}

overlapping_cirles :: (p0: Vector2, r0: float, p1: Vector2, r1: float) -> bool
{
    vec := p1 - p0;
    
    length_sqrd : float = (vec.x * vec.x) + (vec.y * vec.y);
    //length := Math.sqrt(length_sqrd);

    radius_sum := r0 + r1;
    radius_sum_sqrd := radius_sum * radius_sum;

    if length_sqrd < radius_sum_sqrd // circles are overlapping
    {
        return true;
    }
    return false;
}