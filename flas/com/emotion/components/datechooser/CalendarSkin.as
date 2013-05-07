
//=======================================================================================================
//	[FREE AS3 DATE PICKER V2]
//	AUTHOR 			: NIDIN P VINAYAKAN
//	SCRIPT VERSION 	: AS3
//	DATE 			: 2009 AUGUST
//
//=======================================================================================================
package com.hubkap.components.datechooser{

	import flash.display.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.events.*;

	public dynamic class CalendarSkin extends MovieClip {

		public var calendar_mc		:Sprite 	= 	new Sprite();
		public var cellArray		:Array 		= 	new Array();
		public var isToday			:Boolean	=	false;
		public var Days				:Array;
		public var Months			:Array;
		public var DaysinMonth		:Array;
		public var prevDate			:*;
		public var today			:Date;
		public var todaysday		:*;
		public var currentyear		:*;
		public var currentmonth		:*;
		public var currentDateLabel:TextField;
		public var selectedDate	:*
		//************************************************************************************
		//				 					COLOR VARIABLES 	
		//************************************************************************************
		public var backgroundColor			:Array		=	[0xFFFFFF,0x0000FF];
		public var backgroundStrokeColor	:*			=	0xA9A9C2;
		public var labelColor				:*			=	0xFFFFFF;
		public var buttonColor				:*			=	0xFFFFFF;
		public var DesabledCellColor		:*			=	0x999999;
		public var EnabledCellColor			:*			=	0xDAE0FF;
		public var TodayCellColor			:*			=	0xFF0000;
		public var mouseOverCellColor		:*			=	0x0099FF;
		public var entryTextColor			:*			=	0xffffff;

		
		//************************************************************************************
		//************************************************************************************
		//				 				CALENDAR DIAMENSIONS VARIABLES 	
		//************************************************************************************
//		public var calendarWidth			:Number		=
//		public var calendarHeight			:Number		=
//		public var cellWidth				:Number		=
//		public var cellHeight				:Number		=
//		public var labelWidth				:Number		=
		
		public function CalendarSkin() {
			
			super();
			
		}
		public function init() {
		
			addChild(calendar_mc);
//=======================================================================================================
//							DRAW CALENDAR BACKGROUND
//=======================================================================================================
			var type					:String 	= 	GradientType.RADIAL;	//gradient type
			var colorArray				:Array 		= 	backgroundColor; 		//gradient colors
			var alphaArray				:Array 		=	[1,1];					//gradient alpha
			var ratioArray				:Array		=	[0, 255];				//color ratio
			var colorMatrix				:Matrix		=	new Matrix();			
			var spreadMethod			:String 	= 	SpreadMethod.PAD;		
			var interpolationMethod		:String		=	InterpolationMethod.LINEAR_RGB;
			var focalPointRatio			:Number		=	0;
			var bg						:Sprite 	= 	new Sprite();
			var bgStrokeColor			:*			=	backgroundStrokeColor;
			var bgStrokeThickness		:Number		=	1;
			var bgWidth					:Number		=	165+300;
			var bgHeight				:Number		=	178+300;
			
			colorMatrix.createGradientBox(bgWidth,bgHeight,0,0,0);
			
			bg.name 	= 	"background";
			
			bg.graphics.lineStyle(bgStrokeThickness,bgStrokeColor);
			bg.graphics.beginGradientFill(
			  type,
			  colorArray,
			  alphaArray,
			  ratioArray,
			  colorMatrix,
			  spreadMethod,
			  interpolationMethod,
			  focalPointRatio
			  );

			bg.graphics.drawRect(0,0,165,178);
			bg.graphics.endFill();
			
			calendar_mc.addChild(bg);

//=======================================================================================================
//							MAKE CALENDAR LABELS 
//=======================================================================================================
				currentDateLabel		 	= 	new TextField();
				currentDateLabel.name 		= 	"currentDateLabel";
				currentDateLabel.autoSize	=	TextFieldAutoSize.CENTER;
				currentDateLabel.selectable =	false;
				currentDateLabel.width		=	66;
				currentDateLabel.y			=	6;
				
				var oFont:Font = new FontVerdana();
				var format 	= 	new TextFormat();
				format.font			=	oFont.fontName;
				format.color		=	labelColor;
				format.size			=	11;
				format.bold			=	true;
				
			currentDateLabel.defaultTextFormat	=	format;
			currentDateLabel.text				=	"";
			currentDateLabel.embedFonts =	true;
				format.letterSpacing 			=	15;
			var weekdisplay:Array				=	["MTWTFSS","SMTWTFS"]
			var weekname:TextField 				= 	new TextField();
				weekname.selectable				=	false;							
				weekname.defaultTextFormat		=	format;
				weekname.text					=	weekdisplay[0];
				weekname.width					=	165;					
				weekname.x						=	11;
				weekname.y 						=	23;
				weekname.embedFonts = true;
			calendar_mc.addChild(currentDateLabel);
			calendar_mc.addChild(weekname);

//=======================================================================================================
//							MAKE MONTH CHANGER BUTTONS  
//=======================================================================================================
			var nextBtn:Sprite 	= 	makeBtn(90);
				nextBtn.name 	= 	"NextButton";
				nextBtn.x 		= 	160; 
				nextBtn.y 		= 	11;
			var prevBtn:Sprite 	= 	makeBtn(270);
				prevBtn.name 	= 	"PrevButton";
				prevBtn.x 		= 	5; 
				prevBtn.y 		=	18;
				
				nextBtn.buttonMode 	= 	true;
				prevBtn.buttonMode	=	true;
				
			nextBtn.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
			prevBtn.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
			
			calendar_mc.addChild(nextBtn);
			calendar_mc.addChild(prevBtn);
			
//=======================================================================================================
//							MAKE CALENDAR ENTRIES
//=======================================================================================================
			Days			 = 	new Array();
			Months			 = 	new Array();
			DaysinMonth		 =	[31,28,31,30,31,30,31,31,30,31,30,31];
			prevDate		 =	undefined;
			today			 = 	new Date();
			todaysday		 =	today.getDay();
			currentyear		 =	today.getFullYear();
			currentmonth	 =	today.getMonth();
			
			Days.push("Monday");
			Days.push("Tuesday");
			Days.push("Wednesday");
			Days.push("Thursday");
			Days.push("Friday");
			Days.push("Saturday");
			Days.push("Sunday");
			Months.push("January");
			Months.push("February");
			Months.push("March");
			Months.push("April");
			Months.push("May");
			Months.push("June");
			Months.push("July");
			Months.push("August");
			Months.push("September");
			Months.push("October");
			Months.push("November");
			Months.push("December");
			
			currentDateLabel.text	=	Months[currentmonth]+" - "+currentyear;
			
			ConstructCalendar();

		}
		public function clickHandler(e:MouseEvent){
			switch (e.target.name) {
				case "PrevButton" :
					{
						changeMonth(-1);
						break;
					}
				case "NextButton" :
					{
						changeMonth(1);
						break;
					}
			}
			return;
			
		}
//=======================================================================================================
//							MONTH CHANGER FUNCTION
//=======================================================================================================		
		public function changeMonth(monthNum:Number):void {
			if (monthNum!=1) {
				if (currentmonth > 0) {
					currentmonth = (currentmonth - 1);
				} else {
					changeYear(-1);
				}
			} else {
				if (currentmonth < 11) {
					currentmonth = currentmonth+1;
				} else {
					changeYear(1);
				}
			}
			ConstructCalendar();
			return;
		}
//=======================================================================================================
//							YEAR CHANGER FUNCTION
//=======================================================================================================		
		public function changeYear(yearNum:Number):void {

			currentyear = currentyear + yearNum;
			if (yearNum!=1) { currentmonth = 11; } else { currentmonth = 0; }
			var yearDev:* = currentyear/4;
			yearDev = yearDev.toString();
			var yearDevLength:* = yearDev.split(".").length;
			if (yearDevLength != 1) { DaysinMonth[1]=28; } else { DaysinMonth[1]=29; }
			return;
		}
//=======================================================================================================
//							CALENDAR CONSTRUCTOR
//=======================================================================================================		
		public function ConstructCalendar(){
			var dateBox		:MovieClip;
			var xpos		:Number		=	5;
			var ypos		:Number		=	40;
			var weekCount	:Number		=	0;
			
			var endDate:* 	=	new Date(currentyear,currentmonth,0);
			var endDay:*	=	endDate.getDay();
			var locDate:*	=	new Date();
			isToday			=	false;			
			
			if ((locDate.getMonth() == currentmonth) && (locDate.getFullYear() == currentyear)) {
				isToday		=	true;
			}
			//****************************************************
			//		CONSTRUCT FIRST SET OF DESABLED CELLS
			//****************************************************
			if (endDay > 0) {
				var inc_1:Number = 0;
				while (inc_1 < endDay) {
					dateBox 		= 	Construct_Date_Element(DesabledCellColor,inc_1,false);
					dateBox.id 		= 	DesabledCellColor;
					dateBox.isToday	=	false;
					dateBox.name	=	"D"+inc_1;
					dateBox.x		=	xpos+2;
					dateBox.y		=	ypos+2;
					cellArray.push(dateBox);
				
					calendar_mc.addChild(dateBox);
				
					if (weekCount == 6) {
						weekCount = 0;
						ypos += 22;
						xpos = 5;
					} else {
						weekCount++;
						xpos += 22;
					}					
					inc_1++;
				}
			}
			//****************************************************
			//		CONSTRUCT DATE ENTRY CELLS
			//****************************************************			
			var entryNum:* 			= 	1;
			currentDateLabel.text	=	Months[currentmonth]+" - "+currentyear;
			
			var restNum:* = endDay;

			while (restNum < 42) {
				if (entryNum <= DaysinMonth[currentmonth]) {
					if (locDate.getDate()== entryNum && isToday == true) {
						dateBox 		= 	Construct_Date_Element(TodayCellColor,entryNum,true);
						dateBox.id 		= 	TodayCellColor;
						dateBox.date	=	new Date(currentyear,currentmonth,entryNum);
						dateBox.isToday	=	true;						
					}else{
						dateBox 		= 	Construct_Date_Element(EnabledCellColor,entryNum,true);
						dateBox.id 		= 	EnabledCellColor;
						dateBox.date	=	new Date(currentyear,currentmonth,entryNum);
						dateBox.isToday	=	false;
					}
				} else {
			//****************************************************
			//		CONSTRUCT SECOND SET OF DESABLED DATE CELLS
			//****************************************************
					dateBox 		= 	Construct_Date_Element(DesabledCellColor,entryNum,false);
					dateBox.id 		= 	DesabledCellColor;
					dateBox.isToday	=	false;
				}
				dateBox.name	=	"D"+(restNum + inc_1);
				dateBox.x		=	xpos+2;
				dateBox.y		=	ypos+2;
				cellArray.push(dateBox);
				
				calendar_mc.addChild(dateBox);
				
				if (weekCount == 6) {
					weekCount = 0;
					ypos += 22;
					xpos = 5;
				} else {
					weekCount++;
					xpos += 22;
				}
				restNum++;
				entryNum++;
			}
		}
//=======================================================================================================
//							DATE CELL CONSTRUCTOR FUNCTION [RETURNS MOVIECLIP]
//=======================================================================================================
		public function Construct_Date_Element(color:*,day:*,isEntry:Boolean):MovieClip {
			var day_bg		:MovieClip 	= 	new MovieClip();
			var hit			:Sprite 	= 	new Sprite();
			var day_txt		:TextField	=	new TextField();
			var cellColor	:*			=	color;
			var cellWidth	:Number		=	20;
			var cellHeight	:Number		=	20;
			
				day_bg.name	 	= 	"bg";	
				day_txt.name 	= 	"txt";				
			
			day_bg.graphics.beginFill(cellColor,1);
			day_bg.graphics.drawRect(0,0,cellWidth,cellHeight);
			day_bg.graphics.endFill();
			
			hit.graphics.beginFill(0x000000,0);
			hit.graphics.drawRect(0,0,cellWidth,cellHeight);
			hit.graphics.endFill();				
			
			day_txt.autoSize 		= 	TextFieldAutoSize.CENTER;
			day_txt.selectable 		= 	false;
			day_txt.width 			= 	20;
			day_txt.x 				=	8;
			day_txt.y 				=	2;
			

		var oFont:Font 					= 	new FontVerdana();
		var format:TextFormat 			=	new TextFormat();
			format.font 				=	oFont.fontName;
			format.color 				=	"0x515256";
			format.size 				=	11;
			format.bold 				=	false;
			day_txt.defaultTextFormat 	=	format;
			
			if(isEntry){
				day_txt.text 				=	day;
				day_txt.embedFonts 			= 	true;
				hit.name 	 				= 	"hit";
				hit.buttonMode 				=	true;
			}
			
			day_bg.addChild(day_txt);
			day_bg.addChild(hit);
			
			return (day_bg);
		}
//=======================================================================================================
//							CELL COLOR CHANGER
//=======================================================================================================			
		public function changeColor(mc,color){
			
			mc.graphics.beginFill(color);
			mc.graphics.drawRect(0,0,20,20);
			mc.graphics.endFill();
			
		}				
//=======================================================================================================
//							BUTTON GRAPHICS CONSTRUCTOR
//=======================================================================================================		
		public function makeBtn(arg2){
			var triangleHeight:uint=6;
			var triangleShape:Sprite = new Sprite();
			triangleShape.graphics.lineStyle(1,buttonColor);
			triangleShape.graphics.beginFill(buttonColor);
			triangleShape.graphics.moveTo(triangleHeight/2, 5);
			triangleShape.graphics.lineTo(triangleHeight, triangleHeight+5);
			triangleShape.graphics.lineTo(0, triangleHeight+5);
			triangleShape.graphics.lineTo(triangleHeight/2, 5);
			triangleShape.rotation = arg2;
			return(triangleShape);
		}

	}

}