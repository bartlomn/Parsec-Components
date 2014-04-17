/**
 * Fortrus Mobius v2.0
 * User: Bart
 * Date: 17/04/2014
 * Time: 19:37
 * Description:
 */

package com.webintelligence.parsec.components.controls
{
import com.worlize.gif.GIFPlayer;

import flash.events.Event;

import flash.utils.ByteArray;

import spark.core.SpriteVisualElement;

[DefaultProperty("source")]

public class GifPlayer extends SpriteVisualElement
{

   /**
    *  @private
    */
   private var _player:GIFPlayer;


   /**
    *  @private
    */
   public function get smoothing() : Boolean
   {
      return _player.smoothing;
   }
   /**
    *  @private
    */
   public function set smoothing( value : Boolean ) : void
   {
      _player.smoothing = value;
   }


   /**
    *  @private
    */
   public function get autoPlay() : Boolean
   {
      return _player.autoPlay;
   }
   /**
    *  @private
    */
   public function set autoPlay( value : Boolean ) : void
   {
      _player.autoPlay = value;
   }


   /**
    *  @private
    */
   public function get totalFrames() : uint
   {
      return _player.totalFrames;
   }


   /**
    *  @private
    */
   public function get source() : ByteArray
   {
      return _player.loaderInfo ?
               _player.loaderInfo.bytes :
               null;
   }
   /**
    *  @private
    */
   public function set source( value : ByteArray ) : void
   {
      _player.loadBytes( value );
   }


   /**
    *  Constructor
    */
   public function GifPlayer()
   {
      super();

      _player = new GIFPlayer();
      _player.smoothing = false;
      _player.autoPlay = true;
      _player.addEventListener( Event.COMPLETE, handleGifLoaded );

      addChild( _player );
   }


   /**
    *  @private
    */
   public function play():void
   {
      _player.play();
   }

   /**
    *  @private
    */
   public function gotoAndPlay( requestedIndex:uint ):void
   {
      if( _player.totalFrames > requestedIndex )
         _player.gotoAndPlay( requestedIndex );
   }

   /**
    *  @private
    */
   public function stop():void
   {
      _player.stop();
   }

   /**
    *  @private
    */
   private function handleGifLoaded( event:Event ):void
   {
      width = _player.width;
      height = _player.height;
   }

}
}
