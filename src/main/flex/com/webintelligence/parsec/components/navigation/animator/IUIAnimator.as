package com.webintelligence.parsec.components.navigation.animator
{
import flash.geom.Rectangle;

import spark.primitives.BitmapImage;

/***************************************************************************
 * 
 *   @author nowabart 
 *   @created 30 Nov 2011
 *   Describes API of an object 
 *   responsible for transitions between UINavigator screens
 * 
 ***************************************************************************/

public interface IUIAnimator
{
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    //--------------------------------------
    //  method
    //--------------------------------------
    /**
     *  performs transition between two screens and executes callback function
     */
    function animate(from:BitmapImage, 
                     to:BitmapImage, 
                     sourceRect:Rectangle,
                     targetRect:Rectangle,
                     callback:Function):void;
    
}
}