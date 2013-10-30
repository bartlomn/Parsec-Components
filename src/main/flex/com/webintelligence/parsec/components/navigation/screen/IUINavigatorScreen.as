package com.webintelligence.parsec.components.navigation.screen
{
import flash.display.BitmapData;

import mx.core.IVisualElement;

/***************************************************************************
 * 
 *   @author nowabart 
 *   @created 30 Nov 2011
 *   Describes API of a screen hadled by UINavigator
 * 
 ***************************************************************************/

//--------------------------------------
//  EVENTS
//--------------------------------------

/**
 *  Dispatched when screen is ready for further processing
 */
[Event(
    name="screenComplete", 
    type="com.webintelligence.parsec.components.navigation.event.UINavigatorScreenEvent")]

public interface IUINavigatorScreen
   extends IVisualElement
{
   
   //--------------------------------------------------------------------------
   //
   //  Methods
   //
   //--------------------------------------------------------------------------
   
   //--------------------------------------
   //  getScreenshot
   //--------------------------------------
   /**
    *  returns bitmap data (screenshot) of the screen contents 
    */
   function getScreenshot():BitmapData;
   
}
}