package com.webintelligence.parsec.components.navigation.screen
{
import com.webintelligence.parsec.components.navigation.event.UINavigatorScreenEvent;

import flash.display.BitmapData;

import mx.events.FlexEvent;

import spark.components.Group;
import spark.components.SkinnableContainer;

/***************************************************************************
 *
 *   @author nowabart
 *   @created 30 Nov 2011
 *   Abstracts common API methods required from navigator screens
 *
 ***************************************************************************/

//--------------------------------------
//  EVENTS
//--------------------------------------

/**
 *  Dispatched when screen is ready for further processing
 */
[Event( name = "screenComplete",
   type = "com.webintelligence.parsec.components.navigation.event.UINavigatorScreenEvent" )]

public class AbstractUINavigatorScreen extends SkinnableContainer implements IUINavigatorScreen
{

   //--------------------------------------------------------------------------
   //
   //  Constructor
   //
   //--------------------------------------------------------------------------

   /**
    *  Constructor
    */
   public function AbstractUINavigatorScreen()
   {
      super();
      addEventListener( FlexEvent.CREATION_COMPLETE, creationCompleteHandler );
   }

   //--------------------------------------------------------------------------
   //
   //  Methods
   //
   //--------------------------------------------------------------------------

   //--------------------------------------
   //  getScreenshot
   //--------------------------------------
   /**
    *  returns screenshot of the navigator screen to be used by animator
    */
   public function getScreenshot():BitmapData
   {
      var bd:BitmapData;
      if ( width && height )
      {
         bd = new BitmapData( width, height, true, 0x00FFFFFF );
         bd.draw( this );
      }
      return bd;
   }

   //--------------------------------------
   //  creationCompleteHandler
   //--------------------------------------
   /**
    *  executed on creation complete
    */
   protected function creationCompleteHandler( event:FlexEvent ):void
   {
      dispatchEvent( new UINavigatorScreenEvent( UINavigatorScreenEvent.SCREEN_COMPLETE ) );
   }
}
}
