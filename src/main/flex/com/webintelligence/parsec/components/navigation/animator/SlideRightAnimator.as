/**
 * Fortrus Mobius v2.0
 * User: Bart
 * Date: 01/03/2014
 * Time: 01:08
 * Description:
 */

package com.webintelligence.parsec.components.navigation.animator
{
import spark.effects.WipeDirection;

public class SlideRightAnimator extends SlideAnimatorBase
{

   /**
    *  Constructor
    */
   public function SlideRightAnimator()
   {
      super();
      _direction = WipeDirection.RIGHT;
   }
}
}
