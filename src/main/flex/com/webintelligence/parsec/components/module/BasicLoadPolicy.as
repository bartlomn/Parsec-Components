/**
 * User: Bart
 * Date: 07/03/2014
 * Time: 22:15
 * Description:
 */

package com.webintelligence.parsec.components.module
{
import com.adobe.cairngorm.module.BasicLoadPolicy;
import com.adobe.cairngorm.module.IViewLoader;
import com.bnowak.parsec.util.integration.parsley.ContextLookupHelper;
import com.bnowak.parsec.util.integration.parsley.MessageDispatcherProvider;
import com.webintelligence.parsec.core.message.module.LoadModuleErrorMsg;
import com.webintelligence.parsec.core.message.module.LoadModuleProgressMsg;
import com.webintelligence.parsec.core.message.module.LoadModuleReadyMsg;
import com.webintelligence.parsec.core.message.module.ModuleContextReadyMsg;

import flash.display.DisplayObject;

import flash.events.Event;
import flash.events.IEventDispatcher;

import mx.events.ModuleEvent;

import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.messaging.impl.MessageDispatcher;

public class BasicLoadPolicy extends com.adobe.cairngorm.module.BasicLoadPolicy
{

   /**
    *  @private
    */
   private static const LOG:Logger = LogContext.getLogger( com.webintelligence.parsec.components.module.BasicLoadPolicy );

   /**
    *  @private
    */
   private var _lastProgress:*

   /**
    *  @private
    */
   protected var _context:Context;

   /**
    *  @private
    */
   protected var _dispatcher:MessageDispatcher;

   /**
    *  Constructor
    */
   public function BasicLoadPolicy()
   {
      super();
   }

   /**
    *  @inheritDoc
    */
   override public function load(loader:IViewLoader):void
   {
      attachListeners( loader as IEventDispatcher );
      super.load( loader );
   }

   /**
    *  @inheritDoc
    */
   override public function unload(loader:IViewLoader):void
   {
      removeListeners( loader as IEventDispatcher );
      super.unload( loader );
   }

   /**
    *  Start applying the load policy for the given loader and module.
    */
   override public function start( loader:IViewLoader ):void
   {
      LOG.debug( "Starting load policy for {0}", loader.moduleId );
      super.start( loader );
      ContextLookupHelper.lookup( loader as DisplayObject, contextFound );
   }


   /**
    *  @private
    */
   private function contextFound( c:Context ):void
   {
      _context = c;
      attachListeners( loader as IEventDispatcher );
   }

   /**
    *  @private
    *  Attach listeners to the loader events.
    */
   private function attachListeners( loader:IEventDispatcher ):void
   {
      if ( !loader || !_context )
         return;

      if( ! _dispatcher )
      {
         LOG.debug( "Attaching listeners")
         _dispatcher = MessageDispatcherProvider.newInContext( _context );
         loader.addEventListener( ModuleEvent.READY, loader_readyHandler );
         loader.addEventListener( ModuleEvent.PROGRESS, loader_progressHandler );
         loader.addEventListener( "contextReady", loader_contextReadyHandler );
         loader.addEventListener( ModuleEvent.ERROR, loader_errorHandler );
      }
   }


   /**
    *  @private
    */
   private function removeListeners( loader:IEventDispatcher ):void
   {
      if ( !loader )
         return;

      LOG.debug( "Removing listeners");
      _dispatcher.disable();
      _dispatcher = null;
      loader.removeEventListener( ModuleEvent.READY, loader_readyHandler );
      loader.removeEventListener( ModuleEvent.PROGRESS, loader_progressHandler );
      loader.removeEventListener( "contextReady", loader_contextReadyHandler );
      loader.removeEventListener( ModuleEvent.ERROR, loader_errorHandler );
   }
   /**
    *  @private
    */
   private function loader_readyHandler( event:ModuleEvent ):void
   {
      LOG.debug( "Module {0} loaded OK", loader.moduleId );
      _dispatcher.dispatchMessage( new LoadModuleReadyMsg( loader.moduleId ) );
   }

   /**
    *  @private
    */
   private function loader_progressHandler( event:ModuleEvent ):void
   {
      var p:int = ( event.bytesLoaded / event.bytesTotal ) * 100;
      if ( p % 10 == 0 && p != _lastProgress )
      {
         LOG.debug( "Progress loading {0}: {1}% complete", loader.moduleId, p );
         _lastProgress = p;
      }
      _dispatcher.dispatchMessage( new LoadModuleProgressMsg( loader.moduleId, event.bytesLoaded, event.bytesTotal ) );
   }

   /**
    *  @private
    */
   private function loader_contextReadyHandler( event:Event ):void
   {
      LOG.debug( "Module {0} context initialised OK", loader.moduleId );
      _dispatcher.dispatchMessage( new ModuleContextReadyMsg( loader.moduleId ) );
   }

   /**
    *  @private
    */
   private function loader_errorHandler( event:ModuleEvent ):void
   {
      LOG.error( "Module {0} LOAD ERROR", loader.moduleId );
      _dispatcher.dispatchMessage( new LoadModuleErrorMsg( loader.moduleId, event.toString() ) );
   }
}
}
