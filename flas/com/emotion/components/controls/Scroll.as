package com.gloria.components.controls {
	/**
	 * @author Oscar Javier Rodriguez Villanueva
	 */	
	import flash.display.*;
	import flash.geom.*;
	import flash.events.*;
	import flash.utils.*;

	public class Scroll extends Sprite {
		var _sd:Number;
		var _sr:Number;
		var _cd:Number;
		var _cr:Number;
		var _new_y:Number;
		var _drag_area:Rectangle;
		var _content:Sprite;
		var _mask:Sprite;
		var _scrolling_speed:Number; // 0.00 to 1.00
		
		public function Scroll( ):void {
			
		}
		
		public function InitScroll(ct:String, ct_area:String, speed:Number ):void {
			_scrolling_speed = speed;
			if( _scrolling_speed < 0 || _scrolling_speed > 1 ) _scrolling_speed = 0.50;
			
			_content = parent[ct];
			_mask = parent[ct_area];
			_content.mask = _mask;
			//_mask.mask = _content;
			_content.x = _mask.x;
			_content.y = _mask.y;
			
			drag_scroller.buttonMode = true;
			drag_scroller.x = pista.x;
			drag_scroller.y = pista.y;
			
			_sr = _mask.height / _content.height;
			drag_scroller.height = pista.height * _sr;
			
			_sd = pista.height - drag_scroller.height;
			_cd = _content.height - _mask.height;
			_cr = _cd / _sd * 1.01;
			
			_drag_area = new Rectangle(0, 0, 0, pista.height - drag_scroller.height);
			
			if ( _content.height <= _mask.height ){
				drag_scroller.visible = pista.visible = false;
			}
			
			drag_scroller.addEventListener( MouseEvent.MOUSE_DOWN, scroller_drag );
			drag_scroller.addEventListener( MouseEvent.MOUSE_UP, scroller_drop );
			this.addEventListener( Event.ENTER_FRAME, on_scroll );			
		}
		
		private function scroller_drag( me:MouseEvent ):void{
			me.target.startDrag(false, _drag_area);
			stage.addEventListener(MouseEvent.MOUSE_UP, up);
		}
		
		private function scroller_drop( me:MouseEvent ):void{
			me.target.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_UP, up);
		}
		
		private function up( me:MouseEvent ):void{
			drag_scroller.stopDrag();
		}
		
		private function on_scroll( e:Event ):void{
			_new_y = _mask.y + pista.y * _cr - drag_scroller.y  * _cr;
			_content.y += ( _new_y - _content.y ) * _scrolling_speed;
		}		
	}
}