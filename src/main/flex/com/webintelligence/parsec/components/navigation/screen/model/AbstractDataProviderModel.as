/**
 * User: Bart
 * Date: 01/04/2014
 * Time: 13:24
 * Description:
 */

package com.webintelligence.parsec.components.navigation.screen.model
{
import com.webintelligence.parsec.components.navigation.event.UIScreenModelEvent;

import mx.collections.ArrayCollection;

[Event(name="dataProviderChanged",
      type="com.webintelligence.parsec.components.navigation.event.UIScreenModelEvent")]

public class AbstractDataProviderModel extends AbstractFocusClientModel
{

   /**
    *  @private
    */
   private var _dataProvider:ArrayCollection;

   [Bindable(event="dataProviderChanged")]
   /**
    *  @private
    */
   public function get dataProvider() : ArrayCollection
   {
      return _dataProvider;
   }
   /**
    *  @private
    */
   public function set dataProvider( value : ArrayCollection ) : void
   {
      if( value != _dataProvider )
      {
         _log.debug( "Setting data provider ({0} items)", value ? value.length : 0 );
         _dataProvider = value;
         dataProviderChangedHandler();
         dispatchEvent( new UIScreenModelEvent( UIScreenModelEvent.DATA_PROVIDER_CHANGED ));
      }
   }

   /**
    *  Constructor
    */
   public function AbstractDataProviderModel()
   {
      super();
   }

   /**
    *  @private
    */
   protected function dataProviderChangedHandler():void
   {
      _log.debug( "Data provider changed. New length: {0}", dataProvider ? dataProvider.length : null );
   }
}
}
