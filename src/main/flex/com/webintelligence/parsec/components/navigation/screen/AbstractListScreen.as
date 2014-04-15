/**
 * User: Bart
 * Date: 31/03/2014
 * Time: 18:05
 * Description:
 */

package com.webintelligence.parsec.components.navigation.screen
{
import com.webintelligence.parsec.components.navigation.screen.model.AbstractDataProviderModel;

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
         bindToModelProperty( resultList, "dataProvider", ["dataProvider"]);
         if( _model.itemRendererFactory )
            resultList.itemRendererFunction = _model.itemRendererFactory.listItemRendererFunction;
      }
   }

}
}
