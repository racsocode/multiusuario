package com.hubkap.components.datechooser{
	
	import flash.display.*;
	import flash.events.*;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
    import flash.utils.*;
	import flash.net.*;
	import flash.ui.*;	
	import flash.text.TextField;
	import com.hubkap.util.Words;
	import com.hubkap.components.datechooser.CalendarSkin;
	public class DateChooser extends CalendarSkin{
		
		private var calendar:MovieClip;
		private var hidden:Boolean;
		public var showBtn:SimpleButton;
		public var dateField:TextField;
		public var iGi_Menu:ContextMenu;
		
		private var _target:MovieClip;
		
		public static const SELECT_DATE:String = "com.hubkap.components.datechooser.DateChooser:SELECT_DATE";
		private var _date:Array = new Array();
		public function DateChooser() {
			
			super();
			target = this;
			calendar 			=	new CalendarSkin();
			hidden				=	true;			
			//calendar.x			=	93;
			calendar.alpha 		=	0;
			
			calendar.init();
			showBtn.addEventListener(MouseEvent.CLICK,showHideCalendar);
			calendar.addEventListener(MouseEvent.MOUSE_OVER,MouseOver);
			calendar.addEventListener(MouseEvent.MOUSE_OUT,MouseOut);
			calendar.addEventListener(MouseEvent.CLICK,MouseClick);
			_set_dateField_prop();
			addCustomMenuItems();
			
			
		/*	function readDatefun(e:MouseEvent){
				
				trace(selectedDate);
			}*/
				
		}
		public function setArrayDate(a:Array) {
			_date[0] = a[0];
			_date[1] = a[1];
			_date[2] = a[2];
			dateField.text	=	a[0] + "/" + a[1] + "/" + a[2];
			var oDate:Date = new Date();
			//oDate.setMonth(_date[0]-1);
			//oDate.setDate(_date[1]);
			//oDate.setFullYear(_date[2]);
			//trace("DIA " + oDate.getDay());
			trace("GENERADO " + oDate.toString());
			//var time = getDateName(oDate.getDay(), a[1], Number(a[0])-1, a[2])
			trace("TIME " + time);
			txtDateName.text = time; 
		}
        function _set_dateField_prop()
        {
            try{
                dateField["componentInspectorSetting"] = true;
            }
            catch (e:Error){};
            
            

            
            dateField.displayAsPassword 	=	false;
            dateField.selectable			=	false;
            //dateField.enabled 				=	true;
            dateField.maxChars 				= 	0;
            dateField.restrict 				= 	"";
            dateField.text 					= 	getToday();
            dateField.visible 				= 	true;
            try
            {
                dateField["componentInspectorSetting"] = false;
            }
            catch (e:Error)
            {
            };
            return;
        }
        private function getToday(){
        	var oToday:Date = new Date();
			//return (oToday.getMonth()+1)+"/"+oToday.getDate()+"/"+oToday.getFullYear();
        }		
        public function addCustomMenuItems():void
        {
			iGi_Menu = new ContextMenu();
            iGi_Menu.hideBuiltInItems();
            var menu1:*;
			var menu2:*;
            menu1 = null;
			menu1 = new ContextMenuItem("An iGi Lab Production");
            menu2 = new ContextMenuItem("Follow us");			
            menu1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, navigateToSite);
			menu2.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, navigateToSite);
            iGi_Menu.customItems.push(menu1);
			iGi_Menu.customItems.push(menu2);
            this.contextMenu = iGi_Menu;
            return;
        }	
        public function navigateToSite(e:ContextMenuEvent):void
        {
           	//snavigateToURL(new URLRequest("http://www.infogroupindia.com/blog"), "_blank");
            return;
        }				
//=======================================================================================================
//							MOUSE EVENT LISTENERS
//=======================================================================================================		
		public function showHideCalendar(e:MouseEvent){
			var tweer:*;
			if(hidden){
				target.addChild(calendar);
				tweer = new Tween(calendar,"alpha",Strong.easeInOut,0,1,5,false);
				hidden	=	false;
			}else {				
				tweer = new Tween(calendar,"alpha",Strong.easeInOut,1,0,5,false);		
				hidden	=	true;
				tweer.addEventListener(TweenEvent.MOTION_FINISH,done);
				function done(){ target.removeChild(calendar); }
			}			
		}		
		public function MouseOver(e:MouseEvent){
			if(e.target.name == "hit"){
				changeColor(e.target.parent,mouseOverCellColor);
			}else{
				return;
			}
		}
		public function MouseOut(e:MouseEvent){
			if(e.target.name == "hit"){
				changeColor(e.target.parent,e.target.parent.id);
			}else{
				return;
			}
		}
		
		public function MouseClick(e:MouseEvent){
			if (e.target.name == "hit") {	
				var date = e.target.parent.date;
				selectedDate	=	(calendar.currentmonth + 1) + "/" + date.getDate() + "/" + calendar.currentyear;
				dateField.text	=	selectedDate;
				_date[0] = calendar.currentmonth + 1;
				_date[1] = date.getDate();
				_date[2] = calendar.currentyear;
								
				this.dispatchEvent(new Event(SELECT_DATE));
				txtDateName.text = getDateName(date.getDay(),date.getDate(),calendar.currentmonth,calendar.currentyear); 
				showHideCalendar(null);
				if(!e.target.parent.isToday){ changeColor(e.target.parent,mouseOverCellColor); }
			}else{
				return;
			}
		}
		public function getDateName(day:*,date:*,month:*,year:*):String {
			
			trace(day);
			return Words.getDayName(Number(day)) + ", " + Words.getMonthName(Number(month)).substr(0,3) + " " + date+" "+year;
		} 
		
		public function get date():Array { return _date; }
		
		public function set date(value:Array):void 
		{
			_date = value;
		}
		
		public function get target():MovieClip { return _target; }
		
		public function set target(value:MovieClip):void 
		{
			_target = value;
			//_target.x = this.x;
			//_target.y = this.y;
		}

	}
}
		