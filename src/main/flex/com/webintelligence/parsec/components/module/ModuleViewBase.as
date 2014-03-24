package com.webintelligence.parsec.components.module
{
import com.adobe.cairngorm.module.IParsleyModule;
import com.webintelligence.parsec.components.navigation.event.UINavigatorScreenEvent;

import mx.collections.IList;
import mx.events.FlexEvent;
import mx.modules.Module;

import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;
import org.spicefactory.lib.task.enum.TaskState;
import org.spicefactory.parsley.flex.tag.builder.ContextBuilderTag;


/***************************************************************************
 *
 *   @author nowabart
 *   @created 2 Aug 2011
 *   Base for the all project's modules
 *
 ***************************************************************************/

public class ModuleViewBase extends Module implements IParsleyModule
{

   //--------------------------------------------------------------------------
   //
   //  Class constants
   //
   //--------------------------------------------------------------------------

   /**
    *  @private
    */
   protected static const LOG:Logger = LogContext.getLogger( ModuleViewBase );

   //--------------------------------------------------------------------------
   //
   //  Constructor
   //
   //--------------------------------------------------------------------------

   /**
    *  Constructor
    */
   public function ModuleViewBase()
   {
      addEventListener( FlexEvent.CREATION_COMPLETE, creationCompleteHandler );
   }

   //--------------------------------------------------------------------------
   //
   //  Properties
   //
   //--------------------------------------------------------------------------

   //--------------------------------------
   //  contextBuilderTag
   //--------------------------------------

   /**
    *  @private
    *  Placeholder for the MXML defined property
    */
   public var contextBuilderTag:ContextBuilderTag;


   //--------------------------------------
   //  bootstrapSequenceTask
   //--------------------------------------

   // todo: deprecated, remove

   /**
    *  @private
    *  Storage for the bootstrapSequenceTask property.
    */
   private var _bootstrapSequenceTask:Object;

   [Deprecated]
   /**
    *  Application bootstrap sequence task.
    *  Injected from BootstrapContext.mxml
    */
   public function get bootstrapSequenceTask():Object
   {
      return _bootstrapSequenceTask;
   }

   /**
    *  @private
    */
   public function set bootstrapSequenceTask( value:Object ):void
   {
      _bootstrapSequenceTask = value;
      startBootstrap();
   }

   //--------------------------------------
   //  serviceModules
   //--------------------------------------

   [Bindable]

   /**
    *  List of services modules required by the module
    *  Defined in appropriate ModulesContext
    */
   public var serviceModules:IList;

   //--------------------------------------
   //  serviceModuleLoaderReady
   //--------------------------------------

   /**
    *  @private
    *  Storage for the serviceModuleLoaderReady property.
    */
   private var _serviceModuleLoaderReady:Boolean;

   /**
    *  Get the value of serviceModuleLoaderReady
    */
   public function get serviceModuleLoaderReady():Boolean
   {
      return _serviceModuleLoaderReady;
   }

   /**
    *  @private
    */
   public function set serviceModuleLoaderReady( value:Boolean ):void
   {
      LOG.debug( "Service modules are ready" );
      _serviceModuleLoaderReady = value;
      startBootstrap();
   }

   //--------------------------------------
   //  injectionCompleted
   //--------------------------------------

   /**
    *  Flag indicating the successful completion of injection process
    */
   protected var injectionCompleted:Boolean;

   //--------------------------------------------------------------------------
   //
   //  Methods
   //
   //--------------------------------------------------------------------------

   /**
    *  IParsleyModule implementation
    */
   public function get contextBuilder():ContextBuilderTag
   {
      if ( !contextBuilderTag )
         throw new Error( "ContextBuilderTag not implemented in " + this + "! Add appropriate MXML tag." );
      return contextBuilderTag;
   }

   /**
    *  Deferred bootstrap start to avoid occasional race condition
    *  errors due to non-deterministic initialisation
    */
   public function startBootstrap():void
   {
      if ( injectionCompleted && serviceModuleLoaderReady && bootstrapSequenceTask &&
         bootstrapSequenceTask.state == TaskState.INACTIVE )
      {
         LOG.debug( "Starting bootstrap sequence now" );
         bootstrapSequenceTask.start();
      }
   }

   /**
    *  creation complete handler
    */
   protected function creationCompleteHandler( event:FlexEvent ):void
   {
      LOG.debug( "Module creation complete" );
      removeEventListener( FlexEvent.CREATION_COMPLETE, creationCompleteHandler );
      dispatchEvent( new UINavigatorScreenEvent( UINavigatorScreenEvent.SCREEN_COMPLETE ) );
   }
}
}
