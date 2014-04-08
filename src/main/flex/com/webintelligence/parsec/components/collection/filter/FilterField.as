/**
 * User: Bart
 * Date: 03/04/2014
 * Time: 21:38
 * Description:
 */

package com.webintelligence.parsec.components.collection.filter
{

[DefaultProperty("name")]

public class FilterField
{

   /**
    *  @private
    */
   public var name:String;

   /**
    *  Constructor
    */
   public function FilterField()
   {
      super();
   }

   /**
    *  @private
    */
   public function getValue( item:Object ):Object
   {
      if( item && item.hasOwnProperty( name ))
         return item[ name ];
      return null;
   }
}
}
