/**
 * Fortrus Mobius v2.0
 * User: Bart
 * Date: 09/03/2014
 * Time: 17:38
 * Description:
 */

package com.webintelligence.parsec.components.controls
{
import com.webintelligence.parsec.components.navigation.NavigationBar;

import flash.events.Event;

import org.spicefactory.parsley.view.FastInject;

[Event(name="modelChanged", type="flash.events.Event")]
public class ModelDrivenNavigationBar extends NavigationBar
{

   /**
    *  @private
    */
   protected var _modelClass:Class;

   /**
    *  @private
    */
   private var _model:Object;

   /**
    *  @private
    */
   protected var _modelChanged:Boolean;

   [Bindable(event="modelChanged")]
   /**
    *  @private
    */
   public function get model():Object
   {
      return _model
   }
   /**
    *  @private
    */
   public function set model( value:Object ):void
   {
      if( value != model )
      {
         _model = value;
         _modelChanged = true;
         invalidateProperties();
      }
   }

   /**
    *  Constructor
    */
   public function ModelDrivenNavigationBar()
   {
      super();
   }

   /**
    *  @private
    */
   override protected function commitProperties():void
   {
      super.commitProperties();
      if( _context && _modelClass && !model )
      {
         FastInject.view( this )
               .property( "model" )
               .type( _modelClass )
               .execute();
      }
      if( _modelChanged )
      {
         applyModel();
         dispatchEvent( new Event( "modelChanged" ));
         _modelChanged = false;
      }
   }

   /**
    *  @private
    */
   protected function applyModel():void
   {
      //abstract methodd
   }
}
}
