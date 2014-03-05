package com.webintelligence.parsec.components.navigation.animator
{
import flash.geom.Rectangle;

import mx.events.EffectEvent;

import spark.effects.Animate;
import spark.effects.WipeDirection;
import spark.effects.animation.MotionPath;
import spark.effects.animation.RepeatBehavior;
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

public class SlideAnimatorBase
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
   private static const DURATION:int = 300;
   
   //--------------------------------------------------------------------------
   //
   //  Properties
   //
   //--------------------------------------------------------------------------

   /**
    *  @private
    */
   protected var _direction:String;

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
         from[ property ] = 0;
         to[ property ] = 0;
         callback.call();
      }

      var property:String = getAnimatedProperty();

      from[ property ] = 0;
      var slideOut:Animate = new Animate( from );
      slideOut.motionPaths = new <MotionPath>[ new SimpleMotionPath( property, null, null, getOffset( from ) )];
      slideOut.repeatBehavior = RepeatBehavior.REVERSE;
      slideOut.play();

      to[ property ] = getOffset( to ) * -1;
      var slideIn:Animate = new Animate( to );
      slideIn.addEventListener( EffectEvent.EFFECT_END, effectEndHandler );
      slideIn.motionPaths = new <MotionPath>[ new SimpleMotionPath( property, null, null, getOffset( to ) )];
      slideIn.repeatBehavior = RepeatBehavior.REVERSE;
      slideIn.play();
   }

   /**
    *  @private
    */
   protected function getAnimatedProperty():String
   {
      switch ( _direction )
      {
         case WipeDirection.LEFT:
         case WipeDirection.RIGHT:
            return "x";
            break;
         case WipeDirection.DOWN:
         case WipeDirection.UP:
            return "y";
            break;
      }
      throw new Error( "Abstract class, please use concrete implementations");
      return null;
   }

   /**
    *  @private
    */
   protected function getOffset( image:BitmapImage ):Number
   {
      switch ( _direction )
      {
         case WipeDirection.LEFT:
            return -image.width;
            break;
         case WipeDirection.RIGHT:
            return image.width;
            break;
         case WipeDirection.DOWN:
            return image.height;
            break;
         case WipeDirection.UP:
            return -image.height;
            break;
      }
      throw new Error( "Abstract class, please use concrete implementations");
      return null;
   }

   
}
}