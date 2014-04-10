/**
 * User: Bart
 * Date: 03/03/2014
 * Time: 06:15
 * Description:
 */

package com.webintelligence.parsec.components.navigation.control
{
import com.webintelligence.parsec.core.log.LogAware;
import com.webintelligence.parsec.core.navigation.action.INavigationControllerAction;

import org.spicefactory.parsley.core.context.Context;

[DefaultProperty("actions")]

public class NavigationController
   extends LogAware
{

   [MessageDispatcher]
   /**
    *  @private
    */
   public var dispatchMessage:Function;

   [Inject]
   /**
    *  @private
    */
   public var context:Context;

   /**
    *  @private
    */
   private var _actions:Array;

   [ArrayElementType("com.webintelligence.parsec.core.navigation.action.INavigationControllerAction")]
   /**
    *  @private
    */
   public function get actions() : Array
   {
      return _actions;
   }
   /**
    *  @private
    */
   public function set actions( value : Array ) : void
   {
      _actions = value;
   }

   /**
    *  Constructor
    */
   public function NavigationController():void
   {
      super();
   }

   [Init]
   /**
    *  @private
    */
   public function initHandler():void
   {
      registerActions();
   }

   /**
    *  @private
    */
   protected function registerActions():void
   {
      _log.debug( "Registering {0} actions", actions ?  actions.length : 0 );
      for each( var action:INavigationControllerAction in actions )
         action.register( context );
   }
}
}
