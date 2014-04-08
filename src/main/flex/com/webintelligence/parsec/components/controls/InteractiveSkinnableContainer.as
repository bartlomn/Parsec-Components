/**
 * User: Bart
 * Date: 09/03/2014
 * Time: 15:37
 * Description:
 */

package com.webintelligence.parsec.components.controls
{
import flash.events.Event;

import spark.components.supportClasses.InteractionStateDetector;

[SkinState("up")]
[SkinState("over")]
[SkinState("down")]

public class InteractiveSkinnableContainer extends InvalidatingChildrenContainer
{


   /**
    *  @private
    */
   protected var interactionStateDetector:InteractionStateDetector;

   /**
    *  Constructor
    */
   public function InteractiveSkinnableContainer()
   {
      super();
      useHandCursor = true;
      buttonMode = true;
      interactionStateDetector = new InteractionStateDetector( this );
      interactionStateDetector.addEventListener( Event.CHANGE, interactionStateChangeHandler);
   }
   /**
    *  @inheritDoc
    *  @see: spark.components.supportClasses.InteractionState
    */
   override protected function getCurrentSkinState():String
   {
      return interactionStateDetector.state;
   }

   /**
    *  @private
    */
   protected function interactionStateChangeHandler( event:Event ):void
   {
      invalidateSkinState();
      invalidateDisplayList();
   }
}
}
