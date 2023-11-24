import processing.serial.*;
Serial MiPuerto;
Processing Game;
int ShootValueY;
class Processing{
  int ValueX, ValueY, Move, Mode, ValueShipsX, ValueShipsY;
  int ShootValueX ;
  boolean[][] Ships = new boolean[3][7];
  boolean GetMove, Shoot;
  Processing(){
    ValueX = 900;
    ValueY = 950;
    ValueShipsX = 100;
    ValueShipsY = 50;
    Move = 100;
    Mode = 0;
    GetMove = false;
    for(int j=0; j<3; j++){
      for(int i=0; i<7; i++){
      Ships[j][i] = true;}}
  }
  
  void MoveRectDer(){
    Game.ValueX += Game.Move;
    if(Game.ValueX > 1800){Game.ValueX = 1800;}}
  void MoveRectIzq(){
    Game.ValueX -= Game.Move;
    if(Game.ValueX < 100){Game.ValueX = 100;}}  
 
  int Shoot(int ShootValueX, int ShootValueY, boolean Shoot){  //Dibuja Shoot y modifica su valor Y
    if( Shoot == true ){
      fill(#FF0000);
      rect(ShootValueX ,ShootValueY-50,10,20);
      if( ShootValueY > 10){ 
        ShootValueY -= 10;}
    }    
    return(ShootValueY);}
    
  void Collision(int ValueXShoot, int ValueYShoot, int ValueXShip, int ValueYShip, int i, int j, boolean Shoot){
      if( ValueXShip -80 < ValueXShoot && ValueXShoot < ValueXShip +80 && ValueYShoot -20 < ValueYShip +40 && ValueYShip -40 < ValueYShoot -20 && Game.Ships[j][i] == true){
          Game.Ships[j][i] = false;  //Cambia estado de nave
          Game.Shoot = false;  //Cambia el estado del disparo
      }
  }  
    
  int DrawShips(int ShootValueX, int ShootValueY, int ValueX, int ValueY, int Mode, boolean Shoot){  //Dibuja las naves alienigenas
      int LongX = 0, LongY = 0;
      for(int j=0; j<3; j++){           //Cantidad de filas de naves
          for(int i=0; i<7; i++){       //Cantidad de columnas de naves
              Game.Collision( ShootValueX, ShootValueY, ValueX + LongX, ValueY + LongY, i, j, Shoot );
              if( Ships[j][i] == true ){  //Dibuja nave siempre que sea cierto su estado
                  fill(#1000FF);  
                  rect(ValueX + LongX,ValueY + LongY,80,40);
              }
              LongX += 150;  //Separacaion entre naves horizontal
          }
          LongX = 0; //Reinicio la separacion entre naves
          LongY += 80;}  //separacion entre naves vertical
      if( Game.GetMove == true ){  //get.move lo modofica arduino tras pasar un segundo  
          switch (Mode){  
              case 1:{
                  ValueX += 100;  //mueve el conjunto de naves a derecha
                  Game.GetMove = false;}
              break;
              case 2:{
                  ValueX -= 100;  //mueve el conjunto de naves a izquierda
                  Game.GetMove = false;}
              break;}
      }
    return(ValueX);}  
    
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
  background( #030303 );
  fill( #FFFFFF );
  rect( Game.ValueX,Game.ValueY,100,50 );  //dibujo el artillero
  Game.ValueShipsX = Game.DrawShips( Game.ShootValueX, ShootValueY, Game.ValueShipsX, Game.ValueShipsY, Game.Mode, Game.Shoot);
  ShootValueY = Game.Shoot( Game.ShootValueX, ShootValueY, Game.Shoot );
}
  
void serialEvent (Serial  MiPuerto){ //Get
  char caracter = MiPuerto.readChar();
  
  switch( caracter ){ //Disparo
    case 'r':{
      Game.GetMove = true;
      Game.Mode = 1;}
      break;
    case 'l':{
      Game.GetMove = true;
      Game.Mode = 2;}
      break;
    case 's':{
      Game.ValueShipsY += 50;}
      break;
    case 'z':{
      Game.Shoot = true;
      Game.ShootValueX = Game.ValueX;
      ShootValueY = Game.ValueY;}
    break;
    case 'R':{
      Game.MoveRectDer();}  //Movimiento horizontal
    break;
    case 'L':{
      Game.MoveRectIzq();}  //Movimiento horizontal
    break;
  }
} 
