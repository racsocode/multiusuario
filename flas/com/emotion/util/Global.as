package com.emotion.util {
	import flash.external.ExternalInterface;
	
	public class Global {
		
		public static var pid:int ;
		public static var data:Array ;
		public static function trazer(valor:String) {
			trace(valor);
			ExternalInterface.call( "console.log" , valor);
		}	
	}
}