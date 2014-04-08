/**
 * User: Bart
 * Date: 01/04/2014
 * Time: 15:22
 * Description:
 */

package com.webintelligence.parsec.components.navigation.screen.control
{
import com.webintelligence.parsec.components.navigation.screen.model.AbstractFocusClientModel;

public class AbstractModelDrivenScreenController extends AbstractUINavigatorScreenController
{

   /**
    *  @private
    */
   private var _model:Object;

   /**
    *  @private
    */
   private var _modelChanged:Boolean;

   /**
    *  @private
    */
   public function get model() : Object
   {
      return _model;
   }
   /**
    *  @private
    */
   public function set model( value : Object ) : void
   {
      if( value != _model )
      {
         _model = value;
         _modelChanged = true;
         invalidateProperties();
      }
   }

   /**
    *  Constructor
    */
   public function AbstractModelDrivenScreenController( modelInstance:Object = null )
   {
      super();
      if( modelInstance )
         model = modelInstance;
   }

   /**
    *  @inheritDoc
    */
   override protected function setDefaultFocusHandler() : void
   {
      super.setDefaultFocusHandler();
      if( model is AbstractFocusClientModel )
         ( model as AbstractFocusClientModel ).setFocus();
   }

   /**
    *  @inheritDoc
    */
   override protected function commitProperties() : void
   {
      super.commitProperties();
      if( _modelChanged )
      {
         modelChangedHandler();
         _modelChanged = false;
      }
   }

   /**
    *  @private
    */
   protected function modelChangedHandler():void
   {
      _log.debug( "Updated model reference: {0}", model ? model.toString() : null );
   }

   /**
    *  @private
    */
   protected function makeDataRequest( ...params ):void
   {
      // abstract
   }

}
}
