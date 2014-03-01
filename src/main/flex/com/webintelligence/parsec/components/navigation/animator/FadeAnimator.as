package com.webintelligence.parsec.components.navigation.animator
{
import flash.geom.Rectangle;

import mx.events.EffectEvent;

import spark.effects.Animate;
import spark.effects.animation.MotionPath;
import spark.effects.animation.SimpleMotionPath;
import spark.primitives.BitmapImage;

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


      var effectEndHandler:Function = function( event:EffectEvent ):void
      {
         event.target.removeEventListener( EffectEvent.EFFECT_END, effectEndHandler );
         callback.call();
      }

      from.alpha = 1;
      var fadeOut:Animate = new Animate( from );
      fadeOut.duration = DURATION;
      fadeOut.motionPaths = new <MotionPath>[ new SimpleMotionPath( "alpha", 1, 0 )];
      fadeOut.play();
      
      to.alpha = 0;
      var fadeIn:Animate = new Animate( to );
      fadeIn.duration = DURATION;
      fadeIn.addEventListener( EffectEvent.EFFECT_END, effectEndHandler );
      fadeIn.motionPaths = new <MotionPath>[ new SimpleMotionPath( "alpha", 0, 1 )];
      fadeIn.play();
   }
   
   
}
}