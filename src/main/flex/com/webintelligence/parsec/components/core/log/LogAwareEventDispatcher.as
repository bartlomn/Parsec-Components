/**
 * Fortrus Mobius v2.0
 * User: Bart
 * Date: 05/03/2014
 * Time: 20:42
 * Description: Enables common logging capability for singleton EventDispatcher based classes
 */

package com.webintelligence.parsec.components.core.log
{
import flash.events.EventDispatcher;

import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;
import org.spicefactory.lib.reflect.ClassInfo;

public class LogAwareEventDispatcher
   extends EventDispatcher
{

   /**
    *  @private
    */
   private static var _LOG:Logger = LogContext.getLogger( LogAwareEventDispatcher );

   /**
    *  logger instance
    */
   protected var _log:Logger;

   /**
    *  Constructor
    */
   public function LogAwareEventDispatcher()
   {
      try
      {
         _log  = LogContext.getLogger( ClassInfo.forInstance( this ).name );
      } catch( e:Error )
      {
         _LOG.error( "Logger instance creation failed for {0}, error: {1}", this, e.message );
      }
   }
}
}
