/**
 * Fortrus Mobius v2.0
 * User: Bart
 * Date: 03/04/2014
 * Time: 12:09
 * Description:
 */

package com.webintelligence.parsec.components.controls.domain
{
import com.adobe.errors.IllegalStateError;

public class VirtualColumn
{

   /**
    *  @private
    */
   public var bindToProperty:String;

   /**
    *  @private
    */
   public var includeInLabel:Boolean;

   /**
    *  @private
    */
   public var styleName:String;

   /**
    *  Constructor
    */
   public function VirtualColumn()
   {
      super();
   }

   /**
    *  @private
    */
   public function getLabelText( item:Object ):String
   {
      if( bindToProperty && item && item.hasOwnProperty( bindToProperty ))
         return item[ bindToProperty ];
      else
         return item ? item.toString() : "";
   }
}
}
