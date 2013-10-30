package com.webintelligence.parsec.components.controls
{
import spark.components.ToggleButton;


/***************************************************************************
 * 
 *   @author nowabart 
 *   @created 20 Jul 2011
 *   Adds mouse interactivity to vanilla toggle button
 * 
 ***************************************************************************/

public class InteractiveToggleButton 
    extends ToggleButton
{

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Constructor
     */
    public function InteractiveToggleButton()
    {
        super();
        useHandCursor = true;
        buttonMode = true;
    }

}
}