/**
 * User: Bart
 * Date: 03/04/2014
 * Time: 21:50
 * Description:
 */

package com.webintelligence.parsec.components.collection.filter
{
public class StringContainsFilter extends AbstractCollectionFilter
{

   /**
    *  @private
    */
   public var caseSensitive:Boolean;

   /**
    *  @private
    */
   override public function set lookupItem( value : Object ) : void
   {
      _log.debug( "New lookup item: {0}", value ? value.toString() : null );
      if( !value is String )
         return;
      super.lookupItem = value;
      if( lookupItem )
         _searchString = caseSensitive ? lookupItem.toString() : lookupItem.toString().toLowerCase();
      else
         _searchString = null;
   }

   /**
    *  @private
    */
   private var _searchString:String;

   /**
    *  Constructor
    */
   public function StringContainsFilter( filterFields : Vector.<FilterField> = null )
   {
      super( filterFields );
   }

   /**
    *  @inheritDoc
    */
   override public function filterFunction( item : Object ) : Boolean
   {
      if( !_searchString )
         return true;
      for each( var field:FilterField in fields )
      {
         var fieldValue:Object = field.getValue( item );
         if( fieldValue )
         {
            var typedFieldValue:String = caseSensitive ? fieldValue.toString() : fieldValue.toString().toLowerCase();
            if( typedFieldValue.indexOf(  _searchString ) != -1 )
               return true;
         }
      }
      return false;
   }
}
}
