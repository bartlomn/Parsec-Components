package com.webintelligence.parsec.components.core
{
import com.bnowak.parsec.util.integration.parsley.ContextLookupHelper;
import com.bnowak.parsec.util.integration.parsley.MessageDispatcherProvider;

import flash.display.DisplayObject;

import spark.components.supportClasses.SkinnableComponent;

import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.messaging.impl.MessageDispatcher;
import org.spicefactory.parsley.core.view.util.StageEventFilter;



/***************************************************************************
 *
 *   @author nowabart
 *   @created 2 Dec 2011
 *   Core, base class having common functionality of container based components
 *   that use some of the parsley's functions, at the same not being managed by it.
 *
 ***************************************************************************/

public class ParsleyAwareComponent extends SkinnableComponent
{

   //--------------------------------------------------------------------------
   //
   //  Constructor
   //
   //--------------------------------------------------------------------------

   /**
    *  Constructor
    */
   public function ParsleyAwareComponent()
   {
      super();
      //Using StageEventFilter util from Parsley to guarantee that when the removed handler is called
      //it is because the display object was really removed from stage.
      //Containers in Flex SDK may remove/add to stage at anytime to add/remove the content from a scrollpane.
      //This Util use the fact that when the SDK remove/add to/from stage, it happens within the same frame so the 
      //Util simply wait the next frame to check if it is really removed from stage or not.
      filter = new StageEventFilter( this, removedFromStageHandler, addedToStageHandler );
   }

   //--------------------------------------------------------------------------
   //
   //  Variables
   //
   //--------------------------------------------------------------------------

   //--------------------------------------
   //  PARSLEY RELATED
   //--------------------------------------
   /**
    *  @private
    *  stage event filter
    */
   private var filter:StageEventFilter;

   /**
    *  @private
    *  context reference
    */
   protected var _context:Context;

   //--------------------------------------------------------------------------
   //
   //  Properties
   //
   //--------------------------------------------------------------------------

   //--------------------------------------
   //  dispatcher
   //--------------------------------------
   /**
    *  parsley message dispatcher
    */
   protected var dispatcher:MessageDispatcher;

   //--------------------------------------------------------------------------
   //
   //  Methods
   //
   //--------------------------------------------------------------------------

   //--------------------------------------
   //  addedToStageHandler
   //--------------------------------------
   /**
    *  @private
    *  Init tagged method equivalent, called after component is added to stage
    */
   protected function addedToStageHandler( target:DisplayObject ):void
   {
      if ( !_context )
         ContextLookupHelper.lookup( this, contextFoundHandler );
      else
         dispatcher = MessageDispatcherProvider.newInContext( _context );
   }

   //--------------------------------------
   //  removedFromStageHandler
   //--------------------------------------
   /**
    *  @private
    *  Cleanup method, called after component is removed from stage
    */
   protected function removedFromStageHandler( target:DisplayObject ):void
   {
      dispatcher.disable();
   }

   //--------------------------------------
   //  dispatchMessage
   //--------------------------------------
   /**
    *  @private
    *  dispatches message via parsley
    */
   protected function dispatchMessage( message:Object ):void
   {
      dispatcher.dispatchMessage( message );
   }

   //--------------------------------------
   //  contextFoundHandler
   //--------------------------------------
   /**
    *  @private
    *  callback method for context lookup
    */
   private function contextFoundHandler( context:Context ):void
   {
      _context = context;
      dispatcher = MessageDispatcherProvider.newInContext( _context );
      invalidateProperties();
   }

}
}
