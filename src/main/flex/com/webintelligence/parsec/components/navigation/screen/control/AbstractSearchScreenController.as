/**
 * User: Bart
 * Date: 01/04/2014
 * Time: 13:55
 * Description:
 */

package com.webintelligence.parsec.components.navigation.screen.control
{
import com.webintelligence.parsec.components.collection.filter.AbstractCollectionFilter;
import com.webintelligence.parsec.components.navigation.screen.domain.LookupUiState;
import com.webintelligence.parsec.components.navigation.screen.model.AbstractAsyncLookupUiModel;
import com.webintelligence.parsec.components.navigation.screen.model.AbstractSearchScreenModel;

import mx.collections.ArrayCollection;

public class AbstractSearchScreenController extends AbstractListScreenController
{

   /**
    *  @private
    */
   private var _model:AbstractSearchScreenModel;

   /**
    *  @private
    */
   protected var autoRequestDataOnLookupItemChange:Boolean = true;


   /**
    *  @private
    */
   private var _lookupCollectionFilters:Array;

   [ArrayElementType(elementType="com.webintelligence.parsec.components.collection.filter.AbstractCollectionFilter")]
   /**
    *  @private
    */
   public function get lookupCollectionFilters() : Array
   {
      return _lookupCollectionFilters;
   }
   /**
    *  @private
    */
   public function set lookupCollectionFilters( value : Array ) : void
   {
      _lookupCollectionFilters = value;
      if( lookupItems )
         lookupItems.refresh();
   }


   /**
    *  @private
    */
   private var _lookupItems:ArrayCollection;

   /**
    *  @private
    */
   private var _lookupItemsChanged:Boolean;

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
      if( _lookupItems != value )
      {
         _lookupItems = value;
         _lookupItemsChanged = true;
         invalidateProperties();
      }
   }


   /**
    *  @private
    */
   private var _currentLookupItem:Object;

   /**
    *  @private
    */
   private var _currentLookupItemChanged:Boolean;

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
      if( _currentLookupItem != value )
      {
         _log.debug( "Setting current lookup item: {0}", value ? value.toString() : null );
         _currentLookupItem = value;
         _currentLookupItemChanged = true;
         invalidateProperties();
      }
   }


   /**
    *  @private
    */
   override public function set model( value : Object ) : void
   {
      super.model = value;
      _model = model as AbstractSearchScreenModel;
   }


   /**
    *  Constructor
    */
   public function AbstractSearchScreenController( modelInstance:AbstractSearchScreenModel = null )
   {
      super( modelInstance );
   }


   /**
    *  @inheritDoc
    */
   override protected function commitProperties() : void
   {
      super.commitProperties();
      if( _lookupItemsChanged )
      {
         lookupItemsChangedHandler();
         _lookupItemsChanged = false;
      }
      if( _currentLookupItemChanged )
      {
         currentLookupItemChangedHandler();
         _currentLookupItemChanged = false;
      }
   }

   /**
    *  @inheritDoc
    */
   override protected function makeDataRequest( ...params ) : void
   {
      super.makeDataRequest( params );
      if( _model )
      {
         var reqState:String = currentLookupItem ? LookupUiState.SEARCH_IN_PROGRESS : LookupUiState.NO_SEARCH_CRITERIA;
         _log.debug( "Setting view model to {0} state.", reqState );
         _model.uiStateName = reqState;
      }
   }

   /**
    *  @private
    */
   protected function lookupItemsChangedHandler():void
   {
      _log.debug( "Lookup items collection updated. New length: {0}", lookupItems ? lookupItems.length : null );
      if( lookupItems )
         lookupItems.filterFunction = lookupFilterFunction;
      if( _model )
         _model.lookupItems = lookupItems;
   }

   /**
    *  @private
    */
   protected function currentLookupItemChangedHandler():void
   {
      _log.debug( "Current lookup item changed to: {0}", currentLookupItem ? currentLookupItem.toString() : null);
      if( _model && _model.currentLookupItem != currentLookupItem )
         _model.currentLookupItem = currentLookupItem;
      if( autoRequestDataOnLookupItemChange && currentLookupItem )
      {
         _log.debug( "Making default data request for {0}", currentLookupItem.toString() );
         makeDataRequest();
      }
   }

   /**
    *  @see: http://flex.apache.org/asdoc/mx/collections/ListCollectionView.html#filterFunction
    */
   protected function lookupFilterFunction( item:Object ):Boolean
   {
      for each( var filter:AbstractCollectionFilter in lookupCollectionFilters )
      {
         if( !filter.filterFunction( item ))
            return false;
      }
      return true;
   }

   /**
    *  @private
    */
   protected function updateLookupCollectionFilters():void
   {
      _log.debug( "Updating filters");
      for each( var filter:AbstractCollectionFilter in lookupCollectionFilters )
         filter.lookupItem = currentLookupItem;

      _log.debug( "Refreshing lookup items collection with new filters");
      if( lookupItems )
         lookupItems.refresh();
   }
}
}
