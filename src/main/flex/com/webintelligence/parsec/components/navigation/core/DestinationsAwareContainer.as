package com.webintelligence.parsec.components.navigation.core
{
import com.bnowak.parsec.util.integration.parsley.MessageHandlerProvider;
import com.webintelligence.parsec.components.core.ParsleyAwareContainer;
import com.webintelligence.parsec.components.navigation.domain.DestinationDescriptor;
import com.webintelligence.parsec.components.navigation.event.NavigationContainerEvent;
import com.webintelligence.parsec.core.navigation.INavigationRequest;
import com.webintelligence.parsec.core.navigation.destination.Destination;
import com.webintelligence.parsec.core.navigation.enum.DestinationScope;
import com.webintelligence.parsec.core.navigation.message.DestinationReadyMessage;
import com.webintelligence.parsec.core.user.IUserRoleController;
import com.webintelligence.parsec.core.user.event.UserDetailsChangedEvent;

import flash.display.DisplayObject;
import flash.utils.Dictionary;

import mx.collections.ArrayCollection;
import mx.collections.ListCollectionView;

import org.spicefactory.parsley.core.messaging.receiver.MessageTarget;
import org.spicefactory.parsley.view.FastInject;


/***************************************************************************
 *
 *   @author nowabart
 *   @created 2 Dec 2011
 *   Base class for navigation components that handle destinations model.
 *   This encapsulates all functionality needed to react no navigation requests
 *   and indicate current navigation state.
 *
 ***************************************************************************/

//--------------------------------------
//  Events
//--------------------------------------

/**
 *  dispatched after destination descriptors list changes
 */
[Event( name = "descriptorsChanged",
   type = "com.webintelligence.parsec.components.navigation.event.NavigationContainerEvent" )]

/**
 *  dispatched after destination list changes
 */
[Event( name = "destinationsChanged",
   type = "com.webintelligence.parsec.components.navigation.event.NavigationContainerEvent" )]

/**
 *  dispatched after current destination for this component changes
 */
[Event( name = "currentDestinationChanged",
   type = "com.webintelligence.parsec.components.navigation.event.NavigationContainerEvent" )]

//--------------------------------------
//  Other
//--------------------------------------

public class DestinationsAwareContainer extends ParsleyAwareContainer
{

   //--------------------------------------------------------------------------
   //
   //  Constructor
   //
   //--------------------------------------------------------------------------

   /**
    *  Constructor
    */
   public function DestinationsAwareContainer()
   {
      super();
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
    *  navigation request message handler
    */
   private var _navigationRequestHandler:MessageTarget;
   
   /**
    *  @private
    *  destionation ready message handler
    */
   private var _destinationReadyHandler:MessageTarget;
   
//   /**
//    *  @private
//    *  user roles controler subscriber
//    */
//   private var _urcSubscriber:Subscriber;
   
   //--------------------------------------
   //  DESTINATIONS RELATED
   //--------------------------------------
   /**
    *  @private
    *  flag to indicate if destiantion descriptors has been configured
    */
   private var _destinationDescriptorsReady:Boolean;

   /**
    *  @private
    *  maps destinations to destination descriptors
    */
   private var _destinationToDescriptorMap:Dictionary;

   /**
    *  @private
    *  default destination to load
    */
   protected var _defaultDestination:Destination;

   /**
    *  @private
    *  last successfuly loaded primary destination
    */
   protected var _lastPrimaryDestination:Destination;

   //--------------------------------------
   //  PERMISSIONS RELATED
   //--------------------------------------
   /**
    *  @private
    *  flag to indicate that we need to re-evaluate permissions
    */
   private var _permissionsDirty:Boolean;

   //--------------------------------------------------------------------------
   //
   //  Properties
   //
   //--------------------------------------------------------------------------

   //--------------------------------------
   //  descriptorListId
   //--------------------------------------

   /**
    *  @private
    */
   private var _descriptorListId:String;

   /**
    *  Allows to specify directly objectID of destinations descriptors array to use with this navigator.
    *  This will be internally resolved using parsley injection, therefore the specified object
    *  needs to live within the context that is visible to the view navigator lives in.
    */
   public function set descriptorListId( value:String ):void
   {
      _descriptorListId = value;
      invalidateProperties();
   }


   //--------------------------------------
   //  destinationDescriptors
   //--------------------------------------

   /**
    *  @private
    *  property storage
    */
   private var _destinationDescriptors:Array;

   [ArrayElementType( "com.webintelligence.parsec.components.navigation.domain.DestinationDescriptor" )]
   [Bindable( "descriptorsChanged" )]

   /**
    *  List of destination descriptors
    *  Specifies which destinations are handled by this navigator.
    *  Although this is public property, it's not itended as main configuration point.
    *  For code simplicity use descriptorListId property.
    */
   public function set destinationDescriptors( value:Array ):void
   {
      _destinationDescriptors = value;
      _destinationToDescriptorMap = new Dictionary();
      var destArr:Array = [];
      for each ( var dd:DestinationDescriptor in value )
      {
         _destinationToDescriptorMap[ dd.destination ] = dd;
         destArr.push( dd.destination );
         if ( dd.autoLoad && !_defaultDestination )
            _defaultDestination = dd.destination;
      }
      destinations = new ArrayCollection( destArr );
      _destinationDescriptorsReady = true;
      invalidateProperties();
      dispatchEvent( new NavigationContainerEvent( NavigationContainerEvent.DESCRIPTORS_CHANGED ) );
   }

   /**
    *  List of destination descriptors
    *  Specifies which destinations are handled by this navigator.
    *  Although this is public property, it's not itended as main configuration point.
    *  For code simplicity use descriptorListId property.
    */
   public function get destinationDescriptors():Array
   {
      return _destinationDescriptors;
   }

   //--------------------------------------
   //  destinations
   //--------------------------------------

   /**
    *  @inheritDoc
    */
   private var _destinations:ListCollectionView;

   [ArrayElementType( "com.webintelligence.parsec.core.navigation.destination.Destination" )]
   [Bindable( "destinationsChanged" )]

   /**
    *  List of destinations.
    *  In normal mode of operation you woud want to use injected list of destination descriptors,
    *  this property allows to manually override this mechanism
    *  and explicitly specify which destinations to display.
    */
   public function get destinations():ListCollectionView
   {
      return _destinations;
   }

   /**
    *  destinations setter
    */
   public function set destinations( value:ListCollectionView ):void
   {
      if ( _destinations == value )
         return;

      if ( _destinations )
      {
         _destinations.filterFunction = null; // GC
      }
      _destinations = value;
      if ( _destinations )
      {
         _destinations.filterFunction = permissionFilterFunction;
         _destinations.refresh();
      }
      dispatchEvent( new NavigationContainerEvent( NavigationContainerEvent.DESTINATIONS_CHANGED ) );
   }

   //--------------------------------------
   //  currentDestination
   //--------------------------------------

   /**
    *  @private
    */
   private var _currentDestination:Destination;

   [Bindable( "currentDestinationChanged" )]

   /**
    *  returns current destination for this component
    */
   public function get currentDestination():Destination
   {
      return _currentDestination;
   }

   /**
    *  Sets current destination for this component.
    *  Do not use unless you absolutely know what you're doing.
    */
   public function set currentDestination( value:Destination ):void
   {
      _currentDestination = value;
      dispatchEvent( new NavigationContainerEvent( NavigationContainerEvent.CURRENT_DESTINATION_CHANGED ) );
   }

   //--------------------------------------
   //  rolesController
   //--------------------------------------

   /**
    *  @private
    */
   private var _rolesController:IUserRoleController;

   /**
    *  Sets user roles controller.
    *  If set this will allow to interact with restricted access destinations.
    *  If left out, restriced destinations will not be taken into account.
    */
   public function set rolesController( value:IUserRoleController ):void
   {
      if ( _rolesController )
         _rolesController.removeEventListener( UserDetailsChangedEvent.USER_DETAILS_CHANGED, userDetailsChangedHandler );
      _rolesController = value;
      if ( _rolesController )
      {
         _rolesController.addEventListener( UserDetailsChangedEvent.USER_DETAILS_CHANGED, userDetailsChangedHandler );
         if ( _rolesController.hasSpecificRoles )
         {
            _permissionsDirty = true;
            invalidateProperties();
         }
      }
   }

   //--------------------------------------------------------------------------
   //
   //  Methods
   //
   //--------------------------------------------------------------------------

   //--------------------------------------
   //  navigationRequestHandler
   //--------------------------------------
   /**
    *  message handler for navigation requests
    *  entry point for navigation sequence
    */
   public function navigationRequestHandler( request:INavigationRequest ):void
   {
      if ( currentDestination && currentDestination == request.destination && request.closeIfOpen )
         currentDestination = null;
      else
         currentDestination = request.destination;
   }

   //--------------------------------------
   //  destinationReadyHandler
   //--------------------------------------
   /**
    *  Message handler for destination ready notifications.
    *  We check if parent has become ready, which by logic means we are ready as well.
    *  Here we notify world about it.
    */
   public function destinationReadyHandler( message:DestinationReadyMessage ):void
   {
      if ( message.destination.scope == DestinationScope.PRIMARY )
         _lastPrimaryDestination = message.destination;
      if ( !currentDestination || message.destination == currentDestination )
         return;
      var chain:Array = currentDestination.toArray();
      if ( chain.length <= 1 )
         return; //no point doing the rest, since we are the root navigator
      var parentDestination:Destination = chain.splice( chain.length - 2, 1 )[ 0 ];
      if ( parentDestination == message.destination )
         dispatchMessage( new DestinationReadyMessage( currentDestination ) );
   }

   //--------------------------------------
   //  commitProperties
   //--------------------------------------
   /**
    *  @inheritDoc
    */
   override protected function commitProperties():void
   {
      super.commitProperties();
      if ( _context && !_navigationRequestHandler )
         addParsleyHandlers();
      if ( !_destinationDescriptorsReady && _context && _descriptorListId )
         configureDescriptors();
      if ( _permissionsDirty )
      {
         _permissionsDirty = false;
         if ( _destinations )
            _destinations.refresh();
         dispatchEvent( new NavigationContainerEvent( NavigationContainerEvent.DESTINATIONS_CHANGED ) );
      }
      if ( _context && _navigationRequestHandler && _defaultDestination &&
         ( !_defaultDestination.role || ( _rolesController && _rolesController.hasRole( _defaultDestination.role ) ) ) )
      {
         currentDestination = _defaultDestination;
         _defaultDestination = null;
      }
   }

   //--------------------------------------
   //  removedFromStageHandler
   //--------------------------------------
   /**
    *  @inheritDoc
    */
   override protected function removedFromStageHandler( target:DisplayObject ):void
   {
      super.removedFromStageHandler( target );
      removeParsleyHandlers();
   }


   //--------------------------------------
   //  descritptorForDestination
   //--------------------------------------
   /**
    *  returns descritptor for a given destination
    */
   protected function descritptorForDestination( destination:Destination ):DestinationDescriptor
   {
      return destination ?
         ( _destinationToDescriptorMap[ destination ] || descritptorForDestination( findCommonParent( destination ) ) ) :
         null;
   }

   //--------------------------------------
   //  findCommonParent
   //--------------------------------------
   /**
    *  @private
    *  search for a common parent between a given destination and local supported destinations
    */
   protected function findCommonParent( destination:Destination ):Destination
   {
      for each ( var local:Destination in destinations )
      {
         var common:Destination = local.getSharedParent( destination );
         if ( common )
            return common;
      }
      return null;
   }

   //--------------------------------------
   //  addParsleyHandlers
   //--------------------------------------
   /**
    *  @private
    *  configures parsley message handlers
    */
   protected function addParsleyHandlers():void
   {
      _navigationRequestHandler = MessageHandlerProvider.register( _context, INavigationRequest, this, "navigationRequestHandler" )
      _destinationReadyHandler = MessageHandlerProvider.register( _context, DestinationReadyMessage, this, "destinationReadyHandler" )

//      _urcSubscriber =
//         new PropertySubscriber(
//         this,
//         ClassInfo.forInstance( this ).getProperty( "rolesController" ),
//         ClassInfo.forClass( IUserRoleController ) );
//      var mgr:BindingManager =
//         _context.scopeManager.getScope( ScopeName.GLOBAL ).extensions.forType( BindingManager ) as BindingManager;
//      mgr.addSubscriber( _urcSubscriber );
   }

   //--------------------------------------
   //  removeParsleyHandlers
   //--------------------------------------
   /**
    *  @private
    *  removes parsley message handlers
    */
   protected function removeParsleyHandlers():void
   {
      if ( !_context )
         return;
      MessageHandlerProvider.deregister( _context, _navigationRequestHandler );
      MessageHandlerProvider.deregister( _context, _destinationReadyHandler );
      _navigationRequestHandler = null;
      _destinationReadyHandler = null;

//      var mgr:BindingManager =
//         _context.scopeManager.getScope( ScopeName.GLOBAL ).extensions.forType( BindingManager ) as BindingManager;
//      mgr.removeSubscriber( _urcSubscriber );
//      _urcSubscriber = null;
   }

   //--------------------------------------
   //  configureDescriptors
   //--------------------------------------
   /**
    *  @private
    *  if descritpors list is specified by id,
    *  this method attemps to inject it using FastInject DSL API
    */
   private function configureDescriptors():void
   {
      FastInject.view( this ).property( "destinationDescriptors" ).objectId( _descriptorListId ).execute();
   }

   //--------------------------------------
   //  userDetailsChangedHandler
   //--------------------------------------
   /**
    *  @private
    *  triggered after user details change,
    *  indicates a need to reevaluate permissioning
    */
   private function userDetailsChangedHandler( event:UserDetailsChangedEvent ):void
   {
      _permissionsDirty = true;
      invalidateProperties();
   }

   /**
    *  A ListCollectionView filterFunction which filters out destinations
    *  for which the user does not have the required role
    */
   private function permissionFilterFunction( destination:Destination ):Boolean
   {
      return !destination.role || ( _rolesController && _rolesController.hasRole( destination.role ) );
   }
}
}
