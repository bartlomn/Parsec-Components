package com.webintelligence.parsec.components.navigation.screen
{
import com.adobe.errors.IllegalStateError;
import com.webintelligence.parsec.components.navigation.event.UINavigatorScreenEvent;

import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.events.IEventDispatcher;
import flash.utils.Dictionary;

import mx.binding.utils.BindingUtils;

import mx.binding.utils.ChangeWatcher;

import mx.events.FlexEvent;

import org.spicefactory.lib.logging.LogContext;

import org.spicefactory.lib.logging.Logger;

import org.spicefactory.parsley.core.view.util.StageEventFilter;
import org.spicefactory.parsley.view.FastInject;

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

   /**
    *  @private
    */
   private var _filter:StageEventFilter;

   /**
    *  @private
    */
   protected var log:Logger;

   //--------------------------------------------------------------------------
   //
   //  Constructor
   //
   //--------------------------------------------------------------------------

   /**
    *  Constructor
    */
   public function AbstractUINavigatorScreen( logTarget:Class = null )
   {
      super();
      if( !logTarget )
         logTarget = AbstractUINavigatorScreen;
      log = LogContext.getLogger( logTarget );
      _filter = new StageEventFilter( this, removedHandler, addedHandler );
      addEventListener( FlexEvent.CREATION_COMPLETE, creationCompleteHandler );
   }

   //--------------------------------------------------------------------------
   //
   //  Methods
   //
   //--------------------------------------------------------------------------

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


   /**
    *  executed on creation complete
    */
   protected function creationCompleteHandler( event:FlexEvent ):void
   {
      removeEventListener( FlexEvent.CREATION_COMPLETE, creationCompleteHandler );
      dispatchEvent( new UINavigatorScreenEvent( UINavigatorScreenEvent.SCREEN_COMPLETE ) );
   }

   /**
    *  Executed after component is added to stage
    */
   protected function addedHandler( view:DisplayObject ):void
   {
      // abstract
   }

   /**
    *  Executed after component is removed stage
    */
   protected function removedHandler( view:DisplayObject ):void
   {
      // abstract
   }

}
}
