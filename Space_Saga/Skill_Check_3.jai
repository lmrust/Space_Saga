#import "Basic";
#import "raylib-jai";
#load "raylib-jai/raymath.jai";
Math :: #import "math";
#load "background.jai";
#load "player.jai";
#load "bullet.jai";
#load "sandbox.jai";

str: string = "Hello Man";
num :: 64;
//
//main :: ()
//{
//    print("What ho! %, is that a N%\n", str, num);
//}


//Player :: struct
//{
//  pos:    glm.vec2;
//  flags:  PlayerFlags: PlayerFlags.None;
//  color:  glm.vec4;
//  health: int:         100;
//  mana:   int:         500;
//}





Pizza :: struct
{
  hasPeperonni: bool;  
  hasPineapple: bool;
  hasSausage: bool;
  hasPasta: bool;
  sliceCount: int;
};




//Pizza :: struct
//{
//  hasPeperonni: bool;
//  sliceCount:   int;
//  hasPineapple: bool;
//  hasSausage:   bool;
//  hasPasta:     bool;
//};
 
pizzaSize :: size_of(Pizza);


main :: ()
{
  print("%\n", pizzaSize);
  print("What ho! %, is that a N%\n", str, num);

    arr: [10]int;
    for 0..arr.count-1
    {
        arr[it] = it;
    }

  //v0:u8 = cast,trunc(u8)1000;
  //v0 = 232
  //v1:u8 = v0 + 10;  

  //print("%\n", v1);

  //v0:u16 = 10000;
  //v1:u16 = v0 + 1000;
  //print("%\n", v1); 


  //pv: *void;
  //pi: *int;
  //spv :: size_of(type_of(pv));
  //spi :: size_of(type_of(pi));
//
  //print("%\n", spv); 
  //print("%\n", spi); 

  //  arr: [4]int;
  //  for 0..4
  //  {
  //      arr[i] = it;
  //  }




  //i := 0;
  //while (i < 3)
  //{
  //    sum: int;
  //    sum += 1;
  //    i += 1;
  //}
  //print("%\n", sum);




  //    i := 5;
  //while (i)
  //{ 
  //    print("%,", i);
  //    i -= 1;
  //}
  //print("\n");
}
