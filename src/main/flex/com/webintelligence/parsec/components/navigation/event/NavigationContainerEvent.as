package com.webintelligence.parsec.components.navigation.event
{
import flash.events.Event;


/***************************************************************************
 * 
 *   @author nowabart 
 *   @created 2 Dec 2011
 *   Describes event API of naviagation containers
 * 
 ***************************************************************************/

public class NavigationContainerEvent 
    extends Event
{
    
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
    
    /**
     *  enumerates event type
     */
    public static const DESCRIPTORS_CHANGED:String = "descriptorsChanged";
    
    /**
     *  enumerates event type
     */
    public static const DESTINATIONS_CHANGED:String = "destinationsChanged";
    
    /**
     *  enumerates event type
     */
    public static const CURRENT_DESTINATION_CHANGED:String = "currentDestinationChanged";
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Constructor
     */
    public function NavigationContainerEvent(type:String)
    {
        super(type);
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    //--------------------------------------
    //  public method
    //--------------------------------------
    /**
     *  @public
     */
    override public function clone():Event
    {
        return new NavigationContainerEvent(type);
    }
}
}