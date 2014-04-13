/**
 * User: Bart
 * Date: 31/03/2014
 * Time: 18:05
 * Description:
 */

package com.webintelligence.parsec.components.navigation.screen
{
import com.webintelligence.parsec.components.navigation.screen.model.AbstractDataProviderModel;

import spark.components.DataGrid;

public class AbstractDataGridScreen extends AbstractAsyncUIScreen
{

   /**
    *  @private
    */
   private var _model:AbstractDataProviderModel;

   [Bindable][SkinPart(required="true")]
   /**
    *  result list ui
    */
   public var resultGrid:DataGrid;

   /**
    *  Constructor
    */
   public function AbstractDataGridScreen( logTarget:Class )
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
      if( resultGrid && _model )
      {
         bindToModelProperty( resultGrid, "dataProvider", ["dataProvider"]);
//         if( _model.itemRendererFactory )
//            resultGrid.itemR
      }
   }

}
}
