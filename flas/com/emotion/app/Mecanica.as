package com.emotion.app {
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.media.*;
	import flash.utils.*;
	import com.adobe.audio.format.WAVWriter;
	import com.adobe.serialization.json.*;
	import com.britanico.util.CustomEvent;
	import com.britanico.util.Global;
	import flash.system.*;
	import com.demonsters.debugger.MonsterDebugger;
	import flash.external.ExternalInterface;
	
	public class Mecanica extends MovieClip {
		
		private var _mic:Microphone;
		private var _soundRecording:ByteArray;
		private var contadorPalabras:Number=0;
		//private var _so:Sound;
		private var _channel:SoundChannel;
		private var _isfirst:Boolean = true;
		private var _isfirstAplication:Boolean = true;
		private var _res_desing:String;
		private var _last_words:Array
		
		public function Mecanica() {
			_last_words =  Global.data;
			addFrameScript(312, init);
		}
		
		private function init() {
			trace("init");
			initEscucha();
			this.stop();
		}			
		
		private function initEscucha() {
			escucha_btn.buttonMode = true;
			escucha_btn.addEventListener(MouseEvent.CLICK, handlerClick);
		}
			private function handlerClick(e:MouseEvent) {
				escucha_btn.removeEventListener(MouseEvent.CLICK, handlerClick);
				
				e.target.gotoAndStop(2);
				var timer :Timer = new Timer(1000);
				timer.addEventListener(TimerEvent.TIMER, onHandleTimer);
				timer.start();
			}	
				private function onHandleTimer(e:TimerEvent) {
					this.play();
					e.target.removeEventListener(TimerEvent.TIMER,onHandleTimer)
					e.target.stop();
					this.dispatchEvent(new CustomEvent("MECANICA", true, false, "show_prelod"));
					onLoadPalabra();
				}	
					private function onLoadPalabra() {// poner el 
						if (_isfirst) {
							var random_palabra:Object = randomizeArray();	
						}
						var request:URLRequest = new URLRequest(Global.domain + Global.current.desing);////////////////////////////////////////
						//var request:URLRequest = new URLRequest("swfs/ships/pronunciacion.swf");
						
						var loader:Loader = new Loader();
						loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
						loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
						loader.load(request);		
					}	
						private function progressHandler(event:ProgressEvent):void {
							var total:Number = event.bytesTotal;
							var loaded:Number = event.bytesLoaded;
							var percent:int = 100 * (Math.floor(loaded) / Math.floor(total));
							this.dispatchEvent(new CustomEvent("MECANICA", true, false,"update_preload",percent));
						}
						private var _current_word:*;
						
						private function completeHandler(event:Event):void {
							trace("event.target " + event.target);
							_current_word = event.target.content;
							this.addChild(_current_word);
							//event.target.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandler);
							//event.target.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
							this.dispatchEvent(new CustomEvent("MECANICA", true, false, "closed_preload"));
							
							var timer :Timer = new Timer(2000);
							timer.addEventListener(TimerEvent.TIMER, onCompleteAnimacion);
							timer.start();
						}	
							public function onCompleteAnimacion(e:TimerEvent):void {
								e.target.removeEventListener(TimerEvent.TIMER,onCompleteAnimacion)
								e.target.stop();
								this.removeChild(_current_word);
								
								this.gotoAndStop(340);
								iniciarGrabacion();
							}
							
				private function iniciarGrabacion() {
					//countdounw.iniciarCronometro();
					var timer :Timer = new Timer(2000);
					timer.addEventListener(TimerEvent.TIMER, timesUp);
					timer.start();	
					_soundRecording = new ByteArray();
					_mic = Microphone.getMicrophone();
					_mic.addEventListener(SampleDataEvent.SAMPLE_DATA, gotMicData);
					led.gotoAndStop(2);
				}
					private function gotMicData(micData:SampleDataEvent):void {
						_soundRecording.writeBytes(micData.data);
						var audioData:ByteArray = micData.data;
						eco_sp.graphics.clear();
						eco_sp.graphics.lineStyle(0, 0xFF0000);
						eco_sp.graphics.moveTo(0, 0);
						var inclinacion:Number = 300 / audioData.length;
						
						while (audioData.bytesAvailable > 0){
							var nX:Number = audioData.position * inclinacion;
							var nY:Number = audioData.readFloat() * 1000 + 0;
							eco_sp.graphics.lineTo(nX, nY);
						}
					}					
					private function timesUp(e:TimerEvent):void {
						led.gotoAndStop(1);
						e.target.removeEventListener(TimerEvent.TIMER,timesUp)
						e.target.stop();
						_mic.removeEventListener(SampleDataEvent.SAMPLE_DATA, gotMicData);
						saveRecording();
					}	
						private function saveRecording():void {
							if (_soundRecording == null || _soundRecording.length <= 0) { 
								this.gotoAndStop(339);
								trazer("no pudo grbar nada");
								this.dispatchEvent(new CustomEvent("MECANICA", true, false, "show_prelod"));
								var mLoader:Loader = new Loader();
								var mRequest:URLRequest = new URLRequest("swfs/alertas.swf"); 
								mLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandlerNoResult);
								mLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressHandlerNoResult);
								mLoader.load(mRequest);
								return;
							}
							this.dispatchEvent(new CustomEvent("MECANICA", true, false, "show_proceso"));
							
							var wavWriter:WAVWriter = new WAVWriter();
							_soundRecording.position = 0;
							wavWriter.numOfChannels = 1;
							wavWriter.sampleBitRate = 16;
							wavWriter.samplingRate = 44100;
							
							var wavBytes:ByteArray = new ByteArray();
							wavWriter.processSamples(wavBytes, _soundRecording, 44100, 1); // convert our ByteArray to a WAV file.
							
							var request:URLRequest = new URLRequest (Global.domain+'gateway2.php');
							var loader: URLLoader = new URLLoader();
							
							request.contentType = 'application/octet-stream';
							request.method = URLRequestMethod.POST;
							request.data = wavBytes;
							loader.addEventListener(Event.COMPLETE, onCompleteHandler);
							loader.load(request);
						}	
							private function onProgressHandlerNoResult(event:ProgressEvent):void {
								var total:Number = event.bytesTotal;
								var loaded:Number = event.bytesLoaded;
								var percent:int = 100 * (Math.floor(loaded) / Math.floor(total));
							//	trazer("percent  "+percent);
								this.dispatchEvent(new CustomEvent("MECANICA", true, false,"update_preload",percent));
							}
							
							private function onCompleteHandlerNoResult(e:Event) {
								this.dispatchEvent(new CustomEvent("MECANICA", true, false, "closed_preload"));
								var respuesta:MovieClip = e.currentTarget.content as MovieClip;
								this.dispatchEvent(new CustomEvent("MECANICA", true, false, "ani_respuesta_no_results", respuesta));
								_res_desing = "";
							}
							
							private function onCompleteHandler(e:Event):void {
								var variable:URLVariables = new URLVariables(e.target.data);
								trace("variable.imagen " + variable.imagen);
								if (String(variable.imagen) != "") {
									ispeechProcess(variable.imagen);
								} 
							}
								private function ispeechProcess(sonido) {
									var request:URLRequest = new URLRequest(Global.domain+'ispeech_recognition.php');
									var loader: URLLoader = new URLLoader();
									request.method = URLRequestMethod.POST;
									var variables:URLVariables = new URLVariables(); 
									variables.audio = sonido; 
									request.data = variables;
									loader.addEventListener(Event.COMPLETE, onCompleteHandlerApi);
									loader.load(request);
									trace("Procesando...");
									this.gotoAndStop(347);
								}
									private function onCompleteHandlerApi(event:Event):void {
										var loader:URLLoader = URLLoader(event.target);
										
										var resultado:Object = JSON.decode(loader.data);
										trazer("resultado del api  " + loader.data);
										_res_desing = analizarResultado(resultado.text);
										startAnimation(_res_desing);
										this.dispatchEvent(new CustomEvent("MECANICA", true, false, "closed_proceso"));
									}
										public function startAnimation(pelicula:String) {
											this.dispatchEvent(new CustomEvent("MECANICA", true, false, "show_prelod"));
											var mLoader:Loader = new Loader();
											var mRequest:URLRequest = new URLRequest(pelicula); 
											mLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandlerAnimacion);
											mLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressHandlerAnimacion);
											mLoader.load(mRequest);
										}
											private function onProgressHandlerAnimacion(event:ProgressEvent):void {
												var total:Number = event.bytesTotal;
												var loaded:Number = event.bytesLoaded;
												var percent:int = 100 * (Math.floor(loaded) / Math.floor(total));
												this.dispatchEvent(new CustomEvent("MECANICA", true, false,"update_preload",percent));
											}
											private function onCompleteHandlerAnimacion(e:Event) {
												this.dispatchEvent(new CustomEvent("MECANICA", true, false, "closed_preload"));
												var respuesta:MovieClip = e.currentTarget.content as MovieClip;
												if (_res_desing=="swfs/alertas.swf") {
													this.dispatchEvent(new CustomEvent("MECANICA", true, false, "ani_respuesta", respuesta));
												}else {
													this.dispatchEvent(new CustomEvent("MECANICA", true, false, "movie_resp", respuesta));
												}
												_res_desing = "";
											}
											
		private function analizarResultado(resultado:*):String {
			var alternativa:Array = new Array();
			alternativa = Global.current.ajustes;
			var valor:String = "swfs/alertas.swf";
			
			for ( var o:int = 0; o < alternativa.length; o++ ) {
				trace("tag xml  "+alternativa[o].rspta_api+"   resultado api "+resultado);
				if (alternativa[o].rspta_api == resultado ) {
					
					valor = alternativa[o].rspta_movie;
					return valor;
				}
			}
			
			if (valor=="swfs/alertas.swf") {
				var nAleatorio = Math.floor(Math.random() * (2 - 1 + 1)) + 1; 
			}
			
			if (valor=="swfs/alertas.swf") {
				nAleatorio = Math.floor(Math.random() * (2 - 1 + 1)) + 1; 
			}
			
			if (valor=="swfs/alertas.swf") {
				nAleatorio = Math.floor(Math.random() * (2 - 1 + 1)) + 1; 
			}
			
			trace("nAleatorio " + nAleatorio);
			var letra :Array = alternativa[0].rspta_movie.split("/");
			
			switch (nAleatorio) {
				case 1:
					valor = "swfs/alertas.swf";
				break;
				case 2:
					valor = "swfs/"+letra[1]+"/muymal.swf";
				break;
				case 3:
					valor = "swfs/"+letra[1]+"/mal.swf";
				break;
				default:
					valor = "swfs/alertas.swf";
				break;
			}
			
			
			//valor = "swfs/ships/cheap.swf"; 
			trace("valor " + valor);
			
			return valor;
		}
		
		private function randomNumber(low:Number=0, high:Number=1):Number{
			return Math.floor(Math.random() * (1+high-low)) + low;
		}
		
		
		
		
		private function randomizeArray():Array {	
			
			var newArray:Array = new Array();
			
			var rand:Number = randomNumber(0, _last_words.length - 1);
			
			//newArray = _last_words.splice(rand, 1);
			newArray[0] = _last_words[rand];
			
			removeItems(_last_words, rand);
			
			
			trazer( "queda " + _last_words.length +" palabra "+newArray[0].palabra);	
			
			if ( _last_words.length == 0) {
				_last_words = new  Array();
				_last_words = Global.data;
				trazer( "Global.data" + Global.data);	
			}					
			
			Global.current = newArray[0];
			return newArray;
		}
		
			private function removeItems(a:Array,_i:int):void{
				var newArray = new Array();
				for(var i=0;i<a.length;i++){
					if (i != _i) newArray.push(a[i]);
				}
				_last_words = new Array();
				_last_words = newArray
			}	
		
		public function get isfirst():Boolean {
			return _isfirst;
		}
		
		public function set isfirst(value:Boolean):void {
			_isfirst = value;
		}
		
		private function trazer(valor:String) {
			ExternalInterface.call( "console.log" , valor);
		}
	}
}
