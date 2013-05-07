package com.utils {

	import flash.events.Event;

	public class CustomEvent extends Event {

  		public var arg:*;

  		public function CustomEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, ... a:*) {
   			super(type, bubbles, cancelable);
   			arg = a;
   		}
		override public function clone():Event {
			return new CustomEvent(type, bubbles, cancelable, arg);
		}
	}
}