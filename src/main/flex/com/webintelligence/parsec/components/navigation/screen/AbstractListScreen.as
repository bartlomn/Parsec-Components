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
   override protected function partAdded( partName : String, instance : Object ) : void
   {
      super.partAdded( partName, instance );
      if( instance == resultList && model is AbstractDataProviderModel)
      {
         bindToModelProperty( resultList, "dataProvider", ["dataProvider"]);
      }
   }

}
}
