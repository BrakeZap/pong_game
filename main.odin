package main

import "core:fmt"
import "vendor:raylib"


GameState :: enum {
  start,
  running
}

main :: proc() {
  using raylib
  
  initGame()
  leftRect: Rectangle = Rectangle{50,150,50,150}
  rightRect: Rectangle = Rectangle{700,150,50,150}
  pong: Vector2 = [2]f32{800/2,600/2}
  ballSpeed: Vector2 = [2]f32{0,0}
  currState: GameState = GameState.start
  
  for (!WindowShouldClose()) {
    inputHandler(&leftRect, &rightRect, &currState, &ballSpeed)
    collisionHandler(leftRect, rightRect, &pong, &ballSpeed, &currState)
    BeginDrawing()
    ClearBackground(Color([4]u8{0,0,0,0}))
    DrawRectangleRec(leftRect, Color([4]u8{255,255,255,255}))
    DrawRectangleRec(rightRect, Color([4]u8{255,255,255,255}))
    if currState == GameState.start { 
      DrawText("Press space to start!", 800/2-290, 550, 50, Color([4]u8{255,255,255,255}))
    }
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

inputHandler :: proc(leftRect: ^raylib.Rectangle, rightRect: ^raylib.Rectangle, currState: ^GameState, ballSpeed: ^raylib.Vector2) {
  speed: f32 = 5

  if raylib.IsKeyDown(raylib.KeyboardKey.W) && leftRect.y - speed >= 0{
    leftRect.y -= speed
  } if raylib.IsKeyDown(raylib.KeyboardKey.S) && leftRect.y + speed <= 450 {
    leftRect.y += speed
  }  if raylib.IsKeyDown(raylib.KeyboardKey.UP) && rightRect.y - speed >= 0 {
    rightRect.y -= speed
  } if raylib.IsKeyDown(raylib.KeyboardKey.DOWN) && rightRect.y + speed <= 450 {
    rightRect.y += speed
  }

  if raylib.IsKeyDown(raylib.KeyboardKey.SPACE) && currState^ == GameState.start{
    currState^ = GameState.running
    rand1 := raylib.GetRandomValue(0,1)
    rand2 := raylib.GetRandomValue(0,1)

    randArr := [2]f32{-5,5}

    ballSpeedX := randArr[rand1]
    ballSpeedY := randArr[rand2]

    ballSpeed^ += raylib.Vector2([2]f32{ballSpeedX,ballSpeedY})

  } 
}

collisionHandler :: proc(rec1: raylib.Rectangle, rec2: raylib.Rectangle, circle: ^raylib.Vector2, ballSpeed: ^raylib.Vector2, currState: ^GameState) {

  if circle.y > f32(raylib.GetScreenHeight() - 15.0) || circle.y <= 15 {
    ballSpeed.y *= -1
  } 

  if raylib.CheckCollisionCircleRec(circle^, 15, rec1) || raylib.CheckCollisionCircleRec(circle^, 15, rec2){
    ballSpeed.x *= -1
  }

  //Pong went out of bounds
  if (circle.x > f32(raylib.GetScreenWidth() - 15.0) || circle.x <= 15) {
    circle.x = f32(raylib.GetScreenWidth() / 2)
    circle.y = f32(raylib.GetScreenHeight() / 2)
    ballSpeed.x = 0
    ballSpeed.y = 0
    currState^ = GameState.start
  }
}