package com.interbank.components.video{

	import flash.display.*;
	import flash.media.*;
	import flash.net.*;
	import flash.utils.*;
	import flash.events.*;
	
	public class StreamingVideoPlayer extends Sprite{
	
		private var _contentVideo:Sprite;
		private var _mcBarra:Sprite;
		private var _mcBarraBuffer:Sprite;
		private var _mcToogle:MovieClip;
		private var _speaker_mc:MovieClip;
		private var _tmpClient:CustomClient;
		private var _buffer:Number;
		private var _video:Video;
		private var _conexion:NetConnection;
		private var _stream:NetStream;
		private var _urlVideo:String;
		private var _timer:Timer;
		private var _width:Number;
		private var _heigth:Number;
		private var _y:Number;
		private var _duracion:uint;
		private var _sound:SoundTransform ;
		private var _volMin:Number = 0;
		//private var _volMax:Number = barraVol_mc.barra_mc.width - 8;
		private var _volAct:Number = 1;
		private var _volPorc:Number;

		
		public function StreamingVideoPlayer() {
			
		}
		
		public function createVideo():void{
			if( !this._contentVideo ) throw new Error("YOU NEED A CONTENT");
			//
			_conexion = new NetConnection();
			_conexion.connect(null);
			_stream = new NetStream(_conexion);
			_tmpClient = new CustomClient();
			_stream.client = _tmpClient;
			_stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorEventHandler, false, 0, true);
			_stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler, false, 0, true);
			
			_video = new Video();
			_video.width = 440;
			_video.height = 300;
			_video.x = 0;
			_video.y = 0;
			_video.attachNetStream(_stream);
			
			_contentVideo.addChild(_video);
			_sound = new SoundTransform();
			
			_mcToogle.addEventListener(MouseEvent.CLICK, onPauseAndPlay);	
		}
		
		public function onSetSizeVideo(w:int,h:int) {
			_video.width = w;
			_video.height = h;
		}
		
		public function onSetPositionVideo(posX:int,posY:int) {
			_video.x = posX;
			_video.y = posY;
		}
		
		public function onPause() {
			_stream.pause();
		}
			
		public function onClose() {
			_stream.close();
		}		
		public function onPlay() {
			_stream.play();
		}	
		
		private function onPauseAndPlay(e:Event=null) {
			_stream.togglePause();
			if (_mcToogle.currentFrame == 1) {
				_mcToogle.gotoAndStop(2);
			} else if (_mcToogle.currentFrame == 2) {
				_mcToogle.gotoAndStop(1);
			}
		}
		
		
		public function initVideo():void{
			if( !_conexion ) throw new Error("YOU HAVE TO CALL THE FUNCTION: CREATEVIDEO()");
			if( !_urlVideo ) throw new Error("YOU NEED A URL FLV");
			_stream.play( _urlVideo );
		}
		
		private function netStatusHandler(event : NetStatusEvent) : void {
			switch (event.info.code){
				case "NetStream.Play.Start":
				//trace("start");
					this._timer = new Timer(250);
					this._timer.addEventListener(TimerEvent.TIMER, fooTimer, false, 0, true);
					this._timer.start();
					myScale(this._mcBarra, 0);
					myScale(this._mcBarraBuffer, 0);
					if(_buffer) _stream.bufferTime = _buffer;
					break;
				case "NetStream.Play.Stop":
					this._timer.stop();
					this._timer.removeEventListener(TimerEvent.TIMER, fooTimer);
					this._timer = null;
					myScale(this._mcBarra, 1);
					myScale(this._mcBarraBuffer, 1);
					break;
			}
		}
		
		public function fooTimer(e:TimerEvent):void{
			if( _tmpClient.duration > 0 ){
				myScale(this._mcBarra, ((100*_stream.time)/_tmpClient.duration)/100);
				var valueBuffer:Number = ( ((   _stream.time + _stream.bufferLength  )/ _tmpClient.duration )   );
				if(valueBuffer > this._mcBarraBuffer.scaleX)
					myScale(this._mcBarraBuffer, valueBuffer);
			}
		}
		
		private function Conversor(tiempo):String {
			var time = tiempo;
			var min = Math.floor(tiempo /60);
			var sec = tiempo - min * 60;
			
			if (min < 10) {
				min = "0" + min;
			}
			if (sec < 10) {
				sec = "0" + sec;
			}
			var valConvertir = min + ":" + sec;
			return valConvertir;
		}
		
		private function Ahora(event) {
			var secNow:Number = Math.round(_stream.time);
			var secTotal:Number = Math.floor(_duracion);
			var reproducido:Number = _stream.time / secTotal;
			var cargado:Number = _stream.bytesLoaded / _stream.bytesTotal;
			_mcBarraBuffer.width = 300*cargado + 1;
			_mcBarra.width = 300*reproducido + 3 ;
			//display_txt.text = Conversor(secNow)+ "/" + Conversor(secTotal);
			_mcBarraBuffer.addEventListener(MouseEvent.CLICK, Seek1);
			_mcBarra.addEventListener(MouseEvent.CLICK, Seek2);
		}
		//this.addEventListener(Event.ENTER_FRAME, Ahora);

		private function Seek1(event){
			var lugar = _mcBarraBuffer.mouseX;
			_stream.seek(_duracion*lugar);
		}

		private function Seek2(event){
			var lugar = _mcBarraBuffer.mouseX;
			_stream.seek(_duracion*lugar);
		}
		private function Mute(event) {
			if (_speaker_mc.currentFrame == 1) {
				_sound.volume = _volMin;
				_stream.soundTransform = _sound;
				_speaker_mc.gotoAndStop(2);
			} else if (_speaker_mc.currentFrame == 2) {
				_sound.volume = _volAct;
				_stream.soundTransform = _sound;
				_speaker_mc.gotoAndStop(1);
			}
		}			
			
		private function myScale(mc:DisplayObjectContainer, value:Number):void{
			if(mc) mc.scaleX = value;
		}
		
		private function asyncErrorEventHandler(event : AsyncErrorEvent) : void {
			//ignore
		}
		
		public function set contentVideo(value:Sprite):void{
			this._contentVideo = value
		}
		
		public function get contentVideo():Sprite { 
			return this._contentVideo; 
		}
		
		public function set mcPlayAndStop(value:MovieClip):void{
			this._mcToogle = value
		}
		
		public function get mcPlayAndStop():MovieClip { 
			return this._mcToogle; 
		}
		
		public function set mcBarra(value:Sprite):void{
			this._mcBarra = value
		}
		
		public function get mcBarra():Sprite { 
			return this._mcBarra; 
		}
				
		
		public function set mcY(value:int):void {
			this._y = value
			/*trace("bbbb"+_video);
			_video.height = this._y;*/
		}
		
		public function get mcY():int { 
			return this._y; 
		}
		
		public function set mcHeigth(value:int):void{
			this._heigth = value
			//_video.height = _heigth;
		}
		
		public function get mcHeigth():int { 
			return this._heigth; 
		}
		public function set mcWidth(value:int):void{
			this._width = value
			//_video.width = _width;
		}
		
		public function get mcWidth():int { 
			return this._width; 
		}
		
		
		public function set mcBarraBuffer(value:Sprite):void{
			this._mcBarraBuffer = value
		}
		
		public function get mcBarraBuffer():Sprite { 
			return this._mcBarraBuffer; 
		}
		
		public function set buffer(value:Number):void{
			this._buffer = value
		}
		
		public function get buffer():Number { 
			return this._buffer; 
		}
		
		public function set urlVideo(value:String):void{
			this._urlVideo = value
		}
		
		public function get urlVideo():String{ return this._urlVideo; }
		
	}
}

class CustomClient {
	public var duration:Number;
    public function onMetaData(info:Object):void {
		this.duration = info.duration;
        //trace("metadata: duration=" + info.duration + " width=" + info.width + " height=" + info.height + " framerate=" + info.framerate);
    }
}