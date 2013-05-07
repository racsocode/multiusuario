////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2003-2006 Adobe Macromedia Software LLC and its licensors.
//  All Rights Reserved. The following is Source Code and is subject to all
//  restrictions on such code as contained in the End User License Agreement
//  accompanying this product.
//
////////////////////////////////////////////////////////////////////////////////

package mx.skins.halo
{

import flash.display.GradientType;
import flash.display.Graphics;
import mx.skins.Border;
import mx.styles.StyleManager;
import mx.utils.ColorUtil;

/**
 *  The skin for all the states of the icon in a RadioButton.
 */
public class RadioButtonIcon extends Border
{
	include "../../core/Version.as";

	//--------------------------------------------------------------------------
	//
	//  Class variables
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	private static var cache:Object = {};
	
	//--------------------------------------------------------------------------
	//
	//  Class methods
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 *  Several colors used for drawing are calculated from the base colors
	 *  of the component (themeColor, borderColor and fillColors).
	 *  Since these calculations can be a bit expensive,
	 *  we calculate once per color set and cache the results.
	 */
	private static function calcDerivedStyles(themeColor:uint,
											  borderColor:uint,
											  fillColor0:uint,
											  fillColor1:uint):Object
	{
		var key:String = HaloColors.getCacheKey(themeColor, borderColor,
												fillColor0, fillColor1);
		
		if (!cache[key])
		{
			var o:Object = cache[key] = {};
			
			// Cross-component styles
			HaloColors.addHaloColors(o, themeColor, fillColor0, fillColor1);
			
			// RadioButton-unique styles
			o.borderColorDrk1 = ColorUtil.adjustBrightness2(borderColor, -60);
		}
		
		return cache[key];
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 *  Constructor.
	 */
	public function RadioButtonIcon()
	{
		super();
	}

    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
	//  measuredWidth
    //----------------------------------
    
    /**
     *  @private
     */    
    override public function get measuredWidth():Number
    {
        return 14;
    }
    
    //----------------------------------
	//  measuredHeight
    //----------------------------------
    
    /**
     *  @private
     */        
    override public function get measuredHeight():Number
    {
        return 14;
    }
	
	//--------------------------------------------------------------------------
	//
	//  Overridden methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  @private
	 */
	override protected function updateDisplayList(w:Number, h:Number):void
	{
		super.updateDisplayList(w, h);

		// User-defined styles
		var borderColor:uint = getStyle("borderColor");
		var fillAlphas:Array = getStyle("fillAlphas");
		var fillColors:Array = getStyle("fillColors");
		StyleManager.getColorNames(fillColors);
		var highlightAlphas:Array = getStyle("highlightAlphas");		
		var themeColor:uint = getStyle("themeColor");
		
		// Placeholder styles stub
		var radioColor:uint = 0x2B333C; // added style prop
		
		// Derived styles
		var derStyles:Object = calcDerivedStyles(themeColor, borderColor,
												 fillColors[0], fillColors[1]);
		var borderColorDrk1:Number =
			ColorUtil.adjustBrightness2(borderColor, -50);
		
		var themeColorDrk1:Number =
			ColorUtil.adjustBrightness2(themeColor, -25);
		
		var r:Number = width / 2;
		
		var upFillColors:Array;
		var upFillAlphas:Array;

		var disFillColors:Array;
		var disFillAlphas:Array;

		var g:Graphics = graphics;
		
		g.clear();
		
		switch (name)
		{			
			case "upIcon":
			{
   				upFillColors = [ fillColors[0], fillColors[1] ];
				upFillAlphas = [ fillAlphas[0], fillAlphas[1] ];

				// border
				g.beginGradientFill(GradientType.LINEAR, 
									[ borderColor, borderColorDrk1 ],
									[100, 100], [ 0, 0xFF],
									verticalGradientMatrix(0, 0, w , h));
				g.drawCircle(r, r, r);
				g.drawCircle(r, r, (r - 1));
				g.endFill();

					// radio fill
				g.beginGradientFill(GradientType.LINEAR, 
									upFillColors,
									upFillAlphas, [ 0, 0xFF ],
									verticalGradientMatrix(1, 1, w - 2, h - 2));
				g.drawCircle(r, r, (r - 1));
				g.endFill();

				// top highlight
				drawRoundRect(
					1, 1, w - 2, (h - 2) / 2 , 
					{ tl: r, tr: r, bl: 0, br: 0 },
					[ 0xFFFFFF, 0xFFFFFF ], highlightAlphas,
					verticalGradientMatrix(0, 0, w - 2, (h - 2) / 2 )); 

				break;
			}

			case "overIcon":
			{
				var overFillColors:Array;
				if (fillColors.length > 2)
					overFillColors = [ fillColors[2], fillColors[3] ];
				else
					overFillColors = [ fillColors[0], fillColors[1] ];

				var overFillAlphas:Array;
				if (fillAlphas.length > 2)
					overFillAlphas = [ fillAlphas[2], fillAlphas[3] ];
  				else
					overFillAlphas = [ fillAlphas[0], fillAlphas[1] ];

				// border
				g.beginGradientFill(
					GradientType.LINEAR, 
					[ themeColor, themeColorDrk1 ], [ 100, 100 ], [ 0, 0xFF ],
					verticalGradientMatrix(0, 0, w , h));
				g.drawCircle(r, r, r);
				g.drawCircle(r, r, r - 1);
				g.endFill();

				// radio fill
				g.beginGradientFill(
					GradientType.LINEAR,
					overFillColors, overFillAlphas, [ 0, 0xFF ],
					verticalGradientMatrix(1, 1, w - 2, h - 2));
				g.drawCircle(r, r, (r - 1));
				g.endFill();
				
				// top highlight
				drawRoundRect(
					1, 1, w - 2, (h - 2) / 2 , 
					{ tl: r, tr: r, bl: 0, br: 0 },
					[ 0xFFFFFF, 0xFFFFFF ],
					highlightAlphas,
					verticalGradientMatrix(0, 0, w - 2, (h - 2) / 2)); 

				break;
			}

			case "downIcon":
			{
				// border
				g.beginGradientFill(
					GradientType.LINEAR,
					[ themeColor, themeColorDrk1 ], [ 100, 100 ], [ 0, 0xFF ],
					verticalGradientMatrix(0, 0, w , h));
				g.drawCircle(r, r, r);
				g.endFill();
					
				// radio fill
				g.beginGradientFill(
					GradientType.LINEAR,
					[ derStyles.fillColorPress1, derStyles.fillColorPress2 ],
					[ 100, 100 ], [ 0, 0xFF ],
					verticalGradientMatrix(1, 1, w - 2, h - 2));
				g.drawCircle(r, r, (r - 1));
				g.endFill();
				
				// top highlight
				drawRoundRect(
					1, 1, w - 2, (h - 2) / 2 , 
					{ tl: r, tr: r, bl: 0, br: 0 },
					[ 0xFFFFFF, 0xFFFFFF ], highlightAlphas,
					verticalGradientMatrix(0, 0, w - 2, (h - 2) / 2)); 

				break;
			}
			
			case "disabledIcon":
			{
   				disFillColors = [ fillColors[0], fillColors[1] ];
				disFillAlphas = [ Math.max( 0, fillAlphas[0] - 0.15),
								  Math.max( 0, fillAlphas[1] - 0.15) ];

				g.beginGradientFill(
					GradientType.LINEAR,
					[ borderColor, borderColorDrk1 ], [ 0.5, 0.5 ], [ 0, 0xFF ],
					verticalGradientMatrix(0, 0, w, h));
				g.drawCircle(r, r, r);
				g.drawCircle(r, r, (r - 1));
				g.endFill();
				
				g.beginGradientFill(
					GradientType.LINEAR, 
					disFillColors, disFillAlphas, [ 0, 0xFF ],
					verticalGradientMatrix(1, 1, w - 2, h - 2));
				g.drawCircle(r, r, (r - 1));
				g.endFill();
				
				break;
			}
							
			case "selectedUpIcon":
			case "selectedOverIcon":
			case "selectedDownIcon":
			{
   				upFillColors = [ fillColors[0], fillColors[1] ];
				upFillAlphas = [ fillAlphas[0], fillAlphas[1] ];

				// border
				g.beginGradientFill(
					GradientType.LINEAR,
					[ borderColor, borderColorDrk1 ], [ 100, 100 ], [ 0, 0xFF ],
					verticalGradientMatrix(0, 0, w, h));
				g.drawCircle(r, r, r);
				g.drawCircle(r, r, (r - 1));
				g.endFill();

				// radio fill
				g.beginGradientFill(
					GradientType.LINEAR, 
					upFillColors, upFillAlphas, [ 0, 0xFF],
					verticalGradientMatrix(1, 1, w - 2, h - 2));
				g.drawCircle(r, r, (r - 1));
				g.endFill();

				// top highlight
				drawRoundRect(
					1, 1, w - 2, (h - 2) / 2 , 
					{ tl: r, tr: r, bl: 0, br: 0 },
					[0xFFFFFF, 0xFFFFFF], highlightAlphas,
					verticalGradientMatrix(0, 0, w - 2, (h - 2) / 2));

				// radio symbol
				g.beginFill(radioColor);
				g.drawCircle(r, r, 2);
				g.endFill();
				
				break;
			}

			case "selectedDisabledIcon":
			{
   				disFillColors = [ fillColors[0], fillColors[1] ];
				disFillAlphas = [ Math.max( 0, fillAlphas[0] - 0.15),
								  Math.max( 0, fillAlphas[1] - 0.15) ];

				// border
				g.beginGradientFill(
					GradientType.LINEAR,
					[ borderColor, borderColorDrk1 ], [ 0.5, 0.5 ], [ 0, 0xFF ],
					verticalGradientMatrix(0, 0, w , h));
				g.drawCircle(r, r, r);
				g.drawCircle(r, r, (r - 1));
				g.endFill();
				
				// radio fill
				g.beginGradientFill(
					GradientType.LINEAR,
					disFillColors, disFillAlphas, [ 0, 0xFF],
					verticalGradientMatrix(1, 1, w - 2, h - 2));
				g.drawCircle(r, r, (r - 1));
				g.endFill();
				
				// radio symbol
				g..beginFill(0x999999);
				g..drawCircle(r, r, 2);
				g..endFill();
				
				break;
			}
		}
	}
}

}
