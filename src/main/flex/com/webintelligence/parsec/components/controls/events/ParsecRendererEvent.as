/**
 * User: Bart
 * Date: 03/04/2014
 * Time: 11:42
 * Description:
 */

package com.webintelligence.parsec.components.controls.events
{
import flash.events.Event;

public class ParsecRendererEvent extends Event
{

   /**
    *  @private
    */
   public static const DATA_CHANGED:String = "rendererDataChanged";

   /**
    *  @private
    */
   public static const SELECTION_CHANGED:String = "rendererSelectionChanged";

   /**
    *  @private
    */
   public static const ITEM_INDEX_CHANGED:String = "itemIndexChanged";

   /**
    *  @private
    */
   public function ParsecRendererEvent( type : String )
   {
      super( type, false, false );
   }

   /**
    *  @private
    */
   public static function forDataChange():ParsecRendererEvent
   {
      return new ParsecRendererEvent( ParsecRendererEvent.DATA_CHANGED );
   }

   /**
    *  @private
    */
   public static function forSelectionChange():ParsecRendererEvent
   {
      return new ParsecRendererEvent( ParsecRendererEvent.SELECTION_CHANGED );
   }

   /**
    *  @private
    */
   public static function forItemIndexChange():ParsecRendererEvent
   {
      return new ParsecRendererEvent( ParsecRendererEvent.ITEM_INDEX_CHANGED );
   }
}
}
