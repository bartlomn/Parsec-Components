/**
 * Fortrus Mobius v2.0
 * User: Bart
 * Date: 01/04/2014
 * Time: 13:34
 * Description:
 */

package com.webintelligence.parsec.components.navigation.screen.model
{
import com.webintelligence.parsec.components.navigation.event.UIScreenModelEvent;
import com.webintelligence.parsec.components.navigation.screen.control.AbstractSearchScreenController;
import com.webintelligence.parsec.components.navigation.screen.factory.AbstractItemRendererFactory;

import mx.collections.ArrayCollection;

[Event(name="lookupItemChanged",
      type="com.webintelligence.parsec.components.navigation.event.UIScreenModelEvent")]

[Event(name="lookupCollectionChanged",
      type="com.webintelligence.parsec.components.navigation.event.UIScreenModelEvent")]

public class AbstractSearchScreenModel extends AbstractAsyncLookupUiModel
{

   /**
    *  @private
    */
   public var lookupItemRendererFactory:AbstractItemRendererFactory;

   /**
    *  @private
    */
   public var controller:AbstractSearchScreenController;

   /**
    *  @private
    */
   private var _currentLookupItem:Object;

   [Bindable(event="lookupItemChanged")]
   /**
    *  @private
    */
   public function get currentLookupItem() : Object
   {
      return _currentLookupItem;
   }
   /**
    *  @private
    */
   public function set currentLookupItem( value : Object ) : void
   {
      if( value != _currentLookupItem )
      {
         _log.debug( "Setting current lookup item: {0}", value ? value.toString() : null );
         _currentLookupItem = value;
         currentLookupItemChangedHandler();
         dispatchEvent( new UIScreenModelEvent( UIScreenModelEvent.LOOKUP_ITEM_CHANGED ));
      }
   }

   /**
    *  @private
    */
   private var _lookupItems:ArrayCollection;

   [Bindable(event="lookupCollectionChanged")]
   /**
    *  @private
    */
   public function get lookupItems() : ArrayCollection
   {
      return _lookupItems;
   }
   /**
    *  @private
    */
   public function set lookupItems( value : ArrayCollection ) : void
   {
      if( value != _lookupItems )
      {
         _lookupItems = value;
         lookupItemsChangedHandler();
      }
   }

   /**
    *  Constructor
    */
   public function AbstractSearchScreenModel()
   {
      super();
   }

   /**
    *  @private
    */
   protected function lookupItemsChangedHandler():void
   {
      _log.debug( "Lookup items collection changed, length {0}", lookupItems ? lookupItems.length : null );
      dispatchEvent( new UIScreenModelEvent( UIScreenModelEvent.LOOKUP_COLLECTION_CHANGED ));
   }

   /**
    *  @private
    */
   protected function currentLookupItemChangedHandler():void
   {
      _log.debug( "Lookup item changed, new item: {0}. Passing to controller.", currentLookupItem ? currentLookupItem.toString() : null );
      if( controller && controller.currentLookupItem != currentLookupItem )
         controller.currentLookupItem = currentLookupItem;
   }
}
}
