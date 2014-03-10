/**
 * User: Bart
 * Date: 01/03/2014
 * Time: 01:36
 * Description: Performs the directional slide transition between managed screens
 */

package com.webintelligence.parsec.components.navigation
{
import com.webintelligence.parsec.components.navigation.animator.IUIAnimator;
import com.webintelligence.parsec.components.navigation.animator.SlideDownAnimator;
import com.webintelligence.parsec.components.navigation.animator.SlideLeftAnimator;
import com.webintelligence.parsec.components.navigation.animator.SlideRightAnimator;
import com.webintelligence.parsec.components.navigation.animator.SlideUpAnimator;
import com.webintelligence.parsec.core.navigation.destination.Destination;

import mx.controls.sliderClasses.SliderDirection;

public class UISlider extends UINavigator
{

   /**
    *  @private
    */
   public var slideDirection:String = SliderDirection.HORIZONTAL;

   /**
    *  @private
    */
   override public function set currentDestination( value:Destination ):void
   {
      if( value && destinations && destinations.contains( value ))
      {
         var sliderClass:Class;
         var currentIdx:int = destinations.getItemIndex( currentDestination );
         var nextIdx:int = destinations.getItemIndex( value );
         if( nextIdx < currentIdx )
            sliderClass = slideDirection == SliderDirection.HORIZONTAL ? SlideRightAnimator : SlideUpAnimator;
         else
            sliderClass = slideDirection == SliderDirection.HORIZONTAL ? SlideLeftAnimator : SlideDownAnimator;

         animator = new sliderClass() as IUIAnimator;
      }
      super.currentDestination = value;
   }
}
}
