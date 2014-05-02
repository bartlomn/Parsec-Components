/**
 * User: Bart
 * Date: 31/03/2014
 * Time: 18:05
 * Description:
 */

package com.webintelligence.parsec.components.navigation.screen
{
import com.webintelligence.parsec.components.navigation.screen.model.AbstractDataProviderModel;

import flash.events.Event;

import mx.binding.utils.ChangeWatcher;
import mx.events.FlexEvent;

import spark.components.List;

public class AbstractListScreen extends AbstractAsyncUIScreen
{

   /**
    *  @private
    */
   private var _model:AbstractDataProviderModel;

   [Bindable][SkinPart(required="true")]
   /**
    *  result list ui
    */
   public var resultList:List;

   /**
    *  Constructor
    */
   public function AbstractListScreen( logTarget:Class )
   {
      super( logTarget );
   }

   /**
    *  @inheritDoc
    */
   override protected function modelChangedHandler() : void
   {
      super.modelChangedHandler();
      _model = AbstractDataProviderModel( model );
      if( resultList && _model )
      {
         // one-way binding of data provider
         bindToModelProperty( resultList, "dataProvider", ["dataProvider"]);
         // two-way binding of selected item
         bindToModelProperty( resultList, "selectedItem", ["selectedItem"]);
         resultList.addEventListener( FlexEvent.VALUE_COMMIT, resultListSelectedItemChangedHandler );
         if( _model.itemRendererFactory )
            resultList.itemRendererFunction = _model.itemRendererFactory.listItemRendererFunction;
      }
   }

   /**
    *  @private
    */
   protected function resultListSelectedItemChangedHandler( event:FlexEvent ):void
   {
      if( _model && _model.selectedItem != resultList.selectedItem.data )
         _model.selectedItem = resultList.selectedItem.data;
   }

}
}
