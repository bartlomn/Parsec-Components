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

public class UINavigatorScreenEvent extends Event
{

   //--------------------------------------------------------------------------
   //
   //  Class constants
   //
   //--------------------------------------------------------------------------

   /**
    *  enumerates event type
    */
   public static const SCREEN_COMPLETE:String = "screenComplete";

   /**
    *  enumerates event type
    */
   public static const MODEL_CHANGED:String = "uiModelChanged"

   /**
    *  enumerates event type
    */
   public static const LOOKUP_VALUE_CHANGED:String = "lookupValueChanged"

   //--------------------------------------------------------------------------
   //
   //  Constructor
   //
   //--------------------------------------------------------------------------

   /**
    *  Constructor
    */
   public function UINavigatorScreenEvent( type:String )
   {
      super( type, true, false );
   }

}
}
