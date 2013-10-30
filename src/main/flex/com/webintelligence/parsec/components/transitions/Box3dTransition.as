package com.webintelligence.parsec.components.transitions
{
import com.greensock.TweenMax;
import com.greensock.easing.Quad;

import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.EventDispatcher;

import mx.core.Container;
import mx.core.FlexGlobals;
import mx.core.IVisualElement;
import mx.core.IVisualElementContainer;

import spark.primitives.BitmapImage;

/***************************************************************************
 * 
 *   @created Jan 18, 2013
 *
 * 3D "Box like" transition between to images, sprites, or movieclips.
 * Throws Event.COMPLETE when transition is finished.
 * Requires caurina.transitions package.
 * @author Devon O.
 * @see http://blog.onebyonedesign.com/life/3d-box-transition-effect-in-flash-player-10/
 * 
 ***************************************************************************/

//--------------------------------------
//  Events
//--------------------------------------

/**
 * Dispatched after transition finishes
 */
[Event(name="complete", type="flash.events.Event")]

public class Box3dTransition 
   extends EventDispatcher
{
   
   public static const UP:String = "up";
   public static const DOWN:String = "down";
   public static const LEFT:String = "left";
   public static const RIGHT:String = "right";
   
   private var _direction:String;
   private var _currentimage:BitmapImage;
   private var _newimage:BitmapImage;
   private var _time:Number;
   
   private var _imgparent:IVisualElementContainer;
   private var _box:Container;
   private var _orgY:Number;
   private var _orgX:Number;
   
   /**
    * 
    * @param	image that will be transitioned out (must already be on display list).
    * @param	image that will be transitioned in
    * @param	direction in which the out image should travel.
    * 			Choices are Box3dTransition.LEFT, Box3dTransition.RIGHT, Box3dTransition.UP, or Box3dTransition.DOWN
    * @param	time in seconds transition should take place.
    */
   public function Box3dTransition(
      currentimage:DisplayObject, 
      newimage:DisplayObject, 
      direction:String = "left", 
      time:Number = 1) 
   {
      _imgparent = IVisualElementContainer(FlexGlobals.topLevelApplication);
      _orgX = currentimage.x;
      _orgY = currentimage.y;
      var currentImageData:BitmapData = new BitmapData(currentimage.width, currentimage.height, true, 0x00FFFFFF);
      currentImageData.draw(currentimage);
      _currentimage = new BitmapImage();
      _currentimage.source = currentImageData;
      var newImageData:BitmapData = new BitmapData(newimage.width, newimage.height, true, 0x00FFFFFF);
      newImageData.draw(newimage);
      _newimage = new BitmapImage();
      _newimage.source = newImageData;
      _time = time;
      _direction = direction;
   }
   
   public function start():void 
   {
      init();
      beginTransition();
   }
   
   public function get direction():String 
   { 
      return _direction; 
   }
   
   public function set direction(value:String):void 
   {
      _direction = value;
   }
   
   public function get currentimage():IVisualElement 
   { 
      return _currentimage; 
   }
   
   public function get newimage():IVisualElement 
   { 
      return _newimage; 
   }
   
   public function get time():Number 
   { 
      return _time; 
   }
   
   public function set time(value:Number):void 
   { 
      _time = value;
   }
   
   private function init():void 
   {
      var w:int = _currentimage.width * .5;
      var h:int = _currentimage.height * .5;
      _box = new Container();
      _box.x = _currentimage.x;
      _box.y = _currentimage.y;
      IVisualElementContainer(_imgparent).addElementAt(_box, _imgparent.numElements);
      _box.x += _currentimage.width * .5;
      _box.y += _currentimage.height * .5;
      _currentimage.y = -_currentimage.height * .5;
      _currentimage.x = -_currentimage.width * .5;
      
      switch(_direction) 
      {
         case "up" :
            _box["z"] = h;
            _currentimage["z"] -= h;
            _newimage.x = _currentimage.x;
            _newimage.y = _currentimage.y + (h * 2);
            _newimage["rotationX"] = 90;
            _newimage["z"] -= h;
            _box.addElement(_newimage);
            break;
         case "down" :
            _box["z"] = h;
            _currentimage["z"] -= h;	
            _newimage.x = _currentimage.x;
            _newimage.y = _currentimage.y;
            _newimage["rotationX"] = -90;
            _newimage["z"] += h;
            _box.addElement(_newimage);
            break;
         case "left" :
            _box["z"] = w;
            _currentimage["z"] -= w;
            _newimage.x = _currentimage.x + (w * 2);
            _newimage.y = _currentimage.y;
            _newimage["rotationY"] = -90;
            _newimage["z"] -= w;
            _box.addElement(_newimage);
            break;
         case "right" :
            _box["z"] = w;
            _currentimage["z"] -= w;
            _newimage.x = _currentimage.x;
            _newimage.y = _currentimage.y;
            _newimage["rotationY"] = 90;
            _newimage["z"] += w;
            _box.addElement(_newimage);
            break;
      }
      
      _box.addElement(_currentimage);
   }
   
   private function beginTransition():void 
   {
      switch(_direction) 
      {
         case "up" :
            flipUp();
            break;
         case "down" :
            flipDown();
            break;
         case "left" :
            flipLeft();
            break;
         case "right" :
            flipRight();
            break;
      }
   }
   
   private function flipLeft():void 
   {
      TweenMax.to(_box, _time, {
         rotationY:90, 
         ease:Quad.easeOut, 
         onUpdate:checkAngle, 
         onComplete:transitionDone});
   }
   
   private function flipRight():void 
   {
      TweenMax.to(_box, _time, {
         rotationY:-90, 
         ease:Quad.easeOut, 
         onUpdate:checkAngle, 
         onComplete:transitionDone});
   }
   
   private function flipUp():void 
   {
      TweenMax.to(_box, _time, {
         rotationX:-90, 
         ease:Quad.easeOut, 
         onUpdate:checkAngle, 
         onComplete:transitionDone});
   }
   
   private function flipDown():void 
   {
      TweenMax.to(_box, _time, {
         rotationX:90, 
         ease:Quad.easeOut, 
         onUpdate:checkAngle, 
         onComplete:transitionDone});
   }
   
   private function checkAngle():void 
   {
      if (Math.abs(_box["rotationY"]) > 75 || Math.abs(_box["rotationX"]) > 75) 
      {
         _currentimage.visible = false;
      }
   }
   
   private function transitionDone():void 
   {
      IVisualElementContainer(_imgparent).removeElement(_box);
      _box = null;
      _newimage.x = _orgX;
      _newimage.y = _orgY;
      _newimage["z"] = 0;
      _newimage["rotationY"] = 0;
      _newimage["rotationX"] = 0;
      IVisualElementContainer(_imgparent).addElementAt(IVisualElement(_newimage), _imgparent.numElements);
      dispatchEvent(new Event(Event.COMPLETE));
   }
}
}