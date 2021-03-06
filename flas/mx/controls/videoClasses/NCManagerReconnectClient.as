////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2003-2006 Adobe Macromedia Software LLC and its licensors.
//  All Rights Reserved. The following is Source Code and is subject to all
//  restrictions on such code as contained in the End User License Agreement
//  accompanying this product.
//
////////////////////////////////////////////////////////////////////////////////

package mx.controls.videoClasses 
{

[ExcludeClass]

/**
 *  @private
 *  Holds client-side functions for remote procedure calls (RPCs) from
 *  the FCS during reconnection.
 *  One of these objects is created and passed to the
 *  <code>NetConnection.client</code> property.
 */
public class NCManagerReconnectClient
{
	include "../../core/Version.as";

    public var owner:NCManager;

    public function NCManagerReconnectClient(owner:NCManager = null)
    {
		super();

        this.owner = owner;
    }

    // This is defined just to work around bug 121673
    public function onBWCheck(... rest):uint
    {
        return ++owner.payload;
    }

    public function onBWDone(... rest):void
    {
        owner.onReconnected();
    }
}

}