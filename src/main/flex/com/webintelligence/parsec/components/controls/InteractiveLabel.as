package com.webintelligence.parsec.components.controls
{
import spark.components.Label;


/***************************************************************************
 * 
 *   @author bnowak 
 *   @created Nov 19, 2012
 * 
 *   Adds mouse interactivity to vanilla label
 * 
 ***************************************************************************/

public class InteractiveLabel 
   extends Label
{
   
   //--------------------------------------------------------------------------
   //
   //  Constructor
   //
   //--------------------------------------------------------------------------
   
   /**
    *  Constructor
    */
   public function InteractiveLabel()
   {
      super();
      useHandCursor = true;
      buttonMode = true;
   }
   
}
}