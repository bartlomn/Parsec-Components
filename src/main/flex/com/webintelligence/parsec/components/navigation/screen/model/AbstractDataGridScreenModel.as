/**
 * User: Bart
 * Date: 13/04/2014
 * Time: 15:02
 * Description:
 */

package com.webintelligence.parsec.components.navigation.screen.model
{
import com.webintelligence.parsec.components.controls.grid.factory.DataGridColumnFactory;

public class AbstractDataGridScreenModel extends AbstractDataProviderModel
{

   /**
    *  @private
    */
   public var columnFactory:DataGridColumnFactory;


   /**
    *  Constructor
    */
   public function AbstractDataGridScreenModel()
   {
      super();
   }

}
}
