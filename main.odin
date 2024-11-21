package main

import "core:fmt"
import "vendor:raylib"


main :: proc() {
  using raylib
  
  initGame()
  leftRect: Rectangle = Rectangle{50,150,50,200}
  rightRect: Rectangle = Rectangle{700,150,50,200}
  pong: Vector2 = [2]f32{800/2,600/2}
  ballSpeed: Vector2 = [2]f32{5,5}
  for (!WindowShouldClose()) {
    inputHandler(&leftRect, &rightRect)
    collisionHandler(leftRect, rightRect, &pong, &ballSpeed)
    BeginDrawing()
    ClearBackground(Color([4]u8{0,0,0,0}))
    DrawRectangleRec(leftRect, Color([4]u8{255,255,255,255}))
    DrawRectangleRec(rightRect, Color([4]u8{255,255,255,255}))
    DrawCircleV(pong, 15, Color([4]u8{255,255,255,255}))
    pong += ballSpeed
    EndDrawing()
  }
  CloseWindow()


}

initGame :: proc() {
  width: i32 = 800
  height: i32 = 600
  raylib.InitWindow(width, height, "Pong Game")
  raylib.HideCursor()
  //raylib.DisableCursor()
  raylib.SetTargetFPS(60)
  
}

inputHandler :: proc(leftRect: ^raylib.Rectangle, rightRect: ^raylib.Rectangle) {
  speed: f32 = 5

  if raylib.IsKeyDown(raylib.KeyboardKey.W) && leftRect.y - speed >= 0{
    leftRect.y -= speed
  } else if raylib.IsKeyDown(raylib.KeyboardKey.S) && leftRect.y + speed <= 400 {
    leftRect.y += speed
  }  else if raylib.IsKeyDown(raylib.KeyboardKey.UP) && rightRect.y - speed >= 0 {
    rightRect.y -= speed
  } else if raylib.IsKeyDown(raylib.KeyboardKey.DOWN) && rightRect.y + speed <= 400 {
    rightRect.y += speed
  }
}

collisionHandler :: proc(rec1: raylib.Rectangle, rec2: raylib.Rectangle, circle: ^raylib.Vector2, ballSpeed: ^raylib.Vector2) {

  if circle.y > f32(raylib.GetScreenHeight() - 15.0) || circle.y <= 15 {
    ballSpeed.y *= -1
  } 

  if raylib.CheckCollisionCircleRec(circle^, 15, rec1) || raylib.CheckCollisionCircleRec(circle^, 15, rec2){
    ballSpeed.x *= -1
  }
}