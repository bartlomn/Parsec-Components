package com.webintelligence.parsec.components.navigation.animator
{
import flash.geom.Rectangle;

import spark.primitives.BitmapImage;


/***************************************************************************
 * 
 *   @author nowabart 
 *   @created 30 Nov 2011
 *   Performs a cuttof (no animation) transition
 * 
 ***************************************************************************/

public class CutoffAnimator 
   implements IUIAnimator
{
   
   //--------------------------------------------------------------------------
   //
   //  Methods
   //
   //--------------------------------------------------------------------------
   
   //--------------------------------------
   //  animate
   //--------------------------------------
   /**
    *  @inheritDoc
    */
   public function animate(from:BitmapImage, 
                           to:BitmapImage, 
                           sourceRect:Rectangle,
                           targetRect:Rectangle,
                           callback:Function):void
   {
      callback.call();
   }
   
}
}