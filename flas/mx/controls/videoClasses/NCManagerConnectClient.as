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

import flash.net.NetConnection;

[ExcludeClass]

/**
 *  @private
 *  <p>Holds client-side functions for remote procedure calls (rpc) from
 *  the FCS during initial connection.  One of these objects is created and
 *  passed to the <code>NetConnection.client</code> property.
 */
public class NCManagerConnectClient
{
	include "../../core/Version.as";

    public var owner:NCManager;
    public var netConnection:NetConnection;
    public var connIndex:uint;
    public var pending:Boolean;
	
    public function NCManagerConnectClient(nc:NetConnection, owner:NCManager=null, connIndex:uint=0)
    {
		super();

        this.owner = owner;
        this.netConnection = nc;
        this.connIndex = connIndex;
        this.pending = false;
    }

    public function onBWDone(... rest):void
    {
        var p_bw:Number;
        if (rest.length > 0) p_bw = rest[0];

        owner.onConnected(netConnection, p_bw);
    }

    public function onBWCheck(... rest):uint
    {
        return ++owner.payload;
    }

    public function onMetaData(... rest):void
    {
    }
	
    public function onPlayStatus(... rest):void
    {
    }
	
    public function close():void
    {     
    }
}

}