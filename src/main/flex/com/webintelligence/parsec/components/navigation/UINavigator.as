package com.webintelligence.parsec.components.navigation
{
import com.adobe.utils.DictionaryUtil;
import com.webintelligence.parsec.components.navigation.animator.CutoffAnimator;
import com.webintelligence.parsec.components.navigation.animator.IUIAnimator;
import com.webintelligence.parsec.components.navigation.core.DestinationsAwareContainer;
import com.webintelligence.parsec.components.navigation.domain.DestinationDescriptor;
import com.webintelligence.parsec.components.navigation.factory.UINavigatorScreenFactory;
import com.webintelligence.parsec.components.navigation.screen.IUINavigatorScreen;
import com.webintelligence.parsec.core.message.ui.ClearProgressNotificationMsg;
import com.webintelligence.parsec.core.navigation.destination.Destination;
import com.webintelligence.parsec.core.navigation.message.DestinationReadyMessage;
import com.webintelligence.parsec.core.notification.ProgressNotificationRequest;
import com.webintelligence.parsec.core.notification.ProgressNotificationType;

import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.errors.IllegalOperationError;
import flash.utils.Dictionary;
import flash.utils.setTimeout;

import mx.core.FlexGlobals;
import mx.styles.CSSStyleDeclaration;

import spark.components.Group;
import spark.layouts.supportClasses.LayoutBase;
import spark.primitives.BitmapImage;


/***************************************************************************
 * 
 *   @author nowabart 
 *   @created 30 Nov 2011
 *   Component responsible for rendering UI screens according to 
 *   navigation requests
 * 
 ***************************************************************************/

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *  defines a default UINavigator class
 */
[Style(name="animatorClass", type="Class")]

public class UINavigator 
   extends DestinationsAwareContainer
{
   
   //--------------------------------------------------------------------------
   //
   //  Class constants
   //
   //--------------------------------------------------------------------------
   
   /**
    *  @private
    *  has styles intitialized
    */
   private static var STYLES_INITIALIZED:Boolean;
   
   /**
    *  @private
    *  specifies animationlayer depth
    */
   private static const ANIMATION_LAYER_DEPTH:int = 1;
   
   //--------------------------------------------------------------------------
   //
   //  Constructor
   //
   //--------------------------------------------------------------------------
   
   /**
    *  Constructor
    */
   public function UINavigator()
   {
      super();
      initializeStyles();
      _screens = new Vector.<IUINavigatorScreen>();
      _targetToScreenMap = new Dictionary();
   }
   
   //--------------------------------------------------------------------------
   //
   //  Variables
   //
   //--------------------------------------------------------------------------
   
   //--------------------------------------
   //  SCREENS RELATED
   //--------------------------------------
   /**
    *  @private
    *  currently displayed screen
    */
   private var _currentScreen:IUINavigatorScreen;
   
   /**
    *  @private
    *  maps targets to created screen instances
    */
   private var _targetToScreenMap:Dictionary;
   
   /**
    *  @private
    *  list of screens
    */
   private var _screens:Vector.<IUINavigatorScreen>;
   
   /**
    *  @private
    *  screen that is a target of the next transition
    */
   private var _pendingTargetScreen:IUINavigatorScreen;
   
   /**
    *  @private
    *  descriptor of screen to create during next validation
    */
   private var _pendingTargetDescriptor:DestinationDescriptor;
   
   /**
    *  @private
    *  flag to indicate that target is ready for trasition
    */
   private var _pendingTargetScreenReady:Boolean;
   
   /**
    *  @private
    *  flag to indicate we have a pending remove screen operation
    */
   private var _pendingClearScreen:Boolean;
   
   //--------------------------------------
   //  ANIMATOR RELATED
   //--------------------------------------
   /**
    *  @private
    *  flag to tell we have a transition in progress
    */
   private var _transitionInProgress:Boolean;
   
   /**
    *  @private
    *  container for the bitmaps used in transition
    */
   private var _animationLayer:Group;
   
   /**
    *  @private
    *  first animation canvas
    */
   private var _animationCanvas1:BitmapImage;
   
   /**
    *  @private
    *  second animation canvas
    */
   private var _animationCanvas2:BitmapImage;
   
   //--------------------------------------------------------------------------
   //
   //  Properties
   //
   //--------------------------------------------------------------------------
   
   //--------------------------------------
   //  layout
   //--------------------------------------
   /**
    *  @inheritDoc
    */
   override public function set layout(value:LayoutBase):void
   {
      throw new IllegalOperationError("UINavigator does not support layouts");
   }
   
   //--------------------------------------
   //  layout
   //--------------------------------------
   /**
    *  @inheritDoc
    */
   override public function set currentDestination(value:Destination):void
   {
      if ((_pendingTargetScreen || _pendingClearScreen) || 
         (currentDestination && value &&
            (currentDestination == value || currentDestination == currentDestination.getSharedParent(value))))
         return;
      if(value)
      {
         //  legit destination, load and navigate
         var descriptor:DestinationDescriptor = descritptorForDestination(value);
         if (!descriptor)
            return;
         if(_pendingTargetDescriptor)
            _pendingTargetDescriptor = null;
         
         super.currentDestination = destinations.contains(value) ?
            value : 
            descriptor.destination;
         navigateTo(descriptor);
      }
      else
      {
         //  hide current screen
         super.currentDestination = value;
         _pendingClearScreen = true;
         invalidateProperties();
      }
   }
   
   //--------------------------------------
   //  animator
   //--------------------------------------
   /**
    *  @private
    */
   private var _animator:IUIAnimator;
   
   /**
    *  plug-in object responsible for the transition betwen screens
    */
   protected function get animator():IUIAnimator
   {
      if(!_animator)
      {
         var animatorClass:Class = getStyle("animatorClass");
         _animator = new animatorClass() as IUIAnimator;
      }
      return _animator;
   }
   
   /**
    *  plug-in object responsible for the transition betwen screens
    */
   protected function set animator(value:IUIAnimator):void
   {
      if(_animator != value)
         _animator = value;
   }
   
   //--------------------------------------------------------------------------
   //
   //  Methods
   //
   //--------------------------------------------------------------------------
   
   //--------------------------------------
   //  initializeStyles
   //--------------------------------------
   /**
    *  @private
    */
   private static function initializeStyles():void
   {
      if(!STYLES_INITIALIZED)
      {
         var styles:CSSStyleDeclaration = 
            FlexGlobals.topLevelApplication.styleManager.getStyleDeclaration("UINavigator");
         if(!styles)
            styles = new CSSStyleDeclaration();
         styles.defaultFactory = function():void
         {
            this.animatorClass = CutoffAnimator;
         }
         FlexGlobals.topLevelApplication.styleManager.setStyleDeclaration("UINavigator", styles, true);
         STYLES_INITIALIZED = true;
      }
   }

   //--------------------------------------
   //  styleChanged
   //--------------------------------------
   /**
    *  @inheritDoc
    */
   override public function styleChanged(styleProp:String):void
   {
      super.styleChanged(styleProp);
      if(styleProp == "animatorClass")
      {
         var animatorClass:Class = getStyle(styleProp);
         if(animatorClass)
            animator = new animatorClass() as IUIAnimator;
      }
   }
   //--------------------------------------
   //  createChildren
   //--------------------------------------
   /**
    *  @inheritDoc
    */
   override protected function createChildren():void
   {
      if(!_animationLayer)
      {
         _animationCanvas1 = new BitmapImage();
         _animationCanvas2 = new BitmapImage();
         _animationLayer = new Group();
         _animationLayer.depth = ANIMATION_LAYER_DEPTH;
         _animationLayer.percentWidth = _animationLayer.percentHeight = 100;
         _animationLayer.visible = _animationLayer.includeInLayout = false;
         _animationLayer.addElement(_animationCanvas1);
         _animationLayer.addElement(_animationCanvas2);
         addElement(_animationLayer);
      }
   }
   
   //--------------------------------------
   //  commitProperties
   //--------------------------------------
   /**
    *  @inheritDoc
    */
   override protected function commitProperties():void
   {
      super.commitProperties();
      if(_pendingTargetDescriptor)
      {
         _pendingTargetScreen = createScreenInstance(_pendingTargetDescriptor);
         _pendingTargetDescriptor = null;
         return;
      }
      if(_pendingTargetScreen && _pendingTargetScreenReady)
      {
         setCurrentScreen(_pendingTargetScreen);
         _pendingTargetScreen = null;
         return;
      }
      if(_pendingClearScreen)
      {
         setCurrentScreen(null);
         _pendingClearScreen = false;
         return;
      }
   }
   
   //--------------------------------------
   //  navigateTo
   //--------------------------------------
   /**
    *  @private
    *  initiates screen change sequence
    */
   private function navigateTo(target:DestinationDescriptor):void
   {
      var screen:IUINavigatorScreen = getScreenInstance(target);
      if(screen)
      {
         _pendingTargetScreen = screen;
         invalidateProperties();
      }
      else
      {
         // This is to allow time and CPU resources to create notification pop-up before we
         // start using resources to create new screen instance as well as to prevent ugly blinks of notifications
         if(target.useLoadingNotification)
            setTimeout(invalidateProperties, 750);
         else
            callLater(invalidateProperties);
      }
   }
   
   //--------------------------------------
   //  getScreenInstance
   //--------------------------------------
   /**
    *  @private
    *  returns screen instance for a particular target
    */
   private function getScreenInstance(target:DestinationDescriptor):IUINavigatorScreen
   {
      if(_targetToScreenMap[target])
      {
         _pendingTargetScreenReady = true;
         return _targetToScreenMap[target];
      }
      _pendingTargetScreenReady = false;
      _pendingTargetDescriptor = target;
      if(target.useLoadingNotification)
         dispatchMessage(ProgressNotificationRequest.createFor(ProgressNotificationType.LOADING_VIEW));
      return null;
   }
   
   //--------------------------------------
   //  getDescriptorForScreen
   //--------------------------------------
   /**
    *  @private
    *  returns destination descriptor for a given screen instance
    */
   private function getDescriptorForScreen(target:IUINavigatorScreen):DestinationDescriptor
   {
      var descriptors:Array = DictionaryUtil.getKeys(_targetToScreenMap);
      for each(var descriptor:DestinationDescriptor in descriptors)
      {
         if(_targetToScreenMap[descriptor] == target)
            return descriptor;
      }
      return null;
   }
   
   //--------------------------------------
   //  setCurrentScreen
   //--------------------------------------
   /**
    *  @private
    *  makes the indicated screen visible
    */
   private function setCurrentScreen(target:IUINavigatorScreen):void
   {
      var animationCallback:Function = function():void
      {
         _currentScreen = target;
         _animationLayer.visible = _animationLayer.includeInLayout = false;
         bringToFront(_currentScreen);
         _transitionInProgress = false;
         dispatchMessage(new DestinationReadyMessage(currentDestination ?
            currentDestination :
            _lastPrimaryDestination));
      }
      _animationCanvas1.source = _currentScreen ? 
         _currentScreen.getScreenshot() : 
         new BitmapData(width, height, true, 0x00FFFFFF);
      _animationCanvas2.source = target ? 
         target.getScreenshot() :
         new BitmapData(width, height, true, 0x00FFFFFF);
      _animationLayer.visible = _animationLayer.includeInLayout = true;
      _transitionInProgress = true;
      animator.animate(
         _animationCanvas1, 
         _animationCanvas2, 
         (_currentScreen ? 
            DisplayObject(_currentScreen).getRect(_animationLayer) :
            null),
         (target ? 
            DisplayObject(target).getRect(_animationLayer) :
            null),
         animationCallback);
   }
   
   //--------------------------------------
   //  createScreenInstance
   //--------------------------------------
   /**
    *  @private
    *  creates a new screen instace
    */
   private function createScreenInstance(target:DestinationDescriptor):IUINavigatorScreen
   {
      var screenInstance:IUINavigatorScreen = 
         UINavigatorScreenFactory.newInstance(target, screenCreationCompletedHandler);
      _targetToScreenMap[target] = addElement(screenInstance);
      _screens.push(screenInstance);
      return screenInstance;
   }
   
   //--------------------------------------
   //  bringToFront
   //--------------------------------------
   /**
    *  @private
    *  brings target screen instance to front
    *  hides other screen instances
    */
   private function bringToFront(target:IUINavigatorScreen):IUINavigatorScreen
   {
      var result:IUINavigatorScreen;
      for each(var element:IUINavigatorScreen in _screens)
      {
         if(element != target)
         {
            element.visible = element.includeInLayout = false;
            continue;
         }
         result = element;
      }
      if(result)
         result.visible = result.includeInLayout = true;
      return result;
   }
   
   //--------------------------------------
   //  screenCreationCompletedHandler
   //--------------------------------------
   /**
    *  @private
    *  called after newly created screen instance is ready to use
    */
   private function screenCreationCompletedHandler(screenInstance:IUINavigatorScreen):void
   {
      if(screenInstance == _pendingTargetScreen)
      {
         var dd:DestinationDescriptor = getDescriptorForScreen(screenInstance);
         if(dd && dd.useLoadingNotification)
            dispatchMessage(new ClearProgressNotificationMsg());
         _pendingTargetScreenReady = true;
         invalidateProperties();
      }
   }
}
}