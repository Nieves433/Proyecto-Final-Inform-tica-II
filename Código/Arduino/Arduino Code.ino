#include <TimerOne.h>
#include <Wire.h>
#include <MultiFuncShield.h>
#define MAX 5
int Counter1 = 8, Down = 0, MaxRight = 0, Shoot = 1;
class Program{
  public:
   byte button;
   int Counter2 = 1, Counter3 = 2, Time;
   int MoveAlienShips( int MyTime ){ //Mueve las naves a der y a izq
    if ( MyTime == Counter2 ){ //MyTime = Counter2 para verificar que paso 1 seg
        switch( Down ){
          case 0:{
            switch( MaxRight ){
              case 0:{
                  Counter1--; //cuenta atras hasta chocar contra pared del diaplay
                  Counter2++; //Cuenta 1 seg
                  Serial.write( 'r' );
                  if ( Counter1 == 0 ){ 
                    MaxRight = 1;
                    Down = 1;}
                  return( Counter2 );
              }break;  
              case 1:{          
                  Counter1++; //cuenta atras hasta chocar contra esquida del diaplay
                  Counter2++; //Cuenta 1 seg  
                  Serial.write( 'l' );
                  if ( Counter1 == 8 ){ 
                    MaxRight = 0;
                    Down = 1;}
                  return( Counter2 );
              }break;
            }    
          }break;      
          case 1:{
                Counter2++;
                Serial.write( 's' );
                Down = 0;
                return( Counter2 );
          }break;       
   }}
   return(Counter2);}
   int Shots( int MyTime1 ){
      if( MyTime1 == Counter3 ){  //Siempre que pasen 3 seg
        Counter3 += 2;
        Serial.write( 'z' );
      }
      return( Counter3 );
   }
};
Program Game;
void setup() {
   Timer1.initialize();
   MFS.initialize(&Timer1); // initialize multi-function shield library
   Serial.begin(9600);
}

void loop() {
  Game.Time = millis()/1000;
  Game.Counter2 = Game.MoveAlienShips( Game.Time );
  Game.Counter3 = Game.Shots( Game.Time );
  Game.button = MFS.getButton();
      
  if ( Game.button ){
    if( Game.button == BUTTON_3_PRESSED ){
      Serial.write( 'R' );} //Envia
    if( Game.button == BUTTON_1_PRESSED ){
      Serial.write( 'L' );} //Envia
  }
}
