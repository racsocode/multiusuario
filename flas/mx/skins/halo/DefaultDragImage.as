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

import flash.display.Graphics;
import mx.core.IFlexDisplayObject;
import mx.core.SpriteAsset;

/**
 *  The default drag proxy image for a drag and drop operation.
 *  
 *  @see mx.managers.DragManager
 */
public class DefaultDragImage extends SpriteAsset implements IFlexDisplayObject
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
	public function DefaultDragImage()
	{
		draw(10, 10);
		
		super();
	}

	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	override public function get measuredWidth():Number
	{
		return 10;
	}
	
	/**
	 *  @private
	 */
	override public function get measuredHeight():Number
	{
		return 10;
	}

	//--------------------------------------------------------------------------
	//
	//  Overridden methods
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	override public function move(x:Number, y:Number):void
	{
		this.x = x;
		this.y = y;
	}
	
	/**
	 *  @private
	 */
	override public function setActualSize(newWidth:Number,
										   newHeight:Number):void
	{
		draw(newWidth, newHeight);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	private function draw(w:Number, h:Number):void
	{
		var g:Graphics = graphics;
		
		g.clear();
		g.beginFill(0xEEEEEE);
		g.lineStyle(1, 0x80B09A);
		g.drawRect(0, 0, w, h);
		g.endFill();
	}
}

}
