package com.webintelligence.parsec.components.navigation
{
import com.webintelligence.parsec.components.navigation.core.DestinationsAwareContainer;
import com.webintelligence.parsec.components.navigation.event.NavigationContainerEvent;
import com.webintelligence.parsec.core.navigation.NavigationRequest;
import com.webintelligence.parsec.core.navigation.destination.Destination;
import com.webintelligence.parsec.core.navigation.enum.DestinationScope;


/***************************************************************************
 * 
 *   @author nowabart 
 *   @created 2 Dec 2011
 *   Component responsible for displaying navigation liks and initiating
 *   navigation sequences
 * 
 ***************************************************************************/

//--------------------------------------
//  Events
//--------------------------------------

/**
 *  dispatched after destination list changes
 */
[Event(
    name="destinationsChanged", 
    type="com.webintelligence.parsec.components.navigation.event.NavigationContainerEvent")]

//--------------------------------------
//  Other
//--------------------------------------

public class NavigationBar 
    extends DestinationsAwareContainer
{
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Constructor
     */
    public function NavigationBar()
    {
        super();
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //--------------------------------------
    //  scope
    //--------------------------------------
    /**
     *  destination scope in which we are working
     */
    public var scope:DestinationScope;
    
    //--------------------------------------
    //  currentDestination
    //--------------------------------------
    
    [Bindable("currentDestinationChanged")]

    /**
     *  @inheritDoc
     */
    override public function get currentDestination():Destination
    {
        return super.currentDestination;
    }
    
    /**
     *  @inheritDoc
     */
    override public function set currentDestination(value:Destination):void
    {
        if(scope && scope != value.scope)
            return;
        var current:Destination = super.currentDestination;
        if (current && 
            (current == value || current == current.getSharedParent(value)))
            return;

        var parent:Destination = findCommonParent(value);
        var hasDestination:Boolean = destinations.contains(value);
        if (!parent && hasDestination)
        {
            _defaultDestination = value;
        }
        super.currentDestination = hasDestination ? value : parent;
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    //--------------------------------------
    //  navigateTo
    //--------------------------------------
    /**
     *  dispatches navigation request
     */
    public function navigateTo(destination:Destination):void
    {
        if(destination && destination != currentDestination)
            dispatchMessage(NavigationRequest.createFor(destination));
    }
}
}