/**
 * Fortrus Mobius v2.0
 * User: Bart
 * Date: 01/04/2014
 * Time: 15:10
 * Description:
 */

package com.webintelligence.parsec.components.navigation.screen.control
{
import com.webintelligence.parsec.core.invalidating.InvalidatingObject;
import com.webintelligence.parsec.core.navigation.INavigationRequest;
import com.webintelligence.parsec.core.navigation.NavigationRequest;
import com.webintelligence.parsec.core.navigation.destination.Destination;
import com.webintelligence.parsec.core.navigation.message.DestinationReadyMessage;

import mx.resources.IResourceManager;

import mx.resources.ResourceManager;

public class AbstractUINavigatorScreenController extends InvalidatingObject
{

   /**
    *  @private
    */
   protected static var RESOURCE:IResourceManager = ResourceManager.getInstance();

   /**
    *  @private
    */
   protected var supportedDestination:Destination;

   [MessageDispatcher]
   /**
    *  @private
    */
   public var dispatchMessage : Function;

   /**
    *  Constructor
    */
   public function AbstractUINavigatorScreenController()
   {
      super();
   }

   [Init]
   /**
    *  @private
    */
   public function initHandler():void
   {
      if( !isInitialized )
         initialize();
   }

   [MessageHandler]
   /**
    *  @private
    */
   public function navigationRequestHandler( msg:INavigationRequest ):void
   {
      if( msg.destination == supportedDestination )
      {
         _log.debug( "Destination {0} ready.", msg.destination.stringAddress );
         startScreenBootstrap();
      }
   }

   [MessageHandler]
   /**
    *  @private
    */
   public function destinationReadyHandler( msg:DestinationReadyMessage ):void
   {
      if( msg.destination == supportedDestination )
      {
         _log.debug( "Destination {0} is ready.", msg.destination.stringAddress );
         setDefaultFocusHandler();
      }
   }

   /**
    *  @private
    */
   protected function startScreenBootstrap():void
   {
      _log.debug( "Bootstrapping screen" );
   }

   /**
    *  @private
    */
   protected function setDefaultFocusHandler():void
   {
      _log.debug( "Setting default view focus");
   }

}
}
