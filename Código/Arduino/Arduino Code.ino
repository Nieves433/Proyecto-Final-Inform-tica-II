#include <MultiFuncShield.h>
#define MAX 5
FILE *fp;
int Counter1 = 5, Counter5 = 0, Down = 0, MaxRight = 0, Shoot = 1, Speed = 100;
class Program{
  public:
   byte button;
   char Character;
   int Counter2 = 1, Counter3 = 2, Counter4 = 2, Time;
   int MoveAlienShips( int MyTime, int Speed ){ //Descripción: Cada 1 segundo envía un mensaje por puerto serial que indica nueva posición del atacante, sea hacia la izq, der, abajo y si es hacia abajo aumenta la dificultad. Parámetros: Tiempo transcurrido y deficultad. Retorna:Tiempo actualizado.
    if ( MyTime == Counter2 ){ //MyTime = Counter2 para verificar que paso 1 seg
        switch( Down ){
          case 0:{
            switch( MaxRight ){
              case 0:{
                  Counter1--; //cuenta atras hasta chocar contra pared del diaplay
                  Counter2 += Speed; //Cuenta 1 seg
                  Serial.write( 'r' );
                  if ( Counter1 == 0 ){ 
                    MaxRight = 1; //Máxima posición horizontal alcanzada
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
                Counter5++;   //Contador para terminar el juego
                Down = 0;
                return( Counter2 );
          }break;       
   }}
   return(Counter2);}
   int Shoots( int MyTime1, int Speed ){  //Descripción: Al pasar 2 segundos envía un mensaje por puerto serie. Parámetros: Tiempo transcurrido y dificultad. Retorno: Tiempo actualizado.
      if( MyTime1 == Counter3 ){  //Siempre que pasen 2 seg
        Counter3 += Speed*2;
        Serial.write( 'z' );
      }
      return( Counter3 );
   }
   int ShipsShoot( int MyTime1, int Speed ){  //Descripción: Al pasar 1 segundo envía un mensaje por puerto serie. Parámetros: Tiempo transcurrido y dificultad. Retorno: Tiempo actualizado.
      if( MyTime1 == Counter4 ){  //Siempre que pasen 1 seg
        Counter4 += Speed;
        Serial.write( 'c' );
      }
      return( Counter4 );
   }
   void IncressDifficulty(){  //Descripción: Aumenta la dificultad reduciendo el tiempo de comparación. Parámetros: Ningunos. Retorno: Ninguno.
      Speed -= 8;
   }
   void GameOver( int Counter5 ){ //Descripción:Termina el juego tras enviar 10 veces "abajo". Parámetros: Ninguno. Retorno: Ninguno.
      if( Counter5 == 10 ){
        Serial.write( 'G' );
      }
   }
   /*void SaveScore( char Option, int Time ){
      switch( Option ){
        case 'W':{
            if( (fp=fopen("ScoreGame", "w")) != NULL ){
              fwrite("SUCCEDED", sizeof(char), 10, fp);}
          }
          break;
        case 'L':{
            if( (fp=fopen("ScoreGame", "w")) != NULL ){ 
              fwrite(Time, sizeof(int), 1, fp);}
          }
          break;}
   }*/
};
Program Game;
void setup() {
   Timer1.initialize(); // Inicializamos el tiempo interno del shield
   MFS.initialize(&Timer1); // Inicializamos los pulsadores del shield
   Serial.begin(9600);
}

void loop() {
  Game.GameOver( Counter5 );
  Game.Time = millis()/10;
  Game.Counter2 = Game.MoveAlienShips( Game.Time, Speed );
  Game.Counter3 = Game.Shoots( Game.Time, Speed );
  Game.Counter4 = Game.ShipsShoot( Game.Time, Speed );
  Game.button = MFS.getButton();
  Game.Character = Serial.read();
  //Game.SaveScore( Game.Character, Game.Time ); 
  if ( Game.button ){
    if( Game.button == BUTTON_3_PRESSED ){
      Serial.write( 'R' );} //Envia
    if( Game.button == BUTTON_1_PRESSED ){
      Serial.write( 'L' );} //Envia
  }
}
