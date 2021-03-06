////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2003-2006 Adobe Macromedia Software LLC and its licensors.
//  All Rights Reserved. The following is Source Code and is subject to all
//  restrictions on such code as contained in the End User License Agreement
//  accompanying this product.
//
////////////////////////////////////////////////////////////////////////////////

package mx.controls
{

import mx.core.UIComponent;
import mx.core.mx_internal;

use namespace mx_internal;

[IconFile("Spacer.png")]

/**
 *  The Spacer control helps you lay out children within a parent container.
 *  Although the Spacer control does not draw anything, it does allocate space
 *  for itself within its parent container. 
 *  
 *  <p>In the following example, a flexible Spacer control is used
 *  to push the Button control to the right, so that the Button control
 *  is aligned with the right edge of the HBox container:</p>
 *
 *  <pre>
 *  &lt;mx:HBox&gt;
 *  	&lt;mx:Image source="Logo.jpg"/&gt;
 *  	&lt;mx:Label text="Company XYZ"/&gt;
 *  	&lt;mx:Spacer width="100%"/&gt;
 *  	&lt;mx:Button label="Close"/&gt;
 *  &lt;/mx:HBox&gt;
 *  </pre>
 *
 *  @mxml
 *  
 *  <p>The <code>&lt;mx:Spacer&gt;</code> tag inherits all of the tag attributes
 *  of its superclass, and adds no new tag attributes.</p>
 *  
 *  <pre>
 *  &lt;mx:Spacer/&gt;
 *  </pre>
 *  
 *  @includeExample examples/SpacerExample.mxml
 *  
 */
public class Spacer extends UIComponent
{
	include "../core/Version.as";

	//--------------------------------------------------------------------------
	//
	//  Constructor variables
	//
	//--------------------------------------------------------------------------

	/**
	 *  Constructor
	 */
	public function Spacer()
	{
		super();
	}
}

}
