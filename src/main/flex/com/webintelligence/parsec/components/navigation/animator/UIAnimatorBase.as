package com.webintelligence.parsec.components.navigation.animator
{
import flash.geom.Rectangle;

import mx.core.IVisualElementContainer;

import spark.primitives.BitmapImage;


/***************************************************************************
 * 
 *   @author bnowak 
 *   @created Dec 3, 2012
 * 
 *   Performs a simple fade animation
 * 
 ***************************************************************************/

public class UIAnimatorBase 
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
   public function animate(from:BitmapImage, 
                           to:BitmapImage, 
                           sourceRect:Rectangle, 
                           targetRect:Rectangle, 
                           callback:Function):void
   {
      // bring "from" to the front... 
      var p:IVisualElementContainer = from.parent as IVisualElementContainer;
      if(p.getElementIndex(from) < p.getElementIndex(to))
         p.swapElements(from, to);
   }
   
   
}
}