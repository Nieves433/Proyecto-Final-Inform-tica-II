
#include <TimerOne.h>
#include <Wire.h>
#include <MultiFuncShield.h>
#define MAX 5
int Counter1 = 5, Counter5 = 0, Down = 0, MaxRight = 0, Shoot = 1, Speed = 100;
class Program{
  public:
   byte button;
   int Counter2 = 1, Counter3 = 2, Counter4 = 3, Time;
   int MoveAlienShips( int MyTime, int Speed ){ //Mueve las naves a der y a izq
    if ( MyTime == Counter2 ){ //MyTime = Counter2 para verificar que paso 1 seg
        switch( Down ){
          case 0:{
            switch( MaxRight ){
              case 0:{
                  Counter1--; //cuenta atras hasta chocar contra pared del diaplay
                  Counter2 += Speed; //Cuenta 1 seg
                  Serial.write( 'r' );
                  if ( Counter1 == 0 ){ 
                    MaxRight = 1;
                    Down = 1;}
                  return( Counter2 );
              }break;  
              case 1:{          
                  Counter1++; //cuenta atras hasta chocar contra esquida del diaplay
                  Counter2 += Speed; //Cuenta 1 seg  
                  Serial.write( 'l' );
                  if ( Counter1 == 5 ){ 
                    MaxRight = 0;
                    Down = 1;}
                  return( Counter2 );
              }break;
            }    
          }break;      
          case 1:{
                Counter2 += Speed;
                Serial.write( 's' );
                IncressDifficulty();
                Counter5++;
                Down = 0;
                return( Counter2 );
          }break;       
   }}
   return(Counter2);}
   int Shoots( int MyTime1, int Speed ){
      if( MyTime1 == Counter3 ){  //Siempre que pasen 2 seg
        Counter3 += Speed*2;
        Serial.write( 'z' );
      }
      return( Counter3 );
   }
   int ShipsShoot( int MyTime1, int Speed ){
      if( MyTime1 == Counter4 ){  //Siempre que pasen 3 seg
        Counter4 += Speed;
        int RandomNumber = int(random( 7 ));
        Serial.write( 'c' );
      }
      return( Counter4 );
   }
   void IncressDifficulty(){
      Speed -= 8;
   }
   void GameOver( int Counter5 ){ //Termina el juego tras enviar 8 veces "abajo"
      if( Counter5 == 10 ){
        Serial.write( 'G' );
      }
   }
};
Program Game;
void setup() {
   Timer1.initialize();
   MFS.initialize(&Timer1); // initialize multi-function shield library
   Serial.begin(9600);
}

void loop() {
  Game.GameOver( Counter5 );
  Game.Time = millis()/10;
  Game.Counter2 = Game.MoveAlienShips( Game.Time, Speed );
  Game.Counter3 = Game.Shoots( Game.Time, Speed );
  Game.Counter4 = Game.ShipsShoot( Game.Time, Speed );
  Game.button = MFS.getButton();
      
  if ( Game.button ){
    if( Game.button == BUTTON_3_PRESSED ){
      Serial.write( 'R' );} //Envia
    if( Game.button == BUTTON_1_PRESSED ){
      Serial.write( 'L' );} //Envia
  }
}
