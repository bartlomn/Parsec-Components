/**
 * User: Bart
 * Date: 31/03/2014
 * Time: 18:05
 * Description:
 */

package com.webintelligence.parsec.components.navigation.screen
{
import com.webintelligence.parsec.components.navigation.screen.model.AbstractDataGridScreenModel;

import spark.components.DataGrid;

public class AbstractDataGridScreen extends AbstractAsyncUIScreen
{

   /**
    *  @private
    */
   private var _model:AbstractDataGridScreenModel;

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
      _model = AbstractDataGridScreenModel( model );
      if( resultGrid && _model )
      {
         if( _model.columnFactory )
            bindToModelProperty( resultGrid, "columns", [ "columnFactory", "columns" ]);
         bindToModelProperty( resultGrid, "dataProvider", [ "dataProvider" ]);
      }
   }

}
}
