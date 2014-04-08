/**
 * User: Bart
 * Date: 03/04/2014
 * Time: 21:37
 * Description:
 */

package com.webintelligence.parsec.components.collection.filter
{
import com.webintelligence.parsec.core.log.LogAware;

[DefaultProperty("fields")]

public class AbstractCollectionFilter extends LogAware
{

   /**
    *  @private
    */
   private var _lookupItem:Object;

   /**
    *  @private
    */
   public function get lookupItem() : Object
   {
      return _lookupItem;
   }
   /**
    *  @private
    */
   public function set lookupItem( value : Object ) : void
   {
      _lookupItem = value;
   }

   /**
    *  @private
    */
   private var _fields:Vector.<FilterField>;

   /**
    *  @private
    */
   public function get fields() : Vector.<FilterField>
   {
      return _fields;
   }
   /**
    *  @private
    */
   public function set fields( value : Vector.<FilterField> ) : void
   {
      _fields = value;
   }

   /**
    *  Constructor
    */
   public function AbstractCollectionFilter( filterFields:Vector.<FilterField> = null )
   {
      super();
      if( filterFields )
         fields = filterFields;
   }


   /**
    *  @private
    */
   public function filterFunction( item:Object ):Boolean
   {
      // abstract
      return true;
   }

}
}
