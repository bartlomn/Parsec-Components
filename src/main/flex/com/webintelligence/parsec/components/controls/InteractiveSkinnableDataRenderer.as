/**
 * User: Bart
 * Date: 09/03/2014
 * Time: 15:50
 * Description:
 */

package com.webintelligence.parsec.components.controls
{
import flash.events.Event;

import mx.core.IDataRenderer;

[Event(name="dataChanged", type="flash.events.Event")]
public class InteractiveSkinnableDataRenderer
   extends InteractiveSkinnableComponent
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

   [Bindable(event="dataChanged")]
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
      super.commitProperties();
      if( _dataChanged )
      {
         dispatchEvent( new Event( "dataChanged" ));
         _dataChanged = false;
      }
   }

   /**
    *  Constructor
    */
   public function InteractiveSkinnableDataRenderer()
   {
      super();
   }
}
}
