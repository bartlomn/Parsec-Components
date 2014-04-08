/**
 * User: Bart
 * Date: 09/03/2014
 * Time: 15:50
 * Description:
 */

package com.webintelligence.parsec.components.controls
{
import com.webintelligence.parsec.components.controls.events.ParsecRendererEvent;

import mx.core.IDataRenderer;

[Event(name="rendererDataChanged",
      type="com.webintelligence.parsec.components.controls.events.ParsecRendererEvent")]

public class InteractiveSkinableDataRenderer
   extends InteractiveSkinnableContainer
   implements IDataRenderer
{

   /**
    *  @private
    */
   private var _data:Object;

   /**
    *  @private
    */
   protected var _dataChanged:Boolean;

   [Bindable(event="rendererDataChanged")]
   /**
    *  @private
    */
   public function get data():Object
   {
      return _data;
   }
   /**
    *  @private
    */
   public function set data( value:Object ):void
   {
      if( _data != value)
      {
         _data = value;
         _dataChanged = true;
         invalidateProperties();
      }
   }

   /**
    *  @inheritDoc
    */
   override protected function commitProperties():void
   {
      if( _dataChanged )
      {
         dataChangedHandler();
         dispatchEvent( ParsecRendererEvent.forDataChange() );
         _dataChanged = false;
      }
      super.commitProperties();
   }

   /**
    *  Constructor
    */
   public function InteractiveSkinableDataRenderer()
   {
      super();
   }

   /**
    *  @private
    */
   protected function dataChangedHandler():void
   {
      // abstract method
   }
}
}
