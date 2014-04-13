/**
 * User: Bart
 * Date: 01/04/2014
 * Time: 13:24
 * Description:
 */

package com.webintelligence.parsec.components.navigation.screen.model
{
import com.webintelligence.parsec.components.navigation.event.UIScreenModelEvent;
import com.webintelligence.parsec.components.navigation.screen.factory.AbstractItemRendererFactory;

import mx.collections.ArrayCollection;

[Event(name="dataProviderChanged",
      type="com.webintelligence.parsec.components.navigation.event.UIScreenModelEvent")]

[Event(name="selectedItemChanged",
      type="com.webintelligence.parsec.components.navigation.event.UIScreenModelEvent")]

public class AbstractDataProviderModel extends AbstractFocusClientModel
{

   /**
    *  @private
    */
   public var itemRendererFactory:AbstractItemRendererFactory;


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
    *  @private
    */
   private var _selectedItem:Object;

   [Bindable(event="selectedItemChanged")]
   /**
    *  @private
    */
   public function get selectedItem() : Object
   {
      return _selectedItem;
   }
   /**
    *  @private
    */
   public function set selectedItem( value : Object ) : void
   {
      if( value != _selectedItem )
      {
         _log.debug( "Setting selected item: {0}", value );
         _selectedItem = value;
         selectedItemChangedHandler();
         dispatchEvent( new UIScreenModelEvent( UIScreenModelEvent.SELECTED_ITEM_CHANGED ));
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
   protected function selectedItemChangedHandler():void
   {
      _log.debug( "Selected item changed: {0}", selectedItem );
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
