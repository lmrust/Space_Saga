//Background file

    #if OS == .WINDOWS || OS == .MACOS
    GLSL_VERSION :: 330;
    else
    GLSL_VERSION :: 100;

draw_backgroud :: ()
{
    
    //print("Draw Background\n");

    screenSize: [2]float;
    screenSize[0] = cast(float)GetScreenWidth();
    screenSize[1] = cast(float)GetScreenHeight();

    SetShaderValue(shader, size_Loc, *screenSize, .UNIFORM_VEC2);
    SetShaderValue(shader, freqXLoc,  *freqX,  .UNIFORM_FLOAT);
    SetShaderValue(shader, freqYLoc,  *freqY,  .UNIFORM_FLOAT);
    SetShaderValue(shader, ampXLoc,   *ampX,   .UNIFORM_FLOAT);
    SetShaderValue(shader, ampYLoc,   *ampY,   .UNIFORM_FLOAT);
    SetShaderValue(shader, speedXLoc, *speedX, .UNIFORM_FLOAT);
    SetShaderValue(shader, speedYLoc, *speedY, .UNIFORM_FLOAT);

    seconds:float32 = xx GetTime();

    SetShaderValue(shader, secondsLoc, *seconds, .UNIFORM_FLOAT);

    BeginShaderMode(shader);
    defer EndShaderMode();

    DrawTexture(texture, 0, 0, WHITE);
    //DrawTexture(texture, texture.width, 0, WHITE);
}

init_background :: ()
{
    // Load texture texture to apply shaders
    texture = LoadTexture("resources/space.png");
    
    // Load shader and setup location points and values
    shader = LoadShader(null, TextFormat("resources/shaders/glsl%i/wave.fs", GLSL_VERSION));

    size_Loc   = GetShaderLocation(shader,"size");

    secondsLoc = GetShaderLocation(shader, "secondes");
    freqXLoc   = GetShaderLocation(shader, "freqX");
    freqYLoc   = GetShaderLocation(shader, "freqY");
    ampXLoc    = GetShaderLocation(shader, "ampX");
    ampYLoc    = GetShaderLocation(shader, "ampY");
    speedXLoc  = GetShaderLocation(shader, "speedX");
    speedYLoc  = GetShaderLocation(shader, "speedY");
}

#scope_file
// Load texture texture to apply shaders
texture : Texture2D;

// Load shader and setup location points and values
shader : Shader;

// window size
size_Loc :    s32;
secondsLoc :  s32;
freqXLoc :    s32;
freqYLoc :    s32;
ampXLoc :     s32;
ampYLoc :     s32;
speedXLoc :   s32;
speedYLoc :   s32;

// Shader uniform values that can be updated at any time
freqX:  float = 5.0;
freqY:  float = 5.0;
ampX:   float = 3.0;
ampY:   float = 3.0;
speedX: float = 10.0;
speedY: float = 10.0;