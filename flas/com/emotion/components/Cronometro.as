package com.britanico.components
{
   import flash.display.*;
   import flash.events.*;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.Timer;
   import flash.utils.getTimer;

   public class Cronometro extends Sprite
   {
      private var milesimasXcentecima:uint=10;
      private var milesimasXsegundo:uint=1000;
      private var milesimasXminuto:uint=1000 * 60;// 60,000
      private var milesimasXhora:uint=1000 * 60 * 60;// 3,600,000

      private var hora:uint;
      private var minuto:uint;
      private var segundo:uint;
      private var centesima:uint;

      private var hora_txt:String;
      private var minuto_txt:String;
      private var segundo_txt:String;
      private var centesima_txt:String;

      private var milesimasTranscurridas:uint;
      private var copiaDe_GetTimer:uint;
      private var referenciaTemporal:uint;

      private var cronometroPausado:Boolean=false;
      private var cronometroAndando:Boolean=false;

      private var temporizador:Timer=new Timer(10,0);

      public function Cronometro()
      {
         temporizador.addEventListener(TimerEvent.TIMER,tickTack);
         //botonIniciar.addEventListener(MouseEvent.CLICK,iniciarCronometro);
         //botonPausar.addEventListener(MouseEvent.CLICK,pausarCronometro);
         //botonReiniciar.addEventListener(MouseEvent.CLICK,reiniciarCronometro);
         //botonFotografia.addEventListener(MouseEvent.CLICK,fotoGrafiarCronometro);
		// iniciarCronometro();
      }
      private function tickTack(e:TimerEvent):void
      {
         milesimasTranscurridas=getTimer() - copiaDe_GetTimer;
         // Si por ejemplo el .SWF lleva abierto 10 segundos (10000 milesimas) y el cronometro se inicio en el segundo 4,
         // entonses nuestro cronometro lleva 6 segundos transcurridos. 10000 - 4000 = 6000 (6 Segundos)
         hora=Math.floor(milesimasTranscurridas / milesimasXhora);
         // Digamos que llevamos 14,687,987 milesimas trascuridas. 14,687,987 / 3,600,000 = 4.079... Redondeando 4 Horas 
         referenciaTemporal=milesimasTranscurridas - hora * milesimasXhora;
         // Ejem: Llevamos 14,687,987 mile = 4 horas algo. 14,687,987 mils - (4 * milesimasXhora = 14,400,000) = 287,987
         // Aca referenciaTemporal nunca va ser mayor que 3.599.999 milesimas. 

         minuto=Math.floor(referenciaTemporal / milesimasXminuto);
         // Ejem: referenciaTemporal es = 287,987 / milesimasXminuto (60,000) = 4.799.. Redondeando 4 Minutos
         // minuto nunca va ser mayor que 59

         referenciaTemporal=referenciaTemporal - minuto * milesimasXminuto;
         // Ejem: referenciaTemporal es 287,987 - (4 Minutos * 60,000 = 240.000 ) = 47,987
         // Aca referenciaTemporal nunca va ser mayor de 59.999

         segundo=Math.floor(referenciaTemporal / milesimasXsegundo);
         // Ejem: referenciaTemporales 47,987 / milesimasXsegundo que son 1000 es = a 47.987 Redondeando 47 segundos
         // segundo nunca va ser mayor que 59

         referenciaTemporal=referenciaTemporal - segundo * milesimasXsegundo;
         // Ejem: referenciaTemporal es 47,987 - (segundo 47 * milesimasXsegundo que son 1000 = 47,000) = 987 
         // Aca referenciaTemporal nunca va ser mayor que 999

         centesima=Math.floor(referenciaTemporal / milesimasXcentecima);
         // Ejem: ahora referenciaTemporal es 987 / milesimasXcentecima que son 10 es = a 98.7 redondeando 98 centecimas
         // centesima nunca va ser mayor que 99

         // Condicinales que hacen que todos los numeros tengan siempre dos digitos y no uno
         if (hora < 10) {
            hora_txt="0" + hora.toString();
         } else {
            hora_txt=hora.toString();
         }
         if (minuto < 10) {
            minuto_txt="0" + minuto.toString();
         } else {
            minuto_txt=minuto.toString();
         }
         if (segundo < 10) {
            segundo_txt="0" + segundo.toString();
         } else {
            segundo_txt=segundo.toString();
         }
         if (centesima < 10) {
            centesima_txt="0" + centesima.toString();
         } else {
            centesima_txt=centesima.toString();
         }
         // Pasanos todo al campo de texto
        // led_txt.text = hora_txt + " : " + minuto_txt + " : " + segundo_txt + " : " + centesima_txt;
		  led_txt.text=segundo_txt + " : " + centesima_txt;
      }
      public function iniciarCronometro(e:MouseEvent= null):void
      {
		  
		  
         if (cronometroAndando == false && cronometroPausado == false) {
            copiaDe_GetTimer=getTimer();// Toma una foto, de las milesimas que han pasado desde el inicio.
         } else if (cronometroAndando == false && cronometroPausado == true) {
            copiaDe_GetTimer=getTimer() - milesimasTranscurridas;
         }
         temporizador.start();
         cronometroAndando=true;
      }
      private function pausarCronometro(e:MouseEvent):void
      {
         if (cronometroAndando == true) {
            cronometroAndando=false;
            cronometroPausado=true;
            temporizador.stop();
         }
      }
      private function reiniciarCronometro(e:MouseEvent):void
      {
         temporizador.stop();
         led_txt.text="00 : 00";
         milesimasTranscurridas=0;
         cronometroAndando=false;
         cronometroPausado=false;
      }
      private function fotoGrafiarCronometro(e:MouseEvent):void
      {
         temporizador.stop();
      }
   }
}