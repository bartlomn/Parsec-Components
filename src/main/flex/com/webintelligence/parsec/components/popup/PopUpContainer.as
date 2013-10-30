package com.webintelligence.parsec.components.popup
{
import flash.events.MouseEvent;

import mx.core.IVisualElement;
import mx.events.CloseEvent;

import spark.components.BorderContainer;
import spark.components.Button;
import spark.components.Group;
import spark.components.supportClasses.TextBase;
import spark.layouts.supportClasses.LayoutBase;


/***************************************************************************
 * 
 *   @author nowabart 
 *   @created 10 Oct 2011
 *   Wrapper for displaying visual components in an alert style
 * 
 ***************************************************************************/

//--------------------------------------------------------------------------
//
//  Events
//
//--------------------------------------------------------------------------

/**
 *  dispatched after user clicks close button
 */
[Event(name="close", type="mx.events.CloseEvent")]

public class PopUpContainer 
   extends BorderContainer
{
   
   //--------------------------------------------------------------------------
   //
   //  Constructor
   //
   //--------------------------------------------------------------------------
   
   /**
    *  Constructor
    */
   public function PopUpContainer()
   {
      super();
   }
   
   //--------------------------------------------------------------------------
   //
   //  Variables
   //
   //--------------------------------------------------------------------------
   
   /**
    *  @private
    */
   private var _mainMXMLContent:Array;
   
   /**
    *  @private
    */
   private var _controlbarMXMLContent:Array;
   
   /**
    *  @private
    */
   private var _contentGroupLayout:LayoutBase;
   
   /**
    *  @private
    */
   private var _controlbarGroupLayout:LayoutBase;
   
   //--------------------------------------------------------------------------
   //
   //  Properties
   //
   //--------------------------------------------------------------------------
   
   //--------------------------------------
   //  closeButton
   //--------------------------------------
   [SkinPart(required="false")]
   /**
    *  close button
    */
   public var closeButton:Button;
   
   //--------------------------------------
   //  titleDisplay
   //--------------------------------------
   [SkinPart(required="false")]
   /**
    *  title display
    */
   public var titleDisplay:TextBase;
   
   //--------------------------------------
   //  controlsGroup
   //--------------------------------------
   [SkinPart(required="false")]
   /**
    *  controlbar group
    */
   public var controlsGroup:Group;
   
   //--------------------------------------
   //  title
   //--------------------------------------
   [Bindable]
   /**
    *  title
    */
   public var title:String;
   
   //--------------------------------------
   //  closeButtonLabel
   //--------------------------------------
   [Bindable]
   /**
    *  close Button Label
    */
   public var closeButtonLabel:String;
   
   //--------------------------------------
   //  contentLayout
   //--------------------------------------
   [Bindable]
   /**
    *  layout of the content group
    */
   public function get contentLayout():LayoutBase
   {
      return contentGroup ?
         contentGroup.layout :
         _contentGroupLayout;
   }
   public function set contentLayout(value:LayoutBase):void
   {
      contentGroup ?
         contentGroup.layout = value :
         _contentGroupLayout = value;
   }
   
   //--------------------------------------
   //  controlsLayout
   //--------------------------------------
   [Bindable]
   /**
    *  layout of the control buttons group
    */
   public function get controlsLayout():LayoutBase
   {
      return controlsGroup ?
         controlsGroup.layout :
         _controlbarGroupLayout;
   }
   public function set controlsLayout(value:LayoutBase):void
   {
      controlsGroup ?
         controlsGroup.layout = value :
         _controlbarGroupLayout = value;
   }
   
   //--------------------------------------
   //  popupContent
   //--------------------------------------
   
   [DefaultProperty]
   [ArrayElementType("mx.core.IVisualElement")]
   
   /**
    *  contents of the pop-up
    */
   public function set popupContent(value:Array):void
   {
      contentGroup ?
         contentGroup.mxmlContent = value :
         _mainMXMLContent = value;
   }
   
   //--------------------------------------
   //  popupContent
   //--------------------------------------
   
   [ArrayElementType("mx.core.IVisualElement")]
   
   /**
    *  contents of the controls-bar group
    */
   public function set controlbarContent(value:Array):void
   {
      controlsGroup ?
         controlsGroup.mxmlContent = value :
         _controlbarMXMLContent = value;
   }
   
   //--------------------------------------
   //  closeButtonVisible
   //--------------------------------------
   
   /**
    *  @private
    */
   private var _closeButtonVisible:Boolean = true;
   
   /**
    *  is close button visible
    */
   public function get closeButtonVisible():Boolean
   {
      return _closeButtonVisible
   }
   public function set closeButtonVisible(value:Boolean):void
   {
      _closeButtonVisible = value;
      closeButton ?
         closeButton.visible = closeButton.includeInLayout = _closeButtonVisible :
         null;
   }
   
   //--------------------------------------
   //  closeButtonEnabled
   //--------------------------------------
   
   /**
    *  @private
    */
   private var _closeButtonEnabled:Boolean = true;
   
   /**
    *  is close button enabled
    */
   public function get closeButtonEnabled():Boolean
   {
      return _closeButtonEnabled
   }
   public function set closeButtonEnabled(value:Boolean):void
   {
      _closeButtonEnabled = value;
      closeButton ?
         closeButton.enabled = _closeButtonEnabled :
         null;
   }
   
   //--------------------------------------------------------------------------
   //
   //  Methods
   //
   //--------------------------------------------------------------------------
   
   //--------------------------------------
   //  partAdded
   //--------------------------------------
   /**
    *  @inheritDoc
    */
   override protected function partAdded(partName:String, instance:Object):void
   {
      if(instance == closeButton)
      {
         closeButton.addEventListener(MouseEvent.CLICK, closeButtonClickHandler);
         closeButton.visible = closeButton.includeInLayout = closeButtonVisible;
         closeButton.enabled = closeButtonEnabled;
      }
      if(instance == contentGroup)
      {
         if(_mainMXMLContent)
         {
            contentGroup.mxmlContent = _mainMXMLContent;
            _mainMXMLContent = null;
         }
         if(_contentGroupLayout)
         {
            contentGroup.layout = _contentGroupLayout;
            _contentGroupLayout = null;
         }
      }
      if(instance == controlsGroup)
      {
         if(_controlbarMXMLContent)
         {
            controlsGroup.mxmlContent = _controlbarMXMLContent;
            _controlbarMXMLContent = null;
         }
         if(_controlbarGroupLayout)
         {
            controlsGroup.layout = _controlbarGroupLayout;
            _controlbarGroupLayout = null;
         }
      }
   }
   
   //--------------------------------------
   //  partRemoved
   //--------------------------------------
   /**
    *  @inheritDoc
    */
   override protected function partRemoved(partName:String, instance:Object):void
   {
      if(instance == closeButton)
         closeButton.removeEventListener(MouseEvent.CLICK, closeButtonClickHandler);
   }
   
   //--------------------------------------
   //  closeButtonClickHandler
   //--------------------------------------
   /**
    *  @private
    *  close button click handler
    */
   private function closeButtonClickHandler(event:MouseEvent):void
   {
      dispatchEvent(new CloseEvent(CloseEvent.CLOSE, true));
   }
   
}
}