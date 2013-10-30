package com.webintelligence.parsec.components.navigation.factory
{
import com.adobe.errors.IllegalStateError;
import com.webintelligence.parsec.components.navigation.domain.DestinationDescriptor;
import com.webintelligence.parsec.components.navigation.event.UINavigatorScreenEvent;
import com.webintelligence.parsec.components.navigation.screen.IUINavigatorScreen;
import com.webintelligence.parsec.components.navigation.screen.ModuleLoaderScreen;

import flash.utils.Dictionary;

/***************************************************************************
 * 
 *   @author nowabart 
 *   @created 1 Dec 2011
 *   Responsible for creating new instances of UINavigator screens
 *   (And doing apropriate decoration)
 * 
 ***************************************************************************/

public class UINavigatorScreenFactory
{
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private static var _screenToCallbackMap:Dictionary = new Dictionary();;
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    //--------------------------------------
    //  newInstance
    //--------------------------------------
    /**
     *  creates new IUINvigatorScreen instance
     */
    public static function newInstance(descriptor:DestinationDescriptor, 
                                       screenReadyCallback:Function):IUINavigatorScreen
    {
        var screen:Class = descriptor.screenClass;
        var screenInstance:IUINavigatorScreen = IUINavigatorScreen(new screen());
        return decorate(screenInstance, descriptor, screenReadyCallback);
    }
    
    //--------------------------------------
    //  decorate
    //--------------------------------------
    /**
     *  @private
     *  responsible for additional decoration of some screen types
     */
    private static function decorate(instance:IUINavigatorScreen, 
                                     descriptor:DestinationDescriptor,
                                     callback:Function):IUINavigatorScreen
    {
        _screenToCallbackMap[instance] = callback;
        instance.addEventListener(UINavigatorScreenEvent.SCREEN_COMPLETE, screenCompleteHandler);
        if(instance is ModuleLoaderScreen)
            ModuleLoaderScreen(instance).moduleId = descriptor.moduleDescriptor.objectId;
        instance.visible = false;
        return instance;
    }
    
    //--------------------------------------
    //  screenCompleteHandler
    //--------------------------------------
    /**
     *  @private
     */
    private static  function screenCompleteHandler(event:UINavigatorScreenEvent):void
    {
        var screen:IUINavigatorScreen = IUINavigatorScreen(event.currentTarget);
        screen.removeEventListener(UINavigatorScreenEvent.SCREEN_COMPLETE, screenCompleteHandler);
        if(_screenToCallbackMap[screen])
        {
            (_screenToCallbackMap[screen] as Function).call(null, screen);
            delete _screenToCallbackMap[screen];
        }
        else
        {
            throw new IllegalStateError("Screen complete callback is null");
        }
    }
}
}