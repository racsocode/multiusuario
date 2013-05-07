package com.gloria.components.controls{
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Video;
	import flash.net.URLRequest;
	
	public class CheckBox extends MovieClip {
		public static const ON_SELECTED:String = "ON_SELECTED:CheckBox";	
		private var bFlag:Boolean = false;
		function CheckBox(){
			this.stop();
			this.buttonMode = true;
			this.addEventListener(MouseEvent.CLICK, onPress);
		}
		function onPress(e:Event){
			if (bFlag) {
				bFlag = false;
				this.gotoAndStop(1);
			}else {
				bFlag = true;
				this.gotoAndStop(2);
			}
			dispatchEvent(new Event(ON_SELECTED));
		}
		
		public function check(b:Boolean){
	
		}
		
		public function get selected():Boolean { return bFlag; }
		
		public function set selected(value:Boolean):void{
			bFlag = value;
			if (bFlag) {
				this.gotoAndStop(2);
			}else {
				this.gotoAndStop(1);
			}
		}
		
		
	}
}