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
public class InteractiveSkinnableComponent extends SkinnableComponent
{

   /**
    *  @private
    */
   protected static const _STATE_UP:String = "up";

   /**
    *  @private
    */
   protected static const _STATE_OVER:String = "over";

   /**
    *  @private
    */
   protected var _currentSkinstate:String = _STATE_UP;

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
   protected function rollOverHandler( event:MouseEvent ):void
   {
      _currentSkinstate = _STATE_OVER;
      invalidateSkinState();
   }

   /**
    *  @private
    */
   protected function rollOutHandler( event:MouseEvent ):void
   {
      _currentSkinstate = _STATE_UP;
      invalidateSkinState();
   }
}
}
