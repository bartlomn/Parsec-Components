/**
 * User: Bart
 * Date: 13/04/2014
 * Time: 15:16
 * Description:
 */

package com.webintelligence.parsec.components.controls.grid.domain
{
import mx.formatters.IFormatter;

public class GridColumnDefinition
{

   /**
    *  @private
    */
   public var dataField:String;

   /**
    *  @private
    */
   public var formatter:IFormatter;

   /**
    *  @private
    */
   public var headerText:String;

   /**
    *  @private
    *  @see: GridColumn.itemRendererFunction
    */
   public var itemRendererFunction:Function;

   /**
    *  @private
    */
   public var headerRenderer:Class;

   /**
    *  @private
    */
   public var explicitWidth:Number;

   /**
    *  Constructor
    */
   public function GridColumnDefinition()
   {
      super();
   }
}
}
