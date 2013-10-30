package com.webintelligence.parsec.components.navigation.animator
{
import flash.geom.Rectangle;

import spark.primitives.BitmapImage;

import com.greensock.TweenMax;
import com.greensock.easing.Quad;



/***************************************************************************
 * 
 *   @author bnowak 
 *   @created Dec 3, 2012
 * 
 *   Performs a simple fade animation
 * 
 ***************************************************************************/

public class FadeAnimator 
   extends UIAnimatorBase
   implements IUIAnimator
{
   
   //--------------------------------------------------------------------------
   //
   //  Class constants
   //
   //--------------------------------------------------------------------------
   
   /**
    *  @private
    */
   private static const DURATION:int = 500;
   
   //--------------------------------------------------------------------------
   //
   //  Methods
   //
   //--------------------------------------------------------------------------
   
   /**
    *  @inheritDoc
    */
   override public function animate(
      from:BitmapImage, 
      to:BitmapImage, 
      sourceRect:Rectangle, 
      targetRect:Rectangle, 
      callback:Function):void
   {
      super.animate(from, to, sourceRect, targetRect, callback);
      
      from.alpha = 1;
      TweenMax.to(from, DURATION / 1000, {alpha:0, ease:Quad.easeOut});
      to.alpha = 0;
      TweenMax.to(to, DURATION / 1000, {alpha:1, ease:Quad.easeOut, onComplete:callback});
   }
   
   
}
}