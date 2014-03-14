package com.webintelligence.parsec.components.module
{

import com.adobe.cairngorm.module.ILoadPolicy;
import com.adobe.cairngorm.module.IViewLoader;
import com.bnowak.parsec.util.integration.parsley.MessageDispatcherProvider;
import com.bnowak.parsec.util.integration.parsley.MessageHandlerProvider;
import com.webintelligence.parsec.core.message.module.LoadModuleErrorMsg;
import com.webintelligence.parsec.core.message.module.LoadModuleMsg;
import com.webintelligence.parsec.core.message.module.LoadModuleProgressMsg;
import com.webintelligence.parsec.core.message.module.LoadModuleReadyMsg;
import com.webintelligence.parsec.core.message.module.ModuleContextReadyMsg;

import flash.errors.IllegalOperationError;
import flash.events.Event;
import flash.events.IEventDispatcher;

import mx.events.ModuleEvent;

import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.messaging.impl.MessageDispatcher;
import org.spicefactory.parsley.core.messaging.receiver.MessageTarget;

/**
 *  Cairngorm module loader load policy that will wait for an explicit
 *  LoadModuleMsg to initialize the loading of module.
 *
 *  @see http://sourceforge.net/adobe/cairngorm/wiki/HowToUseCairngormModule/#LoadPolicy
 */
public class ExplicitLoadPolicy implements ILoadPolicy
{

   //--------------------------------------------------------------------------
   //
   //  Class constants
   //
   //--------------------------------------------------------------------------

   /**
    *  @private
    */
   private static const LOG:Logger = LogContext.getLogger( ExplicitLoadPolicy );

   //--------------------------------------------------------------------------
   //
   //  Constructor
   //
   //--------------------------------------------------------------------------

   /**
    *  Constructor
    */
   public function ExplicitLoadPolicy( context:Context )
   {
      super();
      _context = context;
   }

   //--------------------------------------------------------------------------
   //
   //  Variables
   //
   //--------------------------------------------------------------------------

   /**
    *  @private
    */
   private var _lastLog:int;

   /**
    *  @private
    */
   protected var _context:Context;

   /**
    *  @private
    */
   protected var _dispatcher:MessageDispatcher;

   /**
    *  @private
    */
   protected var _handler:MessageTarget;

   /**
    *  @private
    */
   protected var loader:IViewLoader;

   /**
    *  @private
    */
   protected var loadRequested:Boolean;

   //--------------------------------------------------------------------------
   //
   //  Methods: ILoadPolicy
   //
   //--------------------------------------------------------------------------

   /**
    *  Start applying the load policy for the given loader and module.
    */
   public function start( loader:IViewLoader ):void
   {
      LOG.debug( "start {0}", loader.moduleId );
      this.loader = loader;
      attachListeners( loader as IEventDispatcher );
      _dispatcher = MessageDispatcherProvider.newInContext( _context );
      _handler = MessageHandlerProvider.register( _context, LoadModuleMsg, this, "loadModuleHandler" );
   }

   /**
    *  Stop applying the load policy for the given loader and module.
    */
   public function stop( loader:IViewLoader ):void
   {
      loader = null;
      removeListeners( loader as IEventDispatcher );
      _dispatcher.disable();
      MessageHandlerProvider.deregister( _context, _handler );
   }

   /**
    *  Trigger the load
    */
   public function load( loader:IViewLoader ):void
   {
      if ( !loadRequested )
      {
         LOG.debug( "load called directly! rejecting" );
         return;
      }

      LOG.debug( "load called directly!" );
      loader.loadModule();
   }

   /**
    *  Trigger the unload
    */
   public function unload( loader:IViewLoader ):void
   {
      //      @TODO: implement unload w. cleanup
      //      loader.unloadModule();
      throw new IllegalOperationError( "Not Allowed" );
   }

   //--------------------------------------------------------------------------
   //
   //  Methods
   //
   //--------------------------------------------------------------------------

   /**
    *  @private
    *  Attach listeners to the loader events.
    */
   private function attachListeners( loader:IEventDispatcher ):void
   {
      if ( !loader )
         return;

      loader.addEventListener( ModuleEvent.READY, loader_readyHandler );
      loader.addEventListener( ModuleEvent.PROGRESS, loader_progressHandler );
      loader.addEventListener( "contextReady", loader_contextReadyHandler );
      loader.addEventListener( ModuleEvent.ERROR, loader_errorHandler );
   }

   /**
    *  @private
    */
   private function removeListeners( loader:IEventDispatcher ):void
   {
      if ( !loader )
         return;

      loader.removeEventListener( ModuleEvent.READY, loader_readyHandler );
      loader.removeEventListener( ModuleEvent.PROGRESS, loader_progressHandler );
      loader.removeEventListener( "contextReady", loader_contextReadyHandler );
      loader.removeEventListener( ModuleEvent.ERROR, loader_errorHandler );
   }

   //--------------------------------------------------------------------------
   //
   //  Message handlers
   //
   //--------------------------------------------------------------------------

   /**
    *  @private
    */
   public function loadModuleHandler( msg:LoadModuleMsg ):void
   {
      if ( !loader )
         return;

      if ( loader.moduleId != msg.moduleId )
         return;

      loadRequested = true;
      LOG.debug( "loadModuleHandler {0}", msg.moduleId );
      loader.loadModule();
   }

   //--------------------------------------------------------------------------
   //
   //  Event handlers
   //
   //--------------------------------------------------------------------------

   /**
    *  @private
    */
   private function loader_readyHandler( event:ModuleEvent ):void
   {
      LOG.debug( "loader_readyHandler {0}", loader.moduleId );
      _dispatcher.dispatchMessage( new LoadModuleReadyMsg( loader.moduleId ) );
   }

   /**
    *  @private
    */
   private function loader_progressHandler( event:ModuleEvent ):void
   {
      var p:int = ( event.bytesLoaded / event.bytesTotal ) * 100;
      if ( p % 10 == 0 && p != _lastLog )
      {
         var tk:int = Math.floor( ( event.bytesTotal + 1023 ) / 1024 );
         var lk:int = Math.floor( ( event.bytesLoaded + 1023 ) / 1024 );
         LOG.debug( "Progress loading {0}: {2}kB/{3}kB ({1}%) complete", loader.moduleId, p, lk, tk );
         _lastLog = p;
      }
      _dispatcher.dispatchMessage( new LoadModuleProgressMsg( loader.moduleId, event.bytesLoaded, event.bytesTotal ) );
   }

   /**
    *  @private
    */
   private function loader_contextReadyHandler( event:Event ):void
   {
      LOG.debug( "loader_contextReadyHandler {0}", loader.moduleId );
      _dispatcher.dispatchMessage( new ModuleContextReadyMsg( loader.moduleId ) );
   }

   /**
    *  @private
    */
   private function loader_errorHandler( event:ModuleEvent ):void
   {
      LOG.error( "loader_errorHandler {0}", loader.moduleId );
      _dispatcher.dispatchMessage( new LoadModuleErrorMsg( loader.moduleId, event.toString() ) );
   }
}
}
