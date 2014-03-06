/**
 * Fortrus Mobius v2.0
 * User: Bart
 * Date: 05/03/2014
 * Time: 20:31
 * Description: Enables common logging capability for singleton classes
 */

package com.webintelligence.parsec.components.core.log
{
import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;
import org.spicefactory.lib.reflect.ClassInfo;

public class LogAware
{

   /**
    *  @private
    */
   private static var _LOG:Logger = LogContext.getLogger( LogAware );

   /**
    *  logger instance
    */
   protected var _log:Logger;

   /**
    *  Constructor
    */
   public function LogAware()
   {
      try
      {
         _log  = LogContext.getLogger( ClassInfo.forInstance( this ).simpleName );
      } catch( e:Error )
      {
         _LOG.error( "Logger instance creation failed for {0}, error: {1}", this, e.message );
      }
   }
}
}