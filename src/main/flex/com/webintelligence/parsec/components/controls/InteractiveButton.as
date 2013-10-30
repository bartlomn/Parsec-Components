package com.webintelligence.parsec.components.controls
{
import spark.components.Button;


/***************************************************************************
 * 
 *   @author bnowak 
 *   @created Nov 19, 2012
 * 
 *   Adds mouse interactivity to vanilla spark button
 * 
 ***************************************************************************/

public class InteractiveButton 
   extends Button
{
   
   //--------------------------------------------------------------------------
   //
   //  Constructor
   //
   //--------------------------------------------------------------------------
   
   /**
    *  Constructor
    */
   public function InteractiveButton()
   {
      super();
      useHandCursor = true;
      buttonMode = true;
   }
   
}
}