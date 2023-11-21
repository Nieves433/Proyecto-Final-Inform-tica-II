import processing.serial.*;
Serial MiPuerto;
Processing Game;
class Processing{
  int ValueX, ValueY, Move;
  int[] ShootValueX = new int[7], ShootValueY = new int[7];;
  Processing(){
    ValueX = 900;
    ValueY = 1000;
    Move = 100;
  }
  
  void moveRect(char HorizontalMov){
      
     if( 100 <= Game.ValueX && Game.ValueX <= 1800){
        switch(HorizontalMov){
          case 'R':{
              Game.ValueX += Game.Move;
              if(Game.ValueX > 1700){Game.ValueX = 1800;}}
          break;
          case 'L':{
              Game.ValueX -= Game.Move;
              if(Game.ValueX < 100){Game.ValueX = 100;}}
          break;    
          case 'r':{
              Game.ValueX += Game.Move;
              Game.ValueX += Game.Move;
              if(Game.ValueX > 1700){Game.ValueX = 1800;}}
          break;
          case 'l':{
              Game.ValueX -= Game.Move;
              Game.ValueX -= Game.Move;
              if(Game.ValueX < 100){Game.ValueX = 100;}}
          break;
        }
     }   
  }
  int Shoot(int ShootValueX, int ShootValueY){
    fill(#FF0000);
    rect(ShootValueX,ShootValueY-50,10,30);
    if( ShootValueY > 30){ 
      ShootValueY -= 10;}
    return(ShootValueY);}  
};  //End class
void setup() {
  //printArray(Serial.list());
  MiPuerto = new Serial(this, Serial.list()[2], 9600);
  fullScreen();
  //size(700, 700);
  Game = new Processing();
  rectMode(CENTER);
  ellipseMode(CENTER);
}
void draw(){
  background(#030303);
  fill(#FFFFFF);
  rect(Game.ValueX,Game.ValueY,100,50);
  for(int i=0;i<7;i++){
    Game.ShootValueY[i] = Game.Shoot(Game.ShootValueX[i], Game.ShootValueY[i] );}
}
  
void serialEvent (Serial  MiPuerto){ //Get
  char dato = MiPuerto.readChar();
  Game.moveRect( dato );
  switch( dato ){
    case 'z':{
      Game.ShootValueX[0] = Game.ValueX;
      Game.ShootValueY[0] = Game.ValueY;}
    break;  
    case 'x':{
      Game.ShootValueX[1] = Game.ValueX;
      Game.ShootValueY[1] = Game.ValueY;}
    break;
    case 'c':{
      Game.ShootValueX[2] = Game.ValueX;
      Game.ShootValueY[2] = Game.ValueY;}
    break;
    case 'v':{
      Game.ShootValueX[3] = Game.ValueX;
      Game.ShootValueY[3] = Game.ValueY;}
    break;
    case 'b':{
      Game.ShootValueX[4] = Game.ValueX;
      Game.ShootValueY[4] = Game.ValueY;}
    break;
    case 'n':{
      Game.ShootValueX[5] = Game.ValueX;
      Game.ShootValueY[5] = Game.ValueY;}
    break;
    case 'm':{
      Game.ShootValueX[6] = Game.ValueX;
      Game.ShootValueY[6] = Game.ValueY;}
    break;
  }
} 
