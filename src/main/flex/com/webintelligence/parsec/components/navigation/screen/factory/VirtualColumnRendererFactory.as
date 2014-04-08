/**
 * Fortrus Mobius v2.0
 * User: Bart
 * Date: 03/04/2014
 * Time: 12:42
 * Description:
 */

package com.webintelligence.parsec.components.navigation.screen.factory
{
import com.webintelligence.parsec.components.controls.VirtualColumnItemRenderer;
import com.webintelligence.parsec.components.controls.domain.VirtualColumn;

[DefaultProperty("columns")]
public class VirtualColumnRendererFactory extends AbstractItemRendererFactory
{

   /**
    *  @private
    */
   private var _columns:Vector.<VirtualColumn>;

   /**
    *  @private
    */
   public function get columns() : Vector.<VirtualColumn>
   {
      return _columns;
   }
   /**
    *  @private
    */
   public function set columns( value : Vector.<VirtualColumn> ) : void
   {
      _columns = value;
      setRendererProperty( "columns", _columns );
   }


   /**
    *  Constructor
    */
   public function VirtualColumnRendererFactory()
   {
      super();
      setGenerator( VirtualColumnItemRenderer );
   }

}
}
