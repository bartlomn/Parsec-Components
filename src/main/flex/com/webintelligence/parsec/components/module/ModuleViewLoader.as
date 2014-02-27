package com.webintelligence.parsec.components.module
{

import com.adobe.cairngorm.module.ILoadPolicy;
import com.adobe.cairngorm.module.IModuleManager;
import com.adobe.cairngorm.module.ModuleViewLoader;
import com.bnowak.parsec.util.integration.parsley.ContextLookupHelper;
import com.bnowak.parsec.util.integration.parsley.MessageDispatcherProvider;
import com.webintelligence.parsec.core.message.lifecycle.NotifyCriticalErrorMsg;

import flash.display.DisplayObject;
import flash.events.UncaughtErrorEvent;

import mx.core.INavigatorContent;
import mx.events.ModuleEvent;

import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.messaging.impl.MessageDispatcher;
import org.spicefactory.parsley.core.view.util.StageEventFilter;

//--------------------------------------
// Events
//--------------------------------------

/**
 *  notifies that loaded screen has initialized and is ready for processing
 */
[Event( name = "screenComplete",
   type = "com.webintelligence.parsec.components.navigation.event.UINavigatorScreenEvent" )]

/**
 *  Cairngorm ModuleViewLoader extension that uses property consolidation to
 *  prevent non-deterministic property assignment race conditions.
 */
public class ModuleViewLoader extends com.adobe.cairngorm.module.ModuleViewLoader implements INavigatorContent
{

   //--------------------------------------------------------------------------
   //
   //  Class constants
   //
   //--------------------------------------------------------------------------

   /**
    *  @private
    */
   private static const LOG:Logger =
      LogContext.getLogger( com.webintelligence.parsec.components.module.ModuleViewLoader );

   //--------------------------------------------------------------------------
   //
   //  Constructor
   //
   //--------------------------------------------------------------------------

   /**
    *  Constructor
    */
   public function ModuleViewLoader()
   {
      super();
      //Using StageEventFilter util from Parsley to guarantee that when the removed handler is called
      //it is because the display object was really removed from stage.
      //Containers in Flex SDK may remove/add to stage at anytime to add/remove the content from a scrollpane.
      //This Util use the fact that when the SDK remove/add to/from stage, it happens within the same frame so the 
      //Util simply wait the next frame to check if it is really removed from stage or not.
      filter = new StageEventFilter( this, removedFromStageHandler, addedToStageHandler );
      addEventListener( ModuleEvent.SETUP, moduleSetupHandler );
   }

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

   /**
    *  @private
    *  parsley message dispatcher
    */
   protected var _dispatcher:MessageDispatcher;

   //--------------------------------------------------------------------------
   //
   //  Properties implementing INavigatorContent
   //  This allows to use the class directly as a child of a ViewStack
   //
   //--------------------------------------------------------------------------

   //--------------------------------------
   // label
   //--------------------------------------

   [Bindable( "labelChanged" )]

   /**
    *  @inheritDoc
    */
   public function get label():String
   {
      return "";
   }

   //--------------------------------------
   // icon
   //--------------------------------------

   [Bindable( "iconChanged" )]

   /**
    *  @inheritDoc
    */
   public function get icon():Class
   {
      return null;
   }

   //--------------------------------------------------------------------------
   //
   //  Overriden properties: ModuleViewLoader
   //
   //--------------------------------------------------------------------------

   //--------------------------------------
   // loadPolicy
   //--------------------------------------

   /**
    *  @private
    *  Storage for the loadPolicy property
    */
   private var _loadPolicy:ILoadPolicy;

   /**
    *  @private
    */
   private var loadPolicyChanged:Boolean;

   /**
    *  Load policy for this loader.
    */
   override public function get loadPolicy():ILoadPolicy
   {
      return _loadPolicy;
   }

   /**
    *  @private
    */
   override public function set loadPolicy( value:ILoadPolicy ):void
   {
      if ( _loadPolicy == value )
         return;

      _loadPolicy = value;
      loadPolicyChanged = true;
      invalidateProperties();
   }

   //--------------------------------------
   // moduleManager
   //--------------------------------------

   /**
    *  @private
    *  Storage for the moduleManager property
    */
   private var _moduleManager:IModuleManager;

   /**
    *  @private
    */
   private var moduleManagerChanged:Boolean;

   /**
    *  Module manager configuration.
    */
   public function get moduleManager():IModuleManager
   {
      return _moduleManager;
   }

   /**
    *  @private
    */
   override public function set moduleManager( value:IModuleManager ):void
   {
      if ( _moduleManager == value )
         return;

      _moduleManager = value;
      moduleManagerChanged = true;
      invalidateProperties();
   }

   //--------------------------------------------------------------------------
   //
   //  Overriden methods: UIComponent
   //
   //--------------------------------------------------------------------------

   /**
    *  @private
    */
   override protected function commitProperties():void
   {
      super.commitProperties();

      // Make sure loadPolicy and moduleManager are set in a correct order.
      if ( loadPolicyChanged )
      {
         loadPolicyChanged = false;
         LOG.debug( "loadPolicyChanged {0}", loadPolicy );
         super.loadPolicy = loadPolicy;
      }

      if ( moduleManagerChanged )
      {
         moduleManagerChanged = false;
         LOG.debug( "moduleManagerChanged {0}", moduleManager );
         super.moduleManager = moduleManager;
      }
   }

   //--------------------------------------------------------------------------
   //
   //  Parsley related methods
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
         setupMessageDispatcher();
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
      _dispatcher.disable();
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
      setupMessageDispatcher();
   }

   //--------------------------------------
   //  setupMessageDispatcher
   //--------------------------------------
   /**
    *  @private
    *  wires message dispatcher
    */
   private function setupMessageDispatcher():void
   {
      _dispatcher = MessageDispatcherProvider.newInContext( _context );
      invalidateProperties();
   }

   //--------------------------------------------------------------------------
   //
   //  Fix for uncought errors, see:
   //  https://blogs.adobe.com/aharui/2011/04/catching-uncaughterror-in-flex-modules.html
   //
   //--------------------------------------------------------------------------

   /**
    *  @private
    *  handler for module setup event
    */
   private function moduleSetupHandler( event:ModuleEvent ):void
   {
      DisplayObject( event.module.factory ).loaderInfo.uncaughtErrorEvents.
         addEventListener( UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler );
   }

   /**
    *  @private
    *  uncought Errors Handler
    */
   private function uncaughtErrorHandler( event:UncaughtErrorEvent ):void
   {
      if ( CONFIG::dev )
         event.preventDefault();
      if ( _dispatcher != null )
      {
         _dispatcher.dispatchMessage( new NotifyCriticalErrorMsg(
            this,
            "Internal Application Error",
            "Critical error, the application must be reloaded.",
            "UncaughtErrorEvent:\n" + event.toString(),
            event.error ) );
      }
      LOG.fatal( "UncaughtErrorEvent caught {0}", event.target.toString() );
   }
}
}
