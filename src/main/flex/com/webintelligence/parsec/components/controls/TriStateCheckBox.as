/**
 * Fortrus Mobius v2.0
 * User: Bart
 * Date: 10/05/2014
 * Time: 13:18
 * Description:
 */

package com.webintelligence.parsec.components.controls
{
import flash.events.Event;

import mx.events.FlexEvent;

import spark.components.CheckBox;

[SkinState("upAndUndefined")]
[SkinState("overAndUndefined")]
[SkinState("downAndUndefined")]
[SkinState("disabledAndUndefined")]

public class TriStateCheckBox extends CheckBox
{

   /**
    *  @private
    *  Enumerates checkbox state
    */
   public static const VALUE_SELECTED:int = 1;

   /**
    *  @private
    *  Enumerates checkbox state
    */
   public static const VALUE_UNDEFINED:int = 0;

   /**
    *  @private
    *  Enumerates checkbox state
    */
   public static const VALUE_DESELECTED:int = -1;


   /**
    *  @private
    */
   private var _value:int = VALUE_UNDEFINED;


   [Bindable]
   /**
    *  @private
    */
   public function get value() : int
   {
      return _value;
   }
   /**
    *  @private
    */
   public function set value( value : int ) : void
   {
      if( _value != value )
      {
         _value = value;
         if( value == VALUE_DESELECTED || value == VALUE_UNDEFINED )
            selected = false;
         else
            selected = true;
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
         invalidateSkinState();
      }
   }


   /**
    *  @inheritDoc
    */
   override public function set selected( value : Boolean ) : void
   {
      super.selected = value;
      if( this.value != VALUE_UNDEFINED || value )
         this.value = selected ? VALUE_SELECTED : VALUE_DESELECTED;
   }


   /**
    *  Constructor
    */
   public function TriStateCheckBox()
   {
      super();
      useHandCursor = buttonMode = true;
   }


   /**
    *  @private
    */
   override protected function getCurrentSkinState():String
   {
      if( value == VALUE_UNDEFINED )
         return super.getCurrentSkinState() + "AndUndefined";
      else
         return super.getCurrentSkinState();
   }

   /**
    *  @inheritDoc
    */
   override protected function buttonReleased():void
   {
      if( value == VALUE_UNDEFINED || value == VALUE_DESELECTED )
         value = VALUE_SELECTED;
      else
         value = VALUE_DESELECTED;

      dispatchEvent(new Event(Event.CHANGE));
   }

}
}

