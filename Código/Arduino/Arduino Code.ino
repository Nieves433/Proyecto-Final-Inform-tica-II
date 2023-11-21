#include <TimerOne.h>
#include <Wire.h>
#include <MultiFuncShield.h>
#define MAX 5
class Program{
  public:
   byte button;
   int Shoot = 0;
};
Program Game;
void setup() {
   Timer1.initialize();
   MFS.initialize(&Timer1); // initialize multi-function shield library
   Serial.begin(9600);
}

void loop() {
  Game.button = MFS.getButton();
  if( Game.Shoot > MAX ){Game.Shoot = 1;}
  if ( Game.button ){
    if( Game.button == BUTTON_3_PRESSED ){
      Serial.write( 'R' );} //Envia
    if( Game.button == BUTTON_3_LONG_PRESSED ){
      Serial.write( 'r' );}
    if( Game.button == BUTTON_1_PRESSED ){
      Serial.write( 'L' );} //Envia
    if( Game.button == BUTTON_1_LONG_PRESSED ){
      Serial.write( 'l' );}
    if( Game.button == BUTTON_2_PRESSED && Game.Shoot <= MAX){
      switch( Game.Shoot ){
        case 1:{Serial.write( 'z' );
        break;}
        case 2:{Serial.write( 'x' );
        break;}
        case 3:{Serial.write( 'c' );
        break;}
        case 4:{Serial.write( 'v' );
        break;}
        case 5:{Serial.write( 'b' );
        break;}
        case 6:{Serial.write( 'n' );
        break;}
        case 7:{Serial.write( 'm' );
        break;}
      }
      Game.Shoot++;    
    }
  }
}
