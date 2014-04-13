package com.webintelligence.parsec.components.navigation.event
{
import flash.events.Event;


/***************************************************************************
 *
 *   @author nowabart
 *   @created 24 Jan 2012
 *   Describes event API of UINavigator screens
 *
 ***************************************************************************/

public class UIScreenModelEvent extends Event
{

   //--------------------------------------------------------------------------
   //
   //  Class constants
   //
   //--------------------------------------------------------------------------

   /**
    *  enumerates event type
    */
   public static const FOCUS_REQUEST:String = "focusRequestReceived";

   /**
    *  enumerates event type
    */
   public static const DATA_PROVIDER_CHANGED:String = "dataProviderChanged";

   /**
    *  enumerates event type
    */
   public static const SELECTED_ITEM_CHANGED:String = "selectedItemChanged";

   /**
    *  enumerates event type
    */
   public static const LOOKUP_ITEM_CHANGED:String = "lookupItemChanged";

   /**
    *  enumerates event type
    */
   public static const LOOKUP_STATE_CHANGED:String = "lookupStateChanged";

   /**
    *  enumerates event type
    */
   public static const LOOKUP_COLLECTION_CHANGED:String = "lookupCollectionChanged";

   //--------------------------------------------------------------------------
   //
   //  Constructor
   //
   //--------------------------------------------------------------------------

   /**
    *  Constructor
    */
   public function UIScreenModelEvent( type:String )
   {
      super( type, true, false );
   }

}
}
