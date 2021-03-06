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

import mx.skins.Border;
import mx.styles.StyleManager;
import mx.utils.ColorUtil;

/**
 *  The skin for the track in a ProgressBar.
 */
public class ProgressTrackSkin extends Border
{
	include "../../core/Version.as";
		
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

	/**
	 *  Constructor.
	 */
	public function ProgressTrackSkin()
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
		return 200;
	}
	
	//----------------------------------
	//  measuredHeight
	//----------------------------------

	/**
	 *  @private
	 */
	override public function get measuredHeight():Number
	{
		return 6;
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
		var fillColors:Array = getStyle("trackColors") as Array;
		StyleManager.getColorNames(fillColors);
		
		// ProgressTrack-unique styles
		var borderColorDrk1:Number =
			ColorUtil.adjustBrightness2(borderColor, -30);
				
		graphics.clear();
		
		drawRoundRect(
			0, 0, w, h, 0, 
			[ borderColorDrk1, borderColor ], 1,
			verticalGradientMatrix(0, 0, w, h));

		drawRoundRect(
			1, 1, w - 2, h - 2, 0,
			fillColors, 1,
			verticalGradientMatrix(1, 1, w - 2, h - 2));
	}
}

}
