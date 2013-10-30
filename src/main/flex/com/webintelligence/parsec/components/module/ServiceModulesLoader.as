package com.webintelligence.parsec.components.module
{
import com.adobe.cairngorm.module.IModuleManager;
import com.adobe.cairngorm.module.ParsleyModuleDescriptor;
import com.bnowak.parsec.util.integration.parsley.ContextLookupHelper;
import com.webintelligence.parsec.components.containers.StyleIgnorantGroup;

import flash.events.Event;
import flash.utils.Dictionary;

import mx.collections.IList;
import mx.events.FlexEvent;

import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;
import org.spicefactory.parsley.core.context.Context;


/***************************************************************************
 *
 *   @author nowabart
 *   @created 8 Nov 2011
 *   Component responsible for loading non-visual service modules
 *
 ***************************************************************************/

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *  defines skin class for individual module loaders
 */
[Style( name = "loaderSkinClass", type = "Class" )]

//--------------------------------------
//  Events
//--------------------------------------

/**
 *  indicates that loaders are ready
 */
[Event( name = "loadersReady", type = "flash.events.Event" )]

public class ServiceModulesLoader extends StyleIgnorantGroup
{

   //--------------------------------------------------------------------------
   //
   //  Class constants
   //
   //--------------------------------------------------------------------------

   /**
    *  @private
    */
   private static const LOG:Logger = LogContext.getLogger( ServiceModulesLoader );

   //--------------------------------------------------------------------------
   //
   //  Constructor
   //
   //--------------------------------------------------------------------------

   /**
    *  Constructor
    */
   public function ServiceModulesLoader()
   {
      super();
      visible = includeInLayout = false;
      descriptorsToLoadersMap = new Dictionary();
   }

   //--------------------------------------------------------------------------
   //
   //  Variables
   //
   //--------------------------------------------------------------------------

   /**
    *  @private
    *  parsley context pointer
    */
   internal var context:Context;

   /**
    *  @private
    *  maps descriptors to loaders
    */
   internal var descriptorsToLoadersMap:Dictionary;

   /**
    *  @private
    */
   internal var numLoaders:int;

   /**
    *  @private
    */
   internal var completeLoaders:int;

   //--------------------------------------------------------------------------
   //
   //  Properties
   //
   //--------------------------------------------------------------------------

   //--------------------------------------
   //  descriptors
   //--------------------------------------

   /**
    *  @private
    *  property storage
    */
   private var _descriptors:IList;

   /**
    *  @private
    *  copy of the old property value
    */
   private var _oldDescriptors:Array;

   /**
    *  @private
    *  property dirty flag
    */
   private var descriptorsDirty:Boolean;

   [ArrayElementType( "com.adobe.cairngorm.module.ParsleyModuleDescriptor" )]

   /**
    *  list of module descriptors for modules handled by this component
    */
   public function get descriptors():IList
   {
      return _descriptors;
   }

   public function set descriptors( value:IList ):void
   {
      if ( value == _descriptors )
         return;
      if ( _descriptors )
         _oldDescriptors = _descriptors.toArray().concat();
      _descriptors = value;
      descriptorsDirty = true;
      invalidateProperties();

      LOG.debug( "Setting non-visual module descriptors" );
   }

   //--------------------------------------------------------------------------
   //
   //  Override Methods: UIComponent
   //
   //--------------------------------------------------------------------------

   //--------------------------------------
   //  commitProperties
   //--------------------------------------
   /**
    *  @inherited
    */
   override protected function commitProperties():void
   {
      super.commitProperties();
      if ( descriptorsDirty )
      {
         if ( _oldDescriptors )
            cleanupLoaders( descriptors );
         createLoaders();
         descriptorsDirty = false;
      }
   }

   //--------------------------------------
   //  initialized
   //--------------------------------------
   /**
    *  @inherited
    */
   override public function initialize():void
   {
      super.initialize();
      ContextLookupHelper.lookup( this, contextFound );
   }

   //--------------------------------------------------------------------------
   //
   //  Methods
   //
   //--------------------------------------------------------------------------

   //--------------------------------------
   //  contextFound
   //--------------------------------------
   /**
    *  @private
    *  callback method
    */
   private function contextFound( foundContext:Context ):void
   {
      if ( foundContext )
         context = foundContext;
   }

   //--------------------------------------
   //  createLoaders
   //--------------------------------------
   /**
    *  @private
    *  creates ModuleLoaders, one per descriptor
    */
   private function createLoaders():void
   {
      if ( !descriptors || !descriptors.length )
      {
         dispatchEvent( new Event( "loadersReady" ) );   // this is to maintain validation even when no loaders are created
         return;
      }
      var l:int = descriptors.length;
      if ( l > 0 )
      {
         completeLoaders = 0;
         for ( var i:int = 0; i < l; i++ )
         {
            var md:ParsleyModuleDescriptor = descriptors.getItemAt( i ) as ParsleyModuleDescriptor;
            if ( md && !descriptorsToLoadersMap[ md ] )
               createLoader( md );
         }
      }
   }

   //--------------------------------------
   //  cleanupLoaders
   //--------------------------------------
   /**
    *  @private
    *  cleans old loaders in case descriptor gets removed
    */
   private function cleanupLoaders( newDescriptors:IList ):void
   {
      for each ( var md:ParsleyModuleDescriptor in _oldDescriptors )
      {
         if ( ( !newDescriptors || newDescriptors.getItemIndex( md ) == -1 ) && descriptorsToLoadersMap[ md ] )
            removeLoader( ModuleViewLoader( descriptorsToLoadersMap[ md ] ), md );
      }
      _oldDescriptors = null;
   }

   //--------------------------------------
   //  removeLoader
   //--------------------------------------
   /**
    *  @private
    *  removes loader from stage, cleans references
    */
   private function removeLoader( loader:ModuleViewLoader, descriptor:ParsleyModuleDescriptor ):void
   {
      delete descriptorsToLoadersMap[ descriptor ];
      removeElement( loader );
      loader = null;
      numLoaders--;
   }

   //--------------------------------------
   //  createLoader
   //--------------------------------------
   /**
    *  @private
    *  creates new module loader, adds it to stage
    */
   private function createLoader( descriptor:ParsleyModuleDescriptor ):void
   {
      var loader:ModuleViewLoader = new ModuleViewLoader();
      var mgr:IModuleManager      = IModuleManager( context.getObject( descriptor.objectId ) );
      loader.setStyle( "skinClass", getStyle( "loaderSkinClass" ) );
      loader.moduleId = descriptor.objectId;
      loader.moduleManager = mgr;
      loader.loadPolicy = LoadPolicyFactory.newInstance( ExplicitLoadPolicy, context );
      loader.addEventListener( FlexEvent.CREATION_COMPLETE, loaderCreationCompleteHandler );
      addElement( loader );
      descriptorsToLoadersMap[ descriptor ] = loader;
      numLoaders++;
   }


   //--------------------------------------
   //  createLoader
   //--------------------------------------
   /**
    *  @private
    */
   private function loaderCreationCompleteHandler( event:FlexEvent ):void
   {
      var loader:ModuleViewLoader = ModuleViewLoader( event.target );
      loader.removeEventListener( FlexEvent.CREATION_COMPLETE, loaderCreationCompleteHandler );
      completeLoaders++;
      if ( completeLoaders == numLoaders )
         dispatchEvent( new Event( "loadersReady" ) );
   }
}
}
