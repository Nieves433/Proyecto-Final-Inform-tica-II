import processing.serial.*;
Serial MiPuerto;
VideoGame Game;
int Scenery = 1 ;
PFont myFont;
PImage GunnerImage;
PImage AlienImage[][] = new PImage[3][3];
class VideoGame{
  int GunnerX, GunnerY, Move, Mode, Mode2, ShipsX, ShipsY;
  int GunnerShotX, GunnerShotY, CounterShots;
  boolean Gunner, GetMove, Shot;
  boolean[][] Ships = new boolean[3][7];
  int[] ShipsShotX = new int[3], ShipsShotY = new int[3], Random = new int[3];
  VideoGame(){
    CounterShots = 0;
    GunnerX = round(0.4687*width);
    GunnerY = round(0.8796*height);
    ShipsX = round(0.052*width);  //posicion width
    ShipsY = round(0.0462*height);  //posicion height
    Move = round(0.052*width);  //desplazamiento de artillero
    Mode = 0;  //Utilizado en 2 funciones
    GetMove = false;
    Gunner = true;
    for(int j=0; j<3; j++){
      for(int i=0; i<7; i++){
      Ships[j][i] = true;}}
  }
  void PositionGunner(int GunnerX, int GunnerY){
    float cte1=0.052, cte2=0.0462;
    image(GunnerImage, GunnerX, GunnerY, round(cte1*width), round(cte2*height));
  }
  void MoveGunnerRight(){  //Descripción: Desplaza el artillero a la derecha siempre que no se supere un valor. Parametros: Null. Devuelve: Null.
    float cte = 0.9375;
    Game.GunnerX += Game.Move;
    if(Game.GunnerX > int(cte*width)){Game.GunnerX = int(cte*width);}}
    
  void MoveGunnerLeft(){  //Descripción: Desplaza el artillero a la izquierda siempre que no se supere un valor. Parametros: Null. Devuelve: Null.
    float cte = 0.0520;
    Game.GunnerX -= Game.Move;
    if(Game.GunnerX < int(cte*width)){Game.GunnerX = int(cte*width);}}
  
  int Ships(int GunnerShotX, int GunnerShotY, int ShipX, int ShipY, int Mode, int Mode2){  //Descripción: Dibuja la matriz de atacantes siempre que su estado sea verdadero y cambia su posición. Parámetros: Posición (X,Y) de proyectil, posición (X,Y) de atacantes y su estado de desplazamiento a der. Retorna: Nueva posición X de atacantes 
    float cte1=0.0781, cte2=0.0416, cte3=0.037, cte4=0.074;
    int LongX = 0, LongY = 0;
    switch(Scenery){
          case 1:{
                for(int j=0; j<3; j++){           //Cantidad de filas de naves
                      for(int i=0; i<7; i++){       //Cantidad de columnas de naves
                          Game.Collision( GunnerShotX, GunnerShotY, ShipX + LongX, ShipY + LongY, i, j, 2 );
                          if( Ships[j][i] == true ){  //Dibuja nave siempre que sea cierto su estado
                              image(AlienImage[j][Mode2], ShipX + LongX, ShipY + LongY, round(cte2*width), round(cte3*height));
                          }
                          LongX += round(cte1*width);  //Separacaion entre naves en eje X
                      }
                      LongX = 0; //Reinicio la separacion entre naves en eje X
                      LongY += round(cte4*height);}  //separacion entre naves en eje Y
                if( Game.GetMove == true ){  //get.move lo modofica arduino tras pasar un segundo  
                    switch (Mode){  
                        case 1:{
                            ShipX += round(cte1*width);  //mueve el conjunto de naves a derecha
                            Game.GetMove = false;}
                        break;
                        case 2:{
                            ShipX -= round(cte1*width);  //mueve el conjunto de naves a izquierda
                            Game.GetMove = false;}
            break;}
          }
         

          }
    }
  return(ShipX);}  
  
  int GunnerShot(int GunnerShotX, int GunnerShotY, boolean Shot){  //Descripción: Dibuja el proyectil del artillero y modifica su valor Y. Parámetros: Posición (X,Y) del proyectil del artillero y su estado. Retorna: Nueva posición Y del proyectil.
      float cte1=0.0462, cte2=0.0052, cte3=0.0185, cte4=0.0092;
      if( Shot == true ){
          fill(#FF0000);
          rect(GunnerShotX ,GunnerShotY-round(cte1*height),round(cte2*width),round(cte3*height));
          if( GunnerShotY > round(cte4*height)){ 
              GunnerShotY -= round(cte4*height);}  //Desplaza el proyectil hacia arriba
      }    
      return(GunnerShotY);}
  
  int ShipsShot( int ShipsShotX, int ShipsShotY, int GunnerX, int GunnerY, int Random, int i ){  //Descripción: Dibuja el proyectil del atacante siempre que el estado del atacantes sea verdadero. Parámetros: Posición (X,Y) del proyectil, posición (X,Y) del artillero, un numero aleatorio y un entero. Retorna: Nueva posición Y del proyectil.
      float cte1=0.074, cte2=0.0052, cte3=0.0185, cte4=1.111;
      for(int j=2; j>0; j--){
              if( Ships[j][Random] == true ){  //Si el estado de la nave es cierto
                  fill(#FF0000);
                  rect( ShipsShotX, ShipsShotY + round(cte1*height)*j, round(cte2*width), round(cte3*height));  //Dibuja disparo en la posicion de la nave más cercana al artillero
                  Game.Collision( ShipsShotX, ShipsShotY + round(cte1*height)*j, GunnerX, GunnerY, i, 0, 1 );
                  j = 0;
                  if( ShipsShotY < round(cte4*height) ){  //Dibuja hasta alcanzar un máx en pantalla 
                       ShipsShotY += round(cte3*height);}
          }
      }
      return(ShipsShotY);}    //Devuelve el nuevo valorY del disparo
    
  void Collision(int ValueXShot, int ValueYShot, int ValueXPosition, int ValueYPosition, int i, int j, int Mode ){  //Descripción: Cambia de estado del artillero o del atacante si alguno fue golpeado por un proyectil. Parámetros: Posición (X,Y) del proyectil, posición (X,Y) del atacante y un estado booleano. Retorna: Nada.
    float cte1=0.052, cte2=0.0462, cte3=0.0185, cte4=0.0416, cte5=0.037;
    switch( Mode ){
      case 1:{  //colision de artillero
        if( ValueXPosition -round(cte1*width) < ValueXShot && ValueXShot < ValueXPosition +round(cte1*width) && ValueYShot +round(cte3*height) < ValueYPosition +round(cte2*height) && ValueYPosition -round(cte2*height) < ValueYShot +round(cte3*height) ){
            Scenery = 4; //Cambia estado de artillero
            MiPuerto.write( 'L' );  
          }
      }break;  
      case 2:{  //colision de naves
        if( ValueXPosition -round(cte4*width) < ValueXShot && ValueXShot < ValueXPosition +round(cte4*width) && ValueYShot -round(cte3*height) < ValueYPosition +round(cte5*height) && ValueYPosition -round(cte5*height) < ValueYShot -round(cte3*height) && Game.Ships[j][i] == true){
            Game.Ships[j][i] = false;  //Cambia estado de nave
            Game.Shot = false;  //Cambia el estado del disparo
          }
      }break;
    }  
  } 
  
  void WinGame(){  //Descripción: Cambia el estado booleano siempre que todos los atacantes hayan sido derribados. Parámetros: Estado booleano. Retorna: Estado booleano. 
      int Contador = 0;
      for(int j=0; j<3; j++){    //Verificamos el estado de los atacantes uno por uno
           for(int i=0; i<7; i++){
                if(Ships[j][i] == false){
                    Contador++;
                }  
           }
      }
      if( Contador == 21 ){  //Si contador es igual al numero de atacantes
          Scenery = 3;    //Juego ganado
          MiPuerto.write( 'W' );
      }
  }  
    
};  //End class

void setup() {
  size(1400, 700);
  AlienImage[2][0] = loadImage("Alien1v1.jpg");
  AlienImage[2][1] = loadImage("Alien1v2.jpg");
  AlienImage[1][0] = loadImage("Alien2v1.jpg");
  AlienImage[1][1] = loadImage("Alien2v2.jpg");
  AlienImage[0][0] = loadImage("Alien3v1.jpg");
  AlienImage[0][1] = loadImage("Alien3v2.jpg");
  GunnerImage = loadImage("gunner.jpg");
  imageMode(CENTER);
  myFont = loadFont("SegoeUIBlack-200.vlw");
  textFont(myFont);
  textSize(150);
  textAlign(CENTER);
  MiPuerto = new Serial(this, Serial.list()[2], 9600);
  Game = new VideoGame();
  rectMode(CENTER);
}
void draw(){
  switch ( Scenery ){
      case 0:{
            fill(#FFFFFF);
            text("PAUSE", width/2, height/2);
            }
            break;
      case 1:{
            background( #030303 );
            Game.PositionGunner(Game.GunnerX,Game.GunnerY);
            Game.ShipsShotY[0] = Game.ShipsShot( Game.ShipsShotX[0], Game.ShipsShotY[0], Game.GunnerX, Game.GunnerY, Game.Random[0], 0 );
            Game.ShipsShotY[1] = Game.ShipsShot( Game.ShipsShotX[1], Game.ShipsShotY[1], Game.GunnerX, Game.GunnerY, Game.Random[1], 1 );
            Game.ShipsShotY[2] = Game.ShipsShot( Game.ShipsShotX[2], Game.ShipsShotY[2], Game.GunnerX, Game.GunnerY, Game.Random[2], 2 );
            Game.ShipsX = Game.Ships( Game.GunnerShotX, Game.GunnerShotY, Game.ShipsX, Game.ShipsY, Game.Mode, Game.Mode2);
            Game.GunnerShotY = Game.GunnerShot( Game.GunnerShotX, Game.GunnerShotY, Game.Shot );
            Game.WinGame();
            }
            break;
      case 2:{
             Game.ShipsX = Game.Ships( Game.GunnerShotX, Game.GunnerShotY, Game.ShipsX, Game.ShipsY, Game.Mode, Game.Mode2);
            }
            break;
      case 3:{
            fill(#0CF0EA);
            text("WIN", width/2, height/2);
            }
            break;
      case 4:{
            fill(#F00C51);
            text("DEFEAT", width/2, height/2);
            }
            break;
  }  
}
  
void serialEvent (Serial  MiPuerto){ //Get
  char caracter = MiPuerto.readChar();
  switch( caracter ){ //Disparo
    case 'r':{
      Game.GetMove = true;
      Game.Mode = 1;
      Game.Mode2 = int(random(0,2));}
      break;
    case 'l':{
      Game.GetMove = true;
      Game.Mode = 2;
      Game.Mode2 = int(random(0,2));}
      break;
    case 's':{
      Game.ShipsY += round(0.074*height);}  //Desplazamiento height de las naves al llegar al tope de pantalla
      break;
    case 'z':{
      Game.Shot = true;
      Game.GunnerShotX = Game.GunnerX;
      Game.GunnerShotY = Game.GunnerY;}
    break;
    case 'c':{
      if( Game.CounterShots < 3 ){
        Game.Random[Game.CounterShots] = int( random(7) );
        Game.ShipsShotX[Game.CounterShots] = Game.ShipsX;        //Guardo las posiciones (X,Y) en donde comienza a dibujarse el proyectil
        Game.ShipsShotX[Game.CounterShots] += Game.Random[Game.CounterShots] * round(0.0781*width);
        Game.ShipsShotY[Game.CounterShots] = Game.ShipsY;
        Game.CounterShots++;}else{Game.CounterShots = 0;}
      }
    break;
    case 'R':{
      Game.MoveGunnerRight();}  //Movimiento del artillero a derecha
    break;
    case 'L':{
      Game.MoveGunnerLeft();}  //Movimiento del artillero a izquierda
    break;
    case 'P':{  //Pausa el juego
      if(Scenery == 0){
          Scenery = 1;}else{Scenery = 0;}
      delay(500);
    }
    break;
    case 'G':{
      Scenery = 4;  //Termina el juego
    }
  }
} 
