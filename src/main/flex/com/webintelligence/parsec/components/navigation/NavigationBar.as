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

   /**
    *  @private
    */
   protected var _useBundle:String;

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
       if( !destinations )
         return;
        if(scope && scope != value.scope)
            return;
        var current:Destination = super.currentDestination;
        if (current && 
            (current == value || current == current.getSharedParent(value)))
            return;

        var parent:Destination = findCommonParent(value);
        var hasDestination:Boolean = destinations!=null && destinations.contains(value);
        if (!parent && hasDestination)
            _defaultDestination = value;
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

   /**
    *  @private
    */
   protected function destinationToLabelFunction( item : Destination ) : String
   {
      var result:String = _useBundle ? resourceManager.getString( _useBundle, item.toString() ) : item.toString();
      return  result || item.toString();
   }
}
}