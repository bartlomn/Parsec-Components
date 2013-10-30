package com.webintelligence.parsec.components.popup
{
import com.adobe.cairngorm.popup.PopUpWrapper;
import com.bnowak.parsec.util.integration.parsley.ContextLookupHelper;

import flash.display.DisplayObject;
import flash.events.Event;

import mx.core.FlexGlobals;
import mx.core.IFlexDisplayObject;

import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.state.GlobalState;


/***************************************************************************
 * 
 *   @author nowabart 
 *   @created 20 Oct 2011
 *   Replacement class for the Parsley's CairngormPopUpSupport
 *   allowing the usage in a non-visual parent document 
 * 
 ***************************************************************************/

public class NonVisualCairngormPopUpSupport 
   extends PopUpWrapper
{
   
   //--------------------------------------------------------------------------
   //
   //  Variables
   //
   //--------------------------------------------------------------------------
   
   /**
    *  @private
    */
   private var hasInitialized:Boolean;
   
   /**
    *  @private
    */
   private var openRequested:Boolean;
   
   //--------------------------------------------------------------------------
   //
   //  Properties
   //
   //--------------------------------------------------------------------------
   
   //--------------------------------------
   //  context
   //--------------------------------------
   
   /**
    *  @private
    *  Storage for context
    */
   private var _context:Context;
   
   [Inject]
   
   /**
    *  The Parsley context
    */
   public function get context():Context
   {
      // if context has not been set any other way, try to look it up, 
      // assuming this object is managed
      if (!_context)
         return GlobalState.objects.getContext(this);
      
      return _context;
   }
   
   /**
    *  @private
    */
   public function set context(value:Context):void
   {
      _context = value;
      
      if (_context && openRequested) 
      {
         openRequested = false;
         super.open = true;
      }
   }
   
   //--------------------------------------
   //  open
   //--------------------------------------
   
   /**
    * @private
    */
   public override function set open(value:Boolean):void
   {
      if (!hasInitialized)
         initialized(this, null);
      if (!context) {
         // if the Context has not been found yet we must defer the opening of the popup
         openRequested = value;	
      }
      else {
         super.open = value;
      }
   }
   
   //--------------------------------------------------------------------------
   //
   //  Methods
   //
   //--------------------------------------------------------------------------
   
   /**
    * @inheritDoc
    */
   public override function initialized(document:Object, id:String):void 
   {
      var view:DisplayObject;
      if (document is DisplayObject)
         view = DisplayObject(document);
      else
         view = FlexGlobals.topLevelApplication as DisplayObject;
      
      if (view.stage != null) 
      {
         findContext(view);
      }
      else 
      {
         view.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
      }
      hasInitialized = true;
   }
   
   /**
    * @inheritDoc
    */
   protected override function getPopUp():IFlexDisplayObject 
   {
      var popup:IFlexDisplayObject = super.getPopUp();
      context.viewManager.addViewRoot(DisplayObject(popup));
      return popup;
   }
   
   /**
    * @inheritDoc
    */    
   protected override function popUpClosed():void 
   {
      var popup:IFlexDisplayObject = super.getPopUp();
      context.viewManager.removeViewRoot(DisplayObject(popup));
      super.popUpClosed();
   }
   
   /**
    * @private
    */    
   private function addedToStage(event:Event):void 
   {
      var view:DisplayObject = DisplayObject(event.target);
      view.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
      findContext(view);
   }
   
   /**
    * @private
    */    
   private function findContext(view:DisplayObject):void 
   {
      ContextLookupHelper.lookup( view, contextFound );
   }
   
   /**
    * @private
    */    
   private function contextFound(context:Context):void 
   {
      if (!context) {
         throw new Error("No Context found in view hierarchy. PopUp will never open");
      }
      
      this.context = context;
   }
}
}