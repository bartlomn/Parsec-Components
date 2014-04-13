/**
 * User: Bart
 * Date: 13/04/2014
 * Time: 16:01
 * Description:
 */

package com.webintelligence.parsec.components.controls.grid.event
{
import flash.events.Event;

public class GridColumnFactoryEvent extends Event
{

   /**
    *  @private
    */
   public static const COLUMNS_CHANGED:String = "gridColumnsChanged";

   /**
    *  @private
    */
   public function GridColumnFactoryEvent( type : String  )
   {
      super( type, bubbles, cancelable );
   }
}
}
