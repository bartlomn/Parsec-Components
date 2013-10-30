package com.webintelligence.parsec.components.navigation.domain
{
import com.adobe.cairngorm.module.ParsleyModuleDescriptor;
import com.webintelligence.parsec.core.navigation.destination.Destination;

/***************************************************************************
 * 
 *   @author nowabart 
 *   @created 30 Nov 2011
 *   Describes Navigation Destination
 * 
 ***************************************************************************/

[DefaultProperty("moduleDescriptor")]

public class DestinationDescriptor
{
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Constructor
     */
    public function DestinationDescriptor(screenClass:Class = null,
                                          destination:Destination = null,
                                          moduleDescriptor:ParsleyModuleDescriptor = null,
                                          autoLoad:Boolean = false,
                                          useNotification:Boolean = false)
    {
        this.screenClass            = screenClass;
        this.destination            = destination;
        this.moduleDescriptor       = moduleDescriptor;
        this.autoLoad               = autoLoad;
        this.useLoadingNotification = useNotification;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //--------------------------------------
    //  autoLoad
    //--------------------------------------
    /**
     *  if set to true it will automatically load the destination as soon as
     *  all requirements for this destination load are met.
     *  Only one autoLoad destination per set is alowed.
     */
    public var autoLoad:Boolean;
    
    //--------------------------------------
    //  destination
    //--------------------------------------
    /**
     *  destination
     */
    public var destination:Destination;
    
    //--------------------------------------
    //  screenClass
    //--------------------------------------
    /**
     *  class of the destination's screen
     */
    public var screenClass:Class;

    //--------------------------------------
    //  moduleDescriptor
    //--------------------------------------
    /**
     *  parsley module descriptor - relevant only for module loader screens
     */
    public var moduleDescriptor:ParsleyModuleDescriptor;

    //--------------------------------------
    //  useLoadingNotification
    //--------------------------------------
    /**
     * flg to indicate if we are showing loading notification popup while initializing the screen
     */
    public var useLoadingNotification:Boolean;

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    //--------------------------------------
    //  toString
    //--------------------------------------
    /**
     *  object to string
     */
    public function toString():String
    {
        return destination.toString();
    }
}
}