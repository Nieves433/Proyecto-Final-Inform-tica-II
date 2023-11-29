import processing.serial.*;
Serial MiPuerto;
Processing Game;
int ShootValueY;
PFont myFont;
class Processing{
  int ValueX, ValueY, Move, Mode, ValueShipsX, ValueShipsY;
  int ShootValueX, Counter;
  boolean Win, Gunner, GetMove, Shoot;
  boolean[][] Ships = new boolean[3][7];
  int[] ShootShipsValueX = new int[3], ShootShipsValueY = new int[3], Random = new int[3];
  Processing(){
    Counter = 0;
    ValueX = 900;
    ValueY = 950;
    ValueShipsX = 100;  //posicion horizontal
    ValueShipsY = 50;  //posicion vertical
    Move = 100;  //desplazamiento de artillero
    Mode = 0;  //Utilizado en 2 funciones
    Win = false; 
    GetMove = false;
    Gunner = true;
    for(int j=0; j<3; j++){
      for(int i=0; i<7; i++){
      Ships[j][i] = true;}}
  }
  
  void MoveRectDer(){  //Descripción: Desplaza el artillero a la derecha siempre que no se supere un valor. Parametros: Null. Devuelve: Null.
    Game.ValueX += Game.Move;
    if(Game.ValueX > 1800){Game.ValueX = 1800;}}
    
  void MoveRectIzq(){  //Descripción: Desplaza el artillero a la izquierda siempre que no se supere un valor. Parametros: Null. Devuelve: Null.
    Game.ValueX -= Game.Move;
    if(Game.ValueX < 100){Game.ValueX = 100;}}
  
  int Ships(int ShootValueX, int ShootValueY, int ValueX, int ValueY, int Mode){  //Descripción: Dibuja la matriz de atacantes siempre que su estado sea verdadero y cambia su posición. Parámetros: Posición (X,Y) de proyectil, posición (X,Y) de atacantes y su estado de desplazamiento a der. Retorna: Nueva posición X de atacantes 
    int LongX = 0, LongY = 0;
    for(int j=0; j<3; j++){           //Cantidad de filas de naves
        for(int i=0; i<7; i++){       //Cantidad de columnas de naves
            Game.Collision( ShootValueX, ShootValueY, ValueX + LongX, ValueY + LongY, i, j, 2 );
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
                ValueX += 150;  //mueve el conjunto de naves a derecha
                Game.GetMove = false;}
            break;
            case 2:{
                ValueX -= 150;  //mueve el conjunto de naves a izquierda
                Game.GetMove = false;}
            break;}
    }
  return(ValueX);}  
  
  int Shoot(int ShootValueX, int ShootValueY, boolean Shoot){  //Descripción: Dibuja el proyectil del artillero y modifica su valor Y. Parámetros: Posición (X,Y) del proyectil del artillero y su estado. Retorna: Nueva posición Y del proyectil.
      if( Shoot == true ){
          fill(#FF0000);
          rect(ShootValueX ,ShootValueY-50,10,20);
          if( ShootValueY > 10){ 
              ShootValueY -= 10;}  //Desplaza el disparo hacia arriba
      }    
      return(ShootValueY);}
  
  int ShootShips( int ShootShipsValueX, int ShootShipsValueY, int ValueX, int ValueY, int Random, int i ){  //Descripción: Dibuja el proyectil del atacante siempre que el estado del atacantes sea verdadero. Parámetros: Posición (X,Y) del proyectil, posición (X,Y) del artillero, un numero aleatorio y un entero. Retorna: Nueva posición Y del proyectil.
      for(int j=2; j>0; j--){
              if( Ships[j][Random] == true ){  //Si el estado de la nave es cierto
                  fill(#FF0000);
                  rect( ShootShipsValueX, ShootShipsValueY + 80*j, 10, 20);  //Dibuja disparo en la posicion de la nave más cercana al artillero
                  Game.Collision( ShootShipsValueX, ShootShipsValueY + 80*j, ValueX, ValueY, i, 0, 1 );
                  j = 0;
                  if( ShootShipsValueY < 1200 ){  //Dibuja hasta alcanzar un máx en pantalla 
                       ShootShipsValueY += 20;}
          }
      }
      return(ShootShipsValueY);}    //Devuelve el nuevo valorY del disparo
    
  void Collision(int ValueXShoot, int ValueYShoot, int ValueXShip, int ValueYShip, int i, int j, int Mode ){  //Descripción: Cambia de estado del artillero o del atacante si alguno fue golpeado por un proyectil. Parámetros: Posición (X,Y) del proyectil, posición (X,Y) del atacante y un estado booleano. Retorna: Nada.
    switch( Mode ){
      case 1:{  //colision de artillero
        if( ValueXShip -100 < ValueXShoot && ValueXShoot < ValueXShip +100 && ValueYShoot +20 < ValueYShip +50 && ValueYShip -50 < ValueYShoot +20 ){
            Game.Gunner = false; //Cambia estado de nave
            MiPuerto.write( 'L' );  
          }
      }break;  
      case 2:{  //colision de naves
        if( ValueXShip -80 < ValueXShoot && ValueXShoot < ValueXShip +80 && ValueYShoot -20 < ValueYShip +40 && ValueYShip -40 < ValueYShoot -20 && Game.Ships[j][i] == true){
            Game.Ships[j][i] = false;  //Cambia estado de nave
            Game.Shoot = false;  //Cambia el estado del disparo
          }
      }break;
    }  
  } 
  
  boolean WinGame(boolean Win){  //Descripción: Cambia el estado booleano siempre que todos los atacantes hayan sido derribados. Parámetros: Estado booleano. Retorna: Estado booleano. 
      int Contador = 0;
      for(int j=0; j<3; j++){    //Verificamos el estado de los atacantes uno por uno
           for(int i=0; i<7; i++){
                if(Ships[j][i] == false){
                    Contador++;
                }  
           }
      }
      if( Contador == 21 ){  //Si contador es igual al numero de atacantes
          Game.Gunner = false;
          Win = true;    //Juego ganado
          MiPuerto.write( 'W' );
      }
      return( Win );
  }  
    
};  //End class

void setup() {
  myFont = loadFont("SegoeUIBlack-200.vlw");
  textFont(myFont);
  MiPuerto = new Serial(this, Serial.list()[2], 9600);
  fullScreen();
  //size(700, 700);
  Game = new Processing();
  rectMode(CENTER);
  ellipseMode(CENTER);
}
void draw(){
  if( Game.Gunner == true ){
      background( #030303 );
      fill( #FFFFFF );
      rect( Game.ValueX,Game.ValueY,100,50 );  //dibujo el artillero
      Game.Win = Game.WinGame( Game.Win );
      Game.ShootShipsValueY[0] = Game.ShootShips( Game.ShootShipsValueX[0], Game.ShootShipsValueY[0], Game.ValueX, Game.ValueY, Game.Random[0], 0 );
      Game.ShootShipsValueY[1] = Game.ShootShips( Game.ShootShipsValueX[1], Game.ShootShipsValueY[1], Game.ValueX, Game.ValueY, Game.Random[1], 1 );
      Game.ShootShipsValueY[2] = Game.ShootShips( Game.ShootShipsValueX[2], Game.ShootShipsValueY[2], Game.ValueX, Game.ValueY, Game.Random[2], 2 );
      Game.ValueShipsX = Game.Ships( Game.ShootValueX, ShootValueY, Game.ValueShipsX, Game.ValueShipsY, Game.Mode);
      ShootValueY = Game.Shoot( Game.ShootValueX, ShootValueY, Game.Shoot );
  }else{if( Game.Win == true ){
            fill(#0CF0EA);
            text("WIN", 750, 560);}
          else{fill(#F00C51);
               text("DEFEAT", 650, 560);}}  
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
      Game.ValueShipsY += 80;}  //Desplazamiento vertical de las naves al llegar al tope de pantalla
      break;
    case 'z':{
      Game.Shoot = true;
      Game.ShootValueX = Game.ValueX;
      ShootValueY = Game.ValueY;}
    break;
    case 'c':{
      if( Game.Counter < 3 ){
        Game.Random[Game.Counter] = int( random(7) );
       
        Game.ShootShipsValueX[Game.Counter] = Game.ValueShipsX;
        Game.ShootShipsValueX[Game.Counter] += Game.Random[Game.Counter] * 150;
        Game.ShootShipsValueY[Game.Counter] = Game.ValueShipsY;
        Game.Counter++;}else{Game.Counter = 0;}
      }
    break;
    case 'R':{
      Game.MoveRectDer();}  //Movimiento horizontal
    break;
    case 'L':{
      Game.MoveRectIzq();}  //Movimiento horizontal
    break;
    case 'G':{
      Game.Gunner = false;  //Termina el juego
      MiPuerto.write( 'L' );  }
  }
} 
