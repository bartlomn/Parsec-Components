/**
 * Fortrus Mobius v2.0
 * User: Bart
 * Date: 03/04/2014
 * Time: 11:47
 * Description:
 */

package com.webintelligence.parsec.components.controls
{
import com.webintelligence.parsec.components.controls.events.ParsecRendererEvent;

import spark.components.IItemRenderer;

[SkinState("upAndSelected")]
[SkinState("oveAndSelectedr")]
[SkinState("downAndSelected")]

[Event(name="rendererSelectionChanged",
      type="com.webintelligence.parsec.components.controls.events.ParsecRendererEvent")]

[Event(name="itemIndexChanged",
      type="com.webintelligence.parsec.components.controls.events.ParsecRendererEvent")]

public class InteractiveSkinnableItemRenderer
   extends InteractiveSkinableDataRenderer
   implements IItemRenderer
{

   /**
    *  @private
    */
   private var _selected:Boolean;

   /**
    *  @private
    */
   private var _selectedChanged:Boolean;

   [Bindable(event="rendererSelectionChanged")]
   /**
    *  @private
    */
   public function get selected() : Boolean
   {
      return _selected;
   }
   /**
    *  @private
    */
   public function set selected( value : Boolean ) : void
   {
      if( _selected != value )
      {
         _selected = value;
         _selectedChanged = true;
         invalidateProperties();
         invalidateSkinState();
      }
   }


   /**
    *  @private
    */
   private var _itemIndex:int;

   /**
    *  @private
    */
   private var _itemIndexChanged:Boolean;

   [Bindable(event="itemIndexChanged")]
   /**
    *  @private
    */
   public function get itemIndex() : int
   {
      return _itemIndex;
   }

   public function set itemIndex( value : int ) : void
   {
      if( _itemIndex != value )
      {
         _itemIndex = value;
         _itemIndexChanged = true;
         invalidateProperties();
      }
   }


   public function get showsCaret() : Boolean
   {
      return false;
   }

   public function set showsCaret( value : Boolean ) : void
   {
      // IItemRenderer impl
   }

   public function get dragging() : Boolean
   {
      return false;
   }

   public function set dragging( value : Boolean ) : void
   {
      // IItemRenderer impl
   }

   public function get label() : String
   {
      return "";
   }

   public function set label( value : String ) : void
   {
      // IItemRenderer impl
   }


   /**
    *  Constructor
    */
   public function InteractiveSkinnableItemRenderer()
   {
      super();
   }


   /**
    *  @inheritDoc
    */
   override protected function getCurrentSkinState() : String
   {
      return selected ? super.getCurrentSkinState() + "AndSelected" : super.getCurrentSkinState();
   }

   /**
    *  @inheritDoc
    */
   override protected function commitProperties() : void
   {
      super.commitProperties();
      if( _selectedChanged )
      {
         selectionChangedHandler();
         dispatchEvent( ParsecRendererEvent.forSelectionChange());
         _selectedChanged = false;
      }
      if( _itemIndexChanged )
      {
         itemIndexChangedHandler();
         dispatchEvent( ParsecRendererEvent.forItemIndexChange());
         _itemIndexChanged = false;
      }
   }

   /**
    *  @private
    */
   protected function itemIndexChangedHandler():void
   {
      // abstract
   }

   /**
    *  @private
    */
   protected function selectionChangedHandler():void
   {
      // abstract
   }
}
}
