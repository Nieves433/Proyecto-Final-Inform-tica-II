#include <MultiFuncShield.h>
#define MAX 5
int CounterUntilWall = 5, Down = 0, MaxRight = 0, Speed = 100;
class Program{
  public:
    char Option;
    int Pause = 2, CounterTime1 = 1, CounterTime2 = 2, CounterTime3 = 2, CounterGameOver = 0, ArduinoTime;
    int MoveAlienShips( int ArduinoTime, int Speed ){ //Descripción: Cada 1 segundo envía un mensaje por puerto serial que indica nueva posición del atacante, sea hacia la izq, der, abajo y si es hacia abajo aumenta la dificultad. Parámetros: Tiempo transcurrido y deficultad. Retorna:Tiempo actualizado.
        if ( ArduinoTime == CounterTime1 ){           //para verificar que paso 1 seg
            switch( Down ){
            case 0:{
                  switch( MaxRight ){
                  case 0:{
                         CounterUntilWall--; //cuenta atras hasta chocar contra pared del diaplay
                         CounterTime1 += Speed; //Cuenta 1 seg
                         Serial.write( 'r' );
                         if ( CounterUntilWall == 0 ){ 
                              MaxRight = 1; //Máxima posición horizontal alcanzada
                              Down = 1;}
                  }break;  
                  case 1:{          
                         CounterUntilWall++; //cuenta atras hasta chocar contra esquida del diaplay
                         CounterTime1 += Speed; //Cuenta 1 seg  
                         Serial.write( 'l' );
                         if ( CounterUntilWall == 5 ){ 
                              MaxRight = 0;
                              Down = 1;}
                  }break;
                  }    
            }break;      
            case 1:{
                  CounterTime1 += Speed;
                  Serial.write( 's' );
                  IncressDifficulty();
                  CounterGameOver++;   //Contador para terminar el juego
                  Down = 0;
            }break;       
       }}
       return(CounterTime1);}
   int DoBotton(int Pause){
        byte button;
        button = MFS.getButton();
        if ( button ){
        if( button == BUTTON_3_PRESSED ){
            Serial.write( 'R' );
            Sound('r');}
        if( button == BUTTON_2_PRESSED ){ 
            Serial.write( 'P');
            if(Pause == 2){
                Pause = 1;
            }else{Pause = 2;}
            }
        if( button == BUTTON_1_PRESSED ){
            Serial.write( 'L' );
            Sound('l');}
        }
        return(Pause);
   }
   int GunnerShots( int ArduinoTime, int Speed ){  //Descripción: Al pasar 2 segundos envía un mensaje por puerto serie. Parámetros: Tiempo transcurrido y dificultad. Retorno: Tiempo actualizado.
        if( ArduinoTime == CounterTime2 ){  //Siempre que pasen 2 seg
          CounterTime2 += Speed*2;
          Serial.write( 'z' );
        }
        return( CounterTime2 );
   }
   int ShipsShot( int ArduinoTime, int Speed ){  //Descripción: Al pasar 1 segundo envía un mensaje por puerto serie. Parámetros: Tiempo transcurrido y dificultad. Retorno: Tiempo actualizado.
        if( ArduinoTime == CounterTime3 ){  //Siempre que pasen 1 seg
          CounterTime3 += Speed;
          Serial.write( 'c' );
        }
        return( CounterTime3 );
   }
   void IncressDifficulty(){  //Descripción: Aumenta la dificultad reduciendo el tiempo de comparación. Parámetros: Ningunos. Retorno: Ninguno.
        Speed -= 8;
   }
   void GameOver( int CounterGameOver ){ //Descripción:Termina el juego tras enviar 10 veces "abajo". Parámetros: Ninguno. Retorno: Ninguno.
        if( CounterGameOver == 10 ){
          Serial.write( 'G' );
          Sound('L');
        }
   }
   int onPause1(int ArduinoTime){
        if ( ArduinoTime == CounterTime1 ){ //MyTime = Counter2 para verificar que paso 1 seg
            CounterTime1 += Speed; //Cuenta 1 seg
        }
        return( CounterTime1 );
   }     
   int onPause2(int ArduinoTime){
        if( ArduinoTime == CounterTime2 ){  //Siempre que pasen 1 seg
            CounterTime2 += Speed; //Cuenta 1 seg
        }
        return( CounterTime2 );
   }
   int onPause3(int ArduinoTime){
        if( ArduinoTime == CounterTime3 ){  //Siempre que pasen 2 seg
            CounterTime3 += Speed*2; //Cuenta 2 seg
        }
        return( CounterTime3 );
   }
   void Sound(char Option){
        switch(Option){
            case 'r':{
              MFS.beep(5);}
            break;
            case 'l':{
              MFS.beep(5);}
            break;
            case 'W':{
               delay(1000); //Retraso de música
               for(int i=0; i<2; i++){
                   MFS.beep(7); delay(300);
                   MFS.beep(7); delay(300);
                   MFS.beep(15); delay(600);}
                   MFS.beep(4); delay(250);
                   MFS.beep(4); delay(250);
                   MFS.beep(10); delay(600);
                   MFS.beep(4); delay(150);
                   MFS.beep(20);}
            break;
            case 'L':{
                 delay(1000); //Retraso de música
                 MFS.beep(5,20,3,1); delay(1000);
                 MFS.beep(10,10,3,1); delay(1200);
                 MFS.beep(20); delay(500);
                 MFS.beep(10);}
            break;
          }
   }
};
Program Game;
void setup() {
   Timer1.initialize(); // Inicializamos el tiempo interno del shield
   MFS.initialize(&Timer1); // Inicializamos los pulsadores del shield
   Serial.begin(9600);
}

void loop() {
    switch( Game.Pause ){
           case 1:{
                Game.ArduinoTime = millis()/10;
                Game.Pause = Game.DoBotton(Game.Pause);
                Game.CounterTime1 = Game.onPause1(Game.ArduinoTime);
                Game.CounterTime2 = Game.onPause3(Game.ArduinoTime);
                Game.CounterTime3 = Game.onPause2(Game.ArduinoTime);}
           break;
           case 2:{
                Game.ArduinoTime = millis()/10;
                Game.Option = Serial.read();
                Game.GameOver( Game.CounterGameOver );
                Game.CounterTime1 = Game.MoveAlienShips( Game.ArduinoTime, Speed );
                Game.CounterTime2 = Game.GunnerShots( Game.ArduinoTime, Speed );
                Game.CounterTime3 = Game.ShipsShot( Game.ArduinoTime, Speed );
                Game.Pause = Game.DoBotton(Game.Pause);
                Game.Sound(Game.Option);}
           break;
    }
}
