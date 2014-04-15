/**
 * Fortrus Mobius v2.0
 * User: Bart
 * Date: 02/04/2014
 * Time: 20:37
 * Description:
 */

package com.webintelligence.parsec.components.navigation.screen.factory
{
import com.adobe.errors.IllegalStateError;
import com.webintelligence.parsec.core.log.LogAware;

import mx.core.ClassFactory;
import mx.core.IFactory;

import spark.components.gridClasses.GridColumn;

public class AbstractItemRendererFactory extends LogAware
{

   /**
    *  @private
    */
   protected var _generator:ClassFactory;


   /**
    *  @private
    */
   private var _rendererStyleName:String;

   /**
    *  @private
    */
   public function get rendererStyleName() : String
   {
      return _rendererStyleName;
   }
   /**
    *  @private
    */
   public function set rendererStyleName( value : String ) : void
   {
      _rendererStyleName = value;
      setRendererProperty( "styleName", _rendererStyleName );
   }


   /**
    *  Constructor
    */
   public function AbstractItemRendererFactory()
   {
      super();
   }


   /**
    *  @private
    */
   protected function setGenerator( value : Class ) : void
   {
      if( value )
         _generator = new ClassFactory( value );
   }

   /**
    *  @private
    */
   protected function setRendererProperty( name:String, value:Object ):void
   {
      if( !_generator )
         throw new IllegalStateError( "Set generator first" );

      if( name && value )
      {
         if( _generator.properties )
         {
            _generator.properties[ name ] = value;
         }
         else
         {
            var properties:Object = {};
            properties[ name ] = value;
            _generator.properties = properties;
         }
      }
   }

   /**
    *  @private
    *  @see: https://flex.apache.org/asdoc/spark/components/SkinnableDataContainer.html#itemRendererFunction
    */
   public function listItemRendererFunction( item:Object ):IFactory
   {
      _log.info( "Creating item renderer for {0}", item ? item.toString() : null );
      if( !_generator )
         throw new IllegalStateError( "Invalid generator");
      return _generator;
   }

   /**
    *  @private
    *  @see: http://flex.apache.org/asdoc/spark/components/gridClasses/GridColumn.html#itemRendererFunction
    */
   public function gridItemRendererFunction( item:Object, column:GridColumn ):IFactory
   {
      _log.info( "Creating item renderer for {0}", item ? item.toString() : null );
      if( !_generator )
         throw new IllegalStateError( "Invalid generator");
      return _generator;
   }
}
}
