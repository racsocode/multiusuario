////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2003-2006 Adobe Macromedia Software LLC and its licensors.
//  All Rights Reserved. The following is Source Code and is subject to all
//  restrictions on such code as contained in the End User License Agreement
//  accompanying this product.
//
////////////////////////////////////////////////////////////////////////////////

package mx.styles
{

import flash.display.DisplayObject;
import flash.events.EventDispatcher;
import flash.utils.Dictionary;
import mx.core.Singleton;
import mx.core.mx_internal;
import mx.managers.SystemManagerGlobals;

use namespace mx_internal;

/**
 *  The CSSStyleDeclaration class represents a set of CSS style rules.
 *  The MXML compiler automatically generates one CSSStyleDeclaration object
 *  for each selector in the CSS files associated with a Flex application.
 *  
 *  <p>A CSS rule such as
 *  <pre>
 *      Button { color: #FF0000 }
 *  </pre>
 *  affects every instance of the Button class;
 *  a selector like <code>Button</code> is called a type selector
 *  and must not start with a dot.</p>
 *
 *  <p>A CSS rule such as
 *  <pre>
 *      .redButton { color: #FF0000 }
 *  </pre>
 *  affects only components whose <code>styleName</code> property
 *  is set to <code>".redButton"</code>;
 *  a selector like <code>.redButton</code> is called a class selector
 *  and must start with a dot.</p>
 *
 *  <p>You can access the autogenerated CSSStyleDeclaration objects
 *  using the <code>StyleManager.getStyleDeclaration()</code> method,
 *  passing it either a type selector
 *  <pre>
 *  var buttonDeclaration:CSSStyleDeclaration =
 *      StyleManager.getStyleDeclaration("Button");
 *  </pre>
 *  or a class selector
 *  <pre>
 *  var redButtonStyleDeclaration:CSSStyleDeclaration =
 *      StyleManager.getStyleDeclaration(".redButton");
 *  </pre>
 8  </p>
 *
 *  <p>You can use the <code>getStyle()</code>, <code>setStyle()</code>,
 *  and <code>clearStyle()</code> methods to get, set, and clear 
 *  style properties on a CSSStyleDeclaration.</p>
 *
 *  <p>You can also create and install a CSSStyleDeclaration at run time
 *  using the <code>StyleManager.setStyleDeclaration()</code> method:
 *  <pre>
 *  var newStyleDeclaration:CSSStyleDeclaration = new CSSStyleDeclaration();
 *  newStyleDeclaration.setStyle("leftMargin", 50);
 *  newStyleDeclaration.setStyle("rightMargin", 50);
 *  StyleManager.setStyleDeclaration(".bigMargins", newStyleDeclaration, true);
 *  </pre>
 *  </p>
 *
 *  @see mx.core.UIComponent
 *  @see mx.styles.StyleManager
 */
public class CSSStyleDeclaration extends EventDispatcher
{
	include "../core/Version.as";

	/**
	 *  @private
	 */
	private static const NOT_A_COLOR:uint = 0xFFFFFFFF;

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 *  Constructor.
	 *
	 *  @param selector If not null, this CSSStyleDeclaration will be
	 *  registered with the StyleManager using the selector value.
	 */
	public function CSSStyleDeclaration(selector:String = null)
	{
		super();

        if (selector)
            StyleManager.setStyleDeclaration(selector, this, false);
	}

	//--------------------------------------------------------------------------
	//
	//  Class variables
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	private static var styleManager:IStyleManager = Singleton
		.getInstance("mx.styles::IStyleManager") as IStyleManager;

	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 *  This Array keeps track of all the style name/value objects
	 *  produced from this CSSStyleDeclaration and already inserted into
	 *  prototype chains. Whenever this CSSStyleDeclaration's overrides object
	 *  is updated by setStyle(), these clone objects must also be updated.
	 */
	private var clones:Dictionary = new Dictionary(true);

	/**
	 *  @private
	 *  The number of CSS selectors pointing to this CSSStyleDeclaration.
	 *  It will be greater than 0 if this CSSStyleDeclaration has been
	 *  installed in the StyleManager.styles table by
	 *  StyleManager.setStyleDeclaration().
	 */
	mx_internal var selectorRefCount:int = 0;

	/**
	 *  @private
	 *  Array that specifies the names of the events declared
	 *  by this CSS style declaration.
	 *  This Array is used by the <code>StyleProtoChain.initObject()</code>
	 *  method to register the effect events with the Effect manager.
	 */
	mx_internal var effects:Array;
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  defaultFactory
	//----------------------------------

	[Inspectable(environment="none")]
	
	/**
	 *  This function, if it isn't <code>null</code>,
	 *  is usually autogenerated by the MXML compiler.
	 *  It produce copies of a plain Object, such as
	 *  <code>{ leftMargin: 10, rightMargin: 10 }</code>,
	 *  containing name/value pairs for style properties; the object is used
	 *  to build a node of the prototype chain for looking up style properties.
	 *
	 *  <p>If this CSSStyleDeclaration is owned by a UIComponent
	 *  written in MXML, this function encodes the style attributes
	 *  that were specified on the root tag of the component definition.</p>
	 *
	 *  <p>If the UIComponent was written in ActionScript,
	 *  this property is <code>null</code>.</p>
	 */
	public var defaultFactory:Function;

	//----------------------------------
	//  factory
	//----------------------------------

	[Inspectable(environment="none")]
	
	/**
	 *  This function, if it isn't <code>null</code>,
	 *  is usually autogenerated by the MXML compiler.
	 *  It produce copies of a plain Object, such as
	 *  <code>{ leftMargin: 10, rightMargin: 10 }</code>,
	 *  containing name/value pairs for style properties; the object is used
	 *  to build a node of the prototype chain for looking up style properties.
	 *
	 *  <p>If this CSSStyleDeclaration is owned by a UIComponent,
	 *  this function encodes the style attributes that were specified in MXML
	 *  for an instance of that component.</p>
	 */
	public var factory:Function;

	//----------------------------------
	//  overrides
	//----------------------------------

	/**
	 *  If the <code>setStyle()</code> method is called on a UIComponent or CSSStyleDeclaration
	 *  at run time, this object stores the name/value pairs that were set;
	 *  they override the name/value pairs in the objects produced by
	 *  the  methods specified by the <code>defaultFactory</code> and 
	 *  <code>factory</code> properties.
	 */
	protected var overrides:Object;

	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------

	/**
	 *  Gets the value for a specified style property,
	 *  as determined solely by this CSSStyleDeclaration.
	 *
	 *  <p>The returned value may be of any type.</p>
	 *
	 *  <p>The values <code>null</code>, <code>""</code>, <code>false</code>,
	 *  <code>NaN</code>, and <code>0</code> are all valid style values,
	 *  but the value <code>undefined</code> is not; it indicates that
	 *  the specified style is not set on this CSSStyleDeclaration.
	 *  You can use the method <code>StyleManager.isValidStyleValue()</code>
	 *  to test the value that is returned.</p>
	 *
	 *  @param styleProp The name of the style property.
	 *
	 *  @return The value of the specified style property if set,
	 *  or <code>undefined</code> if not.
	 */
	public function getStyle(styleProp:String):*
	{
		var o:*;
		var v:*;

		// First look in the overrides, in case setStyle()
		// has been called on this CSSStyleDeclaration.
		if (overrides)
		{
			// If the property exists in our overrides, but 
			// has 'undefined' as its value, it has been 
			// cleared from this stylesheet so return
			// undefined.
			if (styleProp in overrides &&
				overrides[styleProp] === undefined)
				return undefined;
				
			v = overrides[styleProp];
			if (v !== undefined) // must use !==
				return v;
		}

		// Next look in the style object that this CSSStyleDeclaration's
		// factory function produces; it contains styles that
		// were specified in an instance tag of an MXML component
		// (if this CSSStyleDeclaration is attached to a UIComponent).
		if (factory != null)
		{
			factory.prototype = {};
			o = new factory();
			v = o[styleProp];
			if (v !== undefined) // must use !==
				return v;
		}

		// Next look in the style object that this CSSStyleDeclaration's
		// defaultFactory function produces; it contains styles that
		// were specified on the root tag of an MXML component.
		if (defaultFactory != null)
		{
			defaultFactory.prototype = {};
			o = new defaultFactory();
			v = o[styleProp];
			if (v !== undefined) // must use !==
				return v;
		}

		// Return undefined if the style isn't specified
		// in any of these three places.
		return undefined;
	}

	/**
	 *  Sets a style property on this CSSStyleDeclaration.
	 *
	 *  @param styleProp The name of the style property.
	 *
	 *  @param newValue The value of the style property.
	 *  The value may be of any type.
	 *  The values <code>null</code>, <code>""</code>, <code>false</code>,
	 *  <code>NaN</code>, and <code>0</code> are all valid style values,
	 *  but the value <code>undefined</code> is not.
	 *  Setting a style property to the value <code>undefined</code>
	 *  is the same as calling the <code>clearStyle()</code> method.
	 */
	public function setStyle(styleProp:String, newValue:*):void
	{
		var oldValue:Object = getStyle(styleProp);
		var regenerate:Boolean = false;

		// If this CSSStyleDeclaration didn't previously have a factory,
		// defaultFactory, or overrides object, then this CSSStyleDeclaration
		// hasn't been added to anyone's proto chain.  In that case, we
		// need to regenerate everyone's proto chain.
		if (selectorRefCount > 0 &&
			factory == null &&
			defaultFactory == null &&
			!overrides && 
			(oldValue !== newValue)) // must be !==
		{
			regenerate = true;
		}
		
		if (newValue !== undefined) // must be !==
		{
			mx_internal::setStyle(styleProp, newValue);
		}
		else
		{
			if (newValue == oldValue)
				return;
			mx_internal::setStyle(styleProp, newValue);
		}

		var sms:Array = SystemManagerGlobals.topLevelSystemManagers;
		var n:int = sms.length;
		var i:int;

		// Type as Object to avoid dependency on SystemManager.
		var sm:Object;

		if (regenerate)
		{
			// Regenerate all the proto chains
			// for all objects in the application.
			for (i = 0; i < n; i++)
			{
				sm = sms[i];
				sm.regenerateStyleCache(true);
			}
		}

		for (i = 0; i < n; i++)
		{
			sm = sms[i];
			sm.notifyStyleChangeInChildren(styleProp, true);
		}
	}
	
	/**
	 *  @private
	 *  Sets a style property on this CSSStyleDeclaration.
	 *
	 *  @param styleProp The name of the style property.
	 *
	 *  @param newValue The value of the style property.
	 *  The value may be of any type.
	 *  The values <code>null</code>, <code>""</code>, <code>false</code>,
	 *  <code>NaN</code>, and <code>0</code> are all valid style values,
	 *  but the value <code>undefined</code> is not.
	 *  Setting a style property to the value <code>undefined</code>
	 *  is the same as calling <code>clearStyle()</code>.
	 */
	mx_internal function setStyle(styleProp:String, value:*):void
	{
		// If setting to undefined, clear the style attribute.
		if (value === undefined) // must use ===
		{
			clearStyleAttr(styleProp);
			return;
		}

		var o:Object;

		// If the value is a String of the form "#FFFFFF" or "red",
		// then convert it to a RGB color uint (e.g.: 0xFFFFFF).
		if (value is String)
		{
			var colorNumber:Number = StyleManager.getColorName(value);
			if (colorNumber != NOT_A_COLOR)
				value = colorNumber;
		}

		// If the new value for styleProp is different from the one returned
		// from the defaultFactory function, then store the new value on the
		// overrides object. That way, future clones will get the new value.
		if (defaultFactory != null)
		{
			o = new defaultFactory();
			if (o[styleProp] !== value) // must use !==
			{
				if (!overrides)
					overrides = {};
				overrides[styleProp] = value;
			}
			else if (overrides)
			{
				delete overrides[styleProp];
			}
		}

		// If the new value for styleProp is different from the one returned
		// from the factory function, then store the new value on the
		// overrides object. That way, future clones will get the new value.
		if (factory != null)
		{
			o = new factory();
			if (o[styleProp] !== value) // must use !==
			{
				if (!overrides)
					overrides = {};
				overrides[styleProp] = value;
			}
			else if (overrides)
			{
				delete overrides[styleProp];
			}
		}

		if (defaultFactory == null && factory == null)
		{
			if (!overrides)
				overrides = {};
			overrides[styleProp] = value;
		}

		// Update all clones of this style sheet.
		for (var clone:* in clones)
		{
			clone[styleProp] = value;
		}
	}
	
	/**
	 *  Clears a style property on this CSSStyleDeclaration.
	 *
	 *  This is the same as setting the style value to <code>undefined</code>.
	 *
	 *  @param styleProp The name of the style property.
	 */
	public function clearStyle(styleProp:String):void
	{
		public::setStyle(styleProp, undefined);
	}

	/**
	 *  @private
	 */
	mx_internal function createProtoChainRoot():Object
	{
		var root:Object = {};

		// If there's a defaultFactory for this style sheet,
		// then add the object it produces to the root.
		if (defaultFactory != null)
		{
			defaultFactory.prototype = root;
			root = new defaultFactory();
		}

		// If there's a factory for this style sheet,
		// then add the object it produces to the root.
		if (factory != null)
		{
			factory.prototype = root;
			root = new factory();
		}

		clones[ root ] = 1;
		
		return root;
	}

	/**
	 *  @private
	 */
	mx_internal function addStyleToProtoChain(chain:Object,
										 target:DisplayObject):Object
	{
		var nodeAddedToChain:Boolean = false;
		
		// If there's a defaultFactory for this style sheet,
		// then add the object it produces to the chain.
		if (defaultFactory != null)
		{
			defaultFactory.prototype = chain;
			chain = new defaultFactory();
			nodeAddedToChain = true;
		}

		// If there's a factory for this style sheet,
		// then add the object it produces to the chain.
		if (factory != null)
		{
			factory.prototype = chain;
			chain = new factory();
			nodeAddedToChain = true;
		}
		
		// If someone has called setStyle() on this CSSStyleDeclaration,
		// then some of the values returned from the factory are
		// out-of-date. Overwrite them with the up-to-date values.
		if (overrides)
		{
			// Before we add our overrides to the object at the head of
			// the chain, make sure that we added an object at the head
			// of the chain.
			if (defaultFactory == null && factory == null)
			{
				var emptyObjectFactory:Function = function():void
				{
				};
				emptyObjectFactory.prototype = chain;
				chain = new emptyObjectFactory();
				nodeAddedToChain = true;
			}

			for (var p:String in overrides)
			{
				if (overrides[p] === undefined)
					delete chain[p];
				else
					chain[p] = overrides[p];
			}
		}

		if (nodeAddedToChain)
			clones[chain] = 1;

		return chain;
	}

	/**
	 *  @private
	 */
	mx_internal function clearOverride(styleProp:String):void
	{
		if (overrides && overrides[styleProp])
            delete overrides[styleProp];
	}

	/**
	 *  @private
	 */
	private function clearStyleAttr(styleProp:String):void
	{
		// Put "undefined" into our overrides Array
		if (!overrides)
			overrides = {};
		overrides[styleProp] = undefined;
		
		// Remove the property from all our clones
		for (var clone:* in clones)
		{
			delete clone[styleProp];
		}
	}
}

}
