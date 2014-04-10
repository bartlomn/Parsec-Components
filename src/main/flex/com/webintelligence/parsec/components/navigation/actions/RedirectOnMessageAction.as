/**
 * User: Bart
 * Date: 09/04/2014
 * Time: 13:14
 * Description:
 */

package com.webintelligence.parsec.components.navigation.actions
{
import com.webintelligence.parsec.core.navigation.action.AbstractRedirectAction;
import com.webintelligence.parsec.core.navigation.trigger.AbstractMessageTrigger;
import com.webintelligence.parsec.core.navigation.trigger.MessageReceivedTrigger;

import org.spicefactory.parsley.core.context.Context;

public class RedirectOnMessageAction extends AbstractRedirectAction
{

   /**
    *  @private
    */
   private var _trigger:AbstractMessageTrigger;

   /**
    *  @private
    */
   private var _message:Class;

   /**
    *  @private
    */
   public function get message() : Class
   {
      return _message;
   }
   /**
    *  @private
    */
   public function set message( value : Class ) : void
   {
      _message = value;
   }

   /**
    *  Constructor
    */
   public function RedirectOnMessageAction()
   {
      super();
   }

   /**
    *  @inheritDoc
    */
   override public function register( context:Context ) : void
   {
      super.register( context );
      _trigger = new MessageReceivedTrigger( context, message, this );
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
