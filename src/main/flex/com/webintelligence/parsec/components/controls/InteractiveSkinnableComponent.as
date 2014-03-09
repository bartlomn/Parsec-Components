/**
 * User: Bart
 * Date: 09/03/2014
 * Time: 15:37
 * Description:
 */

package com.webintelligence.parsec.components.controls
{
import flash.events.MouseEvent;

import spark.components.supportClasses.SkinnableComponent;

[SkinState("up")]
[SkinState("over")]
[SkinState("down")]

// todo: add state enum

public class InteractiveSkinnableComponent extends SkinnableComponent
{

   /**
    *  @private
    */
   protected var _currentSkinstate:String = "up";

   /**
    *  Constructor
    */
   public function InteractiveSkinnableComponent()
   {
      super();
      useHandCursor = true;
      buttonMode = true;
      addEventListener( MouseEvent.ROLL_OVER, rollOverHandler );
      addEventListener( MouseEvent.ROLL_OUT, rollOutHandler );
      addEventListener( MouseEvent.MOUSE_DOWN, mouseDownHandler );
      addEventListener( MouseEvent.MOUSE_UP, mouseUpHandler );
   }
   /**
    *  @inheritDoc
    */
   override protected function getCurrentSkinState():String
   {
      return _currentSkinstate;
   }

   /**
    *  @private
    */
   private function rollOverHandler( event:MouseEvent ):void
   {
      _currentSkinstate = "over";
      invalidateSkinState();
   }

   /**
    *  @private
    */
   private function rollOutHandler( event:MouseEvent ):void
   {
      _currentSkinstate = "up";
      invalidateSkinState();
   }

   /**
    *  @private
    */
   private function mouseDownHandler( event:MouseEvent ):void
   {
      _currentSkinstate = "down";
      invalidateSkinState();
   }

   /**
    *  @private
    */
   private function mouseUpHandler( event:MouseEvent ):void
   {
      _currentSkinstate = "over";
      invalidateSkinState();
   }

}
}
