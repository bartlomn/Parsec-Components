/**
 * Fortrus Mobius v2.0
 * User: Bart
 * Date: 01/04/2014
 * Time: 13:31
 * Description:
 */

package com.webintelligence.parsec.components.navigation.screen.model
{
import com.webintelligence.parsec.components.navigation.event.UIScreenModelEvent;
import com.webintelligence.parsec.core.log.LogAwareEventDispatcher;

[Event(name="focusRequestReceived",
      type="com.webintelligence.parsec.components.navigation.event.UIScreenModelEvent")]

public class AbstractFocusClientModel extends LogAwareEventDispatcher
{

   /**
    *  Constructor
    */
   public function AbstractFocusClientModel()
   {
      super();
   }

   /**
    *  @private
    */
   public function setFocus():void
   {
      _log.debug( "Focus request received, passing to view.")
      dispatchEvent( new UIScreenModelEvent( UIScreenModelEvent.FOCUS_REQUEST ));
   }
}
}
