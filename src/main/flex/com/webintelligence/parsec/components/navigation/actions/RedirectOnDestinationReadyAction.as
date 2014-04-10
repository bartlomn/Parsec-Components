/**
 * User: Bart
 * Date: 09/04/2014
 * Time: 12:31
 * Description:
 */

package com.webintelligence.parsec.components.navigation.actions
{
import com.webintelligence.parsec.core.navigation.action.AbstractRedirectAction;
import com.webintelligence.parsec.core.navigation.destination.Destination;
import com.webintelligence.parsec.core.navigation.trigger.AbstractMessageTrigger;
import com.webintelligence.parsec.core.navigation.trigger.DestinationReadyTrigger;

import org.spicefactory.parsley.core.context.Context;

public class RedirectOnDestinationReadyAction extends AbstractRedirectAction
{

   /**
    *  @private
    */
   private var _trigger:AbstractMessageTrigger;

   /**
    *  @private
    */
   private var _destination:Destination;

   /**
    *  @private
    */
   public function get destination() : Destination
   {
      return _destination;
   }
   /**
    *  @private
    */
   public function set destination( value : Destination ) : void
   {
      _destination = value;
   }

   /**
    *  Constructor
    */
   public function RedirectOnDestinationReadyAction()
   {
      super();
   }

   /**
    *  @inheritDoc
    */
   override public function register( context:Context ) : void
   {
      super.register( context );
      _trigger = new DestinationReadyTrigger( context, destination, this );
   }

   [Destroy]
   /**
    *  @private
    */
   public function destroyHandler():void
   {
      if( _trigger )
      {
         _trigger.destroy();
         _trigger = null;
      }
   }
}
}
