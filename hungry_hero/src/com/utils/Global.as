package com.utils {
	import flash.external.ExternalInterface;
	
	public class Global {
		
		public static var pid:int ;
		public static var data:Array ;
		public static function trazer(valor:String) {
			trace(valor);
			if (ExternalInterface.available) {
				ExternalInterface.call( "console.log" , valor);
			}
		}	
	}
}