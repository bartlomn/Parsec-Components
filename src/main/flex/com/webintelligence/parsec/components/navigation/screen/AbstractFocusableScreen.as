/**
 * User: Bart
 * Date: 02/04/2014
 * Time: 15:35
 * Description:
 */

package com.webintelligence.parsec.components.navigation.screen
{
import com.webintelligence.parsec.components.navigation.event.UIScreenModelEvent;
import com.webintelligence.parsec.components.navigation.screen.model.AbstractFocusClientModel;

public class AbstractFocusableScreen extends AbstractModelDrivenScreen
{

   /**
    *  Constructor
    */
   public function AbstractFocusableScreen( logTarget : Class )
   {
      super( logTarget );
   }

   /**
    *  @inheritDoc
    */
   override protected function modelChangedHandler() : void
   {
      if( model is AbstractFocusClientModel )
         listenToModelEvent( UIScreenModelEvent.FOCUS_REQUEST, focusRequestHandler );
      super.modelChangedHandler();
   }

   /**
    *  @private
    */
   protected function focusRequestHandler( event:UIScreenModelEvent ):void
   {
      // abstract
   }
}
}
